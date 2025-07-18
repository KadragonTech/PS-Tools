<#
.SYNOPSIS
Validates whether a given string is a syntactically valid file or directory path.

.DESCRIPTION
Determines whether the provided string is a valid path.

Additional checks can be enforced via optional parameters:
- Use '-MustExist' to ensure that the path exists on disk.
- Use '-PathType' to validate the expected path type: file, directory, or any.
- Use '-FileExtensions' to require specific file extensions.
- Use '-FailSilently' to allow the function to resolve or ignore certain errors automatically.

Returns a Boolean result.
Diagnostic metadata — such as `$ExitCode` and `$Reason` — is stored in `$Test-ValidPathStatus` and `$Test-ValidPathExitCode`.

.PARAMETER Path
The path to validate. Can be a string or a [System.Management.Automation.PathInfo] object. 
If a string is provided, it must not be null, empty, or whitespace-only.

.PARAMETER MustExist
If specified, the path must already exist on disk.

.PARAMETER PathType
Enforces the type of the path. Accepted values:
- "any" (default): No type constraints
- "file": Must be a file
- "directory": Must be a directory

.PARAMETER FileExtensions
Requires the path to end with one or more specific file extensions.
Accepted formats include: ".txt", ".docx", ".dll", etc.
If specified, PathType must be set to "file".

.PARAMETER FailSilently
Enables recovery behavior for certain validation failures:
- Automatically sets `$FileExtensions` to `$null` if provided as an empty array.
- Automatically sets `$PathType` to "file" if `$FileExtensions` are supplied.
- Returns `$false` instead of throwing when an exception occurs during `[System.IO.Path]::GetFullPath()`.

.OUTPUTS
[bool]   Returns $true if the path is valid; otherwise, $false.
[void]   Sets the following diagnostic variables:
         - $Test-ValidPathStatus
         - $Test-ValidPathExitCode

.EXAMPLE
Test-ValidPath "C:\MyFolder\report.csv" -PathType file

.EXAMPLE
Test-ValidPath "C:\Scripts\cleanup.ps1" -MustExist -PathType file -FileExtensions ".ps1"

.NOTES
Exit codes are stored in `$Test-ValidPathExitCode`. The status object, containing both exit code and reason, is stored in `$Test-ValidPathStatus`.

Exit Codes:
  0 = Success
  1 = MustExist failure
  2 = PathType failure
  3 = FileExtension failure
  4 = Null/Invalid Path input
  5 = Path syntax issues
  6 = Invalid FileExtensions input
  7 = Exception encountered

.LINK
https://learn.microsoft.com/en-us/dotnet/api/system.io.path.getfullpath
https://learn.microsoft.com/en-us/dotnet/api/system.io.path.hasextension
https://learn.microsoft.com/en-us/dotnet/api/system.io.path.getextension
https://learn.microsoft.com/en-us/dotnet/api/system.io.path.getfilename
https://learn.microsoft.com/en-us/dotnet/api/system.io.path.ispathrooted
https://learn.microsoft.com/en-us/dotnet/api/system.stringcomparer.ordinalignorecase
https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.pathinfo
https://learn.microsoft.com/en-us/powershell/scripting/developer/cmdlet/validating-parameter-input

