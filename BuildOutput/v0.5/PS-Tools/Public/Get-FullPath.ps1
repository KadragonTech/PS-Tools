<#
.SYNOPSIS
Returns the full path to the provided file.
.DESCRIPTION
Accepts a file path as a string and returns the full path to that file.
.PARAMETER path
The file or directory path to process. Can be relative or absolute.
.PARAMETER BasePath
The base directory to use when resolving a relative path. Defaults to the current location.
.PARAMETER MustExist
Ensures the specified path exists; throw an error if it does not.
.PARAMETER EnsureParentExists
Ensures that the parent directory of the path exists; creating it if necessary.
.PARAMETER IsDirectory
Treat the path as a directory path and validate accordingly.
.PARAMETER IsFile
Treat the path as a file path and validate accordingly.
.EXAMPLE
Get-FullPath -Path "logs\output.txt" -EnsureParentExists
.EXAMPLE
Get-FullPAth -Path ".\input\video.mp4" -IsFile
#>
function Get-FullPath {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, HelpMessage = "The file or directory path to process. Can be relative or absolute.")]
        [ValidateScript({ Test-ValidPath $_ })]
        [string]$Path,

        [Parameter(HelpMessage = "The base directory to use when resolving a relative path. Defaults to the current location.")]
        [ValidateScript({ Test-ValidPath $_ })]
        [string]$BasePath = (Get-Location).Path,

        [Parameter(HelpMessage = "Ensures the specified path exists; throw an error if it does not.")]
        [switch]$MustExist,

        [Parameter(HelpMessage = "Ensures that the parent directory of the path exists; creating it if necessary.")]
        [switch]$EnsureParentExists,

        [Parameter(HelpMessage = "Treat the path as a directory path and validate accordingly.")]
        [switch]$IsDirectoryPath,

        [Parameter(HelpMessage = "Treat the path as a file path and validate accordingly.")]
        [switch]$IsFilePath
    )

    if ($IsDirectoryPath -and $IsFilePath) {
        throw "Both -IsDirectoryPath and -IsFilePath can not be switched at the same time."
    }
    # Handle relative -> full translation
    if (-not [System.IO.Path]::IsPathRooted($Path)) {
        $Path = Join-Path -Path $BasePath -ChildPath $Path
    }
    $Path = [System.IO.Path]::GetFullPath($Path)

    # Must Exist validation
    if ($MustExist) {
        try {
            $resolved = (Resolve-Path -Path $Path -ErrorAction Stop).Path
        } catch {
            throw "Path '$Path' does not exist."
        }

        # Check directory / file type
        if ($IsDirectoryPath -and -not(Test-Path -Path $resolved -PathType Container)) {
            throw "Path '$resolved' exists but is not a directory."
        }
        if ($IsFilePath -and -not(Test-Path -Path $resolved -PathType File)) {
            throw "Path '$resolved' exists but is not a file."
        }
        return $resolved
    }

    # Ensure parent exists
    if ($EnsureParentExists) {
        $parentDir = [System.IO.Path]::GetDirectoryName($Path)
        if (-not (Test-Path $parentDir)) {
            Write-Verbose "Creating parent directory '$parentDir' for path."
            New-Item -ItemType Directory -Path $parentDir -Force | Out-Null
        }
    }

    if ($IsDirectoryPath -and $Path -match '\.\w+$') {
        throw "Path '$Path' is not a directory path because it has a file extension."
    }
    if ($IsFilePath -and $Path -notmatch '\.\w+$') {
        throw "Path '$Path' is not a file path because it does not have a file extension."
    }
    return $Path

}