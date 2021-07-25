function Write-Logentry {
    [CmdletBinding(SupportsShouldProcess)]

    param (
        [Parameter(
            Mandatory,
            Position=0,
            ValueFromPipeline
        )]
        [Logistic]$LogisticObject,

        [Parameter(
            Mandatory,
            Position=1,
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
        $ConsoleOutput = $InputObject -as [string]
        switch ($Type) {
            'Verbose' {
                if (-not ($NoConsoleOutput)) { Write-Verbose -Message $ConsoleOutput }
            }
            'Warning' { Write-Warning -Message $ConsoleOutput }
            'Error' { Write-Error -Message $ConsoleOutput }
        }

        $Logentry = GetLogentry -Format $LogisticObject.Format -InputObject $InputObject -Type $Type

        switch ($LogisticInfo.Type) {
            'Outfile' {
                Out-File -FilePath $LogisticObject.Fullpath -Encoding utf8 -Append -InputObject $Logentry
            }

            'StreamWriter' {
                ($LogisticObject.StreamWriter).WriteLine($Logentry)
            }
        }
    }

    end {}
}
