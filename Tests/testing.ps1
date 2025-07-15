Import-Module Pester -MinimumVersion "5.0" -Force
Invoke-Pester -Path ".\Tests\Copy-Test-Stringlike.Tests.ps1"