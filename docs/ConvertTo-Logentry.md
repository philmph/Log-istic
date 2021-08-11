---
external help file: Logistic-help.xml
Module Name: Logistic
online version: https://github.com/philmph/Log-istic/blob/main/docs/ConvertTo-Logentry.md
schema: 2.0.0
---

# ConvertTo-Logentry

## SYNOPSIS

Converts an InputObject (f.e. \[string\], \[PSCustomObject\]) into a log string.

## SYNTAX

```powershell
ConvertTo-Logentry [-InputObject] <PSObject> [-Format <String>] [-Type <String>] [<CommonParameters>]
```

## DESCRIPTION

Converts an InputObject (f.e. \[string\], \[PSCustomObject\]) into a log string.

## EXAMPLES

### EXAMPLE 1

```powershell
ConvertTo-Logentry -InputObject "Teststring" -Format JSON
{"Timestamp":"2021-08-01 23:09:11.179","Callstack":"Runspace","Data":"Teststring","Type":"Verbose"}
```

### EXAMPLE 2

```powershell
ConvertTo-Logentry -InputObject ([PSCustomObject]@{Testobject = 'Data'}) -Format JSON
{"Timestamp":"2021-08-01 23:09:58.362","Callstack":"Runspace","Data":{"Testobject":"Data"},"Type":"Verbose"}
```

### EXAMPLE 3

```powershell
ConvertTo-Logentry -InputObject "Teststring" -Format SCCM
<![LOG[Teststring]LOG]!><time="23:10:55.309843" date="2021-08-01" component="Runspace" context="" type="1" thread="" file="Runspace">
```

### EXAMPLE 4

```powershell
ConvertTo-Logentry -InputObject ([PSCustomObject]@{Testobject = 'Data'}) -Format SCCM
<![LOG[@{Testobject=Data}]LOG]!><time="23:11:19.298018" date="2021-08-01" component="Runspace" context="" type="1" thread="" file="Runspace">
```

## PARAMETERS

### -InputObject

Defines the main log information data.
Can be \[string\] or complex formats like \[PSCustomObject\].

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases: Message

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Format

Defines the log format.
Can be 'JSON' (default) or 'SCCM'.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: JSON
Accept pipeline input: False
Accept wildcard characters: False
```

### -Type

Defines the log type.
Can be 'Verbose' (default), 'Warning' or 'Error'.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Verbose
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### [psobject]

## OUTPUTS

### [string]

## RELATED LINKS

[ConvertTo-Logentry](https://github.com/philmph/Log-istic/blob/main/docs/ConvertTo-Logentry.md)
