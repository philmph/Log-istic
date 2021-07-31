function ConvertTo-Logentry {
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
