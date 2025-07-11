<#
.SYNOPSIS
Tests if string is a valid path.
.DESCRIPTION
Accepts a string and tests if the string contains invalid characters for paths.
.PARAMETER Path
The file or directory path to process. Can be relative or absolute path.
.PARAMETER MustExist
Ensures that the path exists on the disk, instead of simply being a valid path.
.PARAMETER PathType
Ensures that the path is of a specific type (Any, File, Directory, A, F, D). Defaults to Any
.PARAMETER FileExtensions
Ensures that the path corresponds to specified file extension(s) functions in combination with PathType File
.PARAMETER CaseSensitive
Enforces case-sensitive checks.(Where Supported by the OS) If not set, strings will be compared in lowercase.
.PARAMETER FailSilently
Alows some errors to fail silently. Will force PathType to 'file' if fileExtensions is set.
.EXAMPLE
Test-ValidPath "C:\MyFolder\report.csv" -PathType File
.EXAMPLE
Test-ValidPath "C:\Scripts\cleanup.ps1" -MustExist -PathType File -FileExtensions ".ps1"
#>
function Test-ValidPath {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, HelpMessage = "The file or directory path to process. Can be relative or absolute path.")]
        [ValidateScript({ Test-StringLike $_ -NotEmpty })]
        [string]$Path,

        [Parameter(HelpMessage = "Ensures that the path exists on the disk, instead of simply being a valid path.")]
        [switch]$MustExist,

        [Parameter(HelpMessage = "Ensures that the path is of a specific type (Any, File, Directory, A, F, D). Defaults to Any")]
        [ValidateScript({
                if (-not (Test-StringLike $_ -NotEmpty)) { return $false }
                $validInputs = @("any", "file", "directory", "a", "f", "d")
                return $validInputs -contains $_.ToLower()
            })]
        [string]$PathType = "any",

        [Parameter(HelpMessage = "Ensures that the path corresponds to specified file extension(s) functions in combination with PathType File")]
        [ValidateScript({
                foreach ($ext in $_) {
                    if ($ext -notmatch '^\.\w+$') { return $false }
                }
                return $true
            })]
        [string[]]$FileExtensions,

        [Parameter(HelpMessage = "Enforces case-sensitive checks. (Where Supported by the OS) If not set, strings will be compared in lowercase.")]
        [switch]$CaseSensitive,

        [Parameter(HelpMessage = "Alows some errors to fail silently. Will force PathType to 'file' if fileExtensions is set.")]
        [switch]$FailSilently
    )

    switch -Regex ($PathType.ToLower()) {
        '^a$' { $PathType = "any" }
        '^f$' { $PathType = "file" }
        '^d$' { $PathType = "directory" }
    }

    if ($FileExtensions -and $FileExtensions.Count -eq 0) {
        if ($FailSilently) {
            Write-Verbose "Test-ValidPath | FailSilently | File extensions was an empty array."
            Write-Verbose "Test-ValidPath | FailSilently | Setting File extensions to Null."
            $FileExtensions = $null
        } else {
            Write-Warning "Test-ValidPath | FileExtensions is an Empty Array! Returning '$false'"
            return $false
        }
    }

    if (-not $CaseSensitive) {
        Write-Verbose "Test-ValidPath | CaseSensitive is not set. Normalizing all Input to lowercase."
        $Path = $Path.ToLower()
        $PathType = $PathType.ToLower()
        if ($FileExtensions) { $FileExtensions = $FileExtensions | ForEach-Object { $_.ToLower() } }
    }

    if ($FileExtensions -and -not ($PathType -eq "file")) {
        if ($FailSilently) {
            Write-Verbose "Test-ValidPath | FailSilently | Pathtype not set to 'file' when file extensions were passed!"
            Write-Verbose "Test-ValidPath | FailSilently | Setting Pathtype to 'file'"
            $PathType = "file"
        } else {
            Write-Warning "Test-ValidPath | Pathtype must be 'file' if file extensions are passed! Returning '$false'"
            return $false
        }
    }

    if ($MustExist) {
        Write-Verbose "Test-ValidPath | MustExist is set. Checking if path exists on drive."
        if (-not (Test-Path $Path -PathType Any)) {
            Write-Verbose "Test-ValidPath | Path does not exist when MustExist is set. Returning '$false'"
            return $false
        }
        switch ($PathType) {
            "directory" {
                if (-not(Test-Path $Path -PathType Container)) {
                    Write-Verbose "Test-ValidPath | PathType is set to 'directory' but path is a file. Returning '$false'"
                    return $false
                }
            }
            "file" {
                if (-not(Test-Path $Path -PathType Leaf)) {
                    Write-Verbose "Test-ValidPath | PathType is set to 'file' but path is a directory. Returning '$false'"
                    return $false
                }
                if ($FileExtensions) {
                    Write-Verbose "Test-ValidPath | File extensions were passed. Checking if file has a valid extension."
                    if (-not ($FileExtensions | Where-Object { $Path.EndsWith($_) })) {
                        Write-Verbose "Test-ValidPath | File does not end with a valid extension. Returning '$false'"
                        return $false
                    }
                }
            }
        }
    } else {
        Write-Verbose "Test-ValidPath | MustExist is not set. Checking path string syntax."
        $regexMatch = if ($CaseSensitive) {
            { param($inputString, $pattern) $inputString -cmatch $pattern }
        } else {
            { param($inputString, $pattern) $inputString -match $pattern }
        }

        $hasExtension = & $regexMatch $Path '\.\w+$'
        if ($PathType -eq "directory" -and $hasExtension) {
            Write-Verbose "Test-ValidPath | Path type is set to directory but the path has an extension. Returning '$false'"
            return $false
        }
        if ($PathType -eq "file" -and -not $hasExtension) {
            Write-Verbose "Test-ValidPath | Path type is set to file but the path does not have an extension. Returning '$false'"
            return $false
        }

        if ($FileExtensions) {
            Write-Verbose "Test-ValidPath | File extensions were passed. Checking if file has a valid extension."
            if (-not ($FileExtensions | Where-Object { $Path.EndsWith($_) })) {
                Write-Verbose "Test-ValidPath | File does not end with a valid extension. Returning '$false'"
                return $false
            }
        }

        $invalidChars = [System.IO.Path]::GetInvalidPathChars()
        $invalidNameChars = [System.IO.Path]::GetInvalidFileNameChars()
        if ($Path.IndexOfAny($invalidChars) -ge 0) {
            Write-Verbose "Test-ValidPath | Path has invalid path characters. Returning '$false'"
            return $false
        }
        if ($hasExtension -or $PathType -eq "file") {
            Write-Verbose "Test-ValidPath | Path type is 'file' or the path has extensions. Checking for invalid file name characters"
            if ([System.IO.Path]::GetFileNameWithoutExtension($Path).IndexOfAny($invalidNameChars) -ge 0) {
                Write-Verbose "Test-ValidPath | Path has invalid file name characters. Returning '$false'"
                return $false 
            }
        }
    }
    Write-Verbose "Test-ValidPath | Path passed all validations. Returning '$true'"
    return $true
}