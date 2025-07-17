# PSScriptAnalyzer disable PSUseDeclaredVarsMoreThanAssignments

# Requires Pester Version 5.0+

# Ensure Pester is available

# To check if Pester Version 5.0+ is installed:
# Run "Get-Module -ListAvailable -Name Pester"

# To install Pester
# Install-Module Pester -Scope CurrentUser -Force

$thrower = New-Object PSObject
$thrower | Add-Member ScriptMethod ToString { throw "Can't convert to string" } -Force

$testGroups = @(

    # Group 1: No params set
    # All collections should fail
    @{
        GroupNumber      = 1
        GroupDescription = "No params set"
        Params           = @()
        Cases            = @(
            @{  TestNumber      = 1
                TestDescription = "Null"
                Value           = $null
                Expected        = $true
                ExitCode        = 0
                ReasonLike      = "string-like objects"
            }
            @{  TestNumber      = 2 
                TestDescription = "Empty String"
                Value           = "" 
                Expected        = $true 
                ExitCode        = 0 
                ReasonLike      = "empty string but"
            }
            @{  TestNumber      = 3
                TestDescription = "White Space String"
                Value           = "   "
                Expected        = $true 
                ExitCode        = 0
                ReasonLike      = "empty string but"
            }
            @{  TestNumber      = 4
                TestDescription = "Simple String"
                Value           = "Bopp Bipp"
                Expected        = $true 
                ExitCode        = 0
                ReasonLike      = "non-empty string"
            }
            @{  TestNumber      = 5
                TestDescription = "Empty HashTable"
                Value           = @{}
                Expected        = $false 
                ExitCode        = 3
                ReasonLike      = "is a collection."
            }
            @{  TestNumber      = 6
                TestDescription = "Empty Array"
                Value           = @()
                Expected        = $false 
                ExitCode        = 3
                ReasonLike      = "is a collection."
            }
        )
    }

    # Group 2: StrictStringType only
    # All collections should fail
    # All non-strings should fail
    # All strings should pass
    @{
        GroupNumber      = 2
        GroupDescription = "StrictStringType only"
        Params           = @("StrictStringType")
        Cases            = @(
            @{  TestNumber      = 1
                TestDescription = "Valid string"
                Value           = "Hello"
                Expected        = $true
                ExitCode        = 0
                ReasonLike      = "non-empty string" 
            }
            @{  TestNumber      = 2
                TestDescription = "Null"
                Value           = $null
                Expected        = $false
                ExitCode        = 2
                ReasonLike      = "not strings" 
            }
            @{  TestNumber      = 3
                TestDescription = "Integer"
                Value           = 42
                Expected        = $false
                ExitCode        = 2
                ReasonLike      = "not strings" 
            }
            @{  TestNumber      = 4
                TestDescription = "Empty string"
                Value           = ""
                Expected        = $true
                ExitCode        = 0
                ReasonLike      = "empty string but" 
            }
            @{  TestNumber      = 5
                TestDescription = "Empty array"
                Value           = @()
                Expected        = $false
                ExitCode        = 3
                ReasonLike      = "is a collection." 
            }
        )
    }

    # Group 2: NotEmptyOrNull only
    # All collections should fail
    # All empty strings should fail
    # All objects that result in empty strings should fail
    # All strings should pass
    @{
        GroupNumber      = 3
        GroupDescription = "NotEmptyOrNull only"
        Params           = @("NotEmptyOrNull")
        Cases            = @(
            @{  TestNumber      = 1
                TestDescription = "Valid non-empty string"
                Value           = "Ping"
                Expected        = $true
                ExitCode        = 0
                ReasonLike      = "non-empty string" 
            }
            @{  TestNumber      = 2
                TestDescription = "Empty string"
                Value           = ""
                Expected        = $false
                ExitCode        = 1
                ReasonLike      = "empty string but" 
            }
            @{  TestNumber      = 3
                TestDescription = "Whitespace-only string"
                Value           = "   "
                Expected        = $false
                ExitCode        = 1
                ReasonLike      = "empty string but" 
            }
            @{  TestNumber      = 4
                TestDescription = "Null"
                Value           = $null
                Expected        = $false
                ExitCode        = 1
                ReasonLike      = "null, empty, or whitespace-only." 
            }
            @{  TestNumber      = 5
                TestDescription = "Hashtable"
                Value           = @{}
                Expected        = $false
                ExitCode        = 3
                ReasonLike      = "collection" 
            }
        )
    }

    # Group 4: AllowCollections only
    # All collections where all elements can be passed into a string should pass
    # All other collections should fail
    @{
        GroupNumber      = 4
        GroupDescription = "AllowCollections only"
        Params           = @("AllowCollections")
        Cases            = @(
            @{  TestNumber      = 1
                TestDescription = "Array of strings"
                Value           = @("hello", "world")
                Expected        = $true
                ExitCode        = 0
                ReasonLike      = "string-like"
            }
            @{  TestNumber      = 2
                TestDescription = "Array of null and string"
                Value           = @($null, "test")
                Expected        = $true
                ExitCode        = 0
                ReasonLike      = "string-like"
            }
            @{  TestNumber      = 3
                TestDescription = "Empty array"
                Value           = @()
                Expected        = $true
                ExitCode        = 0
                ReasonLike      = "string-like"
            }
            @{  TestNumber      = 4
                TestDescription = "Nested arrays"
                Value           = @("a", @("b", @("c")))
                Expected        = $true
                ExitCode        = 0
                ReasonLike      = "string-like"
            }
            @{  TestNumber      = 5
                TestDescription = "Hashtable with string values"
                Value           = @{ a = "x"
                    b        = "y" 
                }
                Expected        = $true
                ExitCode        = 0
                ReasonLike      = "string-like"
            }
            @{  TestNumber      = 6
                TestDescription = "Mixed convertible types"
                Value           = @("x", 123, $true, 3.14)
                Expected        = $true
                ExitCode        = 0
                ReasonLike      = "string-like"
            }
            @{  TestNumber      = 7
                TestDescription = "Custom object with string output"
                Value           = [PSCustomObject]@{  ToString = { "custom" } }
                Expected        = $true
                ExitCode        = 0
                ReasonLike      = "string-like"
            }
            @{  TestNumber      = 8
                TestDescription = "Collection with one unserializable object"
                Value           = @("valid", $thrower)
                Expected        = $false
                ExitCode        = 4
                ReasonLike      = "Conversion error"
            }
        )
    }
    
    # Group 5: All Params
    # All elements must be strings
    # All elements must not be null, empty, or whitespace-only
    @{
        GroupNumber      = 5
        GroupDescription = "All params set: AllowCollections, StrictStringType, NotEmptyOrNull"
        Params           = @('AllowCollections', 'StrictStringType', 'NotEmptyOrNull')
        Cases            = @(
            @{  TestNumber      = 1
                TestDescription = "All valid strings"
                Value           = @( "a", "b", "c" )
                Expected        = $true
                ExitCode        = 0
                ReasonLike      = "string-like objects"
            }
            @{  TestNumber      = 2
                TestDescription = "Contains empty string"
                Value           = @( "a", "" )
                Expected        = $false
                ExitCode        = 1
                ReasonLike      = "null, empty"
            }
            @{  TestNumber      = 3
                TestDescription = "Contains whitespace string"
                Value           = @( "a", " " )
                Expected        = $false
                ExitCode        = 1
                ReasonLike      = "null, empty"
            }
            @{  TestNumber      = 4
                TestDescription = "Contains non-string object"
                Value           = @( "a", 5 )
                Expected        = $false
                ExitCode        = 2
                ReasonLike      = "not strings"
            }
            @{  TestNumber      = 5
                TestDescription = "Nested arrays, all valid strings"
                Value           = @( "one", @( "two", @("three")))
                Expected        = $true
                ExitCode        = 0
                ReasonLike      = "string-like"
            }
            @{  TestNumber      = 6
                TestDescription = "Nested arrays, one null"
                Value           = @( "one", @($null, @("three")))
                Expected        = $false
                ExitCode        = 2
                ReasonLike      = "not strings"
            }
            @{  TestNumber      = 7
                TestDescription = "Empty array"
                Value           = @()
                Expected        = $false
                ExitCode        = 2
                ReasonLike      = "not strings."
            }
            @{  TestNumber      = 8
                TestDescription = "Nested empty array"
                Value           = @( "one", @())
                Expected        = $false
                ExitCode        = 2
                ReasonLike      = "not strings."
            }
            @{  TestNumber      = 9
                TestDescription = "HashTable with valid strings"
                Value           = @{ a = "x"; b = "y" }
                Expected        = $true
                ExitCode        = 0
                ReasonLike      = "string-like"
            }
            @{  TestNumber      = 10
                TestDescription = "HashTable with null value"
                Value           = @{ a = "x"; b = $null }
                Expected        = $false
                ExitCode        = 2
                ReasonLike      = "not strings."
            }
        )
    }
    
    # Group 6: StrictStringType + AllowCollections
    # All elements must be strings.
    @{
        GroupNumber      = 6
        GroupDescription = "StrictStringType + AllowCollections"
        Params           = @("StrictStringType", "AllowCollections")
        Cases            = @(
            @{  TestNumber      = 1
                TestDescription = "Simple string"
                Value           = "Hello"
                Expected        = $true
                ExitCode        = 0
                ReasonLike      = "non-empty string" 
            }
            @{  TestNumber      = 2
                TestDescription = "Array of strings"
                Value           = @("one", "two")
                Expected        = $true
                ExitCode        = 0
                ReasonLike      = "string-like" 
            }
            @{  TestNumber      = 3
                TestDescription = "Array with $null"
                Value           = @("one", $null)
                Expected        = $false
                ExitCode        = 2
                ReasonLike      = "not strings" 
            }
            @{  TestNumber      = 4
                TestDescription = "Empty array"
                Value           = @()
                Expected        = $false
                ExitCode        = 2
                ReasonLike      = "not strings" 
            }
            @{  TestNumber      = 5
                TestDescription = "Hashtable of strings"
                Value           = @{ a = "1"; b = "2" }
                Expected        = $true
                ExitCode        = 0
                ReasonLike      = "string-like" 
            }
            @{  TestNumber      = 6
                TestDescription = "Hashtable with non-string"
                Value           = @{ a = "1"; b = 2 }
                Expected        = $false
                ExitCode        = 2
                ReasonLike      = "not strings" 
            }
            @{  TestNumber      = 7
                TestDescription = "Non-string scalar"
                Value           = 42
                Expected        = $false
                ExitCode        = 2
                ReasonLike      = "not strings" 
            }
            @{  TestNumber      = 8
                TestDescription = "Array with empty array inside"
                Value           = @(@(), "X")
                Expected        = $false
                ExitCode        = 2
                ReasonLike      = "not strings" 
            }
        )
    }

    # Group 7: StrictStringType + NotEmptyOrNull
    # All collections should fail
    # All non-strings should fail
    # All null, empty, or whitespace-only strings should fail
    # All strings that aren't null, empty, or whitespace-only should pass
    @{
        GroupNumber      = 7
        GroupDescription = "StrictStringType + NotEmptyOrNull"
        Params           = @('StrictStringType', 'NotEmptyOrNull')
        Cases            = @(
            @{  TestNumber      = 1
                TestDescription = "Simple string"
                Value           = "hello world"
                Expected        = $true
                ExitCode        = 0
                ReasonLike      = "non-empty string"
            }
            @{  TestNumber      = 1
                TestDescription = "Empty string"
                Value           = ""
                Expected        = $false
                ExitCode        = 1
                ReasonLike      = "empty string but"
            }
            @{  TestNumber      = 3
                TestDescription = "Whitespace-only string"
                Value           = "   "
                Expected        = $false
                ExitCode        = 1
                ReasonLike      = "empty string but"
            }
            @{  TestNumber      = 4
                TestDescription = "Null value"
                Value           = $null
                Expected        = $false
                ExitCode        = 2
                ReasonLike      = "not strings"
            }
            @{  TestNumber      = 5
                TestDescription = "Array of valid strings"
                Value           = @("one", "two")
                Expected        = $false
                ExitCode        = 3
                ReasonLike      = "collection"
            }
            @{  TestNumber      = 6
                TestDescription = "Empty array"
                Value           = @()
                Expected        = $false
                ExitCode        = 3
                ReasonLike      = "collection"
            }
            @{  TestNumber      = 7
                TestDescription = "String inside nested array"
                Value           = @(@("nested"))
                Expected        = $false
                ExitCode        = 3
                ReasonLike      = "collection"
            }
            @{  TestNumber      = 8
                TestDescription = "Non-string value"
                Value           = 12345
                Expected        = $false
                ExitCode        = 2
                ReasonLike      = "not strings"
            }
        )
    }

    @{
        GroupNumber      = 8
        GroupDescription = "AllowCollections + NotEmptyOrNull"
        Params           = @('AllowCollections', 'NotEmptyOrNull')
        Cases            = @(
            @{  TestNumber      = 1
                TestDescription = "Valid string array"
                Value           = @("a", "b")
                Expected        = $true
                ExitCode        = 0
                ReasonLike      = "string-like objects"
            }
            @{  TestNumber      = 2
                TestDescription = "Includes whitespace string"
                Value           = @("hello", "   ")
                Expected        = $false
                ExitCode        = 1
                ReasonLike      = "null, empty, or whitespace-only"
            }
            @{  TestNumber      = 3
                TestDescription = "Includes empty string"
                Value           = @("hello", "")
                Expected        = $false
                ExitCode        = 1
                ReasonLike      = "null, empty, or whitespace-only"
            }
            @{  TestNumber      = 4
                TestDescription = "Includes '`$null'"
                Value           = @("hello", $null)
                Expected        = $false
                ExitCode        = 1
                ReasonLike      = "null, empty, or whitespace-only"
            }
            @{  TestNumber      = 5
                TestDescription = "Includes array literal @()"
                Value           = @("hello", @())
                Expected        = $false
                ExitCode        = 1
                ReasonLike      = "null, empty, or whitespace-only"
            }
            @{  TestNumber      = 6
                TestDescription = "Empty array input"
                Value           = @()
                Expected        = $false
                ExitCode        = 1
                ReasonLike      = "null, empty, or whitespace-only"
            }
            @{  TestNumber      = 7
                TestDescription = "Array with a number"
                Value           = @(123, "abc")
                Expected        = $true
                ExitCode        = 0
                ReasonLike      = "string-like objects"
            }
            @{  TestNumber      = 8
                TestDescription = "Array with a hashtable"
                Value           = @("hello", @{a = 1 })
                Expected        = $true
                ExitCode        = 0
                ReasonLike      = "string-like objects"
            }
            @{  TestNumber      = 9
                TestDescription = "Hashtable with all valid values"
                Value           = @{one = "x"; two = "y" }
                Expected        = $true
                ExitCode        = 0
                ReasonLike      = "string-like objects"
            }
            @{  TestNumber      = 10
                TestDescription = "Hashtable with empty string value"
                Value           = @{one = "x"; two = "" }
                Expected        = $false
                ExitCode        = 1
                ReasonLike      = "null, empty, or whitespace-only"
            }
        )
    }


)

