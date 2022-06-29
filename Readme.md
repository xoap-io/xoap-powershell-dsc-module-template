# Getting started

This scripts are used to easly create new XOAP PowerShell DSC composite resources.

## Prerequisites

Please install Plaster at first and make sure it's present.

´´PowerShell
Install-Module Plaster
Import-Module Plaster
``

## Creating new modules

Modules will be automatically created once you are creating a new composite resource.

## Creating new composite resources

Composite resources can easily be deployed via the invocation of:

´´PowerShell
.\New-CompositeResource.ps1
``

with parameters

´´PowerShell
.\New-CompositeResource.ps1 -Module Template -Version 1.0.0 -Resource DSC_Template
``

The prefix "XOAP" is automatically added and the postfix "DSC" as well.

The parameter list is as followed:

| Parameter | Description                           | Note |
| --------- | ------------------------------------- | ---- |
| Module    | Name of the outer module part         | -    |
| Version   | Target version of the module          | -    |
| Resource  | The name of the resource /config part | -    |
