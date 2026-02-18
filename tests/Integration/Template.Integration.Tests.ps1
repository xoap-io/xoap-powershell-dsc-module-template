<#
    .SYNOPSIS
        Template for integration tests of DSC resources.

    .DESCRIPTION
        This is a template file for creating integration tests for DSC resources.
        Copy this file and modify for your specific resource.
#>
[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '', Justification = 'Suppressing this rule because Script Analyzer does not understand Pester syntax.')]
param ()

BeforeDiscovery {
    try
    {
        if (-not (Get-Module -Name 'DscResource.Test'))
        {
            if (-not (Get-Module -Name 'DscResource.Test' -ListAvailable))
            {
                & "$PSScriptRoot/../../build.ps1" -Tasks 'noop' 3>&1 4>&1 5>&1 6>&1 > $null
            }

            Import-Module -Name 'DscResource.Test' -Force -ErrorAction 'Stop'
        }
    }
    catch [System.IO.FileNotFoundException]
    {
        throw 'DscResource.Test module dependency not found. Please run ".\build.ps1 -ResolveDependency -Tasks noop" first.'
    }
}

BeforeAll {
    $script:moduleName = 'XOAPWindowsConfigDSC'

    Import-Module -Name $script:moduleName -Force -ErrorAction 'Stop'
}

Describe 'ExampleResource Integration Tests' -Tag 'Integration' {
    Context 'When applying configuration' {
        It 'Should compile MOF without errors' {
            {
                Configuration TestConfig
                {
                    Import-DscResource -ModuleName $script:moduleName

                    Node localhost
                    {
                        # Add resource configuration here
                    }
                }

                TestConfig -OutputPath $TestDrive
            } | Should -Not -Throw
        }
    }
}
