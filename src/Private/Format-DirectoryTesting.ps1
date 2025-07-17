function Format-DirectoryTesting {
    param(
        [string]$testingFolder
    )
    
    Get-ChildItem -Path $testingFolder -Recurse | Remove-Item -Recurse -Force

    $newFolder = @{
        subDir    = "$testingFolder\subdirectory\"
        hiddenDir = "$testingFolder\.hiddenfolder\"
    }

    $newFiles = @{
        textFile   = "$testingFolder\text.txt"
        subText    = "$testingFolder\subdirectory\sub.txt"
        hiddenText = "$testingFolder\.hiddenfolder\hidden.txt"
    }

    foreach ($folder in $newFolder.Values) {
        $actualpath = [System.IO.Path]::GetFullPath($folder)
        New-Item $actualpath -Force -ItemType Directory | Out-Null
    }

    foreach ($file in $newFiles.Values) {
        $actualpath = [System.IO.Path]::GetFullPath($file)
        $filename = [System.IO.Path]::GetFileName($file)
        New-Item $actualpath -Force -ItemType File | Out-Null
        "This is a file: $filename" | Out-File $actualpath
    }
}