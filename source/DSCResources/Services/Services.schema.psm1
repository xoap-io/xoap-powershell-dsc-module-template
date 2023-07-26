<#
.SYNOPSIS​
Please fill me.
​
.DESCRIPTION​
Please fill me.

.COMPONENT​
Information about PowerShell Modules to be required. ​
Powershell Module: PSDesiredStateConfiguration​
Powershell Module: AuditPolicyDSC​
Powershell Module: SecurityPolicyDSC​
Powershell Module: PowerShellAccessControl​
​Powershell Module: WindowsDefender

.EXAMPLE
Get-DscResource -Module XOAP*

.NOTES
For more information about advanced functions, call Get-Help with any
of the topics in the links listed below.
Module Name    : XOAPModuleTemplateDSC
Resource Name  : Services.schema.psm1
Author         : info@XOAP.io
​
.LINK​
https://www.microsoft.com/en-us/download/details.aspx?id=55319​
​
.LINK​
https://www.powershellgallery.com/packages/BaselineManagement/2.9.0​
​
.LINK​
https://gallery.technet.microsoft.com/scriptcenter/PowerShellAccessControl-d3be7b83​

.LINK
https://www.powershellgallery.com/packages/WindowsDefender/1.0.0.4
#>
configuration Services
{

    #Import-DSCResource -ModuleName xPSDesiredStateConfiguration
    #
    #xRegistry disableInsecureCipher_a
    #{
    #    Key       = 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\DES 56/56'
    #    ValueName = 'Enabled'
    #    ValueData = '0'
    #    ValueType = 'Dword'
    #    Ensure    = 'Present'
    #    Force     = $true
    #}

}
