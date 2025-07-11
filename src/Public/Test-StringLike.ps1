<#
.SYNOPSIS
Tests if object is a string or a string like object.
.DESCRIPTION
Accepts an object and tests if it is either a string or can be cleanly converted to a string.
.PARAMETER value
The object to test if it is a string or can seamlessly be converted to a string.
.PARAMETER NotEmpty
Verifies that the inputted object is not, or does not result in, an empty string.
.PARAMETER StrictStringType
Verifies that the inputted object is already a string. Does not attempt to convert to a string.
.PARAMETER AllowCollections
Verifies each item in a collection. Otherwise, collections will always result in failure.
.EXAMPLE
Test-StringLike -value = $string -NotEmpty
.EXAMPLE
Test-StringLike -value = $HashTableObject -AllowCollections
#>
function Test-StringLike {
    param(
        [Parameter(Mandatory, HelpMessage = "The object to test if it is a string or can seamlessly be converted to a string.")]
        $Value,

        [Parameter(HelpMessage = "Verifies that the inputted object is not, or does not result in, an empty string.")]
        [switch]$NotEmpty,

        [Parameter(HelpMessage = "Verifies that the inputted object is already a string. Does not attempt to convert to a string.")]
        [switch]$StrictStringType,

        [Parameter(HelpMessage = "Verifies each item in a collection. Otherwise, collections will always result in failure.")]
        [switch]$AllowCollections
    )

    $result = $true

    # Short-circuits $false if a collection is passed and AllowCollections is not set
    if ((-not $AllowCollections) -and (($Value -is [array]) -or ($Value -is [hashtable]))) {
        Write-Verbose "Collections are not allowed. Value is a collection, returning '$false'."
        return $false
    }

    # Handles collection validation
    if (($AllowCollections) -and (($Value -is [array]) -or ($Value -is [hashtable]))) {
        Write-Verbose "Value is a collection. Performing collection validation"
        $items = if ($Value -is [hashtable]) { $Value.Values } else { $Value }

        # Empty collection edgecase validation
        if ($StrictStringType -and $items.Count -eq 0) {
            Write-Verbose "StrictStringType is enabled. Value is an empty collection. Setting result to false"
            $result = $false
        }
        if ($NotEmpty -and $items.Count -eq 0) {
            Write-Verbose "NotEmpty is enabled. Value is an empty collection. Setting result to false"
            $result = $false
        }

        foreach ($object in $items) {
            Write-Verbose "Validting collection item: $object"
            try {
                if ($StrictStringType) {
                    $isString = $object -is [string]
                    if (-not $isString) {
                        Write-Verbose "StrictStringType is enabled. $object is not a string. Setting result to false"
                        $result = $false
                    }
                }
                $objectString = [string]$object
                if ($NotEmpty -and [string]::IsNullOrWhiteSpace($objectString)) {
                    Write-Verbose "NotEmpty is enabled. $object is null or whitespace, or results in null or whitespace"
                    $result = $false
                }
            } catch {
                Write-Verbose "Conversion failed for value: $object"
                $result = $false
            }
            if (-not $result) { break }
        }
    }

    # Handles single object validation
    else {
        Write-Verbose "Value is not a collection. Performing standard validation."
        try {
            if ($StrictStringType) {
                $isString = $Value -is [string]
                if (-not $isString) {
                    Write-Verbose "StrictStringType is enabled. $Value is not a string. Setting result to false"
                    $result = $false
                }
            }
            $stringValue = [string]$Value
            if ($NotEmpty -and [string]::IsNullOrWhiteSpace($stringValue)) {
                Write-Verbose "NotEmpty is enabled. $Value is null or whitespace, or results in null or whitespace"
                $result = $false
            }
        } catch {
            Write-Verbose "Conversion failed for value: $Value"
            $result = $false
        }
    }
    Write-Verbose "Returning result: $result"
    return $result
}