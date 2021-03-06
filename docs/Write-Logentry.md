---
external help file: Logistic-help.xml
Module Name: Logistic
online version: https://github.com/philmph/Log-istic/blob/main/docs/Write-Logentry.md
schema: 2.0.0
---

# Write-Logentry

## SYNOPSIS
Writes log entries into logfile with specific formatting.

## SYNTAX

```
Write-Logentry -LogisticObject <Logistic> [-InputObject] <PSObject> [-Type <String>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Writes log entries into logfile with specific formatting.

## EXAMPLES

### EXAMPLE 1
```
Write-Logentry -LogisticObject $Logistic -InputObject 'Teststring1'
```

### EXAMPLE 2
```
Write-Logentry -LogisticObject $Logistic -InputObject 'Teststring2' -Type Warning
WARNING: Teststring
```

This example outputs a WARNING message to the console on default $WarningPreference

### EXAMPLE 3
```
Write-Logentry -LogisticObject $Logistic -InputObject ([PSCustomObject]@{Testobject = 'Data'}) -Type Error
Write-Logentry : @{Testobject=Data}
```

This example outputs an ERROR message to the console on default $ErrorPreference

## PARAMETERS

### -LogisticObject
Required as this object provides required log settings.

```yaml
Type: Logistic
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

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

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### [string]
## OUTPUTS

### -
## NOTES

## RELATED LINKS

[https://github.com/philmph/Log-istic/blob/main/docs/Write-Logentry.md](https://github.com/philmph/Log-istic/blob/main/docs/Write-Logentry.md)