$flatTestCases = foreach ($group in $testGroups) {
    foreach ($case in $group.Cases) {
        [PSCustomObject]@{
            GroupNumber = $group.GroupNumber
            TestNumber  = $case.TestNumber
            Params      = $group.Params
            Value       = $case.Value
            Expected    = $case.Expected
            ExitCode    = $case.ExitCode
            ReasonLike  = $case.ReasonLike
        }
    }
}

Describe "Test-StringLike Comprehensive Testing" -ForEach $flatTestCases {
    BeforeAll {
        Import-Module "$PSScriptRoot\..\src\PS-Tools.psm1" -Force
        $case = $_
    }
    
    It "<case.groupnumber>.<case.testnumber>.Return" {
        $paramSplat = @{ Value = $case.Value }
        
        foreach ($param in $case.params) {
            $paramSplat[$param] = $true
        }
        
        $result = Test-StringLike @paramSplat
        $result | Should -BeExactly $case.Expected
    }

    It "<case.groupnumber>.<case.testnumber>.ExitCode" {
        $exitCode = Get-Variable -Scope Global -ValueOnly  -Name "Test-StringLikeExitCode"
        $exitCode | Should -BeExactly $case.ExitCode
    }

    It "<case.groupnumber>.<case.testnumber>.StatusMessage" {
        $status = Get-Variable -Scope Global -ValueOnly  -Name "Test-StringLikeStatus"
        $status.Reason | Should -Match $case.ReasonLike
    }
}