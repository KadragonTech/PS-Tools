@{
    # Required
    RootModule        = 'PS-Tools.psm1'
    ModuleVersion     = '0.5.0'
    GUID              = 'b7553b76-e15c-4758-af00-a5d0028ba7a7'

    # Author & Info
    Author            = 'KadragonTech'
    CompanyName       = ''
    Copyright         = '© 2025 KadragonTech. All rights reserved.'
    Description       = 'A collection of PowerShell tools and helper functions for scripting.'

    # Functions to export
    FunctionsToExport = '*'
    CmdLetstoExport   = @()
    VariablesToExport = @()
    AliasesToEport = @()

    # PowerShell Compatibility
    PowerShellVersion = '5.1'
    CompatiblePSEditions = @('Desktop', 'Core')

    # Files to process when importing
    ScriptsToProcess = @()
    TypesToProcess = @()
    FormatsToProcess = @()

    # Private data
    PrivateData = @{}

    # Help Info
    HelpInfoURI = ''

    # If you later add RequiredModules or RequiredAssemblies
    RequiredModules = @()
    RequiredAssemblies = @()
}