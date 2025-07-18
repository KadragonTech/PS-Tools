$BaseDir = [System.IO.Path]::GetFullPath("$PSScriptRoot\DirectoryTesting")

$testGroups = @(
    # Group 1: No params set
    # All paths with invalid syntax should fail
    @{
        GroupNumber      = 1
        GroupDescription = "No Params set"
        Params           = @()
        Cases            = @(
            @{  TestNumber      = 1 
                TestDescription = "Valid file path"
                Path            = "$BaseDir\text.txt"
                Expected        = $true
                ExitCode        = 0
                ReasonLike      = "checks passed"
            }
            @{  TestNumber      = 2 
                TestDescription = "Valid subdirectory file"
                Path            = "$BaseDir\subdirectory\sub.txt"
                Expected        = $true
                ExitCode        = 0
                ReasonLike      = "checks passed"
            }
            @{  TestNumber      = 3
                TestDescription = "Valid hidden file"
                Path            = "$BaseDir\.hiddenfolder\hidden.txt"
                Expected        = $true
                ExitCode        = 0
                ReasonLike      = "checks passed"
            }
            @{  TestNumber      = 4
                TestDescription = "Valid directory path"
                Path            = "$BaseDir\text.txt"
                Expected        = $true
                ExitCode        = 0
                ReasonLike      = "checks passed"
            }
            @{  TestNumber      = 5
                TestDescription = "Invalid path string"
                Path            = "*<InvalidPath>"
                Expected        = $false
                ExitCode        = 5
                ReasonLike      = "syntax is invalid"
            }
            @{  TestNumber      = 6
                TestDescription = "Null Input"
                Path            = $null
                Expected        = $false
                ExitCode        = 4
                ReasonLike      = "is null, empty, or whitespace-only"
            }
        )
    }
)

$flatTestCases = foreach ($group in $testGroups) {
    foreach ($test in $group.Cases) {
        [PSCustomObject]@{
            GroupNumber = $group.GroupNumber
            TestNumber  = $test.TestNumber
            Params      = $group.Params
            Path        = $test.Path
            Expected    = $test.Expected
            ExitCode    = $test.ExitCode
            ReasonLike  = $test.ReasonLike
        }
    }
}

Describe "Test-ValidPath Comprehensive Testing" -ForEach $flatTestCases {
    BeforeAll {
        Import-Module "$PSScriptRoot\..\src\PS-Tools.psm1" -Force
        . "$PSScriptRoot\Format-DirectoryTesting.ps1"
        Format-DirectoryTesting -TestingFolder $BaseDir
        $case = $_
    }
    It "<case.groupnumber>.<case.testnumber>.Return" {
        $paramSplat = @{ Path = $case.Path }
        
        foreach ($param in $case.params) {
            $paramSplat[$param] = $true
        }

        Push-Location $BaseDir
        $result = Test-ValidPath @paramSplat
        Pop-Location
        $result | Should -BeExactly $case.Expected
    }

    It "<case.groupnumber>.<case.testnumber>.ExitCode" {
        $exitCode = Get-Variable -Scope Global -ValueOnly  -Name "Test-ValidPathExitCode"
        $exitCode | Should -BeExactly $case.ExitCode
    }

    It "<case.groupnumber>.<case.testnumber>.StatusMessage" {
        $status = Get-Variable -Scope Global -ValueOnly  -Name "Test-ValidPathStatus"
        $status.Reason | Should -Match $case.ReasonLike
    }
}