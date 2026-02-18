# Contributing to XOAPModuleTemplateDSC

Thank you for considering contributing to this project!

## Getting Started

1. **Fork the repository** and clone it locally
2. **Install dependencies**: `.\build.ps1 -ResolveDependency -Tasks noop`
3. **Create a feature branch**: `git checkout -b feature/my-new-feature`
4. **Make your changes** following our coding standards
5. **Run tests**: `.\build.ps1 -Tasks test`
6. **Commit your changes**: `git commit -am 'feat: Add some feature'`
7. **Push to the branch**: `git push origin feature/my-new-feature`
8. **Submit a pull request**

## Development Guidelines

### Coding Standards

- Follow DSC Community style guidelines
- Use PSScriptAnalyzer rules (enforced by build)
- Maintain minimum 85% code coverage
- Add comprehensive comment-based help

### Testing Requirements

- **Unit Tests**: Required for all functions
- **Integration Tests**: Required for DSC resources
- **Code Coverage**: Minimum 85%
- **HQRM Tests**: Must pass

## Running the Tests

```powershell
# All tests
.\build.ps1 -Tasks test

# Unit tests only
Invoke-Pester -Path ./tests/Unit/

# Integration tests only
Invoke-Pester -Path ./tests/Integration/
```

## Code of Conduct

This project has adopted this [Code of Conduct](CODE_OF_CONDUCT.md).
