<#
.SYNOPSIS
Validates whether a value — or each object within a collection — can be treated as a string.

.DESCRIPTION
Determines whether the provided input is a string or can be seamlessly converted to one.

By default, collections are not allowed. When the -AllowCollections switch is specified, the function recursively inspects each object in supported collections, such as arrays or hashtables.

You can enforce additional checks using these switches:
- Use `-StrictStringType` to require that the value (or each element in a collection) is already a string (no implicit conversion is attempted).
- Use `-NotEmptyOrNull` to ensure that the value (or each element in a collection) is not null, empty, or whitespace-only.

The function returns a Boolean result.
Diagnostic metadata — such as `$ExitCode` and `$Reason` — is stored in `Test-StringLikeStatus` and `Test-StringLikeExitCode`.

.PARAMETER Value
The object to validate. Can be a single object, or a collection if -AllowCollections is used.

.PARAMETER NotEmptyOrNull
When specified, ensures that the value — or each element in the collection — is not null, empty, or whitespace-only.

.PARAMETER StrictStringType
When specified, requires that the value — or each element in the collection — is explicitly a string. No type conversion is attempted.

.PARAMETER AllowCollections
Allows the input to be a collection such as an array, or hashtable. Each element is validated individually. If not specified, passing a collection causes the function to fail.

.EXAMPLE
Test-StringLike -Value "Bopp Bipp" -NotEmptyOrNull

Returns $true. The string is not null or empty.

.EXAMPLE
Test-StringLike -Value @("Bopp", "Bipp") -AllowCollections -StrictStringType
Returns $true. Each element is already a string, and collections and explicitly allowed.

.EXAMPLE
Test-StringLike -Value @("Bopp Bipp", $null) -AllowCollections -NotEmptyOrNull

Returns $false. One element is `$null`, and `NotEmptyOrNull` is enabled.

.EXAMPLE
Test-StringLike -Value @(@(), "test") -AllowCollections -StrictStringType

Returns $false. The empty array fails the strict string type check.
#>
function Test-StringLike {
    [cmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(HelpMessage = "The object to validate. Can be a single object, or a collection if -AllowCollections is used.")]
        $Value,

        [Parameter(HelpMessage = "Ensures the value — or each element in a collection — is not null, empty, or whitespace-only.")]
        [switch]$NotEmptyOrNull,

        [Parameter(HelpMessage = "Requires the value — or each element in a collection — to already be a string. No type conversion is performed.")]
        [switch]$StrictStringType,

        [Parameter(HelpMessage = "Allows the input to be a collection (array, hashtable, etc.) and recursively validates each element. If not specified, collections are rejected.")]
        [switch]$AllowCollections
    )
    Write-Verbose "Test-StringLike | Starting validation"
    Set-FunctionStatus $null
    if ($Value) {
        Write-Debug "Test-StringLike | Value is '$Value' of Type '$($Value.GetType())'"
    } else {
        Write-Debug "Test-StringLike | Value is '`$null'."
    }

    # Check early if a String is passed
    if ($Value -is [string]) {
        if (-not ([string]::IsNullOrWhiteSpace($Value))) {
            Write-Verbose "Test-StringLike | Value is a non-empty string, returning '$true'."
            Write-Debug "Test-StringLike | Value is '$Value'"
            Set-FunctionStatus -ExitCode 0 -Reason "Value is a non-empty string."
            return $true
        } elseif ([string]::IsNullOrWhiteSpace($Value) -and -not $NotEmptyOrNull) {
            Write-Verbose "Test-StringLike | Value is an empty string, but empty strings are allowed, returning '$true'"
            Write-Debug "Test-StringLike | Value is '$Value'"
            Set-FunctionStatus -ExitCode 0 -Reason "Value is an empty string but '`$NotEmptyOrNull' is not specified."
            return $true
        } else {
            Write-Verbose "Test-StringLike | Value is an empty string and 'NotEmptyOrNull' is set. Returning '$false'"
            Write-Debug "Test-StringLike | Value is '$Value'"
            Set-FunctionStatus -ExitCode 1 -Reason "Value is an empty string but '`$NotEmptyOrNull' is specified."
            return $false
        }
    }

    $isCollection = ($Value -is [System.Collections.IDictionary] -or $Value -is [System.Collections.IEnumerable]) -and ($Value -isnot [string])

    # Fail is a collection is passed when collections are not allowed
    if ((-not $AllowCollections -and $isCollection)) {
        Write-Verbose "Test-StringLike | Value is a collection. '`$AllowCollections' not specified. Returning '$false'."
        Write-Debug "Test-StringLike | Value is '$Value' of type: '$($Value.GetType())'."
        Set-FunctionStatus -ExitCode 3 -Reason "Value is a collection. AllowCollections not specified."
        return $false
    }

    $itemsToTest = New-Object System.Collections.Generic.List[object]
    if ($isCollection) {
        $PSDefaultParameterValues.Remove('Invoke-Pester:Path')
        Write-Verbose "Test-StringLike | Value is a collection. '`$AllowCollections' specified. Getting collection elements."
        $elements = if ($Value -is [System.Collections.IDictionary]) { $Value.Values } else { $Value }
        $itemsToTest.AddRange(@(Get-FlattenedCollection $elements))
    } else {
        $itemsToTest.Add($Value)
    }

    foreach ($item in $itemsToTest) {
        if ($StrictStringType -and $item -isnot [string]) {
            Write-Verbose "Test-StringLike | One or more elements are not strings. '`$StrictStringType' specified. Returning '$false'"
            Set-FunctionStatus -ExitCode 2 -Reason "One or more elements are not strings. StrictStringType specified."
            return $false 
        }
        try {
            $itemString = [string]$item
        } catch {
            $msg = $_.Exception.Message
            Write-Verbose "Test-StringLike | Exception during conversion: $msg. Returning '$false'"
            Set-FunctionStatus -ExitCode 4 -Reason "Conversion error: $msg"
            return $false
        }
        if ($NotEmptyOrNull -and [string]::IsNullOrWhiteSpace($itemString)) {
            Write-Verbose "Test-StringLike | One or more elements are null, empty, or whitespace-only. '`$NotEmptyOrNull' specified. Returning '$false'"
            Set-FunctionStatus -ExitCode 1 -Reason "One or more elements are null, empty, or whitespace-only. '`$NotEmptyOrNull' specified."
            return $false
        }
    }
    Write-Verbose "Test-StringLike | All elements passed validation checks. Returning '$true'"
    Set-FunctionStatus -ExitCode 0 -Reason "Validation Passed. All elements are string-like objects."
    return $true
}