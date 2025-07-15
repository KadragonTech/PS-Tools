<#
.SYNOPSIS
Writes text to file.

.DESCRIPTION
Writes the given text string to the specfied file.

.PARAMETER text
The text to be writen to the file.

.PARAMETER file
The file to be written to.
#>
function Write-File {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateScript({ Test-StringLike $_ })]
        [string] $text,
        [Parameter(Mandatory)]
        [ValidateScript({ Test-StringLike $_ -NotEmpty })]
        [string] $file
    )
    Write-Verbose "Write-File | Starting to write text to '$file'"
    Write-Debug "Write-File | Text: '$text'"

    try {
        $text | Out-File -FilePath $file -Append
        Write-Verbose "Write-File | Successfully wrote to '$file'"
    } catch {
        Write-Warning "Write-File | Failed to write to '$file': $_"
        throw
    }
    Write-Verbose "Write-File | Ending Process"
}