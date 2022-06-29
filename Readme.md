# Getting started

This scripts are used to easly create new dsc composite ressources.

## Prerequisites

Please install Plaster at first and make sure it's present.

´´PowerShell
Install-Module Plaster
Import-Module Plaster
``

## Creating new modules

Modules will be automatically created once you are creating a new composite ressource.

## Creating new composite ressources

Composite ressources can easily be deployed via the invocation of

´´PowerShell
.\New-CompositeRessource.ps1
``

with parameters

´´PowerShell
.\New-CompositeRessource.ps1 -Module W2K19DC1903Baseline -Version 1.0.0 -Ressource DSC_ScheduledTasks
``
The parameter list is as followed:

| Parameter | Description                            | Note |
| --------- | -------------------------------------- | ---- |
| Module    | Name of the outer module part          | -    |
| Version   | Target version of the module           | -    |
| Ressource | The name of the ressource /config part | -    |
