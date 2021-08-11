function Write-Logentry {
    <#
    .SYNOPSIS
        Writes log entries into logfile with specific formatting.

    .DESCRIPTION
        Writes log entries into logfile with specific formatting.

    .PARAMETER LogisticObject
        Required as this object provides required log settings.

    .PARAMETER InputObject
        Defines the main log information data. Can be [string] or complex formats like [PSCustomObject].

    .PARAMETER Type
        Defines the log type. Can be 'Verbose' (default), 'Warning' or 'Error'.

    .EXAMPLE
        Write-Logentry -LogisticObject $Logistic -InputObject 'Teststring' -Type Warning
        WARNING: Teststring

    .EXAMPLE
        Write-Logentry -LogisticObject $Logistic -InputObject ([PSCustomObject]@{Testobject = 'Data'}) -Type Error
        Write-Logentry : @{Testobject=Data}

    .INPUTS
        [string]

    .OUTPUTS
        -

    .LINK
        https://github.com/philmph/Log-istic/blob/main/docs/Write-Logentry.md
    #>


    [CmdletBinding(SupportsShouldProcess)]

    param (
        [Parameter(Mandatory)]
        [Logistic]$LogisticObject,

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
        [ValidateSet('Verbose', 'Warning', 'Error')]
        [string]$Type = 'Verbose'
    )

    begin {
        Set-StrictMode -Version 3
    }

    process {
        # Outputting data without formatting to keep it human readable
        $ConsoleOutput = $InputObject -as [string]
        switch ($Type) {
            'Verbose' { Write-Verbose -Message $ConsoleOutput }
            'Warning' { Write-Warning -Message $ConsoleOutput }
            'Error' { Write-Error -Message $ConsoleOutput }
        }

        # Gather timestamp information
        $Timestamp = Get-Date

        # Gather callstack information
        $Callstack = $MyInvocation

        $GetLogEntryArgs = @{
            LogID       = $LogisticObject.LogID
            Format      = $LogisticObject.Format
            Timestamp   = $Timestamp
            Callstack   = $Callstack
            Inputobject = $InputObject
            Type        = $Type
        }
        $Logentry = GetLogentry @GetLogEntryArgs

        if ($PSCmdlet.ShouldProcess($LogisticObject.Fullpath, 'Write-Logentry')) {
            switch ($LogisticObject.Type) {
                'Outfile' {
                    Out-File -FilePath $LogisticObject.Fullpath -Encoding utf8 -Append -InputObject $Logentry
                }

                'StreamWriter' {
                    if ($LogisticObject.StreamWriter) {
                        ($LogisticObject.StreamWriter).WriteLine($Logentry)
                    } else {
                        Write-Error 'StreamWriter in $LogisticObject is not initialized'
                    }
                }
            }
        }
    }

    end {}
}
