# Log-istic

[![Build Status](https://dev.azure.com/philmph/Log-istic/_apis/build/status/logistic-ci?branchName=main)](https://dev.azure.com/philmph/Log-istic/_build/latest?definitionId=10&branchName=main)

## About

This project is used for providing various different logging methods for PowerShell. The mopdule provided is opinionated and reflects my idea of how logging should look like. Changes might occur over time.

## Installation

To be added (PSGallery). For now only manual download and installation is possible.

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

**Note: Don't forget to use the method `CloseStreamWriter()` when using StreamWriter functionality.**

### Path

Relative or fully qualified path to a leaf location (logfile). F.e. `'./logistic.log'`.

### Type

- Outfile
- StreamWriter

### Format

- JSON
- SCCM

### Hint

```powershell
# Don't forget to use the very useful variable $PSDefaultParameterValues when used in a script
$PSDefaultParameterValues = @{
    'Write-Logentry:LogisticObject' = $Logistic
}
```

## Example

```powershell
# Creating a new [Logistic] instance
C:\> $Logistic = [Logistic]::new('.\logistic.log', 'StreamWriter')

# Writing a warning into the log
C:\> Write-Logentry -LogisticObject $Logistic -InputObject "Testentry" -Type Warning

WARNING: Testentry

# Writing an object into the log
C:\> $CustomObject = [PSCustomObject]@{ Testobject = 123; Testobject2 = "String" }
C:\> Write-Logentry -LogisticObject $Logistic -InputObject $CustomObject

# Closing the StreamWriter
C:\> $Logistic.CloseStreamWriter()

# Querying data we just wrote into '.\logistic.log'
C:\> $Data = Get-LogisticLog -Path .\logistic.log
C:\> $Data

Timestamp         : 2021-07-31 21:47:02.737
Callstack         : Runspace
Data              : Testentry
Type              : Warning
TimestampDatetime : 31.07.2021 21:47:02

Timestamp         : 2021-07-31 21:47:46.401
Callstack         : Runspace
Data              : @{Testobject=123; Testobject2=String}
Type              : Verbose
TimestampDatetime : 31.07.2021 21:47:46

# Expanding the Data property of the $Data object
# Data : @{Testobject=123; Testobject2=String}
C:\> $Data[1].Data

Testobject Testobject2
---------- -----------
       123 String
```

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## Authors and Acknowledgments

- Philipp Maier

## License

[License](LICENSE)
