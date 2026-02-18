# XOAPWindowsConfigDSC

This repository is a template that can be used as a starting point for creating new DSC (Desired State Configuration) modules and composite resources for PowerShell.

[![CI/CD Pipeline](https://github.com/xoap-io/xoapwindowsconfigdsc/actions/workflows/ci-cd.yml/badge.svg)](https://github.com/xoap-io/xoapwindowsconfigdsc/actions/workflows/ci-cd.yml)
[![codecov](https://codecov.io/gh/xoap-io/xoapwindowsconfigdsc/branch/master/graph/badge.svg)](https://codecov.io/gh/xoap-io/xoapwindowsconfigdsc)
[![PowerShell Gallery](https://img.shields.io/powershellgallery/v/XOAPWindowsConfigDSC.svg)](https://www.powershellgallery.com/packages/XOAPWindowsConfigDSC)

## Features

- **Modern Build System**: Uses Sampler framework with InvokeBuild
- **Automated Testing**: Pester 5.x integration with code coverage
- **CI/CD Ready**: Comprehensive GitHub Actions workflows
- **Quality Assurance**: PSScriptAnalyzer with HQRM tests
- **Quick Scaffolding**: Automated resource and module generation
- **VS Code Integration**: Tasks, debugging, and code analysis

## Code of Conduct

This project has adopted this [Code of Conduct](CODE_OF_CONDUCT.md).

## Contributing

Please check out common DSC Community [contributing guidelines](https://dsccommunity.org/guidelines/contributing) and our [contributing guide](CONTRIBUTING.md).

## Change log

A full list of changes in each version can be found in the [change log](CHANGELOG.md).

## Documentation

### Quick Start

### Option 1: Use as GitHub Template (Recommended)

1. Click the **"Use this template"** button at the top of this repository
2. Create your new repository with your desired name
3. Clone your new repository locally
4. Run the initialization script:

```powershell
.\Initialize-ModuleTemplate.ps1 -ModuleName "WindowsConfig" -Author "Your Name" -CompanyName "Your Company"
```

This will rename everything from XOAPWindowsConfigDSC to your module name.

### Option 2: Manual Setup

If you prefer manual setup or want to understand the process:

1. Clone/fork this repository
2. Manually rename files and update references
3. Update the module manifest (.psd1 file)

## Prerequisites

- PowerShell 5.1 or PowerShell 7.x
- Plaster module (minimum version 1.1.3)

Install Plaster if not already present:

```powershell
Install-Module -Name Plaster -MinimumVersion 1.1.3 -Scope CurrentUser
Import-Module Plaster
```

## Creating Your First DSC Resource

After initializing your module, create DSC resources using:

```powershell
.\New-CompositeResource.ps1 -Module "WindowsConfig" -Version "1.0.0" -Resource "RegistrySettings"
```

**Parameter Details:**

| Parameter | Description                                | Required |
|-----------|-------------------------------------------|----------|
| Module    | Name of your module (without XOAP prefix) | Yes      |
| Version   | Version of the module                     | Yes      |
| Resource  | Name of the DSC resource to create        | Yes      |
| Company   | Company name (default: RIS AG)            | No       |

**Note:** The script automatically adds the XOAP prefix and DSC suffix to your module name.

### Examples

You can review the [Examples](/Examples/Resources) directory for example DSC resource configurations.

## Building and Testing

See [BUILD.md](BUILD.md) for detailed build and test instructions.

Quick commands:

```powershell
# Resolve dependencies and build
.\build.ps1 -ResolveDependency -Tasks build

# Run tests
.\build.ps1 -Tasks test

# Package module
.\build.ps1 -Tasks pack
```

## Repository Structure

```
├── .build/              # Custom build tasks
├── .github/             # GitHub templates and workflows
├── .vscode/             # VS Code configuration
├── source/              # Module source code
│   ├── DSCResources/    # DSC resources
│   ├── Public/          # Public functions
│   ├── Private/         # Private functions
│   ├── Classes/         # PowerShell classes
│   └── Examples/        # Usage examples
├── tests/               # Test files
│   ├── Unit/            # Unit tests
│   ├── Integration/     # Integration tests
│   └── QA/              # Quality assurance tests
├── build.ps1            # Main build script
├── build.yaml           # Build configuration
└── RequiredModules.psd1 # Module dependencies
```

## Resources

- [DSC Community](https://dsccommunity.org/)
- [Sampler Framework](https://github.com/gaelcolas/Sampler)
- [Pester Testing Framework](https://pester.dev/)
