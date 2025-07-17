<#
.SYNOPSIS
Writes Text to File.

.DESCRIPTION
Writes the given Text string to the specfied File.

.PARAMETER Text
The Text to be writen to the File.

.PARAMETER File
The File to be written to.
#>
function Write-File {
    param (
        [CmdletBinding()]
        [Parameter(Mandatory, HelpMessage = "The Text to write to the File. Can be a string, or any object that can be converted to a string as long it is not a collection.")]
        [ValidateScript({ Test-StringLike $_ })]
        [string] $Text,

        [Parameter(Mandatory, HelpMessage = "The path to the File to be written to. Must be a valid path to a File.")]
        [ValidateScript({ Test-StringLike $_ -NotEmptyOrNull })]
        [string] $File
    )
    Write-Verbose "Write-File | Starting to write Text to File: '$File'"
    Write-Debug "Write-File | Text: '$Text'"

    try {
        $Text | Out-File -FilePath $File -Append
        Write-Verbose "Write-File | Successfully wrote to '$File'"
    } catch {
        Write-Warning "Write-File | Failed to write to '$File': $_"
        throw
    }
    Write-Verbose "Write-File | Ending Process"
}