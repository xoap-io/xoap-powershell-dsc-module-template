<#
    .SYNOPSIS
        Quality Assurance tests for the module structure and standards.

    .DESCRIPTION
        This test file runs Script Analyzer and validates module structure
        according to DSC Community standards.
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

    $projectPath = "$PSScriptRoot/../.." | Convert-Path
    $script:moduleName = (Get-ChildItem -Path "$projectPath/source" -Filter '*.psd1').BaseName
}

BeforeAll {
    $projectPath = "$PSScriptRoot/../.." | Convert-Path
    $script:moduleName = (Get-ChildItem -Path "$projectPath/source" -Filter '*.psd1').BaseName
}

Describe 'Module Quality Tests' -Tag 'QA' {
    BeforeAll {
        Import-Module -Name PSScriptAnalyzer
    }

    Context 'PSScriptAnalyzer' {
        It 'Should pass PSScriptAnalyzer rules' {
            $analyzerParams = @{
                Path        = "$projectPath/source"
                Severity    = @('Error', 'Warning')
                Recurse     = $true
                ExcludeRule = @()
            }

            $results = Invoke-ScriptAnalyzer @analyzerParams

            if ($results)
            {
                $results | ForEach-Object {
                    Write-Warning "$($_.Severity): $($_.Message) in $($_.ScriptName):$($_.Line)"
                }
            }

            $results | Should -BeNullOrEmpty
        }
    }

    Context 'Module Structure' {
        It 'Should have a module manifest' {
            Test-Path "$projectPath/source/$script:moduleName.psd1" | Should -Be $true
        }

        It 'Should have DSCResources folder' {
            Test-Path "$projectPath/source/DSCResources" | Should -Be $true
        }

        It 'Should have Examples folder' {
            Test-Path "$projectPath/source/Examples" | Should -Be $true
        }
    }
}

Describe 'Changelog Management' -Tag 'Changelog' {
    It 'Changelog file exists' {
        Test-Path -Path "$projectPath/CHANGELOG.md" | Should -Be $true
    }

    It 'Changelog uses KeepAChangelog format' {
        $changelogContent = Get-Content -Path "$projectPath/CHANGELOG.md" -Raw
        $changelogContent | Should -Match '\[Unreleased\]'
    }
}
