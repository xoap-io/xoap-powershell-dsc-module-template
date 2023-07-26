#Requires -Modules @{ ModuleName="Plaster"; ModuleVersion="1.1.3" }

[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]
    $Module,
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]
    $Version,
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]
    $Ressource,
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]
    $Company = "RIS AG"
)

$globalPrefix = "XOAP"
$curDirectory = Resolve-Path .\
$templatePath = Join-Path $curDirectory "templates"
$rootModulePath = Resolve-Path .\source
$Module = "${globalPrefix}${Module}DSC"
$modulePath = Join-Path $rootModulePath "$Module"
$moduleVersionPath = Join-Path $modulePath $Version
$moduleRessources = Join-Path $moduleVersionPath "DSCResources"
$ressourcePath = Join-Path $moduleRessources $Ressource


Write-Output "Checking if module $Module already exists under $moduleVersionPath"

if(Test-Path "$moduleVersionPath")
{
    Write-Output  "Module $Module with version $Version already exists. Continuing."
}
else
{
    Write-Warning  "Module $Module with version $Version does not exist. Creating new module. Please provide missing data."
    $template = Join-Path $templatePath "shared_module"
    $moduleData = @{
        project_name = $Module
        version = $Version
        company = $Company
        TemplatePath = "$template"
        DestinationPath = "$moduleVersionPath"
    }

    Invoke-Plaster @moduleData
}


Write-Output "Going to check if ressource $Ressource exists under $ressourcePath"

if(Test-Path "$ressourcePath")
{
    Write-Error "Ressource $Ressource already exists. Aborting"
}
else
{
    Write-Output "Creating new ressource $Ressource for module $Module"
    $template = Join-Path $templatePath "composite_resource"
    $moduleData = @{
        project_name = "${Ressource}"
        version = "0.0.1"
        company = $Company
        TemplatePath = "$template"
        DestinationPath = "$ressourcePath"
    }

    Invoke-Plaster @moduleData
}
