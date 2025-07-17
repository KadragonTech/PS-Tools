function Set-FunctionStatus {
    param(
        [int]$ExitCode,
        [string]$Reason
    )


    # Gets the name of the calling function. Defaults to calling script name if not function name is found.
    $caller = (Get-PSCallStack)[1].FunctionName
    if (-not $caller) {
        $caller = Split-Path -Leaf $MyInvocation.ScriptName
    }
    # Sets the Status and ExitCode according to input value
    if ($null -eq $ExitCode) {
        Set-Variable -Scope Global -Name "${caller}Status" -Value $null
        Set-Variable -Scope Global -Name "${caller}ExitCode" -Value $null
    } else {
        Set-Variable -Scope Global -Name "${caller}Status" -Value @{
            ExitCode = $ExitCode
            Reason   = $Reason
        }
        Set-Variable -Scope Global -Name "${caller}ExitCode" -Value $ExitCode
    }
}