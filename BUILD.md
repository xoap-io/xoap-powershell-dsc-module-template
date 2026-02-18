# Build and Development Guide

## Prerequisites

Before building the module, ensure you have:

- PowerShell 5.1 or PowerShell 7.x
- Git (for version control)
- An internet connection (for downloading dependencies)

## Quick Start

### 1. Clone the Repository

```powershell
git clone https://github.com/xoap-io/xoap-powershell-dsc-module-template.git
cd xoap-powershell-dsc-module-template
```

### 2. Resolve Dependencies

```powershell
.\build.ps1 -ResolveDependency -Tasks noop
```

This will download all required modules to `output/RequiredModules`.

### 3. Build the Module

```powershell
.\build.ps1 -Tasks build
```

The compiled module will be in `output/XOAPModuleTemplateDSC/`.

### 4. Run Tests

```powershell
.\build.ps1 -Tasks test
```

## Build Tasks

The build system supports several tasks:

| Task | Description |
|------|-------------|
| `build` | Compiles the module from source |
| `test` | Runs all Pester tests |
| `clean` | Removes output directory |
| `pack` | Creates a NuGet package |
| `publish` | Publishes module to PowerShell Gallery |
| `hqrmtest` | Runs HQRM (High Quality Resource Module) tests |

### Running Specific Tasks

```powershell
# Run multiple tasks
.\build.ps1 -Tasks clean, build, test

# Run with parameters
.\build.ps1 -Tasks test -PesterTag 'Unit'
```

## Development Workflow

### Creating a New DSC Resource

1. Use the provided script:
   ```powershell
   .\New-CompositeResource.ps1 -Module ModuleTemplate -Version 0.1.0 -Resource MyNewResource
   ```

2. This creates a new resource under `source/DSCResources/MyNewResource/`

3. Implement your resource logic in the `.schema.psm1` file

4. Add unit tests in `tests/Unit/`

5. Add integration tests in `tests/Integration/`

### Code Quality Standards

All code must:
- Pass PSScriptAnalyzer rules
- Have 85%+ code coverage
- Follow DSC Community style guidelines
- Include help documentation

### Testing Locally

```powershell
# Run all tests
Invoke-Pester -Path ./tests

# Run specific test file
Invoke-Pester -Path ./tests/Unit/MyResource.Tests.ps1

# Run with code coverage
Invoke-Pester -Path ./tests -CodeCoverage './source/**/*.ps1'
```

## Continuous Integration

The repository uses:
- **GitHub Actions** for complete CI/CD pipeline
- **Codecov** for code coverage reporting
- **CodeQL** for security scanning

### Workflow Jobs

1. **Build and Test** - Compiles module and runs unit tests with code coverage
2. **Quality Assurance** - Runs HQRM tests and quality checks
3. **Publish** - Publishes to PowerShell Gallery (master/main branch only)

## Troubleshooting

### Issue: Dependencies fail to resolve

**Solution**: Try manually installing PSDepend:
```powershell
Install-Module -Name PSDepend -Scope CurrentUser -Force
```

### Issue: Build fails with "Module not found"

**Solution**: Ensure you've run `-ResolveDependency` first:
```powershell
.\build.ps1 -ResolveDependency -Tasks noop
```

### Issue: Tests fail locally but pass in CI

**Solution**: Check PowerShell version and installed modules:
```powershell
$PSVersionTable
Get-Module -ListAvailable
```

## VS Code Integration

The repository includes VS Code tasks:
- **Build Module** (Ctrl+Shift+B)
- **Run Tests**
- **Clean Output**
- **Resolve Dependencies**

Access via `Terminal > Run Task...`

## Further Reading

- [DSC Community Guidelines](https://dsccommunity.org/guidelines/)
- [Sampler Documentation](https://github.com/gaelcolas/Sampler)
- [Pester Documentation](https://pester.dev/)