.LINK
Set-FunctionStatus
.LINK
Test-StringLike
.LINK
https://github.com/KadragonTech/PS-Tools/blob/main/README.md
#>
function Test-ValidPath {
    [CmdletBinding()]
    [OutputType([bool])]
    [Alias('Test-PathValid', 'Is-ValidPath')]
    param(
        [Parameter(HelpMessage = "The path to validate. Can be relative or absolute.")]
        [ValidateScript({ 
                if ($_ -is [System.Management.Automation.PathInfo]) {
                    return $true
                }
                if (-Not(Test-StringLike $_ -NotEmptyOrNull -StrictStringType)) {
                    Write-Verbose "Test-ValidPath | '`$Path' must be a string that is not null, empty, or whitespace-only"
                    Write-Debug "Test-ValidPath | '`$Path': $Path"
                    Set-FunctionStatus -ExitCode 4 -Reason "Path is either not a string, or is null, empty, or whitespace-only."
                    return $false
                }
                return $true
            })]
        [string]$Path,

        [Parameter(HelpMessage = "Ensures that the path already exists on the drive.")]
        [switch]$MustExist,

        [Parameter(HelpMessage = "Ensures the path is of the specified type: 'any', 'file', or 'directory'. Defaults to 'any'.")]
        [ValidateSet("any", "file", "directory")]
        [string]$PathType = "any",

        [Parameter(HelpMessage = "One or more allowed file extensions (e.g., '.txt', '.dll'). Used with PathType 'file'.")]
        [ValidateScript({
                foreach ($ext in $_) {
                    if ($ext -notmatch '^\.\w+$') {
                        Write-Verbose "Test-ValidPath | Value in '`$FileExtensions' is not valid."
                        Write-Debug "Test-ValidPath | Value: $ext"
                        Set-FunctionStatus -ExitCode 6 -Reason "Value in FileExtensions is not valid."
                        return $false 
                    }
                }
                return $true
            })]
        [string[]]$FileExtensions,

        [Parameter(HelpMessage = "Allows certain errors to be handled silently or corrected automatically.")]
        [switch]$FailSilently
    )

    Set-FunctionStatus $null

    # Logging
    Write-Verbose "Test-ValidPath | Starting Validation."
    Write-Debug "Test-ValidPath | '`$Path': $Path."
    Write-Debug "Test-ValidPath | '`$PathType': $PathType."
    Write-Debug ("Test-ValidPath | '`$FileExtensions': {0}." -f ($FileExtensions -join ', ' -replace '^$', '[Empty]' ))
    Write-Debug "Test-ValidPath | '`$MustExist': $MustExist."
    Write-Debug "Test-ValidPath | '`$FailSilently': $FailSilently."
    
    Write-Verbose "Test-ValidPath | Checking '`$Path' syntax using -IsValid"
    
    # Handles invalid $path syntax
    if (-not (Test-Path $Path -IsValid )) {
        Write-Verbose "Test-ValidPath | '`$Path' is not syntactically valid. Returning '$false'"
        Write-Debug "Test-ValidPath | '`$Path': $Path"
        Set-FunctionStatus -ExitCode 5 -Reason "Path syntax is invalid."
        return $false
    }

    # Handles empty FileExtensions arrays
    if ($PSBoundParameters.ContainsKey('FileExtensions') -and $FileExtensions.Count -eq 0) {
        if ($FailSilently) {
            Write-Verbose "Test-ValidPath | FailSilently | '`$FileExtensions' was passed as an empty array."
            Write-Verbose "Test-ValidPath | FailSilently | Setting '`$FileExtensions' to '`$null'."
            $FileExtensions = $null
        } else {
            Write-Warning "Test-ValidPath | '`$FileExtensions' was passed as an empty array! Returning '$false'"
            Set-FunctionStatus -ExitCode 6 -Reason "FileExtensions is an empty array."
            return $false
        }
    }

    # Handles when FileExtensions and PathType are not compatible
    if ($FileExtensions -and -not ($PathType -eq "file")) {
        if ($FailSilently) {
            Write-Verbose "Test-ValidPath | FailSilently | '`$PathType' not set to 'file' when '`$FileExtensions' were specified!"
            Write-Verbose "Test-ValidPath | FailSilently | Setting '`$PathType' to 'file'."
            $PathType = "file"
        } else {
            Write-Warning "Test-ValidPath | Pathtype must be 'file' if '`$FileExtensions' are passed! Returning '$false'"
            Set-FunctionStatus -ExitCode  -Reason "PathType must be 'file' when FileExtensions was provided."
            return $false
        }
    }

    # Normalizes $Path into a rooted absolute path
    Write-Verbose "Test-ValidPath | Normalizing to absolute path using GetFullPath()."
    try {
        if (-not [System.IO.Path]::IsPathRooted($Path)) { 
            Write-Verbose "Test-ValidPath | Supplied '`$Path' is not rooted. Getting full path."
            $actualPath = [System.IO.Path]::GetFullPath($Path, (Get-Location).Path)
            Write-Debug "Test-ValidPath | Generated full path is: $actualPath" 
        } else {
            Write-Verbose "Test-ValidPath | Supplied '`$Path' is already rooted."
            $actualPath = [System.IO.Path]::GetFullPath($Path)
        }
        Write-Debug "Test-ValidPath | Calculated full path is: $actualPath"
    } catch {
        $msg = $_.Exception.Message
        if ($FailSilently) {
            Write-Verbose "Test-ValidPath | Exception occured during GetFullPath(). Returning '$false'"
            Write-Debug "Test-ValidPath | Exception: $msg"
            Set-FunctionStatus -ExitCode 7 -Reason "Exception occured during GetFullPath()."
            return $false
        } else {
            Write-Error "Test-ValidPath | Exception occured during GetFullPath()."
            Set-FunctionStatus -ExitCode 7 -Reason "Exception occured during GetFullPath()."
            throw $_
        }
    }

    # Handles verifying $Path according to params
    if ($MustExist) {
        Write-Verbose "Test-ValidPath | '`$MustExist' is specified. Validating if '`$Path' exists on disk."
        if (-not (Test-Path $actualPath -PathType Any)) {
            Write-Verbose "Test-ValidPath | '`$Path' does not exist when '`$MustExist' is specified. Returning '$false'"
            Set-FunctionStatus -ExitCode 1 -Reason "`$Path' does not exist."
            return $false
        }
        switch ($PathType) {
            "directory" {
                if (-not(Test-Path $actualPath -PathType Container)) {
                    Write-Verbose "Test-ValidPath | `$Path' exists on disk, but is a file when expected directory. Returning '$false'"
                    Set-FunctionStatus -ExitCode 2 -Reason "Path is a file, expected irectory."
                    return $false
                }
            }
            "file" {
                if (-not(Test-Path $actualPath -PathType Leaf)) {
                    Write-Verbose "Test-ValidPath | `$Path' exists on disk, but is a directory when expcted file. Returning '$false'"
                    Set-FunctionStatus -ExitCode 2 -Reason "Path is a directory, expcted file."
                    return $false
                }
            }
        }
    } else {
        Write-Verbose "Test-ValidPath | '`$MustExist' is not specified. Checking '`$Path' syntax."

        $hasExtension = [System.IO.Path]::HasExtension($actualPath) -and ($actualPath -notmatch '[\\\/]\.[^\\\/]+$')
        if ($hasExtension) {
            Write-Verbose "Test-ValidPath | '`$Path' has an extension."
            $ending = [System.IO.Path]::GetExtension($actualPath)
        } else {
            Write-Verbose "Test-ValidPath | '`$Path' does not have an extension."
            $ending = [System.IO.Path]::GetFileName($actualPath)
        }
        if ($PathType -eq "directory" -and $hasExtension) {
            Write-Verbose "Test-ValidPath | '`$PathType' is set to 'directory' but '`$Path' has an extension. Returning '$false'"
            Write-Debug "Test-ValidPath | '`$Path' ends in extension: $ending"
            Set-FunctionStatus -ExitCode 2 -Reason "Path has an extension."
            return $false
        }
        if ($PathType -eq "file" -and -not $hasExtension) {
            Write-Verbose "Test-ValidPath | '`$PathType' is set to 'file' but '`$Path' does not have an extension. Returning '$false'"
            Write-Debug "Test-ValidPath | '`$Path' ends in directory: $ending"
            Set-FunctionStatus -ExitCode 2 -Reason "Path does not have an extension."
            return $false
        }
    }

    # Handles $FileExtensions validation
    if ($FileExtensions) {
        Write-Verbose "Test-ValidPath | '`$FileExtensions' are specified. Checking if file has a valid extension."
        if (-not ($FileExtensions | Where-Object { $actualPath.EndsWith($_, [StringComparison]::OrdinalIgnoreCase) })) {
            Write-Verbose "Test-ValidPath | '`$Path' does not end with a valid extension. Returning '$false'"
            $ending = [System.IO.Path]::GetFileName($actualPath)
            Write-Debug "Test-ValidPath | '`$Path' ends with: $ending"
            Set-FunctionStatus -ExitCode 3 -Reason "Path does not have a valid extension."
            return $false
        }
    }
    Write-Verbose "Test-ValidPath | All checks passed. Returning '$true' for: $actualPath"
    Set-FunctionStatus -ExitCode 0 -Reason "All checks passed."
    return $true
}