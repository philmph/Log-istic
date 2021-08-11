# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [v0.1.0] - 2021-08-11

### Added

- GUID as `LogID` for easier tracing of logentries which belong together
- `LogID` and `Type` filter for `Get-LogisticLog`
- Optional Parameter `LogID` for `ConvertTo-Logentry`

### Fixed

- `Get-LogisticLog` for PowerShell version 5 missing parameter `-Depth` for `ConvertFrom-Json`

## [v0.0.3] - 2021-08-03

### Added

- Finished basic functionality
- Documentation for public functions
- Basic Pester tests (Module, Lint)
- Initial GitHub Workflow

## [v0.0.2] - 2021-07-31

### Added

- Basic functionality for Outfile and StreamWriter
- Public functions `ConvertTo-Logentry`, `Get-LogisticLog` and `Write-Logentry`

## [v0.0.1] - 2021-07-25

### Added

- Project creation
