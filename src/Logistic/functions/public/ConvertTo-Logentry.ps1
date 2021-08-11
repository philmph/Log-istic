function ConvertTo-Logentry {
    <#
    .SYNOPSIS
        Converts an InputObject (f.e. [string], [PSCustomObject]) into a log string.

    .DESCRIPTION
        Converts an InputObject (f.e. [string], [PSCustomObject]) into a log string.

    .PARAMETER InputObject
        Defines the main log information data. Can be [string] or complex formats like [PSCustomObject].

    .PARAMETER Format
        Defines the log format. Can be 'JSON' (default) or 'SCCM'.

    .PARAMETER Type
        Defines the log type. Can be 'Verbose' (default), 'Warning' or 'Error'.

    .PARAMETER LogID
        Optional to define a LogID to easier reference log entires later.

    .EXAMPLE
        ConvertTo-Logentry -InputObject "Teststring" -Format JSON
        {"LogID":"","Timestamp":"2021-08-11 22:30:33.130","Callstack":"Runspace","Data":"Teststring","Type":"Verbose"}

    .EXAMPLE
        ConvertTo-Logentry -InputObject ([PSCustomObject]@{Testobject = 'Data'}) -Format JSON -LogID 1234
        {"LogID":1234,"Timestamp":"2021-08-11 22:30:45.221","Callstack":"Runspace","Data":{"Testobject":"Data"},"Type":"Verbose"}

        Using -LogID to add an unique identifier to the logentry.

    .EXAMPLE
        ConvertTo-Logentry -InputObject "Teststring" -Format SCCM
        <![LOG[Teststring]LOG]!><time="23:10:55.309843" date="2021-08-01" component="Runspace" context="" type="1" thread="" file="Runspace">

    .EXAMPLE
        ConvertTo-Logentry -InputObject ([PSCustomObject]@{Testobject = 'Data'}) -Format SCCM
        <![LOG[@{Testobject=Data}]LOG]!><time="23:11:19.298018" date="2021-08-01" component="Runspace" context="" type="1" thread="" file="Runspace">

    .INPUTS
        [psobject]

    .OUTPUTS
        [string]

    .LINK
        https://github.com/philmph/Log-istic/blob/main/docs/ConvertTo-Logentry.md
    #>

    [CmdletBinding()]

    param (
        [Parameter(
            Mandatory,
            Position = 0,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [Alias('Message')]
        [ValidateNotNullOrEmpty()]
        [psobject]$InputObject,

        [Parameter()]
        [ValidateSet('JSON', 'SCCM')]
        [string]$Format = 'JSON',

        [Parameter()]
        [ValidateSet('Verbose', 'Warning', 'Error')]
        [string]$Type = 'Verbose',

        [string]$LogID = ''
    )

    begin {
        Set-StrictMode -Version 3
    }

    process {
        # Gather timestamp information
        $Timestamp = Get-Date

        # Gather callstack information
        $Callstack = $MyInvocation

        $GetLogEntryArgs = @{
            LogID       = $LogID
            Format      = $Format
            Timestamp   = $Timestamp
            Callstack   = $Callstack
            Inputobject = $InputObject
            Type        = $Type
        }
        $Output = GetLogentry @GetLogEntryArgs

        Write-Output -InputObject $Output
    }

    end {}
}
