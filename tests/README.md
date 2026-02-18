# Testing Documentation

This folder contains all test files for the module.

## Structure

- **Unit/** - Unit tests for individual functions and resources
- **Integration/** - Integration tests that test full DSC configurations
- **QA/** - Quality assurance tests (PSScriptAnalyzer, module structure, etc.)

## Running Tests

### All Tests
```powershell
.\build.ps1 -Tasks test
```

### Unit Tests Only
```powershell
Invoke-Pester -Path .\tests\Unit\
```

### Integration Tests Only
```powershell
Invoke-Pester -Path .\tests\Integration\
```

### QA Tests Only
```powershell
Invoke-Pester -Path .\tests\QA\
```

## Writing Tests

Use the template files in each folder as starting points for new tests:
- `Unit/Template.Tests.ps1` - Template for unit tests
- `Integration/Template.Integration.Tests.ps1` - Template for integration tests

## Test Standards

- All tests should use Pester 5.x syntax
- Unit tests should mock external dependencies
- Integration tests should test actual DSC configurations
- All tests should have appropriate `BeforeAll`, `BeforeEach`, `AfterEach`, and `AfterAll` blocks
- Use descriptive test names with proper context
