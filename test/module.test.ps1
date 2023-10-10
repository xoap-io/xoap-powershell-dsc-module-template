Configuration 'XOAPModuleTemplateDSC'
{
    Import-DSCResource -Module 'XOAPModuleTemplateDSC' -Name 'XOAP_DSCResource' -ModuleVersion '0.0.1'


    Node 'XOAPModuleTemplateDSC'
    {
        XOAP_DSCResource 'XOAP_DSCResource'
        {
        }
    }
}
XOAPModuleTemplateDSC -OutputPath 'C:\XOAPModuleTemplateDSC'
