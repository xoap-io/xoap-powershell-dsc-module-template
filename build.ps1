<#
    .SYNOPSIS
        Bootstrap and build script for PowerShell DSC module CI/CD pipeline.

    .DESCRIPTION
        This is the main build script that handles dependency resolution and
        invokes the build tasks using InvokeBuild.

    .PARAMETER Tasks
        The build task(s) to run. Default is '.' which runs the default task.

    .PARAMETER ResolveDependency
        Resolve module dependencies before running build tasks.

    .PARAMETER BuildInfo
        Build configuration object. Loaded from build.yaml if not provided.

    .PARAMETER OutputDirectory
        Directory for build output. Default is 'output'.

    .PARAMETER BuiltModuleSubdirectory
        Subdirectory under OutputDirectory for the built module. Default is empty.

    .PARAMETER RequiredModulesDirectory
        Directory to save required modules. Default is 'output/RequiredModules'.

    .EXAMPLE
        .\build.ps1 -ResolveDependency -Tasks build

    .EXAMPLE
        .\build.ps1 -Tasks test
#>
[CmdletBinding()]
param
(
    [Parameter(Position = 0)]
    [System.String[]]
    $Tasks = '.',

    [Parameter()]
    [System.String]
    $OutputDirectory = 'output',

    [Parameter()]
    [System.String]
    $BuiltModuleSubdirectory = '',

    [Parameter()]
    [System.String]
    $RequiredModulesDirectory = 'output/RequiredModules',

    [Parameter()]
    [Alias('Bootstrap')]
    [System.Management.Automation.SwitchParameter]
    $ResolveDependency,

    [Parameter(DontShow)]
    [AllowNull()]
    [System.Collections.Hashtable]
    $BuildInfo,

    [Parameter()]
    [System.String]
    [ValidateScript({ Test-Path -Path $_ })]
    $BuildConfig
)

process
{
    if ($MyInvocation.ScriptName -notLike '*Invoke-Build.ps1')
    {
        # Only run the process block through InvokeBuild
        return
    }

    # Execute the build process
    Push-Location -Path $PSScriptRoot -StackName 'BeforeBuild'

    try
    {
        Write-Host '[build] Starting build process' -ForegroundColor Magenta

        if (-not $PSBoundParameters.ContainsKey('BuildInfo'))
        {
            try
            {
                if (-not $BuildConfig)
                {
                    $BuildConfig = Get-ChildItem -Path "$PSScriptRoot" -Include 'build.y*ml', 'build.psd1' -ErrorAction Stop |
                        Select-Object -First 1
                }

                Write-Host "[build] Loading configuration from $($BuildConfig.Name)" -ForegroundColor Green

                $buildConfigContent = Get-Content -Path $BuildConfig -Raw

                if ($BuildConfig.Extension -match '\.(yml|yaml)$')
                {
                    Import-Module -Name 'powershell-yaml' -ErrorAction Stop
                    $BuildInfo = ConvertFrom-Yaml -Yaml $buildConfigContent
                }
                else
                {
                    $BuildInfo = Import-PowerShellDataFile -Path $BuildConfig
                }
            }
            catch
            {
                Write-Warning "Failed to load build configuration: $_"
                $BuildInfo = @{}
            }
        }

        # Set task header if specified
        if ($BuildInfo.TaskHeader)
        {
            Set-BuildHeader -Script ([scriptblock]::Create($BuildInfo.TaskHeader))
        }

        # Import tasks from .build folder
        Get-ChildItem -Path '.build/' -Recurse -Include '*.ps1' -ErrorAction Ignore |
            ForEach-Object {
                Write-Host "[build] Importing tasks from $($_.Name)" -ForegroundColor DarkGray
                . $_.FullName
            }

        # Execute the requested tasks
        Write-Host "[build] Executing tasks: $($Tasks -join ', ')" -ForegroundColor Magenta
    }
    finally
    {
        Pop-Location -StackName 'BeforeBuild'
    }
}

begin
{
    # Bootstrap dependencies if needed
    if ($MyInvocation.ScriptName -notlike '*Invoke-Build.ps1')
    {
        Write-Host '[pre-build] Starting build initialization' -ForegroundColor Green

        Push-Location $PSScriptRoot -StackName 'BuildModule'

        # Resolve output and required modules paths
        if (-not (Split-Path -IsAbsolute -Path $OutputDirectory))
        {
            $OutputDirectory = Join-Path -Path $PSScriptRoot -ChildPath $OutputDirectory
        }

        if (-not (Split-Path -IsAbsolute -Path $RequiredModulesDirectory))
        {
            $RequiredModulesDirectory = Join-Path -Path $PSScriptRoot -ChildPath $RequiredModulesDirectory
        }

        # Create required modules directory if it doesn't exist
        if (-not (Test-Path -Path $RequiredModulesDirectory))
        {
            Write-Host "[pre-build] Creating required modules directory: $RequiredModulesDirectory" -ForegroundColor Green
            $null = New-Item -ItemType Directory -Force -Path $RequiredModulesDirectory
        }

        # Add required modules to PSModulePath
        $env:PSModulePath = $RequiredModulesDirectory + [System.IO.Path]::PathSeparator + $env:PSModulePath

        # Check if we need to resolve dependencies
        $invokeBuildModule = Get-Module -Name 'InvokeBuild' -ListAvailable
        $psDependModule = Get-Module -Name 'PSDepend' -ListAvailable

        if (-not ($invokeBuildModule -and $psDependModule) -and -not $ResolveDependency)
        {
            Write-Host "[pre-build] Required modules missing. Run with -ResolveDependency parameter first." -ForegroundColor Yellow
            $ResolveDependency = $true
        }

        if ($ResolveDependency)
        {
            Write-Host '[pre-build] Resolving module dependencies' -ForegroundColor Green

            # Bootstrap PSDepend if not available
            if (-not $psDependModule)
            {
                Write-Host '[pre-build] Installing PSDepend' -ForegroundColor Green
                Install-Module -Name PSDepend -Repository PSGallery -Scope CurrentUser -Force
                Import-Module -Name PSDepend -Force
            }

            # Use PSDepend to install required modules
            if (Test-Path -Path './RequiredModules.psd1')
            {
                Import-Module -Name PSDepend
                $null = Invoke-PSDepend -Path './RequiredModules.psd1' -Install -Import -Force
            }
        }

        if ($MyInvocation.ScriptName -notlike '*Invoke-Build.ps1')
        {
            if ($PSBoundParameters.ContainsKey('ResolveDependency'))
            {
                $null = $PSBoundParameters.Remove('ResolveDependency')
            }

            Write-Host '[build] Starting build with InvokeBuild' -ForegroundColor Green

            # Import InvokeBuild
            Import-Module -Name InvokeBuild -Force

            # Invoke the build
            Invoke-Build @PSBoundParameters -Task $Tasks -File $MyInvocation.MyCommand.Path

            Pop-Location -StackName 'BuildModule'

            return
        }
    }
}
