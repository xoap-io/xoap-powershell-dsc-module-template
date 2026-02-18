<#
    .SYNOPSIS
        Bootstrap script for PSDepend to resolve module dependencies.

    .DESCRIPTION
        This script uses PSDepend to resolve and install module dependencies
        specified in RequiredModules.psd1.

    .PARAMETER DependencyFile
        Path to the dependency file. Default is 'RequiredModules.psd1'.

    .PARAMETER PSDependTarget
        Target directory for dependency installation.

    .PARAMETER Proxy
        Proxy URI if needed.

    .PARAMETER ProxyCredential
        Proxy credentials if needed.

    .PARAMETER Scope
        Installation scope. Default is 'CurrentUser'.

    .PARAMETER Gallery
        PowerShell gallery to use. Default is 'PSGallery'.

    .EXAMPLE
        .\Resolve-Dependency.ps1

    .EXAMPLE
        .\Resolve-Dependency.ps1 -Scope CurrentUser
#>
[CmdletBinding()]
param
(
    [Parameter()]
    [System.String]
    $DependencyFile = 'RequiredModules.psd1',

    [Parameter()]
    [System.String]
    $PSDependTarget = (Join-Path -Path $PSScriptRoot -ChildPath 'output/RequiredModules'),

    [Parameter()]
    [System.Uri]
    $Proxy,

    [Parameter()]
    [System.Management.Automation.PSCredential]
    $ProxyCredential,

    [Parameter()]
    [ValidateSet('CurrentUser', 'AllUsers')]
    [System.String]
    $Scope = 'CurrentUser',

    [Parameter()]
    [System.String]
    $Gallery = 'PSGallery'
)

Write-Host '[Resolve-Dependency] Starting dependency resolution' -ForegroundColor Green

# Ensure PSGallery is registered and trusted
$psGallery = Get-PSRepository -Name $Gallery -ErrorAction SilentlyContinue

if (-not $psGallery)
{
    Write-Host "[Resolve-Dependency] Registering PSGallery" -ForegroundColor Yellow
    Register-PSRepository -Default
    $psGallery = Get-PSRepository -Name $Gallery
}

if ($psGallery.InstallationPolicy -ne 'Trusted')
{
    Write-Host "[Resolve-Dependency] Setting PSGallery as trusted" -ForegroundColor Yellow
    Set-PSRepository -Name $Gallery -InstallationPolicy Trusted
}

# Bootstrap PSDepend if not available
if (-not (Get-Module -Name PSDepend -ListAvailable))
{
    Write-Host '[Resolve-Dependency] Installing PSDepend module' -ForegroundColor Green

    $installPSDependParams = @{
        Name       = 'PSDepend'
        Repository = $Gallery
        Scope      = $Scope
        Force      = $true
    }

    if ($Proxy)
    {
        $installPSDependParams['Proxy'] = $Proxy
    }

    if ($ProxyCredential)
    {
        $installPSDependParams['ProxyCredential'] = $ProxyCredential
    }

    Install-Module @installPSDependParams
}

# Import PSDepend
Import-Module -Name PSDepend -Force

# Resolve dependencies
if (Test-Path -Path $DependencyFile)
{
    Write-Host "[Resolve-Dependency] Processing dependency file: $DependencyFile" -ForegroundColor Green

    $psDependParams = @{
        Path    = $DependencyFile
        Install = $true
        Import  = $true
        Force   = $true
        Target  = $PSDependTarget
    }

    Invoke-PSDepend @psDependParams

    Write-Host '[Resolve-Dependency] Dependency resolution completed successfully' -ForegroundColor Green
}
else
{
    Write-Warning "Dependency file not found: $DependencyFile"
}
