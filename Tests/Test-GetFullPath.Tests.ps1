# Requires -Module Pester

Describe "Get-FullPath" {

    BeforeAll {
        Import-Module "$PSScriptRoot\..\src\PS-Tools.psm1" -Force
    }

    Context "Path resolution" {
        It "resolves relative path against current directory" {
            $relPath = "subfolder\file.txt"
            $full = Get-FullPath -Path $relPath
            $expectedPath = Join-Path (Get-Location).Path $relPath
            $escapedPattern = [regex]::Escape($expectedPath)
            $full | Should -Match $escapedPattern
        }

        It "resolves relative path against specified base path" {
            $base = "C:\Windows"
            $relPath = "System32\calc.exe"
            $result = Get-FullPath -Path $relPath -BasePath $base
            $result | Should -Be (Join-Path $base $relPath | Resolve-Path).Path
        }

        It "returns absolute path unchanged" {
            $absPath = "C:\Windows\System32"
            Get-FullPath -Path $absPath | Should -Be $absPath
        }
    }

    Context "MustExist behavior" {
        It "throws if -MustExist is set and path does not exist" {
            { Get-FullPath -Path "Z:\NotReal\file.txt" -MustExist } | Should -Throw
        }

        It "returns existing path with -MustExist" {
            $existing = "C:\Windows"
            Get-FullPath -Path $existing -MustExist | Should -Be (Resolve-Path $existing).Path
        }
    }

    Context "EnsureParentExists" {
        It "creates parent directory if needed" {
            $file = "$PSScriptRoot\DirectoryTesting\test.txt"
            Get-FullPath -Path $file -EnsureParentExists | Out-Null
            Test-Path (Split-Path $file -Parent) | Should -BeTrue
        }
    }

    Context "IsDirectoryPath and IsFilePath" {
        It "throws if -IsDirectoryPath is used on path with file extension" {
            { Get-FullPath -Path "folder\file.txt" -IsDirectoryPath } | Should -Throw
        }

        It "throws if -IsFilePath is used on path without file extension" {
            { Get-FullPath -Path "folder\noextension" -IsFilePath } | Should -Throw
        }
    }

    Context "Defensive parameter check" {
        It "throws if both -IsDirectoryPath and -IsFilePath are set" {
            { Get-FullPath -Path "some\path" -IsDirectoryPath -IsFilePath } | Should -Throw
        }
    }
}
