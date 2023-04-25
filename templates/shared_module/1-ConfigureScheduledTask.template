configuration Example
{
    param
    (
        [string[]]$NodeName = 'localhost'
    )

    Import-DSCResource -ModuleName XOAPW2K19BaselineDSC

    Node $AllNodes.NodeName
    {
        WindowsFeature IIS
        {
            Ensure          = "Present"
            Name            = "Web-Server"
        }
    }
}
