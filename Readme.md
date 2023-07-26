# XOAPApplicationPackagingDSC

This module contains DSC resources for the configuration of a Windows node, that can be used to package applications with the PSADT.

## Code of Conduct

This project has adopted this [Code of Conduct](CODE_OF_CONDUCT.md).

## Releases

tbd

## Contributing

Please check out common DSC Community [contributing guidelines](https://dsccommunity.org/guidelines/contributing).

## Change log

A full list of changes in each version can be found in the [change log](CHANGELOG.md).

## Documentation

This script is used to easily create new DSC modules and resources.

## Prerequisites

Please install Plaster first and make sure it's present.

´´´PowerShell
Install-Module Plaster
Import-Module Plaster
´´´

## Create new DSC modules

Modules will be automatically created once you are creating a new DSC resource.

## Create new DSC resources

DSC resources can easily be deployed via the invocation of

´´´PowerShell
.\New-CompositeResource.ps1
``´

with parameters

´´´PowerShell
.\New-CompositeResource.ps1 -Module W2K19DC1903Baseline -Version 1.0.0 -Resource ScheduledTasks
´´´

The parameter list is as followed:

| Parameter | Description                            | Note |
|-----------|----------------------------------------|------|
| Module    | Name of the outer module part          | -    |
| Version   | Target version of the module           | -    |
| Ressource | The name of the ressource /config part | -    |

### Examples

You can review the [Examples](/source/Examples/Resources) directory in the **XOAPApplicationPackagingDSC** module
for some general use scenarios for all the resources that are in the module.
