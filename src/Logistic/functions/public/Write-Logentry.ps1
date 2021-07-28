function Write-Logentry {
    [CmdletBinding(SupportsShouldProcess)]

    param (
        [Parameter(
            Mandatory,
            Position = 0,
            ValueFromPipeline
        )]
        [Logistic]$LogisticObject,

        [Parameter(
            Mandatory,
            Position = 1,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [Alias('Message')]
        [ValidateNotNullOrEmpty()]
        [psobject]$InputObject,

        [Parameter()]
        [ValidateSet('Verbose', 'Warning', 'Error')]
        [string]$Type = 'Verbose',

        [switch]$NoConsoleOutput
    )

    begin {
        Set-StrictMode -Version 3
    }

    process {
        $Timestamp = Get-Date

        # TODO: Dig deeper
        # Gathering stacktrace information
        if ($MyInvocation.PSCommandPath) {
            $StackTrace = Split-Path -Path $MyInvocation.PSCommandPath -Leaf
        } else {
            $StackTrace = $MyInvocation.CommandOrigin
        }

        # Outputting data without formatting to keep it human readable
        $ConsoleOutput = $InputObject -as [string]
        switch ($Type) {
            'Verbose' {
                if (-not ($NoConsoleOutput)) {
                    Write-Verbose -Message $ConsoleOutput
                }
            }
            'Warning' { Write-Warning -Message $ConsoleOutput }
            'Error' { Write-Error -Message $ConsoleOutput }
        }

        $Logentry = GetLogentry -Format $LogisticObject.Format -InputObject $InputObject -Type $Type

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
