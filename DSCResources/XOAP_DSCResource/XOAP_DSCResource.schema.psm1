configuration 'XOAP_DSCResource'
{

    Import-DSCResource -ModuleName 'XOAPModuleTemplateDSC' -Name 'XOAP_DSCResource' -ModuleVersion '0.0.1'

    <#
    Registry disableInsecureCipher_a
    {
        Key       = 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\DES 56/56'
        ValueName = 'Enabled'
        ValueData = '0'
        ValueType = 'Dword'
        Ensure    = 'Present'
        Force     = $true
    }#>
}
