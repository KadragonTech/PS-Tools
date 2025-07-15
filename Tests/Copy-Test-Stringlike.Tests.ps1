# Requires Pester Version 5.0+

# Ensure Pester is available

# To check if Pester Version 5.0+ is installed:
# Run "Get-Module -ListAvailable -Name Pester"

# To install Pester
# Install-Module Pester -Scope CurrentUser -Force

$testGroups = @(

    # Group 1: No params set
    # All collections should fail
    @{
        GroupNumber      = 1
        GroupDescription = "No params set"
        Params           = @()
        Cases            = @(
            @{ TestNumber = 1; TestDescription = "Null"
                Input = $null; Expected = $true
            }
            @{ TestNumber = 2; TestDescription = "Empty String"
                Input = ""; Expected = $true
            }
            @{ TestNumber = 3; TestDescription = "White Space String"
                Input = "   "; Expected = $true
            }
            @{ TestNumber = 4; TestDescription = "Simple String"
                Input = "Bopp Bipp"; Expected = $true
            }
            @{ TestNumber = 5; TestDescription = "Integer"
                Input = 42; Expected = $true
            }
            @{ TestNumber = 6; TestDescription = "Float"
                Input = 0.33; Expected = $true
            }
            @{ TestNumber = 7; TestDescription = "Boolean True"
                Input = $true; Expected = $true
            }
            @{ TestNumber = 8; TestDescription = "Boolean False"
                Input = $false; Expected = $true
            }
            @{ TestNumber = 9; TestDescription = "DateTime"
                Input = "1955-11-05"; Expected = $true
            }
            @{ TestNumber = 10; TestDescription = "Empty HashTable"
                Input = @{}; Expected = $false
            }
            @{ TestNumber = 11; TestDescription = "Empty Array"
                Input = @(); Expected = $false
            }
            @{ TestNumber = 12; TestDescription = "HashTable of Simple Strings"
                Input = @{Bopp = "Bipp"; Birb = "Zephyr" }; Expected = $false
            }
            @{ TestNumber = 13; TestDescription = "Array of Simple Strings"
                Input = @("Bopp", "Bipp", "Birb", "Zephy"); Expected = $false
            }
            @{ TestNumber = 14; TestDescription = "HashTable of Empty Strings"
                Input = @{empty = ""; string = "" }; Expected = $false
            }
            @{ TestNumber = 15; TestDescription = "Array of Empty Strings"
                Input = @("", "", "", ""); Expected = $false
            }
            @{ TestNumber = 16; TestDescription = "HashTable of White Space Strings"
                Input = @{white = "  "; space = "  " }; Expected = $false
            }
            @{ TestNumber = 17; TestDescription = "Array of White Space Strings"
                Input = @("   ", "   ", "   ", "   "); Expected = $false
            }
            @{ TestNumber = 18; TestDescription = "Mixed Type HashTables"
                Input = @{string = "type"; empty = ""; whitespace = "   "; integer = 42; boolean = $true; null = $null }; Expected = $false
            }
            @{ TestNumber = 19; TestDescription = "Mixed Type Array"
                Input = @("type", "", "   ", 42, $true, $null); Expected = $false
            }
            @{ TestNumber = 20; TestDescription = "Nested Array of Simple Strings"
                Input = @(@("Bopp", "Bipp"), @("Birb", "Zephy")); Expected = $false
            }
            @{ TestNumber = 21; TestDescription = "Nested HashTable"
                Input = @{first = @{a = 1; b = 2 }; second = @{c = 3; d = 4 } }; Expected = $false
            }
            @{ TestNumber = 22; TestDescription = "Nested Mixed Collections"
                Input = @(@{string = "type"; empty = ""; integer = 42 }, @($true, $null, "   ")); Expected = $false
            }
            @{ TestNumber = 23; TestDescription = "Empty Nested Collection"
                Input = @(@(), @{}); Expected = $false
            }
            @{ TestNumber = 24; TestDescription = "Deep Nested Arrays"
                Input = @(@(@(@("deep")))); Expected = $false
            }
            @{ TestNumber = 25; TestDescription = "Nested Array with Empty String"
                Input = @(@("valid"), @("")); Expected = $false
            }
            @{ TestNumber = 26; TestDescription = "Nested HashTable with WhiteSpace String"
                Input = @{outer = @{inner = "   " } }; Expected = $false
            }
            @{ TestNumber = 27; TestDescription = "Mixed Nested Collections with Empty Arrays"
                Input = @(@(), @(@()), @{}); Expected = $false
            }
            @{ TestNumber = 28; TestDescription = "Nested Mixed Types"
                Input = @(@("string", 1), @{key = $true }, @($null)); Expected = $false
            }
            @{ TestNumber = 29; TestDescription = "Deep Nested Mixed Collections"
                Input = @(@(@(@(@("deepest")))), @{hash = @{key = "value" } }); Expected = $false
            }
            @{ TestNumber = 30; TestDescription = "Nested Collection with Nulls"
                Input = @($null, @{key = $null }, @($null)); Expected = $false
            }
            @{ TestNumber = 31; TestDescription = "Deep Nested Array with White Space String"
                Input = @(@(@(@(" ")))); Expected = $false
            }
            @{ TestNumber = 32; TestDescription = "Mixxed Collection with Empty Array and Valid String"
                Input = @(@(@(@(@(), "valid")))); Expected = $false
            }
        )
    },
    # Group 2: NotEmptyOrNull param only
    # All Collections should fail
    # Empty Strings and Null values should fail
    # Everything else should pass
    @{
        GroupNumber      = 2
        GroupDescription = "Param: NotEmptyOrNull only"
        Params           = @('NotEmptyOrNull')
        Cases            = @(
            @{ TestNumber = 1; TestDescription = "Null"
                Input = $null; Expected = $false
            }
            @{ TestNumber = 2; TestDescription = "Empty String"
                Input = ""; Expected = $false
            }
            @{ TestNumber = 3; TestDescription = "White Space String"
                Input = "   "; Expected = $false
            }
            @{ TestNumber = 4; TestDescription = "Simple String"
                Input = "Bopp Bipp"; Expected = $true
            }
            @{ TestNumber = 5; TestDescription = "Integer"
                Input = 42; Expected = $true
            }
            @{ TestNumber = 6; TestDescription = "Float"
                Input = 0.33; Expected = $true
            }
            @{ TestNumber = 7; TestDescription = "Boolean True"
                Input = $true; Expected = $true
            }
            @{ TestNumber = 8; TestDescription = "Boolean False"
                Input = $false; Expected = $true
            }
            @{ TestNumber = 9; TestDescription = "DateTime"
                Input = "1955-11-05"; Expected = $true
            }
            @{ TestNumber = 10; TestDescription = "Empty HashTable"
                Input = @{}; Expected = $false
            }
            @{ TestNumber = 11; TestDescription = "Empty Array"
                Input = @(); Expected = $false
            }
            @{ TestNumber = 12; TestDescription = "HashTable of Simple Strings"
                Input = @{Bopp = "Bipp"; Birb = "Zephyr" }; Expected = $false
            }
            @{ TestNumber = 13; TestDescription = "Array of Simple Strings"
                Input = @("Bopp", "Bipp", "Birb", "Zephy"); Expected = $false
            }
            @{ TestNumber = 14; TestDescription = "HashTable of Empty Strings"
                Input = @{empty = ""; string = "" }; Expected = $false
            }
            @{ TestNumber = 15; TestDescription = "Array of Empty Strings"
                Input = @("", "", "", ""); Expected = $false
            }
            @{ TestNumber = 16; TestDescription = "HashTable of White Space Strings"
                Input = @{white = "  "; space = "  " }; Expected = $false
            }
            @{ TestNumber = 17; TestDescription = "Array of White Space Strings"
                Input = @("   ", "   ", "   ", "   "); Expected = $false
            }
            @{ TestNumber = 18; TestDescription = "Mixed Type HashTables"
                Input = @{string = "type"; empty = ""; whitespace = "   "; integer = 42; boolean = $true; null = $null }; Expected = $false
            }
            @{ TestNumber = 19; TestDescription = "Mixed Type Array"
                Input = @("type", "", "   ", 42, $true, $null); Expected = $false
            }
            @{ TestNumber = 20; TestDescription = "Nested Array of Simple Strings"
                Input = @(@("Bopp", "Bipp"), @("Birb", "Zephy")); Expected = $false
            }
            @{ TestNumber = 21; TestDescription = "Nested HashTable"
                Input = @{first = @{a = 1; b = 2 }; second = @{c = 3; d = 4 } }; Expected = $false
            }
            @{ TestNumber = 22; TestDescription = "Nested Mixed Collections"
                Input = @(@{string = "type"; empty = ""; integer = 42 }, @($true, $null, "   ")); Expected = $false
            }
            @{ TestNumber = 23; TestDescription = "Empty Nested Collection"
                Input = @(@(), @{}); Expected = $false
            }
            @{ TestNumber = 24; TestDescription = "Deep Nested Arrays"
                Input = @(@(@(@("deep")))); Expected = $false
            }
            @{ TestNumber = 25; TestDescription = "Nested Array with Empty String"
                Input = @(@("valid"), @("")); Expected = $false
            }
            @{ TestNumber = 26; TestDescription = "Nested HashTable with WhiteSpace String"
                Input = @{outer = @{inner = "   " } }; Expected = $false
            }
            @{ TestNumber = 27; TestDescription = "Mixed Nested Collections with Empty Arrays"
                Input = @(@(), @(@()), @{}); Expected = $false
            }
            @{ TestNumber = 28; TestDescription = "Nested Mixed Types"
                Input = @(@("string", 1), @{key = $true }, @($null)); Expected = $false
            }
            @{ TestNumber = 29; TestDescription = "Deep Nested Mixed Collections"
                Input = @(@(@(@(@("deepest")))), @{hash = @{key = "value" } }); Expected = $false
            }
            @{ TestNumber = 30; TestDescription = "Nested Collection with Nulls"
                Input = @($null, @{key = $null }, @($null)); Expected = $false
            }
            @{ TestNumber = 31; TestDescription = "Deep Nested Array with White Space String"
                Input = @(@(@(@(" ")))); Expected = $false
            }
            @{ TestNumber = 32; TestDescription = "Mixxed Collection with Empty Array and Valid String"
                Input = @(@(@(@(@(), "valid")))); Expected = $false
            }
        )
    },
    # Group 3: StrictStringType param only
    # All Collections should fail
    # All non-Strings should fail
    # All Strings should pass
    @{
        GroupNumber      = 3
        GroupDescription = "Param: StrictStringType only"
        Params           = @('StrictStringType')
        Cases            = @(
            @{ TestNumber = 1; TestDescription = "Null"
                Input = $null; Expected = $false
            }
            @{ TestNumber = 2; TestDescription = "Empty String"
                Input = ""; Expected = $true
            }
            @{ TestNumber = 3; TestDescription = "White Space String"
                Input = "   "; Expected = $true
            }
            @{ TestNumber = 4; TestDescription = "Simple String"
                Input = "Bopp Bipp"; Expected = $true
            }
            @{ TestNumber = 5; TestDescription = "Integer"
                Input = 42; Expected = $false
            }
            @{ TestNumber = 6; TestDescription = "Float"
                Input = 0.33; Expected = $false
            }
            @{ TestNumber = 7; TestDescription = "Boolean True"
                Input = $true; Expected = $false
            }
            @{ TestNumber = 8; TestDescription = "Boolean False"
                Input = $false; Expected = $false
            }
            @{ TestNumber = 9; TestDescription = "DateTime"
                Input = "1955-11-05"; Expected = $true
            }
            @{ TestNumber = 10; TestDescription = "Empty HashTable"
                Input = @{}; Expected = $false
            }
            @{ TestNumber = 11; TestDescription = "Empty Array"
                Input = @(); Expected = $false
            }
            @{ TestNumber = 12; TestDescription = "HashTable of Simple Strings"
                Input = @{Bopp = "Bipp"; Birb = "Zephyr" }; Expected = $false
            }
            @{ TestNumber = 13; TestDescription = "Array of Simple Strings"
                Input = @("Bopp", "Bipp", "Birb", "Zephy"); Expected = $false
            }
            @{ TestNumber = 14; TestDescription = "HashTable of Empty Strings"
                Input = @{empty = ""; string = "" }; Expected = $false
            }
            @{ TestNumber = 15; TestDescription = "Array of Empty Strings"
                Input = @("", "", "", ""); Expected = $false
            }
            @{ TestNumber = 16; TestDescription = "HashTable of White Space Strings"
                Input = @{white = "  "; space = "  " }; Expected = $false
            }
            @{ TestNumber = 17; TestDescription = "Array of White Space Strings"
                Input = @("   ", "   ", "   ", "   "); Expected = $false
            }
            @{ TestNumber = 18; TestDescription = "Mixed Type HashTables"
                Input = @{string = "type"; empty = ""; whitespace = "   "; integer = 42; boolean = $true; null = $null }; Expected = $false
            }
            @{ TestNumber = 19; TestDescription = "Mixed Type Array"
                Input = @("type", "", "   ", 42, $true, $null); Expected = $false
            }
            @{ TestNumber = 20; TestDescription = "Nested Array of Simple Strings"
                Input = @(@("Bopp", "Bipp"), @("Birb", "Zephy")); Expected = $false
            }
            @{ TestNumber = 21; TestDescription = "Nested HashTable"
                Input = @{first = @{a = 1; b = 2 }; second = @{c = 3; d = 4 } }; Expected = $false
            }
            @{ TestNumber = 22; TestDescription = "Nested Mixed Collections"
                Input = @(@{string = "type"; empty = ""; integer = 42 }, @($true, $null, "   ")); Expected = $false
            }
            @{ TestNumber = 23; TestDescription = "Empty Nested Collection"
                Input = @(@(), @{}); Expected = $false
            }
            @{ TestNumber = 24; TestDescription = "Deep Nested Arrays"
                Input = @(@(@(@("deep")))); Expected = $false
            }
            @{ TestNumber = 25; TestDescription = "Nested Array with Empty String"
                Input = @(@("valid"), @("")); Expected = $false
            }
            @{ TestNumber = 26; TestDescription = "Nested HashTable with WhiteSpace String"
                Input = @{outer = @{inner = "   " } }; Expected = $false
            }
            @{ TestNumber = 27; TestDescription = "Mixed Nested Collections with Empty Arrays"
                Input = @(@(), @(@()), @{}); Expected = $false
            }
            @{ TestNumber = 28; TestDescription = "Nested Mixed Types"
                Input = @(@("string", 1), @{key = $true }, @($null)); Expected = $false
            }
            @{ TestNumber = 29; TestDescription = "Deep Nested Mixed Collections"
                Input = @(@(@(@(@("deepest")))), @{hash = @{key = "value" } }); Expected = $false
            }
            @{ TestNumber = 30; TestDescription = "Nested Collection with Nulls"
                Input = @($null, @{key = $null }, @($null)); Expected = $false
            }
            @{ TestNumber = 31; TestDescription = "Deep Nested Array with White Space String"
                Input = @(@(@(@(" ")))); Expected = $false
            }
            @{ TestNumber = 32; TestDescription = "Mixxed Collection with Empty Array and Valid String"
                Input = @(@(@(@(@(), "valid")))); Expected = $false
            }
        )
    },
    # Group 4: NotEmptyOrNull and StrictStringType params
    # All Collections should fail
    # All non-Strings should fail
    # All empty strings should fail
    # non-empty strings should pass
    
    @{
        GroupNumber      = 4
        GroupDescription = "Params: NotEmptyOrNull, StrictStringType"
        Params           = @('NotEmptyOrNull', 'StrictStringType')
        Cases            = @(
            @{ TestNumber = 1; TestDescription = "Null"
                Input = $null; Expected = $false
            }
            @{ TestNumber = 2; TestDescription = "Empty String"
                Input = ""; Expected = $false
            }
            @{ TestNumber = 3; TestDescription = "White Space String"
                Input = "   "; Expected = $false
            }
            @{ TestNumber = 4; TestDescription = "Simple String"
                Input = "Bopp Bipp"; Expected = $true
            }
            @{ TestNumber = 5; TestDescription = "Integer"
                Input = 42; Expected = $false
            }
            @{ TestNumber = 6; TestDescription = "Float"
                Input = 0.33; Expected = $false
            }
            @{ TestNumber = 7; TestDescription = "Boolean True"
                Input = $true; Expected = $false
            }
            @{ TestNumber = 8; TestDescription = "Boolean False"
                Input = $false; Expected = $false
            }
            @{ TestNumber = 9; TestDescription = "DateTime"
                Input = "1955-11-05"; Expected = $true
            }
            @{ TestNumber = 10; TestDescription = "Empty HashTable"
                Input = @{}; Expected = $false
            }
            @{ TestNumber = 11; TestDescription = "Empty Array"
                Input = @(); Expected = $false
            }
            @{ TestNumber = 12; TestDescription = "HashTable of Simple Strings"
                Input = @{Bopp = "Bipp"; Birb = "Zephyr" }; Expected = $false
            }
            @{ TestNumber = 13; TestDescription = "Array of Simple Strings"
                Input = @("Bopp", "Bipp", "Birb", "Zephy"); Expected = $false
            }
            @{ TestNumber = 14; TestDescription = "HashTable of Empty Strings"
                Input = @{empty = ""; string = "" }; Expected = $false
            }
            @{ TestNumber = 15; TestDescription = "Array of Empty Strings"
                Input = @("", "", "", ""); Expected = $false
            }
            @{ TestNumber = 16; TestDescription = "HashTable of White Space Strings"
                Input = @{white = "  "; space = "  " }; Expected = $false
            }
            @{ TestNumber = 17; TestDescription = "Array of White Space Strings"
                Input = @("   ", "   ", "   ", "   "); Expected = $false
            }
            @{ TestNumber = 18; TestDescription = "Mixed Type HashTables"
                Input = @{string = "type"; empty = ""; whitespace = "   "; integer = 42; boolean = $true; null = $null }; Expected = $false
            }
            @{ TestNumber = 19; TestDescription = "Mixed Type Array"
                Input = @("type", "", "   ", 42, $true, $null); Expected = $false
            }
            @{ TestNumber = 20; TestDescription = "Nested Array of Simple Strings"
                Input = @(@("Bopp", "Bipp"), @("Birb", "Zephy")); Expected = $false
            }
            @{ TestNumber = 21; TestDescription = "Nested HashTable"
                Input = @{first = @{a = 1; b = 2 }; second = @{c = 3; d = 4 } }; Expected = $false
            }
            @{ TestNumber = 22; TestDescription = "Nested Mixed Collections"
                Input = @(@{string = "type"; empty = ""; integer = 42 }, @($true, $null, "   ")); Expected = $false
            }
            @{ TestNumber = 23; TestDescription = "Empty Nested Collection"
                Input = @(@(), @{}); Expected = $false
            }
            @{ TestNumber = 24; TestDescription = "Deep Nested Arrays"
                Input = @(@(@(@("deep")))); Expected = $false
            }
            @{ TestNumber = 25; TestDescription = "Nested Array with Empty String"
                Input = @(@("valid"), @("")); Expected = $false
            }
            @{ TestNumber = 26; TestDescription = "Nested HashTable with WhiteSpace String"
                Input = @{outer = @{inner = "   " } }; Expected = $false
            }
            @{ TestNumber = 27; TestDescription = "Mixed Nested Collections with Empty Arrays"
                Input = @(@(), @(@()), @{}); Expected = $false
            }
            @{ TestNumber = 28; TestDescription = "Nested Mixed Types"
                Input = @(@("string", 1), @{key = $true }, @($null)); Expected = $false
            }
            @{ TestNumber = 29; TestDescription = "Deep Nested Mixed Collections"
                Input = @(@(@(@(@("deepest")))), @{hash = @{key = "value" } }); Expected = $false
            }
            @{ TestNumber = 30; TestDescription = "Nested Collection with Nulls"
                Input = @($null, @{key = $null }, @($null)); Expected = $false
            }
            @{ TestNumber = 31; TestDescription = "Deep Nested Array with White Space String"
                Input = @(@(@(@(" ")))); Expected = $false
            }
            @{ TestNumber = 32; TestDescription = "Mixxed Collection with Empty Array and Valid String"
                Input = @(@(@(@(@(), "valid")))); Expected = $false
            }
        )
    },
    # Group 5: AllowCollections only
    @{
        GroupNumber      = 5
        GroupDescription = "Param: AllowCollections only"
        Params           = @('AllowCollections')
        Cases            = @(
            @{ TestNumber = 1; TestDescription = "Null"
                Input = $null; Expected = $true
            }
            @{ TestNumber = 2; TestDescription = "Empty String"
                Input = ""; Expected = $true
            }
            @{ TestNumber = 3; TestDescription = "White Space String"
                Input = "   "; Expected = $true
            }
            @{ TestNumber = 4; TestDescription = "Simple String"
                Input = "Bopp Bipp"; Expected = $true
            }
            @{ TestNumber = 5; TestDescription = "Integer"
                Input = 42; Expected = $true
            }
            @{ TestNumber = 6; TestDescription = "Float"
                Input = 0.33; Expected = $true
            }
            @{ TestNumber = 7; TestDescription = "Boolean True"
                Input = $true; Expected = $true
            }
            @{ TestNumber = 8; TestDescription = "Boolean False"
                Input = $false; Expected = $true
            }
            @{ TestNumber = 9; TestDescription = "DateTime"
                Input = "1955-11-05"; Expected = $true
            }
            @{ TestNumber = 10; TestDescription = "Empty HashTable"
                Input = @{}; Expected = $true
            }
            @{ TestNumber = 11; TestDescription = "Empty Array"
                Input = @(); Expected = $true
            }
            @{ TestNumber = 12; TestDescription = "HashTable of Simple Strings"
                Input = @{Bopp = "Bipp"; Birb = "Zephyr" }; Expected = $true
            }
            @{ TestNumber = 13; TestDescription = "Array of Simple Strings"
                Input = @("Bopp", "Bipp", "Birb", "Zephy"); Expected = $true
            }
            @{ TestNumber = 14; TestDescription = "HashTable of Empty Strings"
                Input = @{empty = ""; string = "" }; Expected = $true
            }
            @{ TestNumber = 15; TestDescription = "Array of Empty Strings"
                Input = @("", "", "", ""); Expected = $true
            }
            @{ TestNumber = 16; TestDescription = "HashTable of White Space Strings"
                Input = @{white = "  "; space = "  " }; Expected = $true
            }
            @{ TestNumber = 17; TestDescription = "Array of White Space Strings"
                Input = @("   ", "   ", "   ", "   "); Expected = $true
            }
            @{ TestNumber = 18; TestDescription = "Mixed Type HashTables"
                Input = @{string = "type"; empty = ""; whitespace = "   "; integer = 42; boolean = $true; null = $null }; Expected = $true
            }
            @{ TestNumber = 19; TestDescription = "Mixed Type Array"
                Input = @("type", "", "   ", 42, $true, $null); Expected = $true
            }
            @{ TestNumber = 20; TestDescription = "Nested Array of Simple Strings"
                Input = @(@("Bopp", "Bipp"), @("Birb", "Zephy")); Expected = $true
            }
            @{ TestNumber = 21; TestDescription = "Nested HashTable"
                Input = @{first = @{a = 1; b = 2 }; second = @{c = 3; d = 4 } }; Expected = $true
            }
            @{ TestNumber = 22; TestDescription = "Nested Mixed Collections"
                Input = @(@{string = "type"; empty = ""; integer = 42 }, @($true, $null, "   ")); Expected = $true
            }
            @{ TestNumber = 23; TestDescription = "Empty Nested Collection"
                Input = @(@(), @{}); Expected = $true
            }
            @{ TestNumber = 24; TestDescription = "Deep Nested Arrays"
                Input = @(@(@(@("deep")))); Expected = $true
            }
            @{ TestNumber = 25; TestDescription = "Nested Array with Empty String"
                Input = @(@("valid"), @("")); Expected = $true
            }
            @{ TestNumber = 26; TestDescription = "Nested HashTable with WhiteSpace String"
                Input = @{outer = @{inner = "   " } }; Expected = $true
            }
            @{ TestNumber = 27; TestDescription = "Mixed Nested Collections with Empty Arrays"
                Input = @(@(), @(@()), @{}); Expected = $true
            }
            @{ TestNumber = 28; TestDescription = "Nested Mixed Types"
                Input = @(@("string", 1), @{key = $true }, @($null)); Expected = $true
            }
            @{ TestNumber = 29; TestDescription = "Deep Nested Mixed Collections"
                Input = @(@(@(@(@("deepest")))), @{hash = @{key = "value" } }); Expected = $true
            }
            @{ TestNumber = 30; TestDescription = "Nested Collection with Nulls"
                Input = @($null, @{key = $null }, @($null)); Expected = $true
            }
            @{ TestNumber = 31; TestDescription = "DateTime (string)"
                Input = "1955-11-05"; Expected = $true
            }
            @{ TestNumber = 32; TestDescription = "Boolean True (again)"
                Input = $true; Expected = $true
            }
        )
    },
    # Group 6: NotEmptyOrNull + AllowCollections
    @{
        GroupNumber      = 6
        GroupDescription = "Params: NotEmptyOrNull, AllowCollections"
        Params           = @('NotEmptyOrNull', 'AllowCollections')
        Cases            = @(
            @{ TestNumber = 1; TestDescription = "Null"
                Input = $null; Expected = $false
            }
            @{ TestNumber = 2; TestDescription = "Empty String"
                Input = ""; Expected = $false
            }
            @{ TestNumber = 3; TestDescription = "White Space String"
                Input = "   "; Expected = $false
            }
            @{ TestNumber = 4; TestDescription = "Simple String"
                Input = "Bopp Bipp"; Expected = $true
            }
            @{ TestNumber = 5; TestDescription = "Integer"
                Input = 42; Expected = $true
            }
            @{ TestNumber = 6; TestDescription = "Float"
                Input = 0.33; Expected = $true
            }
            @{ TestNumber = 7; TestDescription = "Boolean True"
                Input = $true; Expected = $true
            }
            @{ TestNumber = 8; TestDescription = "Boolean False"
                Input = $false; Expected = $true
            }
            @{ TestNumber = 9; TestDescription = "DateTime"
                Input = "1955-11-05"; Expected = $true
            }
            @{ TestNumber = 10; TestDescription = "Empty HashTable"
                Input = @{}; Expected = $false
            }
            @{ TestNumber = 11; TestDescription = "Empty Array"
                Input = @(); Expected = $false
            }
            @{ TestNumber = 12; TestDescription = "HashTable of Simple Strings"
                Input = @{Bopp = "Bipp"; Birb = "Zephyr" }; Expected = $true
            }
            @{ TestNumber = 13; TestDescription = "Array of Simple Strings"
                Input = @("Bopp", "Bipp", "Birb", "Zephy"); Expected = $true
            }
            @{ TestNumber = 14; TestDescription = "HashTable of Empty Strings"
                Input = @{empty = ""; string = "" }; Expected = $false
            }
            @{ TestNumber = 15; TestDescription = "Array of Empty Strings"
                Input = @("", "", "", ""); Expected = $false
            }
            @{ TestNumber = 16; TestDescription = "HashTable of White Space Strings"
                Input = @{white = "  "; space = "  " }; Expected = $false
            }
            @{ TestNumber = 17; TestDescription = "Array of White Space Strings"
                Input = @("   ", "   ", "   ", "   "); Expected = $false
            }
            @{ TestNumber = 18; TestDescription = "Mixed Type HashTables"
                Input = @{string = "type"; empty = ""; whitespace = "   "; integer = 42; boolean = $true; null = $null }; Expected = $false
            }
            @{ TestNumber = 19; TestDescription = "Mixed Type Array"
                Input = @("type", "", "   ", 42, $true, $null); Expected = $false
            }
            @{ TestNumber = 20; TestDescription = "Nested Array of Simple Strings"
                Input = @(@("Bopp", "Bipp"), @("Birb", "Zephy")); Expected = $true
            }
            @{ TestNumber = 21; TestDescription = "Nested HashTable"
                Input = @{first = @{a = 1; b = 2 }; second = @{c = 3; d = 4 } }; Expected = $true
            }
            @{ TestNumber = 22; TestDescription = "Nested Mixed Collections"
                Input = @(@{string = "type"; empty = ""; integer = 42 }, @($true, $null, "   ")); Expected = $false
            }
            @{ TestNumber = 23; TestDescription = "Empty Nested Collection"
                Input = @(@(), @{}); Expected = $false
            }
            @{ TestNumber = 24; TestDescription = "Deep Nested Arrays"
                Input = @(@(@(@("deep")))); Expected = $true
            }
            @{ TestNumber = 25; TestDescription = "Nested Array with Empty String"
                Input = @(@("valid"), @("")); Expected = $false
            }
            @{ TestNumber = 26; TestDescription = "Nested HashTable with WhiteSpace String"
                Input = @{outer = @{inner = "   " } }; Expected = $false
            }
            @{ TestNumber = 27; TestDescription = "Mixed Nested Collections with Empty Arrays"
                Input = @(@(), @(@()), @{}); Expected = $false
            }
            @{ TestNumber = 28; TestDescription = "Nested Mixed Types"
                Input = @(@("string", 1), @{key = $true }, @($null)); Expected = $false
            }
            @{ TestNumber = 29; TestDescription = "Deep Nested Mixed Collections"
                Input = @(@(@(@(@("deepest")))), @{hash = @{key = "value" } }); Expected = $true
            }
            @{ TestNumber = 30; TestDescription = "Nested Collection with Nulls"
                Input = @($null, @{key = $null }, @($null)); Expected = $false
            }
            @{ TestNumber = 31; TestDescription = "DateTime (string)"
                Input = "1955-11-05"; Expected = $true
            }
            @{ TestNumber = 32; TestDescription = "Boolean True (again)"
                Input = $true; Expected = $true
            }
        )
    },
    # Group 7: StrictStringType + AllowCollections
    @{
        GroupNumber      = 7
        GroupDescription = "Params: StrictStringType, AllowCollections"
        Params           = @('StrictStringType', 'AllowCollections')
        Cases            = @(
            @{ TestNumber = 1; TestDescription = "Null"
                Input = $null; Expected = $false
            }
            @{ TestNumber = 2; TestDescription = "Empty String"
                Input = ""; Expected = $true
            }
            @{ TestNumber = 3; TestDescription = "White Space String"
                Input = "   "; Expected = $true
            }
            @{ TestNumber = 4; TestDescription = "Simple String"
                Input = "Bopp Bipp"; Expected = $true
            }
            @{ TestNumber = 5; TestDescription = "Integer"
                Input = 42; Expected = $false
            }
            @{ TestNumber = 6; TestDescription = "Float"
                Input = 0.33; Expected = $false
            }
            @{ TestNumber = 7; TestDescription = "Boolean True"
                Input = $true; Expected = $false
            }
            @{ TestNumber = 8; TestDescription = "Boolean False"
                Input = $false; Expected = $false
            }
            @{ TestNumber = 9; TestDescription = "DateTime"
                Input = "1955-11-05"; Expected = $true
            }
            @{ TestNumber = 10; TestDescription = "Empty HashTable"
                Input = @{}; Expected = $true
            }
            @{ TestNumber = 11; TestDescription = "Empty Array"
                Input = @(); Expected = $true
            }
            @{ TestNumber = 12; TestDescription = "HashTable of Simple Strings"
                Input = @{Bopp = "Bipp"; Birb = "Zephyr" }; Expected = $true
            }
            @{ TestNumber = 13; TestDescription = "Array of Simple Strings"
                Input = @("Bopp", "Bipp", "Birb", "Zephy"); Expected = $true
            }
            @{ TestNumber = 14; TestDescription = "HashTable of Empty Strings"
                Input = @{empty = ""; string = "" }; Expected = $true
            }
            @{ TestNumber = 15; TestDescription = "Array of Empty Strings"
                Input = @("", "", "", ""); Expected = $true
            }
            @{ TestNumber = 16; TestDescription = "HashTable of White Space Strings"
                Input = @{white = "  "; space = "  " }; Expected = $true
            }
            @{ TestNumber = 17; TestDescription = "Array of White Space Strings"
                Input = @("   ", "   ", "   ", "   "); Expected = $true
            }
            @{ TestNumber = 18; TestDescription = "Mixed Type HashTables"
                Input = @{string = "type"; empty = ""; whitespace = "   "; integer = 42; boolean = $true; null = $null }; Expected = $false
            }
            @{ TestNumber = 19; TestDescription = "Mixed Type Array"
                Input = @("type", "", "   ", 42, $true, $null); Expected = $false
            }
            @{ TestNumber = 20; TestDescription = "Nested Array of Simple Strings"
                Input = @(@("Bopp", "Bipp"), @("Birb", "Zephy")); Expected = $true
            }
            @{ TestNumber = 21; TestDescription = "Nested HashTable"
                Input = @{first = @{a = 1; b = 2 }; second = @{c = 3; d = 4 } }; Expected = $true
            }
            @{ TestNumber = 22; TestDescription = "Nested Mixed Collections"
                Input = @(@{string = "type"; empty = ""; integer = 42 }, @($true, $null, "   ")); Expected = $false
            }
            @{ TestNumber = 23; TestDescription = "Empty Nested Collection"
                Input = @(@(), @{}); Expected = $true
            }
            @{ TestNumber = 24; TestDescription = "Deep Nested Arrays"
                Input = @(@(@(@("deep")))); Expected = $true
            }
            @{ TestNumber = 25; TestDescription = "Nested Array with Empty String"
                Input = @(@("valid"), @("")); Expected = $false
            }
            @{ TestNumber = 26; TestDescription = "Nested HashTable with WhiteSpace String"
                Input = @{outer = @{inner = "   " } }; Expected = $false
            }
            @{ TestNumber = 27; TestDescription = "Mixed Nested Collections with Empty Arrays"
                Input = @(@(), @(@()), @{}); Expected = $true
            }
            @{ TestNumber = 28; TestDescription = "Nested Mixed Types"
                Input = @(@("string", 1), @{key = $true }, @($null)); Expected = $false
            }
            @{ TestNumber = 29; TestDescription = "Deep Nested Mixed Collections"
                Input = @(@(@(@(@("deepest")))), @{hash = @{key = "value" } }); Expected = $true
            }
            @{ TestNumber = 30; TestDescription = "Nested Collection with Nulls"
                Input = @($null, @{key = $null }, @($null)); Expected = $false
            }
            @{ TestNumber = 31; TestDescription = "DateTime (string)"
                Input = "1955-11-05"; Expected = $true
            }
            @{ TestNumber = 32; TestDescription = "Boolean True (again)"
                Input = $true; Expected = $false
            }
        )
    },
    # Group 8: NotEmptyOrNull + StrictStringType + AllowCollections
    @{
        GroupNumber      = 8
        GroupDescription = "Params: NotEmptyOrNull, StrictStringType, AllowCollections"
        Params           = @('NotEmptyOrNull', 'StrictStringType', 'AllowCollections')
        Cases            = @(
            @{ TestNumber = 1; TestDescription = "Null"
                Input = $null; Expected = $false
            }
            @{ TestNumber = 2; TestDescription = "Empty String"
                Input = ""; Expected = $false
            }
            @{ TestNumber = 3; TestDescription = "White Space String"
                Input = "   "; Expected = $false
            }
            @{ TestNumber = 4; TestDescription = "Simple String"
                Input = "Bopp Bipp"; Expected = $true
            }
            @{ TestNumber = 5; TestDescription = "Integer"
                Input = 42; Expected = $false
            }
            @{ TestNumber = 6; TestDescription = "Float"
                Input = 0.33; Expected = $false
            }
            @{ TestNumber = 7; TestDescription = "Boolean True"
                Input = $true; Expected = $false
            }
            @{ TestNumber = 8; TestDescription = "Boolean False"
                Input = $false; Expected = $false
            }
            @{ TestNumber = 9; TestDescription = "DateTime"
                Input = "1955-11-05"; Expected = $true
            }
            @{ TestNumber = 10; TestDescription = "Empty HashTable"
                Input = @{}; Expected = $false
            }
            @{ TestNumber = 11; TestDescription = "Empty Array"
                Input = @(); Expected = $false
            }
            @{ TestNumber = 12; TestDescription = "HashTable of Simple Strings"
                Input = @{Bopp = "Bipp"; Birb = "Zephyr" }; Expected = $true
            }
            @{ TestNumber = 13; TestDescription = "Array of Simple Strings"
                Input = @("Bopp", "Bipp", "Birb", "Zephy"); Expected = $true
            }
            @{ TestNumber = 14; TestDescription = "HashTable of Empty Strings"
                Input = @{empty = ""; string = "" }; Expected = $false
            }
            @{ TestNumber = 15; TestDescription = "Array of Empty Strings"
                Input = @("", "", "", ""); Expected = $false
            }
            @{ TestNumber = 16; TestDescription = "HashTable of White Space Strings"
                Input = @{white = "  "; space = "  " }; Expected = $false
            }
            @{ TestNumber = 17; TestDescription = "Array of White Space Strings"
                Input = @("   ", "   ", "   ", "   "); Expected = $false
            }
            @{ TestNumber = 18; TestDescription = "Mixed Type HashTables"
                Input = @{string = "type"; empty = ""; whitespace = "   "; integer = 42; boolean = $true; null = $null }; Expected = $false
            }
            @{ TestNumber = 19; TestDescription = "Mixed Type Array"
                Input = @("type", "", "   ", 42, $true, $null); Expected = $false
            }
            @{ TestNumber = 20; TestDescription = "Nested Array of Simple Strings"
                Input = @(@("Bopp", "Bipp"), @("Birb", "Zephy")); Expected = $true
            }
            @{ TestNumber = 21; TestDescription = "Nested HashTable"
                Input = @{first = @{a = 1; b = 2 }; second = @{c = 3; d = 4 } }; Expected = $true
            }
            @{ TestNumber = 22; TestDescription = "Nested Mixed Collections"
                Input = @(@{string = "type"; empty = ""; integer = 42 }, @($true, $null, "   ")); Expected = $false
            }
            @{ TestNumber = 23; TestDescription = "Empty Nested Collection"
                Input = @(@(), @{}); Expected = $false
            }
            @{ TestNumber = 24; TestDescription = "Deep Nested Arrays"
                Input = @(@(@(@("deep")))); Expected = $true
            }
            @{ TestNumber = 25; TestDescription = "Nested Array with Empty String"
                Input = @(@("valid"), @("")); Expected = $false
            }
            @{ TestNumber = 26; TestDescription = "Nested HashTable with WhiteSpace String"
                Input = @{outer = @{inner = "   " } }; Expected = $false
            }
            @{ TestNumber = 27; TestDescription = "Mixed Nested Collections with Empty Arrays"
                Input = @(@(), @(@()), @{}); Expected = $false
            }
            @{ TestNumber = 28; TestDescription = "Nested Mixed Types"
                Input = @(@("string", 1), @{key = $true }, @($null)); Expected = $false
            }
            @{ TestNumber = 29; TestDescription = "Deep Nested Mixed Collections"
                Input = @(@(@(@(@("deepest")))), @{hash = @{key = "value" } }); Expected = $true
            }
            @{ TestNumber = 30; TestDescription = "Nested Collection with Nulls"
                Input = @($null, @{key = $null }, @($null)); Expected = $false
            }
            @{ TestNumber = 31; TestDescription = "DateTime (string)"
                Input = "1955-11-05"; Expected = $true
            }
            @{ TestNumber = 32; TestDescription = "Boolean True (again)"
                Input = $true; Expected = $false
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
Describe "Test-StringLike Comprehensive Testing" -ForEach $flatTestCases {
    BeforeAll {
        Import-Module "$PSScriptRoot\..\src\PS-Tools.psm1" -Force
        $test = $_
    }
    It "<test.groupnumber>.<test.testnumber>" {
        $paramHash = @{ Value = $test.Input }
        $test.Params.ForEach({ $paramHash[$_] = $true })
        Test-StringLike @paramHash
    }
}