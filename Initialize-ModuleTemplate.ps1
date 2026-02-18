<#
.SYNOPSIS
    Initialize a new DSC module from this template.

.DESCRIPTION
    This script helps you create a new PowerShell DSC module from the template by:
    - Renaming the module to your desired name
    - Updating all references throughout the codebase
    - Updating module manifest and documentation
    - Preparing the repository for your module development

.PARAMETER ModuleName
    The name of your new DSC module (without the DSC suffix).
    Example: If you want "MyCustomDSC", enter "MyCustom"

.PARAMETER Author
    Module author name. Default: Current user.

.PARAMETER CompanyName
    Company or organization name. Default: "Unknown"

.PARAMETER Description
    Brief description of the module's purpose.

.PARAMETER ModulePrefix
    Prefix to add to the module name. Default: "XOAP"
    Set to empty string for no prefix.

.EXAMPLE
    .\Initialize-ModuleTemplate.ps1 -ModuleName "WindowsConfig" -Author "John Doe" -CompanyName "Contoso"

    Creates XOAPWindowsConfigDSC module with author "John Doe" and company "Contoso"

.EXAMPLE
    .\Initialize-ModuleTemplate.ps1 -ModuleName "AzureSettings" -ModulePrefix "" -Description "Configure Azure resources"

    Creates AzureSettingsDSC module without prefix

.NOTES
    This script should be run once when creating a new module from the template.
    After running, you can delete this script or keep it for reference.
#>
[CmdletBinding(SupportsShouldProcess)]
param (
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]
    $ModuleName,

    [Parameter()]
    [string]
    $Author = $env:USERNAME,

    [Parameter()]
    [string]
    $CompanyName = "Unknown",

    [Parameter()]
    [string]
    $Description = "PowerShell DSC module for managing configurations",

    [Parameter()]
    [string]
    $ModulePrefix = "XOAP"
)

$ErrorActionPreference = 'Stop'

# Construct full module name
$fullModuleName = if ($ModulePrefix) {
    "${ModulePrefix}${ModuleName}DSC"
} else {
    "${ModuleName}DSC"
}

Write-Host "=" * 80 -ForegroundColor Cyan
Write-Host "  Initializing Module Template" -ForegroundColor Cyan
Write-Host "=" * 80 -ForegroundColor Cyan
Write-Host ""
Write-Host "  New Module Name: " -NoNewline
Write-Host $fullModuleName -ForegroundColor Green
Write-Host "  Author:          " -NoNewline
Write-Host $Author -ForegroundColor Green
Write-Host "  Company:         " -NoNewline
Write-Host $CompanyName -ForegroundColor Green
Write-Host ""

if (-not $PSCmdlet.ShouldProcess($fullModuleName, "Initialize module template")) {
    return
}

$rootPath = $PSScriptRoot
$currentYear = (Get-Date).Year

# Files and folders to update
$filesToUpdate = @(
    'XOAPModuleTemplateDSC.psd1'
    'Readme.md'
    'CHANGELOG.md'
    'New-CompositeResource.ps1'
    'source/Build.psd1'
    'source/README.md'
    'source/en-US/about_XOAPModuleTemplateDSC.help.txt'
    'build.yaml'
    'Examples/XOAPModuleTemplateDSC.ps1'
    'tests/Unit/Template.Tests.ps1'
    'tests/Integration/Template.Integration.Tests.ps1'
    'tests/QA/module.tests.ps1'
    '.github/workflows/ci-cd.yml'
    '.github/workflows/tagging.yaml'
)

Write-Host "Step 1: Updating file contents..." -ForegroundColor Yellow

foreach ($file in $filesToUpdate) {
    $filePath = Join-Path $rootPath $file

    if (Test-Path $filePath) {
        Write-Host "  Updating: $file" -ForegroundColor Gray

        $content = Get-Content -Path $filePath -Raw

        # Replace module name references
        $content = $content -replace 'XOAPModuleTemplateDSC', $fullModuleName
        $content = $content -replace 'xoap-powershell-dsc-module-template', "$($fullModuleName.ToLower())"

        # Update author and company in manifest
        if ($file -like '*.psd1') {
            $content = $content -replace "Author = '.*?'", "Author = '$Author'"
            $content = $content -replace "CompanyName = '.*?'", "CompanyName = '$CompanyName'"
            $content = $content -replace "Copyright = '\(c\) .*?'", "Copyright = '(c) $currentYear $CompanyName. All rights reserved.'"
            $content = $content -replace "Description = '.*?'", "Description = '$Description'"
        }

        Set-Content -Path $filePath -Value $content -NoNewline
    }
}

Write-Host ""
Write-Host "Step 2: Renaming module manifest file..." -ForegroundColor Yellow

