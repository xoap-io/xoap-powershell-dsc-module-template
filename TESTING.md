# Testing Guide for Module Creation

This guide walks you through testing the complete module creation workflow, including versioning, changelog generation, and resource documentation.

## Table of Contents

- [Prerequisites](#prerequisites)
- [1. Test Complete Module Initialization](#1-test-complete-module-initialization)
- [2. Test Versioning](#2-test-versioning)
- [3. Test Resource Creation](#3-test-resource-creation)
- [4. Test Build Process](#4-test-build-process)
- [5. Test Changelog Generation](#5-test-changelog-generation)
- [6. Test README/Documentation Generation](#6-test-readmedocumentation-generation)
- [7. Run All Quality Tests](#7-run-all-quality-tests)
- [8. Test HQRM Standards](#8-test-hqrm-standards)
- [Complete Test Workflow Example](#complete-test-workflow-example)
- [Key Files to Monitor](#key-files-to-monitor)
- [Validation Checklist](#validation-checklist)
- [Troubleshooting](#troubleshooting)

## Prerequisites

Before starting the tests, ensure you have:

- PowerShell 5.1 or PowerShell 7.x
- Git installed and configured
- Plaster module (minimum version 1.1.3)
- Internet connection (for downloading dependencies)

```powershell
# Install Plaster if needed
Install-Module -Name Plaster -MinimumVersion 1.1.3 -Scope CurrentUser
Import-Module Plaster
```

## 1. Test Complete Module Initialization

Test the module template initialization process to create a new module from scratch.

```powershell
# Initialize a new module from the template
.\Initialize-ModuleTemplate.ps1 `
    -ModuleName "TestModule" `
    -Author "Test Author" `
    -CompanyName "Test Company" `
    -Description "Test module for validation"
```

**What this does:**

- Renames module files and references throughout the codebase
- Updates the module manifest (.psd1) with new metadata
- Updates all documentation files
- Prepares the repository for your module development

**Expected Outcome:**

- All references to "XOAPWindowsConfigDSC" are replaced with "XOAPTestModuleDSC"
- Module manifest contains your author and company information
- README.md is updated with new module name

**Verification:**

```powershell
# Check if module manifest was updated
Get-Content ./source/XOAPTestModuleDSC.psd1 | Select-String "Author", "CompanyName", "Description"

# Verify no old references remain
git grep "WindowsConfig" --cached
```

## 2. Test Versioning

The module uses **GitVersion** for semantic versioning based on git commits and branches.

### Understanding Version Control

GitVersion configuration in `GitVersion.yml`:

- **next-version**: Base version (currently 0.2.0)
- **mode**: ContinuousDelivery
- **master/main**: Patch increment by default
- **feature branches**: Tagged with branch name
- **hotfix branches**: Patch increment
- **release branches**: Controlled versioning

### Test Version Detection

```powershell
# Check current version (requires GitVersion tool)
dotnet tool install --global GitVersion.Tool
dotnet-gitversion

# Or check via Git tags
git describe --tags --abbrev=0
```

### Test Version Increments

```powershell
# Test 1: Patch increment on master
git checkout master
echo "# Test change" >> test.txt
git add test.txt
git commit -m "fix: test patch increment"
# Build and check version increases from 0.2.0 to 0.2.1

# Test 2: Feature branch versioning
git checkout -b feature/test-versioning
echo "# Feature test" >> test2.txt
git add test2.txt
git commit -m "feat: test feature versioning"
# Build and check version includes feature tag

# Test 3: Release branch
git checkout -b release/1.0.0
# Version should be 1.0.0
```

**Expected Outcomes:**

- Master commits increment patch version
- Feature branches append branch name to version
- Release branches use specified version
- Pre-release versions have appropriate tags

## 3. Test Resource Creation

Test creating new DSC composite resources within your module.

```powershell
# Create a test resource
.\New-CompositeResource.ps1 `
    -Module "TestModule" `
    -Version "1.0.0" `
    -Resource "TestRegistry" `
    -Company "Test Company"
```

**What this creates:**

```
source/
└── XOAPTestModuleDSC/
    └── 1.0.0/
        ├── XOAPTestModuleDSC.psd1
        └── DSCResources/
            └── TestRegistry/
                └── TestRegistry.schema.psm1
```

**Verification:**

```powershell
# Check if resource folder was created
Test-Path "./source/XOAPTestModuleDSC/1.0.0/DSCResources/TestRegistry"

# Check resource schema file
Get-Content "./source/XOAPTestModuleDSC/1.0.0/DSCResources/TestRegistry/TestRegistry.schema.psm1" | Select-String "Configuration"

# Verify module manifest includes the resource
Get-Content "./source/XOAPTestModuleDSC/1.0.0/XOAPTestModuleDSC.psd1" | Select-String "DscResourcesToExport"
```

### Add Resource Logic (Example)

Edit the schema file to add actual DSC resource logic:

```powershell
# Open the schema file
code "./source/XOAPTestModuleDSC/1.0.0/DSCResources/TestRegistry/TestRegistry.schema.psm1"
```

Example resource content:

```powershell
Configuration TestRegistry
{
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $RegistryKey,

        [Parameter()]
        [String]
        $Value
    )

    Import-DscResource -ModuleName PSDesiredStateConfiguration

    Registry MyRegistry
    {
        Key       = $RegistryKey
        ValueName = 'TestValue'
        ValueData = $Value
        Ensure    = 'Present'
    }
}
```

## 4. Test Build Process

Test the complete module build process.

### Step 1: Resolve Dependencies

```powershell
# First-time setup: Download all required modules
.\build.ps1 -ResolveDependency -Tasks noop
```

**Expected Output:**

- Creates `output/RequiredModules/` directory
- Downloads Sampler, Pester, PSScriptAnalyzer, and other dependencies
- Shows progress of each module installation

**Verification:**

```powershell
# Check if dependencies were downloaded
Get-ChildItem ./output/RequiredModules/
```

### Step 2: Build the Module

```powershell
# Build the module
.\build.ps1 -Tasks build
```

**What this does:**

1. **Clean**: Removes old output files
2. **Build_Module_ModuleBuilder**: Compiles source into module
3. **Create_changelog_release_output**: Processes changelog
4. **Generate_Conceptual_Help**: Creates help documentation
5. **Generate_Wiki_Content**: Generates wiki pages

**Expected Output Structure:**

```
output/
└── XOAPTestModuleDSC/
    └── <version>/
        ├── XOAPTestModuleDSC.psd1
        ├── XOAPTestModuleDSC.psm1
        ├── DSCResources/
        │   └── TestRegistry/
        └── en-US/
            └── about_XOAPTestModuleDSC.help.txt
```

**Verification:**

```powershell
# Check if module was built
Test-Path "./output/XOAPTestModuleDSC"

# Check module version
$manifest = Import-PowerShellDataFile "./output/XOAPTestModuleDSC/*/XOAPTestModuleDSC.psd1"
$manifest.ModuleVersion

# Verify resources are included
$manifest.DscResourcesToExport
```

### Step 3: Inspect Build Output

```powershell
# View build log details
Get-Content ./output/build.log -Tail 50

# Check compiled manifest
Get-Content ./output/XOAPTestModuleDSC/*/XOAPTestModuleDSC.psd1 | Select-String "ModuleVersion", "Author", "DscResourcesToExport"
```

## 5. Test Changelog Generation

The changelog is automatically updated based on git commit messages using Conventional Commits.

### Understanding Changelog Generation

The build process reads git commits and updates `CHANGELOG.md`:

- **feat:** → Added section
- **fix:** → Fixed section
- **docs:** → Documentation section
- **refactor:** → Changed section
- **perf:** → Changed section

### Test Changelog Updates

```powershell
# Make a commit following Conventional Commits
git add .
git commit -m "feat: add TestRegistry resource"

# Build and check changelog
.\build.ps1 -Tasks build

# View changelog
Get-Content ./CHANGELOG.md -Head 30
```

**Expected Changelog Format:**

```markdown
# Changelog for XOAPTestModuleDSC

## [Unreleased]

### Added

- Add TestRegistry resource

### Changed

### Fixed

### Removed

## [0.2.0] - 2026-01-23

...
```

**Verification:**

```powershell
# Verify changelog follows KeepAChangelog format
$changelog = Get-Content ./CHANGELOG.md -Raw
$changelog -match '\[Unreleased\]' | Should -Be $true
$changelog -match '### Added' | Should -Be $true

# Check for your commit message
$changelog | Select-String "TestRegistry"
```

## 6. Test README/Documentation Generation

Documentation is automatically generated for DSC resources during the build.

### What Gets Generated

1. **Conceptual Help**: `en-US/about_*.help.txt`
2. **Resource Documentation**: Help for each DSC resource
3. **Wiki Content**: Markdown documentation for wikis

### Generate Documentation

```powershell
# Build includes documentation generation
.\build.ps1 -Tasks build

# Check generated help files
Get-ChildItem ./output/XOAPTestModuleDSC/*/en-US/
```

**Expected Files:**

```
en-US/
├── about_XOAPTestModuleDSC.help.txt
└── XOAPTestModuleDSC.strings.psd1
```

### Verify Resource Documentation

```powershell
# View generated help
Get-Content ./output/XOAPTestModuleDSC/*/en-US/about_XOAPTestModuleDSC.help.txt

# Check if resources are documented
Get-Help -Name TestRegistry -Full
```

### Test Wiki Generation

```powershell
# Wiki content is generated to output/WikiContent/
Get-ChildItem ./output/WikiContent/ -Recurse

# View generated wiki pages
Get-ChildItem ./output/WikiContent/*.md
```

## 7. Run All Quality Tests

Run the complete test suite to validate module quality.

### Run All Tests

```powershell
# Run all tests (unit, integration, QA)
.\build.ps1 -Tasks test
```

**What gets tested:**

- **Unit Tests**: Individual function testing (tests/Unit/)
- **Integration Tests**: Full DSC configuration tests (tests/Integration/)
- **QA Tests**: PSScriptAnalyzer, module structure (tests/QA/)
- **Code Coverage**: Must meet 85% threshold

### View Test Results

```powershell
# Test results are saved to output/testResults/
Get-ChildItem ./output/testResults/

# View unit test results
$results = [xml](Get-Content ./output/testResults/NUnit*.xml)
$results.'test-results'

# Check code coverage
Get-Content ./output/testResults/CodeCoverage*.xml
```

### Run Specific Test Types

```powershell
# Unit tests only
Invoke-Pester -Path ./tests/Unit/

# Integration tests only
Invoke-Pester -Path ./tests/Integration/

# QA tests only
Invoke-Pester -Path ./tests/QA/

# With code coverage
Invoke-Pester -Path ./tests -CodeCoverage './source/**/*.ps1'
```

### Interpret Test Results

**Successful Test Output:**
```
Tests completed in 2.5s
Tests Passed: 15, Failed: 0, Skipped: 0, NotRun: 0
Code Coverage: 87.5% (threshold: 85%)
```

**If Tests Fail:**

```powershell
# View failed tests
$results = Invoke-Pester -Path ./tests -PassThru
$results.Failed | Format-List

# Check specific error
$results.Failed[0].ErrorRecord
```

## 8. Test HQRM Standards

Test compliance with High Quality Resource Module (HQRM) standards from the DSC Community.

```powershell
# Run HQRM tests
.\build.ps1 -Tasks hqrmtest
```

**What gets validated:**

- ✅ Module follows DSC Community guidelines
- ✅ Proper folder structure
- ✅ Required metadata in manifest
- ✅ Examples are provided
- ✅ Help documentation exists
- ✅ Resources are properly formatted
- ✅ Integration tests exist
- ✅ No Script Analyzer violations

**Expected Output:**

```markdown
Describing 'Common Tests - Validate Module Files'
  [+] Changelog file exists
  [+] Module manifest exists
  [+] Module manifest has correct structure

Describing 'Common Tests - Script Analyzer'
  [+] Module passes Script Analyzer rules

Describing 'Common Tests - Required Module Files'
  [+] DSCResources folder exists
  [+] Examples folder exists
```

**Verification:**

```powershell
# Check HQRM test results
Get-Content ./output/testResults/DscResource*.xml
```

## Complete Test Workflow Example

Follow this end-to-end workflow to test everything:

```powershell
# ====================================
# STEP 1: Clean Start
# ====================================
.\build.ps1 -Tasks clean
Remove-Item ./output -Recurse -Force -ErrorAction SilentlyContinue

# ====================================
# STEP 2: Create Test Resource
# ====================================
.\New-CompositeResource.ps1 `
    -Module "WindowsConfig" `
    -Version "1.0.0" `
    -Resource "TimeZone"

# ====================================
# STEP 3: Add Resource Logic
# ====================================
$resourcePath = "./source/XOAPWindowsConfigDSC/1.0.0/DSCResources/TimeZone/TimeZone.schema.psm1"
$resourceContent = @'
Configuration TimeZone
{
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $TimeZone,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [String]
        $Ensure = 'Present'
    )

    Import-DscResource -ModuleName ComputerManagementDsc

    TimeZone SetTimeZone
    {
        IsSingleInstance = 'Yes'
        TimeZone         = $TimeZone
    }
}
'@
Set-Content -Path $resourcePath -Value $resourceContent

# ====================================
# STEP 4: Commit Changes
# ====================================
git add .
git commit -m "feat: add TimeZone composite resource

This resource allows setting the system time zone using DSC."

# ====================================
# STEP 5: Resolve Dependencies
# ====================================
.\build.ps1 -ResolveDependency -Tasks noop

# ====================================
# STEP 6: Build Module
# ====================================
.\build.ps1 -Tasks build

# ====================================
# STEP 7: Verify Build Outputs
# ====================================

# Check version in manifest
Write-Host "`n=== MODULE VERSION ===" -ForegroundColor Cyan
$manifest = Import-PowerShellDataFile "./output/XOAPWindowsConfigDSC/*/XOAPWindowsConfigDSC.psd1"
Write-Host "Version: $($manifest.ModuleVersion)"

# Check changelog
Write-Host "`n=== CHANGELOG ===" -ForegroundColor Cyan
Get-Content ./CHANGELOG.md -Head 25

# Check generated help
Write-Host "`n=== GENERATED DOCUMENTATION ===" -ForegroundColor Cyan
Get-ChildItem ./output/XOAPWindowsConfigDSC/*/en-US/

# Check resource was included
Write-Host "`n=== DSC RESOURCES ===" -ForegroundColor Cyan
Write-Host "Exported Resources: $($manifest.DscResourcesToExport -join ', ')"

# ====================================
# STEP 8: Run Tests
# ====================================
Write-Host "`n=== RUNNING TESTS ===" -ForegroundColor Cyan
.\build.ps1 -Tasks test

# ====================================
# STEP 9: Review Test Results
# ====================================
Write-Host "`n=== TEST RESULTS ===" -ForegroundColor Cyan
Get-ChildItem ./output/testResults/ | Format-Table Name, Length, LastWriteTime

# ====================================
# STEP 10: Run HQRM Tests
# ====================================
Write-Host "`n=== HQRM TESTS ===" -ForegroundColor Cyan
.\build.ps1 -Tasks hqrmtest

# ====================================
# STEP 11: Package Module (Optional)
# ====================================
Write-Host "`n=== PACKAGING MODULE ===" -ForegroundColor Cyan
.\build.ps1 -Tasks pack

# Check created package
Get-ChildItem ./output/*.nupkg

# ====================================
# STEP 12: Final Summary
# ====================================
Write-Host "`n=== BUILD SUMMARY ===" -ForegroundColor Green
Write-Host "✓ Module built successfully"
Write-Host "✓ Version: $($manifest.ModuleVersion)"
Write-Host "✓ Resources: $($manifest.DscResourcesToExport.Count)"
Write-Host "✓ Tests passed"
Write-Host "✓ Documentation generated"
Write-Host "✓ Package created"
```

## Key Files to Monitor

Track these files throughout the testing process:

| File/Folder | Purpose | Check For |
|-------------|---------|-----------|
| `GitVersion.yml` | Version strategy | Branch configurations, increment rules |
| `CHANGELOG.md` | Change history | Unreleased section, version entries |
| `output/XOAPModuleDSC/<version>/` | Built module | Module files, resources, manifest |
| `output/XOAPModuleDSC/<version>/XOAPModuleDSC.psd1` | Module manifest | Version, metadata, exported resources |
| `output/XOAPModuleDSC/<version>/en-US/` | Documentation | Help files for module and resources |
| `output/testResults/` | Test outputs | NUnit XML, code coverage reports |
| `output/*.nupkg` | Package | NuGet package for distribution |
| `build.yaml` | Build configuration | Tasks, Pester settings, thresholds |

### Quick Check Commands

```powershell
# Monitor all key files at once
$checks = @{
    "Module Version" = { 
        $m = Import-PowerShellDataFile "./output/XOAPWindowsConfigDSC/*/XOAPWindowsConfigDSC.psd1"
        $m.ModuleVersion 
    }
    "Changelog Updated" = { 
        (Get-Content ./CHANGELOG.md -Head 10 | Select-String "Unreleased").Count -gt 0
    }
    "Documentation Exists" = { 
        (Get-ChildItem ./output/XOAPWindowsConfigDSC/*/en-US/ -ErrorAction SilentlyContinue).Count -gt 0
    }
    "Tests Passed" = { 
        Test-Path ./output/testResults/NUnit*.xml
    }
    "Package Created" = { 
        (Get-ChildItem ./output/*.nupkg -ErrorAction SilentlyContinue).Count -gt 0
    }
}

foreach ($check in $checks.GetEnumerator()) {
    $result = & $check.Value
    $status = if ($result) { "✓" } else { "✗" }
    Write-Host "$status $($check.Key): $result"
}
```

## Validation Checklist

Use this checklist to ensure complete testing:

### Module Initialization

- [ ] Module initialization script runs without errors
- [ ] All file references are updated to new module name
- [ ] Module manifest contains correct metadata
- [ ] No old module name references remain

### Versioning

- [ ] GitVersion calculates version correctly
- [ ] Version increments on master commits
- [ ] Feature branches show appropriate tags
- [ ] Built module manifest has correct version

### Resource Creation

- [ ] New-CompositeResource creates folder structure
- [ ] Resource schema file is generated
- [ ] Module manifest includes new resource
- [ ] Resource can be compiled

### Build Process

- [ ] Dependencies resolve without errors
- [ ] Build completes successfully
- [ ] Output directory has correct structure
- [ ] Module files are in versioned folder
- [ ] No build errors or warnings

### Changelog

- [ ] Changelog file exists
- [ ] Follows KeepAChangelog format
- [ ] Contains [Unreleased] section
- [ ] Git commits appear in appropriate categories
- [ ] Version sections have dates

### Documentation

- [ ] Conceptual help files generated in en-US/
- [ ] Resource documentation exists
- [ ] Wiki content is created
- [ ] Help content is accessible via Get-Help

### Testing

- [ ] All unit tests pass
- [ ] All integration tests pass
- [ ] All QA tests pass
- [ ] Code coverage meets 85% threshold
- [ ] PSScriptAnalyzer reports no issues
- [ ] Test results are saved to output/

### HQRM Standards

- [ ] Module structure follows DSC Community guidelines
- [ ] Required files present (README, CHANGELOG, etc.)
- [ ] Examples are provided
- [ ] No Script Analyzer violations
- [ ] Integration tests exist

### Packaging

- [ ] Module packages into .nupkg
- [ ] Package contains all necessary files
- [ ] Package version matches module version

## Troubleshooting

### Common Issues and Solutions

#### Issue: Dependencies fail to download

```powershell
# Solution: Clear cache and retry
Remove-Item ./output/RequiredModules -Recurse -Force
.\build.ps1 -ResolveDependency -Tasks noop
```

#### Issue: GitVersion not found

```powershell
# Solution: Install GitVersion tool
dotnet tool install --global GitVersion.Tool
```

#### Issue: Build fails with "Module not found"

```powershell
# Solution: Ensure you've resolved dependencies first
.\build.ps1 -ResolveDependency -Tasks noop
# Then build again
.\build.ps1 -Tasks build
```

#### Issue: Tests fail with "Cannot find module"

```powershell
# Solution: Build before testing
.\build.ps1 -Tasks build
.\build.ps1 -Tasks test
```

#### Issue: Code coverage below threshold

```powershell
# Solution: Add more unit tests or adjust threshold in build.yaml
# Temporarily lower threshold for testing:
# Edit build.yaml: CodeCoverageThreshold: 70

# Or add more unit tests to tests/Unit/
```

#### Issue: PSScriptAnalyzer violations

```powershell
# Solution: Run analyzer locally to see issues
Install-Module -Name PSScriptAnalyzer -Scope CurrentUser
Invoke-ScriptAnalyzer -Path ./source -Recurse -Settings PSGallery

# Fix reported issues in your code
```

#### Issue: Changelog not updating

```powershell
# Solution: Use conventional commit messages
git commit -m "feat: add new feature"
git commit -m "fix: resolve bug"

# Build to process commits
.\build.ps1 -Tasks build
```

#### Issue: Documentation not generated

```powershell
# Solution: Ensure DscResource.DocGenerator is installed
.\build.ps1 -ResolveDependency
# Check for .psd1 files in DSCResources folders
# Run build with verbose output
.\build.ps1 -Tasks build -Verbose
```

### Getting Help

- **DSC Community**: https://dsccommunity.org/
- **Sampler Framework**: https://github.com/gaelcolas/Sampler
- **Pester Documentation**: https://pester.dev/
- **GitVersion**: https://gitversion.net/

### Debug Build Issues

```powershell
# Run build with verbose output
.\build.ps1 -Tasks build -Verbose

# Check build log
Get-Content ./output/build.log

# Run individual tasks
.\build.ps1 -Tasks Clean
.\build.ps1 -Tasks Build_Module_ModuleBuilder
.\build.ps1 -Tasks Create_changelog_release_output
```

### Test Specific Components

```powershell
# Test only PSScriptAnalyzer
Invoke-ScriptAnalyzer -Path ./source -Recurse

# Test only module manifest
Test-ModuleManifest ./output/XOAPWindowsConfigDSC/*/XOAPWindowsConfigDSC.psd1

# Test only specific Pester file
Invoke-Pester -Path ./tests/QA/module.tests.ps1 -Output Detailed
```

---

## Next Steps

After completing these tests:

1. **Review Results**: Check all outputs and logs for issues
2. **Iterate**: Fix any failures and retest
3. **Document**: Add your resources to Examples folder
4. **Commit**: Save your working configuration
5. **Share**: Push to repository or publish to PowerShell Gallery

For more information, see:

- [BUILD.md](BUILD.md) - Detailed build documentation
- [CONTRIBUTING.md](CONTRIBUTING.md) - Contribution guidelines
- [README.md](README.md) - Module overview
