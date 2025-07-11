# Loads and exports public functions from .\Public\
$PublicFunctions = Get-ChildItem -Path "$PSScriptRoot\Public\" -Recurse -Include "*.ps1"
$PublicFunctions | ForEach-Object { . $_.FullName }

Export-ModuleMember -Function ($PublicFunctions | ForEach-Object {$_.BaseName})

# Loads private functions from .\Private\ but doesn't export them
$PrivateFunctions = Get-ChildItem -Path "$PSScriptRoot\Private\" -Recurse -Include "*.ps1"
$PrivateFunctions | ForEach-Object { . $_.FullName}
