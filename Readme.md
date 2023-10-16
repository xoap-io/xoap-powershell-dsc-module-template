# XOAPModuleTemplateDSC

This repository is a template that can be used as a starting point for creating new DSC modules and resources.

## Code of Conduct

This project has adopted this [Code of Conduct](CODE_OF_CONDUCT.md).

## Contributing

Please check out common DSC Community [contributing guidelines](https://dsccommunity.org/guidelines/contributing).

## Change log

A full list of changes in each version can be found in the  [Releases](https://github.com/xoap-io/XOAPModuleTemplateDSC/releases).

## Documentation

This script is used to easily create new DSC modules and resources.

## Prerequisites

Be sure that the following DSC modules are installed on your system:

- ModuleName (x.x.x)

## DSC Resources and syntax

### XOAP_AddServerToCollection

```PowerShell
XOAP_DSCResource [String] #ResourceName
    {
        [DependsOn = [String[]]]
        [PsDscRunAsCredential = [PSCredential]]
    }
```

## Configuration examples for each resource

You can review the [Examples](/Examples/DSCResources) directory in the **XOAPModuleTemplateDSC** module
for some general usage scenarios for all the resources that are in the module.

To implement the Module Template DSC module, add the following resources to your DSC configuration and adjust the parameters accordingly:

### Add server to a collection

```PowerShell
configuration 'XOAP_DSCResource'
{
    Import-DscResource -ModuleName 'XOAPModuleTemplateDSC' -Name 'XOAP_DSCResource' -ModuleVersion '0.0.1'
    
    XOAP_DSCResource 'Example'
    {
          DependsOn = @('[String[]]')
          PsDscRunAsCredential = [PSCredential]
    }
}
XOAP_DSCResource 
```

## Create new DSC resource

DSC resources can easily be deployed via the invocation of

```powershell
.\New-CompositeResource.ps1
```

with parameters

```powershell
.\New-CompositeResource.ps1 -Module 'XOAPModuleTemplateDSC' -Version '0.0.1' -Resource 'DSCResource'
```
