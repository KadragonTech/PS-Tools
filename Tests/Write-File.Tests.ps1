# Requires Pester Version 5.0+

# Ensure Pester is available

# To check if Pester Version 5.0+ is installed:
# Run "Get-Module -ListAvailable -Name Pester"

# To install Pester
# Install-Module Pester -Scope CurrentUser -Force

Write-Output "$PSScriptRoot\..\src\PS-Tools.psm1"

Describe "Write-File comprehensive tests" {
    
    BeforeAll {
        Import-Module "$PSScriptRoot\..\src\PS-Tools.psm1" -Force
    }

    It "writes text to a new file" {
        $filePath = "TestDrive:\testfile.txt"
        $text = "Hello, world!"

        Write-File -text $text -file $filePath

        $actual = Get-Content $filePath -Raw
        $actual | Should -BeExactly "$text`r`n"
    }

    It "appends text to an existing file" {
        $filePath = "TestDrive:\appendfile.txt"
        $first = "Line 1"
        $second = "Line 2"

        # First write
        Write-File -text $first -file $filePath
        # Append
        Write-File -text $second -file $filePath

        $actual = Get-Content $filePath -Raw
        $actual | Should -BeExactly ("$first`r`n$second`r`n")
    }

    It "throws if file path is empty" {
        { Write-File -text "abc" -file "" } | Should -Throw
    }
}