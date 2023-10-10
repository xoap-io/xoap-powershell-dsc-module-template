configuration 'XOAPModuleTemplateDSC'
{
	Import-DSCResource -Module 'XOAPModuleTemplateDSC' -Name 'XOAP_DSCResource' -ModuleVersion '0.0.1'

    XOAP_DSCResource 'Example'
    {
	    Example [String]= 'Example'
    }
}
XOAP_DSCResource -OutputPath 'C:\XOAP_DSCResource'
