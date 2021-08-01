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

    .EXAMPLE
        C:\> ConvertTo-Logentry -InputObject "Teststring" -Format JSON
        {"Timestamp":"2021-08-01 23:09:11.179","Callstack":"Runspace","Data":"Teststring","Type":"Verbose"}

    .EXAMPLE
        C:\> ConvertTo-Logentry -InputObject ([PSCustomObject]@{Testobject = 'Data'}) -Format JSON
        {"Timestamp":"2021-08-01 23:09:58.362","Callstack":"Runspace","Data":{"Testobject":"Data"},"Type":"Verbose"}

    .EXAMPLE
        C:\> ConvertTo-Logentry -InputObject "Teststring" -Format SCCM
        <![LOG[Teststring]LOG]!><time="23:10:55.309843" date="2021-08-01" component="Runspace" context="" type="1" thread="" file="Runspace">

    .EXAMPLE
        C:\> ConvertTo-Logentry -InputObject ([PSCustomObject]@{Testobject = 'Data'}) -Format SCCM
        <![LOG[@{Testobject=Data}]LOG]!><time="23:11:19.298018" date="2021-08-01" component="Runspace" context="" type="1" thread="" file="Runspace">

    .INPUTS
        [psobject]

    .OUTPUTS
        [string]

    .NOTES
        Author:			Philipp Maier
        Author Git:		https://github.com/philmph

    .LINK
        TODO: Add docs/markdown to GitHub
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
        [string]$Type = 'Verbose'
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
            Format = $Format
            Timestamp = $Timestamp
            Callstack = $Callstack
            Inputobject = $InputObject
            Type = $Type
        }
        $Output = GetLogentry @GetLogEntryArgs

        Write-Output -InputObject $Output
    }

    end {}
}