$oldManifestPath = Join-Path $rootPath "XOAPModuleTemplateDSC.psd1"
$newManifestPath = Join-Path $rootPath "$fullModuleName.psd1"

if (Test-Path $oldManifestPath) {
    Move-Item -Path $oldManifestPath -Destination $newManifestPath -Force
    Write-Host "  Renamed: XOAPModuleTemplateDSC.psd1 -> $fullModuleName.psd1" -ForegroundColor Gray
}

Write-Host ""
Write-Host "Step 3: Updating source folder files..." -ForegroundColor Yellow

$oldBuildPsd1 = Join-Path $rootPath "source/Build.psd1"
if (Test-Path $oldBuildPsd1) {
    $content = Get-Content -Path $oldBuildPsd1 -Raw
    $content = $content -replace 'XOAPModuleTemplateDSC.psd1', "$fullModuleName.psd1"
    Set-Content -Path $oldBuildPsd1 -Value $content -NoNewline
}

$oldHelpFile = Join-Path $rootPath "source/en-US/about_XOAPModuleTemplateDSC.help.txt"
$newHelpFile = Join-Path $rootPath "source/en-US/about_$fullModuleName.help.txt"
if (Test-Path $oldHelpFile) {
    Move-Item -Path $oldHelpFile -Destination $newHelpFile -Force
    Write-Host "  Renamed help file: about_$fullModuleName.help.txt" -ForegroundColor Gray
}

Write-Host ""
Write-Host "Step 4: Updating example files..." -ForegroundColor Yellow

$oldExampleFile = Join-Path $rootPath "Examples/XOAPModuleTemplateDSC.ps1"
$newExampleFile = Join-Path $rootPath "Examples/$fullModuleName.ps1"
if (Test-Path $oldExampleFile) {
    Move-Item -Path $oldExampleFile -Destination $newExampleFile -Force
    Write-Host "  Renamed: $fullModuleName.ps1" -ForegroundColor Gray
}

Write-Host ""
Write-Host "Step 5: Cleaning up old template resources..." -ForegroundColor Yellow

$oldResourcePath = Join-Path $rootPath "DSCResources/XOAP_DSCResource"
if (Test-Path $oldResourcePath) {
    Remove-Item -Path $oldResourcePath -Recurse -Force
    Write-Host "  Removed template resource: XOAP_DSCResource" -ForegroundColor Gray
}

$oldServicesPath = Join-Path $rootPath "DSCResources/Services"
if (Test-Path $oldServicesPath) {
    Remove-Item -Path $oldServicesPath -Recurse -Force
    Write-Host "  Removed template resource: Services" -ForegroundColor Gray
}

Write-Host ""
Write-Host "Step 6: Initializing Git repository..." -ForegroundColor Yellow

# Update .gitignore if needed
$gitignorePath = Join-Path $rootPath ".gitignore"
if (Test-Path $gitignorePath) {
    $gitignoreContent = Get-Content -Path $gitignorePath -Raw
    if ($gitignoreContent -notmatch 'output/') {
        Add-Content -Path $gitignorePath -Value "`n# Build output`noutput/`n"
        Write-Host "  Updated .gitignore" -ForegroundColor Gray
    }
}

Write-Host ""
Write-Host "=" * 80 -ForegroundColor Green
Write-Host "  Module Template Initialized Successfully!" -ForegroundColor Green
Write-Host "=" * 80 -ForegroundColor Green
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Review and update the module manifest:" -ForegroundColor White
Write-Host "   $fullModuleName.psd1" -ForegroundColor Gray
Write-Host ""
Write-Host "2. Create your first DSC resource:" -ForegroundColor White
Write-Host "   .\New-CompositeResource.ps1 -Module '$ModuleName' -Version '1.0.0' -Resource 'MyResource'" -ForegroundColor Gray
Write-Host ""
Write-Host "3. Build the module:" -ForegroundColor White
Write-Host "   .\build.ps1 -ResolveDependency -Tasks build" -ForegroundColor Gray
Write-Host ""
Write-Host "4. Run tests:" -ForegroundColor White
Write-Host "   .\build.ps1 -Tasks test" -ForegroundColor Gray
Write-Host ""
Write-Host "5. Update CHANGELOG.md with your changes" -ForegroundColor White
Write-Host ""
Write-Host "6. Commit your changes to Git:" -ForegroundColor White
Write-Host "   git add ." -ForegroundColor Gray
Write-Host "   git commit -m 'feat: Initialize $fullModuleName module'" -ForegroundColor Gray
Write-Host ""
Write-Host "Documentation:" -ForegroundColor Cyan
Write-Host "  - See BUILD.md for detailed build instructions" -ForegroundColor Gray
Write-Host "  - See CONTRIBUTING.md for contribution guidelines" -ForegroundColor Gray
Write-Host ""
