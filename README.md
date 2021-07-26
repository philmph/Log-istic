# Log-istic

## About

This project is used for providing various different logging methods since PowerShell does not offer this functinoality built in.

## Installation

## Usage

Initialize a new `[Logistic]` class using `[Logistic]::new(TYPE, FORMAT, PATH)`. The following options are available

### Type

- Outfile
- StreamWriter
- WindowsEventlog (not yet available)
- SQL (not yet available)

### Format

- JSON
- SCCM

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

### Open Tasks / Ideas

- [ ] Finish initial version
- [ ] Add functions for reading and browsing a Log-istic logs via PowerShell
- [ ] Add functionality for custom formats
- [ ] Add Pester tests
- [ ] Add Build process
- [ ] Add automatic PSGallery publishing (via GitHub Actions / Azure DevOps Pipelines)

## Authors and Acknowledgments

- Philipp Maier

## License

[License](LICENSE)
