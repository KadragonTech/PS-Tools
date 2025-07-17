@{
    Run          = @{
        Path     = 'Tests\Test-Stringlike.Tests.ps1'
        PassThru = $true
    }

    CodeCoverage = @{
        Enabled               = $true
        Path                  = 'src\Public\Test-StringLike.ps1'
        OutputFormat          = 'CoverageGutters'
        OutputPath            = 'Coverage\gutters.xml'
        OutputEncoding        = 'UTF8'
        CoveragePercentTarget = 100
    }

    Output       = @{
        Verbosity = 'Detailed'
    }
}