@{
    PSDependOptions                = @{
        AddToPath  = $true
        Target     = 'output/RequiredModules'
        Parameters = @{
            Repository = 'PSGallery'
        }
    }

    # Build and test framework
    InvokeBuild                    = 'latest'
    PSScriptAnalyzer               = 'latest'
    Pester                         = @{
        Version    = 'latest'
        Parameters = @{
            AllowPrerelease = $true
        }
    }

    # Module building and publishing
    Plaster                        = 'latest'
    ModuleBuilder                  = 'latest'
    ChangelogManagement            = 'latest'
    Sampler                        = 'latest'
    'Sampler.GitHubTasks'          = 'latest'

    # Testing and quality
    'DscResource.Test'             = 'latest'
    'DscResource.AnalyzerRules'    = @{
        Version    = 'latest'
        Parameters = @{
            AllowPrerelease = $true
        }
    }
    'Indented.ScriptAnalyzerRules' = 'latest'
    xDscResourceDesigner           = 'latest'
    MarkdownLinkCheck              = 'latest'
    ConvertToSARIF                 = 'latest'

    # Dependencies for DSC resources
    'DscResource.Base'             = 'latest'
    'DscResource.Common'           = 'latest'

    # Documentation generation
    PlatyPS                        = 'latest'
    'DscResource.DocGenerator'     = 'latest'

    # YAML support
    'powershell-yaml'              = 'latest'

    # Dependency management
    PSDepend                       = 'latest'
}
