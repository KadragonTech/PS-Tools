function Get-FlattenedCollection {
    param (
        [object]$InputObject
    )

    if ($null -eq $InputObject) {
        return @($null)
    }

    if ($InputObject -is [string] -or $InputObject -isnot [System.Collections.IEnumerable]) {
        return @($InputObject)
    }

    $inputObjectValues = if ($InputObject -is [System.Collections.IDictionary]) { $InputObject.Values } else { $InputObject }

    $result = New-Object System.Collections.Generic.List[object]
    foreach ($item in $inputObjectValues) {
        if ($null -eq $item -or $item -is [string] -or $item -isnot [System.Collections.IEnumerable]) {
            $result.Add($item)
        } else {
            $flattened = Get-FlattenedCollection $item
            if ($flattened -is [System.Collections.IEnumerable] -and $flattened -isnot [string] -and ($flattened | Measure-Object).Count -gt 0) {
                $result.AddRange($flattened)
            } else {
                $result.Add($flattened)
            }

        }
    }
    return $result
}
