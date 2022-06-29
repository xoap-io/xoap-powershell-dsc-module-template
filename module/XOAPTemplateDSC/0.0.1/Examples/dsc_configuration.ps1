configuration Template
{
    param
    (
        # Target nodes to apply the configuration
        [string[]]$NodeName = 'localhost'
    )

    Import-Module XOAPTemplateDSC
    Import-DSCResource -ModuleName XOAPTemplateDSC

    Node $NodeName
    {
        $moduleRoot = [io.path]::GetDirectoryName((Get-Module XOAPTemplateDSC).Path)
        $examples = "$moduleRoot\Examples"

        # Install the IIS role
        WindowsFeature IIS
        {
            Ensure          = "Present"
            Name            = "Web-Server"
        }
    }
}
