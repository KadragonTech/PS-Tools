param (
    [Parameter(Mandatory)]
    [string]$Version,
    [string]$OutputRoot = "$PSScriptRoot\BuildOutput"
)

$moduleName = "PS-Tools"
$versionPath = Join-Path $OutputRoot "$Version\$moduleName"
if (-not (Test-Path $versionPath)) {
    New-Item -ItemType Directory -Path $versionPath -Force | Out-Null
}

Write-Output "Coping module files to $versionPath"
Copy-Item -Path "$PSScriptRoot\src\*" -Destination $versionPath -Recurse -Force

Write-Output "Deployment complete."