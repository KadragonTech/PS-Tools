# PSScriptAnalyzer disable PSUseWriteHost

Write-Output "=== Running PSScriptAnalyzer ==="
$lintResults = Invoke-ScriptAnalyzer -Path . -Recurse -Severity Warning, Error -ReportSummary

if ($lintResults.Count -gt 0) {
    Write-Error "Linting failed!"
    $lintResults | Format-Table -AutoSize
    exit 1
}

Write-Output "=== Running Pester Tests ==="
Import-Module Pester -MinimumVersion 5.0.0 -Force
Invoke-Pester

if ($LASTEXITCODE -ne 0) {
    Write-Error "Tests failed!"
    exit 1
}

Write-Output "=== All checks passed ==="
Write-Output "=== Running Deployment ==="
.\Deploy.ps1

