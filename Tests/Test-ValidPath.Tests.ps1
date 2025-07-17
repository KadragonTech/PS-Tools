$DirectoryTesting = [System.IO.Path]::GetFullPath("$PSScriptRoot\DirectoryTesting")

$testGroups = @(
    # Group 1: No params set
    # All paths with invalid syntax should fail
    @{
        GroupNumber      = 1
        GroupDescription = "Invalid syntax"
        Params           = @()
        Cases            = @(
            @{TestNumber = 1; TestDescription = "Relative file with wrong syntax"
                Input = "test<.txt"; Expected = $false
            }
            @{TestNumber = 2; TestDescription = "Relative directory with wrong syntax"
                Input = "testdir|"; Expected = $false
            }
            @{TestNumber = 3; TestDescription = "Absolute file with wrong syntax"
                Input = "C:\\test>.txt"; Expected = $false
            }
            @{TestNumber = 4; TestDescription = "Relative file with wrong syntax"
                Input = "C:\\Windows|"; Expected = $false
            }
        )
    }

    # Group 2: No params set
    # All paths should pass on syntax alone
    @{
        GroupNumber      = 2
        GroupDescription = "No params set"
        Params           = @()
        Cases            = @(
            @{TestNumber = 1; TestDescription = "Simple relative file"
                Input = "doesnotexist.txt"; Expected = $true
            }
            @{TestNumber = 2; TestDescription = "Simple relative directory"
                Input = "doesnotexist"; Expected = $true
            }
            @{TestNumber = 3; TestDescription = "Simple absolute file"
                Input = "C:\\doesnotexist.txt"; Expected = $true
            }
            @{TestNumber = 4; TestDescription = "Simple absolute directory"
                Input = "C:\\doesnotexist"; Expected = $true
            }
        )
    }
    # Group 3: MustExist param only
    # Paths that exist should pass. Paths that don't should not
    @{
        GroupNumber      = 3
        GroupDescription = "MustExist param only"
        Params           = @('MustExist')
        Cases            = @(
            @{TestNumber = 1; TestDescription = "Simple relative file"
                Input = "text.txt"; Expected = $true
            }
            @{TestNumber = 2; TestDescription = "Simple relative directory"
                Input = "subdirectory"; Expected = $true
            }
            @{TestNumber = 3; TestDescription = "Simple absolute file"
                Input = "$DirectoryTesting\text.txt"; Expected = $true
            }
            @{TestNumber = 4; TestDescription = "Simple absolute directory"
                Input = "$DirectoryTesting"; Expected = $true
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
            Input       = $test.Input
            Expected    = $test.Expected
        }
    }
}

Describe "Test-ValidPath Comprehensive Testing" -ForEach $flatTestCases {
    BeforeAll {
        Import-Module "$PSScriptRoot\..\src\PS-Tools.psm1" -Force
        Format-DirectoryTesting($DirectoryTesting)
        $test = $_
    }
    It "<test.groupnumber>.<test.testnumber>" {
        $paramHash = @{ Path = $test.Input }
        $test.Params.ForEach({ $paramHash[$_] = $true })
        Push-Location $DirectoryTesting
        Test-ValidPath @paramHash | Should -BeExactly $test.Expected
        Pop-Location
    }
}