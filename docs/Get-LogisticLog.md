---
external help file: Logistic-help.xml
Module Name: Logistic
online version: https://github.com/philmph/Log-istic/blob/main/docs/Get-LogisticLog.md
schema: 2.0.0
---

# Get-LogisticLog

## SYNOPSIS

Retrieves Logistic logfile data and converts them into PowerShell objects.

## SYNTAX

```powershell
Get-LogisticLog [-Path] <String> [-JSONDepth <Int16>] [<CommonParameters>]
```

## DESCRIPTION

Retrieves Logistic logfile data and converts them into PowerShell objects.

## EXAMPLES

### EXAMPLE 1

```powershell
Get-LogisticLog -Path .\logistic_json.log

Timestamp         : 2021-08-02 09:49:33.007
Callstack         : Runspace
Data              : Teststring
Type              : Verbose
TimestampDatetime : 02.08.2021 09:49:33

# Content of logistic_json.log
C:\> Get-Content .\logistic_json.log
{"Timestamp":"2021-08-02 09:49:33.007","Callstack":"Runspace","Data":"Teststring","Type":"Verbose"}
```

### EXAMPLE 2

```powershell
Get-LogisticLog -Path .\logistic_sccm.log

Timestamp         : 2021-08-02 09:49:45.330436
Callstack         : Runspace
Data              : Teststring
Type              : Verbose
TimestampDatetime : 02.08.2021 09:49:45

# Content of logistic_sccm.log
C:\> Get-Content .\logistic_sccm.log
<![LOG[Teststring]LOG]!><time="09:49:45.330436" date="2021-08-02" component="Runspace" context="" type="1" thread="" file="Runspace">
```

## PARAMETERS

### -Path

Defines the path to the logfile.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -JSONDepth

Defines the object depth (only relevant for JSON logfiles).

```yaml
Type: Int16
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 3
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### [string]

## OUTPUTS

### [psobject]

## NOTES

Author: Philipp Maier
Author Git: [GitHub](https://github.com/philmph)

## RELATED LINKS

[Get-LogisticLog](https://github.com/philmph/Log-istic/blob/main/docs/Get-LogisticLog.md)
