Describe "Test-ValidPath" {

    BeforeAll {
        Import-Module "$PSScriptRoot\..\src\PS-Tools.psm1" -Force
    }

    It "accepts a simple relative file path with PathType file" {
        Test-ValidPath "test.txt" -PathType File | Should -BeTrue
    }

    It "rejects non-existent path when MustExist is set" {
        Test-ValidPath "Z:\DefinitelyDoesNotExist" -MustExist | Should -BeFalse
    }

    It "accepts existing file with MustExist" {
        $path = "TestDrive:\sample.txt"
        Set-Content $path "data"
        Test-ValidPath $path -MustExist | Should -BeTrue
    }

    It "rejects directory if PathType file" {
        $dir = "TestDrive:\mydir"
        New-Item -ItemType Directory -Path $dir
        Test-ValidPath $dir -PathType File | Should -BeFalse
    }

    It "accepts file with valid extension" {
        $path = "TestDrive:\good.ps1"
        Set-Content $path ""
        Test-ValidPath $path -MustExist -PathType File -FileExtensions ".ps1" | Should -BeTrue
    }

    It "rejects wrong extension without FailSilently" {
        $path = "TestDrive:\wrong.txt"
        Set-Content $path ""
        Test-ValidPath $path -MustExist -PathType File -FileExtensions ".ps1" | Should -BeFalse
    }

    It "auto coerces PathType with FailSilently" {
        $path = "TestDrive:\auto.ps1"
        Set-Content $path ""
        Test-ValidPath $path -MustExist -FileExtensions ".ps1" -FailSilently | Should -BeTrue
    }

    It "is case-sensitive when requested" {
        $path = "TestDrive:\myfile.TXT"
        Set-Content $path ""
        Test-ValidPath $path -MustExist -PathType File -FileExtensions ".txt" -CaseSensitive | Should -BeFalse
    }

    It "is case-insensitive by default" {
        $path = "TestDrive:\myfile.TXT"
        Set-Content $path ""
        Test-ValidPath $path -MustExist -PathType File -FileExtensions ".txt" | Should -BeTrue
    }

    It "rejects paths with invalid characters" {
        Test-ValidPath "invalid<>path.txt" | Should -BeFalse
    }

    It "rejects file with invalid name characters" {
        Test-ValidPath "bad:file.txt" -PathType File | Should -BeFalse
    }

    It "returns true for directory without extension when PathType directory" {
        $dir = "TestDrive:\validDir"
        New-Item -ItemType Directory -Path $dir
        Test-ValidPath $dir -MustExist -PathType Directory | Should -BeTrue
    }

    It "rejects directory path if PathType file is set" {
        $dir = "TestDrive:\otherDir"
        New-Item -ItemType Directory -Path $dir
        Test-ValidPath $dir -MustExist -PathType File | Should -BeFalse
    }
}