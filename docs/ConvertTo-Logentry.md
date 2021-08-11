---
external help file: Logistic-help.xml
Module Name: Logistic
online version: https://github.com/philmph/Log-istic/blob/main/docs/ConvertTo-Logentry.md
schema: 2.0.0
---

# ConvertTo-Logentry

## SYNOPSIS
Converts an InputObject (f.e.
\[string\], \[PSCustomObject\]) into a log string.

## SYNTAX

```
ConvertTo-Logentry [-InputObject] <PSObject> [-Format <String>] [-Type <String>] [-LogID <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Converts an InputObject (f.e.
\[string\], \[PSCustomObject\]) into a log string.

## EXAMPLES

### EXAMPLE 1
```
ConvertTo-Logentry -InputObject "Teststring" -Format JSON
{"LogID":"","Timestamp":"2021-08-11 22:30:33.130","Callstack":"Runspace","Data":"Teststring","Type":"Verbose"}
```

### EXAMPLE 2
```
ConvertTo-Logentry -InputObject ([PSCustomObject]@{Testobject = 'Data'}) -Format JSON -LogID 1234
{"LogID":1234,"Timestamp":"2021-08-11 22:30:45.221","Callstack":"Runspace","Data":{"Testobject":"Data"},"Type":"Verbose"}
```

Using -LogID to add an unique identifier to the logentry.

### EXAMPLE 3
```
ConvertTo-Logentry -InputObject "Teststring" -Format SCCM
<![LOG[Teststring]LOG]!><time="23:10:55.309843" date="2021-08-01" component="Runspace" context="" type="1" thread="" file="Runspace">
```

### EXAMPLE 4
```
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

### -LogID
Optional to define a LogID to easier reference log entires later.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### [psobject]
## OUTPUTS

### [string]
## NOTES

## RELATED LINKS

[https://github.com/philmph/Log-istic/blob/main/docs/ConvertTo-Logentry.md](https://github.com/philmph/Log-istic/blob/main/docs/ConvertTo-Logentry.md)

