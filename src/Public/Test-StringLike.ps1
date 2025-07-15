<#
.SYNOPSIS
Validates whether a value or all ojects within a collection are strings or can be converted to strings.
.DESCRIPTION
Tests if the provided input is a string or can seamlessly be converted to a string.  
When the -AllowCollections switch is specified, the function recursively validates each object within collections such as arrays or hashtables.  
Additional switches control whether the input must already be a string (-StrictStringType) and whether null, empty, or whitespace-only strings are considered valid (-NotEmptyOrNull).  
Collections are rejected by default unless -AllowCollections is specified.
.PARAMETER value
The object to test. Can be a single object or a collection of objects if -AllowCollections is set.
.PARAMETER NotEmptyOrNull
When set, verifies that the object, or each object in the collection, is not null, empty, or whitespace-only.
.PARAMETER StrictStringType
When set, verifies that the object, or each object in the collection, is already a string. No conversion attempts are made.
.PARAMETER AllowCollections
When set, allowes the inputted object to be a collection (array, hashtable, etc.) and validates each element recursively. When not set, collections will always fail the test.
.EXAMPLE
Test-StringLike -Value "Bopp Bipp" -NotEmptyOrNull
.EXAMPLE
Test-StringLike -Value @("Bopp", "Bipp") -AllowCollections -StrictStringType
#>
function Test-StringLike {
    param(
        [Parameter(HelpMessage = "The object to test. Can be a single object or a collection of objects if -AllowCollections is set.")]
        $Value,

        [Parameter(HelpMessage = "When set, verifies that the object, or each object in the collection, is not null, empty, or whitespace-only.")]
        [switch]$NotEmptyOrNull,

        [Parameter(HelpMessage = "When set, verifies that the object, or each object in the collection, is already a string. No conversion attempts are made.")]
        [switch]$StrictStringType,

        [Parameter(HelpMessage = "When set, allowes the inputted object to be a collection (array, hashtable, etc.) and validates each element recursively. When not set, collections will always fail the test.")]
        [switch]$AllowCollections
    )
    if ((-not $AllowCollections) -and ($Value -is [System.Collections.IDictionary] -or $Value -is [System.Collections.IEnumerable])) {
        Write-Verbose "Collections are not allowed. Value is a collection, returning '$false'."
        return $false
    }

    # If value is a collection but collections are not allowed, fail fast
    if (-not $AllowCollections -and ($Value -is [System.Collections.IEnumerable] -and -not ($Value -is [string]))) {
        return $false
    }

    # If collections are allowed and value is a collection, recurse into elements
    if ($AllowCollections -and ($Value -is [System.Collections.IEnumerable] -and -not ($Value -is [string]))) {
        # For IDictionary, iterate over Values only
        $elements = if ($Value -is [System.Collections.IDictionary]) { $Value.Values } else { $Value }

        # Handle empty collection edge cases for flags
        if ($StrictStringType -and $elements.Count -eq 0) { return $false }
        if ($NotEmptyOrNull -and $elements.Count -eq 0) { return $false }

        foreach ($item in $elements) {
            if (-not (Test-StringLike -Value $item -NotEmptyOrNull:$NotEmptyOrNull -StrictStringType:$StrictStringType -AllowCollections)) {
                return $false
            }
        }
        return $true
    }

    # Scalar validation

    if ($StrictStringType -and $Value -isnot [string]) {
        return $false
    }
    try {
        $stringValue = [string]$Value
    } catch {
        return $false
    }
    if ($NotEmptyOrNull -and [string]::IsNullOrWhiteSpace($stringValue)) {
        return $false
    }
    return $true
}