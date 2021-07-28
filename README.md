# Log-istic

## About

This project is used for providing various different logging methods for PowerShell. The mopdule provided is opinionated and reflects my idea of how logging should look like. Changes might occur over time.

## Installation

TODO: PSGallery publishing

## Usage

Initialize a new `[Logistic]` class providing a set of the following overloads. Available inputs see below.

```powershell
# Initializing Logistic with n overloads

# Defaults to Outfile type and JSON format
[Logistic]::new('PATH')

# Defaults to JSON format
[Logistic]::new('PATH', 'TYPE')

# Full constructor
[Logistic]::new('PATH', 'TYPE', 'FORMAT')
```

### Path

Relative or fully qualified path to a leaf location (logfile). F.e. `'./logistic.log'`.

### Type

- Outfile
- StreamWriter

### Format

- JSON
- SCCM

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## Authors and Acknowledgments

- Philipp Maier

## License

[License](LICENSE)
