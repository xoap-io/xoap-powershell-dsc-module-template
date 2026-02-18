# Changelog for xoap-application-packaging-dsc

The format is based on and uses the types of changes according to [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Added PowerShell Core (Desktop and Core) compatibility to module manifest
- Improved README with better feature descriptions and prerequisites
- Added minimum version requirements for Plaster dependency
- Comprehensive GitHub Actions CI/CD workflow with build, test, and publish stages
- DscResource.DocGenerator for automatic DSC documentation generation
- Properly versioned build artifacts

### Removed

- Azure Pipelines configuration (replaced with GitHub Actions)
- AppVeyor configuration (replaced with GitHub Actions)

### Changed

- Updated GitHub Actions to latest versions (checkout@v4, dependabot/fetch-metadata@v2, wagoid/commitlint-github-action@v6)
- Updated pre-commit hooks to latest versions (conventional-pre-commit v3.2.0, pre-commit-hooks v5.0.0, check-jsonschema 0.30.0, prettier v4.0.0-alpha.8)
- Bumped module version from 0.0.1 to 0.1.0
- Updated copyright year to 2024-2026
- Improved README documentation with better formatting and clearer instructions

### Deprecated

- None

### Removed

- None

### Fixed

- Fixed typo: 'Ressource' corrected to 'Resource' throughout the codebase (New-CompositeResource.ps1)
- Fixed variable naming inconsistency in New-CompositeResource.ps1

### Security

- None
