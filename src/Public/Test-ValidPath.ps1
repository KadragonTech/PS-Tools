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
.PARAMETER FailSilently
Alows some errors to fail silently. Will force PathType to 'file' if fileExtensions is set.
.EXAMPLE
Test-ValidPath "C:\MyFolder\report.csv" -PathType File
.EXAMPLE
Test-ValidPath "C:\Scripts\cleanup.ps1" -MustExist -PathType File -FileExtensions ".ps1"
#>
function Test-ValidPath {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory, HelpMessage = "The file or directory path to validate. Can be relative or absolute path.")]
        [ValidateScript({ Test-StringLike $_ -NotEmptyOrNull })]
        [string]$Path,

        [Parameter(HelpMessage = "Validates that the file or directory path already exists. Otherwise only checks that the Path appears valid.")]
        [switch]$MustExist,

        [Parameter(HelpMessage = "Validates that the path is of a specific type (Any, File, Directory, A, F, D). Defaults to Any.")]
        [ValidateScript({
                if (-not (Test-StringLike $_ -NotEmptyOrNull)) { return $false }
                $validInputs = @("any", "file", "directory", "a", "f", "d")
                return $validInputs -contains $_.ToLower()
            })]
        [string]$PathType = "any",

        [Parameter(HelpMessage = "Validates that the path is a file with specified file extension(s). Works in combination with PathType File (F).")]
        [ValidateScript({
                foreach ($ext in $_) {
                    if ($ext -notmatch '^\.\w+$') { return $false }
                }
                return $true
            })]
        [string[]]$FileExtensions,

        [Parameter(HelpMessage = "Allows some errors to fail silently. Will force PathType to 'file' if fileExtensions is set.")]
        [switch]$FailSilently
    )
    
    $actualPath = [System.IO.Path]::GetFullPath($Path, (Get-Location).Path)

    # Checks if path is syntactically valid.
    if (-not (Test-Path $actualPath -IsValid )) {
        Write-Verbose "Test-ValidPath | Path is not syntactically valid. Returning '$false'."
        return $false
    }

    # Converts PathType to full word
    $PathType = $PathType.ToLower()
    switch -Regex ($PathType) {
        '^a$' { $PathType = "any" }
        '^f$' { $PathType = "file" }
        '^d$' { $PathType = "directory" }
    }

    # Handles when an empty arrray is passed into FileExtension
    if ($PSBoundParameters.ContainsKey('FileExtensions') -and $FileExtensions.Count -eq 0) {
        if ($FailSilently) {
            Write-Verbose "Test-ValidPath | FailSilently | FileExtensions was passed as empty array."
            Write-Verbose "Test-ValidPath | FailSilently | Setting File extensions to 'null'."
            $FileExtensions = $null
        } else {
            Write-Warning "Test-ValidPath | FileExtensions was passed as an empty array! Returning '$false'"
            return $false
        }
    }

    # Handles when FileExtensions and PathType are not compatible
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

    # Handles verifying if the file exists on the system
    if ($MustExist) {
        Write-Verbose "Test-ValidPath | MustExist is set. Checking if path exists on drive."
        if (-not (Test-Path $actualPath -PathType Any)) {
            Write-Verbose "Test-ValidPath | Path does not exist when MustExist is set. Returning '$false'"
            return $false
        }
        switch ($PathType) {
            "directory" {
                if (-not(Test-Path $actualPath -PathType Container)) {
                    Write-Verbose "Test-ValidPath | PathType is set to 'directory' but path is a file. Returning '$false'"
                    return $false
                }
            }
            "file" {
                if (-not(Test-Path $actualPath -PathType Leaf)) {
                    Write-Verbose "Test-ValidPath | PathType is set to 'file' but path is a directory. Returning '$false'"
                    return $false
                }
    
                # Handles verifying if the path looks like a valid path
            }
        }
    } else {
        Write-Verbose "Test-ValidPath | MustExist is not set. Checking path string syntax."

        $hasExtension = $actualPath -match '[^\\\/]\.\w+$'
        if ($PathType -eq "directory" -and $hasExtension) {
            Write-Verbose "Test-ValidPath | Path type is set to directory but the path has an extension. Returning '$false'"
            return $false
        }
        if ($PathType -eq "file" -and -not $hasExtension) {
            Write-Verbose "Test-ValidPath | Path type is set to file but the path does not have an extension. Returning '$false'"
            return $false
        }
    }

    if ($FileExtensions) {
        Write-Verbose "Test-ValidPath | File extensions were passed. Checking if file has a valid extension."
        if (-not ($FileExtensions | Where-Object { $actualPath.EndsWith($_, [StringComparison]::InvariantCultureIgnoreCase) })) {
            Write-Verbose "Test-ValidPath | File does not end with a valid extension. Returning '$false'"
            return $false
        }
    }
    Write-Verbose "Test-ValidPath | Path passed all validations. Returning '$true'"
    return $true
}