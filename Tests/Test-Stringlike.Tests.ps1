# Requires Pester Version 5.0+

# Ensure Pester is available

# To check if Pester Version 5.0+ is installed:
# Run "Get-Module -ListAvailable -Name Pester"

# To install Pester
# Install-Module Pester -Scope CurrentUser -Force

Describe "Test-StringLike comprehensive tests" {

    BeforeAll {
        Import-Module "$PSScriptRoot\..\src\PS-Tools.psm1" -Force
    }

    # Combo 1: No flags (NotEmpty=$false, StrictStringType=$false, AllowCollections=$false)
    It "handles Value='abc' NotEmpty=False StrictStringType=False AllowCollections=False" {
        $params = @{ Value = "abc" }
        (Test-StringLike @params) | Should -BeExactly $true
    }
    It "handles Value=$true NotEmpty=False StrictStringType=False AllowCollections=False" {
        $params = @{ Value = $true }
        (Test-StringLike @params) | Should -BeExactly $true
    }
    It "handles Value=123 NotEmpty=False StrictStringType=False AllowCollections=False" {
        $params = @{ Value = 123 }
        (Test-StringLike @params) | Should -BeExactly $true
    }
    It "handles Value=123.456 NotEmpty=False StrictStringType=False AllowCollections=False" {
        $params = @{ Value = 123.456 }
        (Test-StringLike @params) | Should -BeExactly $true
    }
    It "handles Value='' NotEmpty=False StrictStringType=False AllowCollections=False" {
        $params = @{ Value = "" }
        (Test-StringLike @params) | Should -BeExactly $true
    }
    It "handles Value='   ' NotEmpty=False StrictStringType=False AllowCollections=False" {
        $params = @{ Value = "   " }
        (Test-StringLike @params) | Should -BeExactly $true
    }
    It "handles Value=@('a','b','c') NotEmpty=False StrictStringType=False AllowCollections=False" {
        $params = @{ Value = @("a", "b", "c") }
        (Test-StringLike @params) | Should -BeExactly $false
    }
    It "handles Value=@(1,'b',$true) NotEmpty=False StrictStringType=False AllowCollections=False" {
        $params = @{ Value = @(1, "b", $true) }
        (Test-StringLike @params) | Should -BeExactly $false
    }
    It "handles Value=@(' ','b','a') NotEmpty=False StrictStringType=False AllowCollections=False" {
        $params = @{ Value = @(" ", "b", "a") }
        (Test-StringLike @params) | Should -BeExactly $false
    }
    It "handles Value=@{'One'=1;'Two'=2} NotEmpty=False StrictStringType=False AllowCollections=False" {
        $params = @{ Value = @{"One" = 1; "Two" = 2 } }
        (Test-StringLike @params) | Should -BeExactly $false
    }
    It "handles Value=@{'One'='Two';'Three'='Four'} NotEmpty=False StrictStringType=False AllowCollections=False" {
        $params = @{ Value = @{"One" = "Two"; "Three" = "Four" } }
        (Test-StringLike @params) | Should -BeExactly $false
    }
    It "handles Value=@{'One'='';'Two'=''} NotEmpty=False StrictStringType=False AllowCollections=False" {
        $params = @{ Value = @{"One" = ""; "Two" = "" } }
        (Test-StringLike @params) | Should -BeExactly $false
    }
    It "handles Value=@{'One'='Two';'Three'=$true;'Five'=' '} NotEmpty=False StrictStringType=False AllowCollections=False" {
        $params = @{ Value = @{"One" = "Two"; "Three" = $true; "Five" = " " } }
        (Test-StringLike @params) | Should -BeExactly $false
    }
    It "handles Value=@() NotEmpty=False StrictStringType=False AllowCollections=False" {
        $params = @{ Value = @() }
        (Test-StringLike @params) | Should -BeExactly $false
    }
    It "handles Value=@{} NotEmpty=False StrictStringType=False AllowCollections=False" {
        $params = @{ Value = @{} }
        (Test-StringLike @params) | Should -BeExactly $false
    }

    # Combo 2: -NotEmpty only (NotEmpty=$true, StrictStringType=$false, AllowCollections=$false)
    It "handles Value='abc' NotEmpty=True StrictStringType=False AllowCollections=False" {
        $params = @{ Value = "abc"; NotEmpty = $true }
        (Test-StringLike @params) | Should -BeExactly $true
    }
    It "handles Value=$true NotEmpty=True StrictStringType=False AllowCollections=False" {
        $params = @{ Value = $true; NotEmpty = $true }
        (Test-StringLike @params) | Should -BeExactly $true
    }
    It "handles Value=123 NotEmpty=True StrictStringType=False AllowCollections=False" {
        $params = @{ Value = 123; NotEmpty = $true }
        (Test-StringLike @params) | Should -BeExactly $true
    }
    It "handles Value=123.456 NotEmpty=True StrictStringType=False AllowCollections=False" {
        $params = @{ Value = 123.456; NotEmpty = $true }
        (Test-StringLike @params) | Should -BeExactly $true
    }
    It "handles Value='' NotEmpty=True StrictStringType=False AllowCollections=False" {
        $params = @{ Value = ""; NotEmpty = $true }
        (Test-StringLike @params) | Should -BeExactly $false
    }
    It "handles Value='   ' NotEmpty=True StrictStringType=False AllowCollections=False" {
        $params = @{ Value = "   "; NotEmpty = $true }
        (Test-StringLike @params) | Should -BeExactly $false
    }
    It "handles Value=@('a','b','c') NotEmpty=True StrictStringType=False AllowCollections=False" {
        $params = @{ Value = @("a", "b", "c"); NotEmpty = $true }
        (Test-StringLike @params) | Should -BeExactly $false
    }
    It "handles Value=@(1,'b',$true) NotEmpty=True StrictStringType=False AllowCollections=False" {
        $params = @{ Value = @(1, "b", $true); NotEmpty = $true }
        (Test-StringLike @params) | Should -BeExactly $false
    }
    It "handles Value=@{'One'=1;'Two'=2} NotEmpty=True StrictStringType=False AllowCollections=False" {
        $params = @{ Value = @{"One" = 1; "Two" = 2 }; NotEmpty = $true }
        (Test-StringLike @params) | Should -BeExactly $false
    }
    It "handles Value=@(' ','b','a') NotEmpty=True StrictStringType=False AllowCollections=False" {
        $params = @{ Value = @(" ", "b", "a"); NotEmpty = $true }
        (Test-StringLike @params) | Should -BeExactly $false
    }
    It "handles Value=@{'One'='Two';'Three'='Four'} NotEmpty=True StrictStringType=False AllowCollections=False" {
        $params = @{ Value = @{"One" = "Two"; "Three" = "Four" }; NotEmpty = $true }
        (Test-StringLike @params) | Should -BeExactly $false
    }
    It "handles Value=@{'One'='';'Two'=''} NotEmpty=True StrictStringType=False AllowCollections=False" {
        $params = @{ Value = @{"One" = ""; "Two" = "" }; NotEmpty = $true }
        (Test-StringLike @params) | Should -BeExactly $false
    }
    It "handles Value=@{'One'='Two';'Three'=$true;'Five'=' '} NotEmpty=True StrictStringType=False AllowCollections=False" {
        $params = @{ Value = @{"One" = "Two"; "Three" = $true; "Five" = " " }; NotEmpty = $true }
        (Test-StringLike @params) | Should -BeExactly $false
    }
    It "handles Value=@() NotEmpty=True StrictStringType=False AllowCollections=False" {
        $params = @{ Value = @(); NotEmpty = $true }
        (Test-StringLike @params) | Should -BeExactly $false
    }
    It "handles Value=@{} NotEmpty=True StrictStringType=False AllowCollections=False" {
        $params = @{ Value = @{}; NotEmpty = $true }
        (Test-StringLike @params) | Should -BeExactly $false
    }

    # Combo 3: -StrictStringType only (NotEmpty=$false, StrictStringType=$true, AllowCollections=$false)
    It "handles Value='abc' NotEmpty=False StrictStringType=True AllowCollections=False" {
        $params = @{ Value = "abc"; StrictStringType = $true }
        (Test-StringLike @params) | Should -BeExactly $true
    }
    It "handles Value=$true NotEmpty=False StrictStringType=True AllowCollections=False" {
        $params = @{ Value = $true; StrictStringType = $true }
        (Test-StringLike @params) | Should -BeExactly $false
    }
    It "handles Value=123 NotEmpty=False StrictStringType=True AllowCollections=False" {
        $params = @{ Value = 123; StrictStringType = $true }
        (Test-StringLike @params) | Should -BeExactly $false
    }
    It "handles Value=123.456 NotEmpty=False StrictStringType=True AllowCollections=False" {
        $params = @{ Value = 123.456; StrictStringType = $true }
        (Test-StringLike @params) | Should -BeExactly $false
    }
    It "handles Value='' NotEmpty=False StrictStringType=True AllowCollections=False" {
        $params = @{ Value = ""; StrictStringType = $true }
        (Test-StringLike @params) | Should -BeExactly $true
    }
    It "handles Value='   ' NotEmpty=False StrictStringType=True AllowCollections=False" {
        $params = @{ Value = "   "; StrictStringType = $true }
        (Test-StringLike @params) | Should -BeExactly $true
    }
    It "handles Value=@('a','b','c') NotEmpty=False StrictStringType=True AllowCollections=False" {
        $params = @{ Value = @("a", "b", "c"); StrictStringType = $true }
        (Test-StringLike @params) | Should -BeExactly $false
    }
    It "handles Value=@(1,'b',$true) NotEmpty=False StrictStringType=True AllowCollections=False" {
        $params = @{ Value = @(1, "b", $true); StrictStringType = $true }
        (Test-StringLike @params) | Should -BeExactly $false
    }
    It "handles Value=@(' ','b','a') NotEmpty=False StrictStringType=True AllowCollections=False" {
        $params = @{ Value = @(" ", "b", "a"); StrictStringType = $true }
        (Test-StringLike @params) | Should -BeExactly $false
    }
    It "handles Value=@{'One'=1;'Two'=2} NotEmpty=False StrictStringType=True AllowCollections=False" {
        $params = @{ Value = @{"One" = 1; "Two" = 2 }; StrictStringType = $true }
        (Test-StringLike @params) | Should -BeExactly $false
    }
    It "handles Value=@{'One'='Two';'Three'='Four'} NotEmpty=False StrictStringType=True AllowCollections=False" {
        $params = @{ Value = @{"One" = "Two"; "Three" = "Four" }; StrictStringType = $true }
        (Test-StringLike @params) | Should -BeExactly $false
    }
    It "handles Value=@{'One'='';'Two'=''} NotEmpty=False StrictStringType=True AllowCollections=False" {
        $params = @{ Value = @{"One" = ""; "Two" = "" }; StrictStringType = $true }
        (Test-StringLike @params) | Should -BeExactly $false
    }
    It "handles Value=@{'One'='Two';'Three'=$true;'Five'=' '} NotEmpty=False StrictStringType=True AllowCollections=False" {
        $params = @{ Value = @{"One" = "Two"; "Three" = $true; "Five" = " " }; StrictStringType = $true }
        (Test-StringLike @params) | Should -BeExactly $false
    }
    It "handles Value=@() NotEmpty=False StrictStringType=True AllowCollections=False" {
        $params = @{ Value = @(); StrictStringType = $true }
        (Test-StringLike @params) | Should -BeExactly $false
    }
    It "handles Value=@{} NotEmpty=False StrictStringType=True AllowCollections=False" {
        $params = @{ Value = @{}; StrictStringType = $true }
        (Test-StringLike @params) | Should -BeExactly $false
    }

    # Combo 4: -NotEmpty & -StrictStringType (NotEmpty=$true, StrictStringType=$true, AllowCollections=$false)
    It "handles Value='abc' NotEmpty=True StrictStringType=True AllowCollections=False" {
        $params = @{ Value = "abc"; NotEmpty = $true; StrictStringType = $true }
        (Test-StringLike @params) | Should -BeExactly $true
    }
    It "handles Value=$true NotEmpty=True StrictStringType=True AllowCollections=False" {
        $params = @{ Value = $true; NotEmpty = $true; StrictStringType = $true }
        (Test-StringLike @params) | Should -BeExactly $false
    }
    It "handles Value=123 NotEmpty=True StrictStringType=True AllowCollections=False" {
        $params = @{ Value = 123; NotEmpty = $true; StrictStringType = $true }
        (Test-StringLike @params) | Should -BeExactly $false
    }
    It "handles Value=123.456 NotEmpty=True StrictStringType=True AllowCollections=False" {
        $params = @{ Value = 123.456; NotEmpty = $true; StrictStringType = $true }
        (Test-StringLike @params) | Should -BeExactly $false
    }
    It "handles Value='' NotEmpty=True StrictStringType=True AllowCollections=False" {
        $params = @{ Value = ""; NotEmpty = $true; StrictStringType = $true }
        (Test-StringLike @params) | Should -BeExactly $false
    }
    It "handles Value='   ' NotEmpty=True StrictStringType=True AllowCollections=False" {
        $params = @{ Value = "   "; NotEmpty = $true; StrictStringType = $true }
        (Test-StringLike @params) | Should -BeExactly $false
    }
    It "handles Value=@('a','b','c') NotEmpty=True StrictStringType=True AllowCollections=False" {
        $params = @{ Value = @("a", "b", "c"); NotEmpty = $true; StrictStringType = $true }
        (Test-StringLike @params) | Should -BeExactly $false
    }
    It "handles Value=@(1,'b',$true) NotEmpty=True StrictStringType=True AllowCollections=False" {
        $params = @{ Value = @(1, "b", $true); NotEmpty = $true; StrictStringType = $true }
        (Test-StringLike @params) | Should -BeExactly $false
    }
    It "handles Value=@(' ','b','a') NotEmpty=True StrictStringType=True AllowCollections=False" {
        $params = @{ Value = @(" ", "b", "a"); NotEmpty = $true; StrictStringType = $true }
        (Test-StringLike @params) | Should -BeExactly $false
    }
    It "handles Value=@{'One'=1;'Two'=2} NotEmpty=True StrictStringType=True AllowCollections=False" {
        $params = @{ Value = @{"One" = 1; "Two" = 2 }; NotEmpty = $true; StrictStringType = $true }
        (Test-StringLike @params) | Should -BeExactly $false
    }
    It "handles Value=@{'One'='Two';'Three'='Four'} NotEmpty=True StrictStringType=True AllowCollections=False" {
        $params = @{ Value = @{"One" = "Two"; "Three" = "Four" }; NotEmpty = $true; StrictStringType = $true }
        (Test-StringLike @params) | Should -BeExactly $false
    }
    It "handles Value=@{'One'='';'Two'=''} NotEmpty=True StrictStringType=True AllowCollections=False" {
        $params = @{ Value = @{"One" = ""; "Two" = "" }; NotEmpty = $true; StrictStringType = $true }
        (Test-StringLike @params) | Should -BeExactly $false
    }
    It "handles Value=@{'One'='Two';'Three'=$true;'Five'=' '} NotEmpty=True StrictStringType=True AllowCollections=False" {
        $params = @{ Value = @{"One" = "Two"; "Three" = $true; "Five" = " " }; NotEmpty = $true; StrictStringType = $true }
        (Test-StringLike @params) | Should -BeExactly $false
    }
    It "handles Value=@() NotEmpty=True StrictStringType=True AllowCollections=False" {
        $params = @{ Value = @(); NotEmpty = $true; StrictStringType = $true }
        (Test-StringLike @params) | Should -BeExactly $false
    }
    It "handles Value=@{} NotEmpty=True StrictStringType=True AllowCollections=False" {
        $params = @{ Value = @{}; NotEmpty = $true; StrictStringType = $true }
        (Test-StringLike @params) | Should -BeExactly $false
    }

    # Combo 5: -AllowCollections only (NotEmpty=$false, StrictStringType=$false, AllowCollections=$true)
    It "handles Value='abc' NotEmpty=False StrictStringType=False AllowCollections=True" {
        $params = @{ Value = "abc"; AllowCollections = $true }
        (Test-StringLike @params) | Should -BeExactly $true
    }
    It "handles Value=$true NotEmpty=False StrictStringType=False AllowCollections=True" {
        $params = @{ Value = $true; AllowCollections = $true }
        (Test-StringLike @params) | Should -BeExactly $true
    }
    It "handles Value=123 NotEmpty=False StrictStringType=False AllowCollections=True" {
        $params = @{ Value = 123; AllowCollections = $true }
        (Test-StringLike @params) | Should -BeExactly $true
    }
    It "handles Value=123.456 NotEmpty=False StrictStringType=False AllowCollections=True" {
        $params = @{ Value = 123.456; AllowCollections = $true }
        (Test-StringLike @params) | Should -BeExactly $true
    }
    It "handles Value='' NotEmpty=False StrictStringType=False AllowCollections=True" {
        $params = @{ Value = ""; AllowCollections = $true }
        (Test-StringLike @params) | Should -BeExactly $true
    }
    It "handles Value='   ' NotEmpty=False StrictStringType=False AllowCollections=True" {
        $params = @{ Value = "   "; AllowCollections = $true }
        (Test-StringLike @params) | Should -BeExactly $true
    }
    It "handles Value=@('a','b','c') NotEmpty=False StrictStringType=False AllowCollections=True" {
        $params = @{ Value = @("a", "b", "c"); AllowCollections = $true }
        (Test-StringLike @params) | Should -BeExactly $true
    }
    It "handles Value=@(1,'b',$true) NotEmpty=False StrictStringType=False AllowCollections=True" {
        $params = @{ Value = @(1, "b", $true); AllowCollections = $true }
        (Test-StringLike @params) | Should -BeExactly $true
    }
    It "handles Value=@(' ','b','a') NotEmpty=False StrictStringType=False AllowCollections=True" {
        $params = @{ Value = @(" ", "b", "a"); AllowCollections = $true }
        (Test-StringLike @params) | Should -BeExactly $true
    }
    It "handles Value=@{'One'=1;'Two'=2} NotEmpty=False StrictStringType=False AllowCollections=True" {
        $params = @{ Value = @{"One" = 1; "Two" = 2 }; AllowCollections = $true }
        (Test-StringLike @params) | Should -BeExactly $true
    }
    It "handles Value=@{'One'='Two';'Three'='Four'} NotEmpty=False StrictStringType=False AllowCollections=True" {
        $params = @{ Value = @{"One" = "Two"; "Three" = "Four" }; AllowCollections = $true }
        (Test-StringLike @params) | Should -BeExactly $true
    }
    It "handles Value=@{'One'='';'Two'=''} NotEmpty=False StrictStringType=False AllowCollections=True" {
        $params = @{ Value = @{"One" = ""; "Two" = "" }; AllowCollections = $true }
        (Test-StringLike @params) | Should -BeExactly $true
    }
    It "handles Value=@{'One'='Two';'Three'=$true;'Five'=' '} NotEmpty=False StrictStringType=False AllowCollections=True" {
        $params = @{ Value = @{"One" = "Two"; "Three" = $true; "Five" = " " }; AllowCollections = $true }
        (Test-StringLike @params) | Should -BeExactly $true
    }
    It "handles Value=@() NotEmpty=False StrictStringType=False AllowCollections=True" {
        $params = @{ Value = @(); AllowCollections = $true }
        (Test-StringLike @params) | Should -BeExactly $true
    }
    It "handles Value=@{} NotEmpty=False StrictStringType=False AllowCollections=True" {
        $params = @{ Value = @{}; AllowCollections = $true }
        (Test-StringLike @params) | Should -BeExactly $true
    }

    # Combo 6: -NotEmpty & -AllowCollections (NotEmpty=$true, StrictStringType=$false, AllowCollections=$true)
    It "handles Value='abc' NotEmpty=True StrictStringType=False AllowCollections=True" {
        $params = @{ Value = "abc"; NotEmpty = $true; AllowCollections = $true }
        (Test-StringLike @params) | Should -BeExactly $true
    }
    It "handles Value=$true NotEmpty=True StrictStringType=False AllowCollections=True" {
        $params = @{ Value = $true; NotEmpty = $true; AllowCollections = $true }
        (Test-StringLike @params) | Should -BeExactly $true
    }
    It "handles Value=123 NotEmpty=True StrictStringType=False AllowCollections=True" {
        $params = @{ Value = 123; NotEmpty = $true; AllowCollections = $true }
        (Test-StringLike @params) | Should -BeExactly $true
    }
    It "handles Value=123.456 NotEmpty=True StrictStringType=False AllowCollections=True" {
        $params = @{ Value = 123.456; NotEmpty = $true; AllowCollections = $true }
        (Test-StringLike @params) | Should -BeExactly $true
    }
    It "handles Value='' NotEmpty=True StrictStringType=False AllowCollections=True" {
        $params = @{ Value = ""; NotEmpty = $true; AllowCollections = $true }
        (Test-StringLike @params) | Should -BeExactly $false
    }
    It "handles Value='   ' NotEmpty=True StrictStringType=False AllowCollections=True" {
        $params = @{ Value = "   "; NotEmpty = $true; AllowCollections = $true }
        (Test-StringLike @params) | Should -BeExactly $false
    }
    It "handles Value=@('a','b','c') NotEmpty=True StrictStringType=False AllowCollections=True" {
        $params = @{ Value = @("a", "b", "c"); NotEmpty = $true; AllowCollections = $true }
        (Test-StringLike @params) | Should -BeExactly $true
    }
    It "handles Value=@(1,'b',$true) NotEmpty=True StrictStringType=False AllowCollections=True" {
        $params = @{ Value = @(1, "b", $true); NotEmpty = $true; AllowCollections = $true }
        (Test-StringLike @params) | Should -BeExactly $true
    }
    It "handles Value=@(' ','b','a') NotEmpty=True StrictStringType=False AllowCollections=True" {
        $params = @{ Value = @(" ", "b", "a"); NotEmpty = $true; AllowCollections = $true }
        (Test-StringLike @params) | Should -BeExactly $false
    }
    It "handles Value=@{'One'=1;'Two'=2} NotEmpty=True StrictStringType=False AllowCollections=True" {
        $params = @{ Value = @{"One" = 1; "Two" = 2 }; NotEmpty = $true; AllowCollections = $true }
        (Test-StringLike @params) | Should -BeExactly $true
    }
    It "handles Value=@{'One'='Two';'Three'='Four'} NotEmpty=True StrictStringType=False AllowCollections=True" {
        $params = @{ Value = @{"One" = "Two"; "Three" = "Four" }; NotEmpty = $true; AllowCollections = $true }
        (Test-StringLike @params) | Should -BeExactly $true
    }
    It "handles Value=@{'One'='';'Two'=''} NotEmpty=True StrictStringType=False AllowCollections=True" {
        $params = @{ Value = @{"One" = ""; "Two" = "" }; NotEmpty = $true; AllowCollections = $true }
        (Test-StringLike @params) | Should -BeExactly $false
    }
    It "handles Value=@{'One'='Two';'Three'=$true;'Five'=' '} NotEmpty=True StrictStringType=False AllowCollections=True" {
        $params = @{ Value = @{"One" = "Two"; "Three" = $true; "Five" = " " }; NotEmpty = $true; AllowCollections = $true }
        (Test-StringLike @params) | Should -BeExactly $false
    }
    It "handles Value=@() NotEmpty=True StrictStringType=False AllowCollections=True" {
        $params = @{ Value = @(); NotEmpty = $true; AllowCollections = $true }
        (Test-StringLike @params) | Should -BeExactly $false
    }
    It "handles Value=@{} NotEmpty=True StrictStringType=False AllowCollections=True" {
        $params = @{ Value = @{}; NotEmpty = $true; AllowCollections = $true }
        (Test-StringLike @params) | Should -BeExactly $false
    }

    # Combo 7: -StrictStringType & -AllowCollections (NotEmpty=$false, StrictStringType=$true, AllowCollections=$true)
    It "handles Value='abc' NotEmpty=False StrictStringType=True AllowCollections=True" {
        $params = @{ Value = "abc"; StrictStringType = $true; AllowCollections = $true }
        (Test-StringLike @params) | Should -BeExactly $true
    }
    It "handles Value=$true NotEmpty=False StrictStringType=True AllowCollections=True" {
        $params = @{ Value = $true; StrictStringType = $true; AllowCollections = $true }
        (Test-StringLike @params) | Should -BeExactly $false
    }
    It "handles Value=123 NotEmpty=False StrictStringType=True AllowCollections=True" {
        $params = @{ Value = 123; StrictStringType = $true; AllowCollections = $true }
        (Test-StringLike @params) | Should -BeExactly $false
    }
    It "handles Value=123.456 NotEmpty=False StrictStringType=True AllowCollections=True" {
        $params = @{ Value = 123.456; StrictStringType = $true; AllowCollections = $true }
        (Test-StringLike @params) | Should -BeExactly $false
    }
    It "handles Value='' NotEmpty=False StrictStringType=True AllowCollections=True" {
        $params = @{ Value = ""; StrictStringType = $true; AllowCollections = $true }
        (Test-StringLike @params) | Should -BeExactly $true
    }
    It "handles Value='   ' NotEmpty=False StrictStringType=True AllowCollections=True" {
        $params = @{ Value = "   "; StrictStringType = $true; AllowCollections = $true }
        (Test-StringLike @params) | Should -BeExactly $true
    }
    It "handles Value=@('a','b','c') NotEmpty=False StrictStringType=True AllowCollections=True" {
        $params = @{ Value = @("a", "b", "c"); StrictStringType = $true; AllowCollections = $true }
        (Test-StringLike @params) | Should -BeExactly $true
    }
    It "handles Value=@(1,'b',$true) NotEmpty=False StrictStringType=True AllowCollections=True" {
        $params = @{ Value = @(1, "b", $true); StrictStringType = $true; AllowCollections = $true }
        (Test-StringLike @params) | Should -BeExactly $false
    }
    It "handles Value=@(' ','b','a') NotEmpty=False StrictStringType=True AllowCollections=True" {
        $params = @{ Value = @(" ", "b", "a"); StrictStringType = $true; AllowCollections = $true }
        (Test-StringLike @params) | Should -BeExactly $true
    }
    It "handles Value=@{'One'=1;'Two'=2} NotEmpty=False StrictStringType=True AllowCollections=True" {
        $params = @{ Value = @{"One" = 1; "Two" = 2 }; StrictStringType = $true; AllowCollections = $true }
        (Test-StringLike @params) | Should -BeExactly $false
    }
    It "handles Value=@{'One'='Two';'Three'='Four'} NotEmpty=False StrictStringType=True AllowCollections=True" {
        $params = @{ Value = @{"One" = "Two"; "Three" = "Four" }; StrictStringType = $true; AllowCollections = $true }
        (Test-StringLike @params) | Should -BeExactly $true
    }
    It "handles Value=@{'One'='';'Two'=''} NotEmpty=False StrictStringType=True AllowCollections=True" {
        $params = @{ Value = @{"One" = ""; "Two" = "" }; StrictStringType = $true; AllowCollections = $true }
        (Test-StringLike @params) | Should -BeExactly $true
    }
    It "handles Value=@{'One'='Two';'Three'=$true;'Five'=' '} NotEmpty=False StrictStringType=True AllowCollections=True" {
        $params = @{ Value = @{"One" = "Two"; "Three" = $true; "Five" = " " }; StrictStringType = $true; AllowCollections = $true }
        (Test-StringLike @params) | Should -BeExactly $false
    }
    It "handles Value=@() NotEmpty=False StrictStringType=True AllowCollections=True" {
        $params = @{ Value = @(); StrictStringType = $true; AllowCollections = $true }
        (Test-StringLike @params) | Should -BeExactly $false
    }
    It "handles Value=@{} NotEmpty=False StrictStringType=True AllowCollections=True" {
        $params = @{ Value = @{}; StrictStringType = $true; AllowCollections = $true }
        (Test-StringLike @params) | Should -BeExactly $false
    }

    # Combo 8: -NotEmpty, -StrictStringType, & -AllowCollections (NotEmpty=$true, StrictStringType=$true, AllowCollections=$true)
    It "handles Value='abc' NotEmpty=True StrictStringType=True AllowCollections=True" {
        $params = @{ Value = "abc"; NotEmpty = $true; StrictStringType = $true; AllowCollections = $true }
        (Test-StringLike @params) | Should -BeExactly $true
    }
    It "handles Value=$true NotEmpty=True StrictStringType=True AllowCollections=True" {
        $params = @{ Value = $true; NotEmpty = $true; StrictStringType = $true; AllowCollections = $true }
        (Test-StringLike @params) | Should -BeExactly $false
    }
    It "handles Value=123 NotEmpty=True StrictStringType=True AllowCollections=True" {
        $params = @{ Value = 123; NotEmpty = $true; StrictStringType = $true; AllowCollections = $true }
        (Test-StringLike @params) | Should -BeExactly $false
    }
    It "handles Value=123.456 NotEmpty=True StrictStringType=True AllowCollections=True" {
        $params = @{ Value = 123.456; NotEmpty = $true; StrictStringType = $true; AllowCollections = $true }
        (Test-StringLike @params) | Should -BeExactly $false
    }
    It "handles Value='' NotEmpty=True StrictStringType=True AllowCollections=True" {
        $params = @{ Value = ""; NotEmpty = $true; StrictStringType = $true; AllowCollections = $true }
        (Test-StringLike @params) | Should -BeExactly $false
    }
    It "handles Value='   ' NotEmpty=True StrictStringType=True AllowCollections=True" {
        $params = @{ Value = "   "; NotEmpty = $true; StrictStringType = $true; AllowCollections = $true }
        (Test-StringLike @params) | Should -BeExactly $false
    }
    It "handles Value=@('a','b','c') NotEmpty=True StrictStringType=True AllowCollections=True" {
        $params = @{ Value = @("a", "b", "c"); NotEmpty = $true; StrictStringType = $true; AllowCollections = $true }
        (Test-StringLike @params) | Should -BeExactly $true
    }
    It "handles Value=@(1,'b',$true) NotEmpty=True StrictStringType=True AllowCollections=True" {
        $params = @{ Value = @(1, "b", $true); NotEmpty = $true; StrictStringType = $true; AllowCollections = $true }
        (Test-StringLike @params) | Should -BeExactly $false
    }
    It "handles Value=@(' ','b','a') NotEmpty=True StrictStringType=True AllowCollections=True" {
        $params = @{ Value = @(" ", "b", "a"); NotEmpty = $true; StrictStringType = $true; AllowCollections = $true }
        (Test-StringLike @params) | Should -BeExactly $false
    }
    It "handles Value=@{'One'=1;'Two'=2} NotEmpty=True StrictStringType=True AllowCollections=True" {
        $params = @{ Value = @{"One" = 1; "Two" = 2 }; NotEmpty = $true; StrictStringType = $true; AllowCollections = $true }
        (Test-StringLike @params) | Should -BeExactly $false
    }
    It "handles Value=@{'One'='Two';'Three'='Four'} NotEmpty=True StrictStringType=True AllowCollections=True" {
        $params = @{ Value = @{"One" = "Two"; "Three" = "Four" }; NotEmpty = $true; StrictStringType = $true; AllowCollections = $true }
        (Test-StringLike @params) | Should -BeExactly $true
    }
    It "handles Value=@{'One'='';'Two'=''} NotEmpty=True StrictStringType=True AllowCollections=True" {
        $params = @{ Value = @{"One" = ""; "Two" = "" }; NotEmpty = $true; StrictStringType = $true; AllowCollections = $true }
        (Test-StringLike @params) | Should -BeExactly $false
    }
    It "handles Value=@{'One'='Two';'Three'=$true;'Five'=' '} NotEmpty=True StrictStringType=True AllowCollections=True" {
        $params = @{ Value = @{"One" = "Two"; "Three" = $true; "Five" = " " }; NotEmpty = $true; StrictStringType = $true; AllowCollections = $true }
        (Test-StringLike @params) | Should -BeExactly $false
    }
    It "handles Value=@() NotEmpty=True StrictStringType=True AllowCollections=True" {
        $params = @{ Value = @(); NotEmpty = $true; StrictStringType = $true; AllowCollections = $true }
        (Test-StringLike @params) | Should -BeExactly $false
    }
    It "handles Value=@{} NotEmpty=True StrictStringType=True AllowCollections=True" {
        $params = @{ Value = @{}; NotEmpty = $true; StrictStringType = $true; AllowCollections = $true }
        (Test-StringLike @params) | Should -BeExactly $false
    }
}