function Get-LogisticLog {
    [CmdletBinding()]

    param (
        [Parameter(
            Mandatory,
            Position = 0,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [ValidateScript( {
                if (Test-Path -Path $_ -PathType Leaf) {
                    $true
                } else {
                    throw "Cannot validate Path to logfile '$_'"
                }
            })]
        [string]$Path,

        [int16]$JSONDepth = 3
    )

    begin {
        Set-StrictMode -Version 3
    }

    process {
        $Content = Get-Content -Path $Path -Encoding utf8

        $Type = switch -Regex ($Content[0]) {
            '^\{"' { 'JSON' }
            '^<!' { 'SCCM' }
            default { Write-Error -Message 'Cannot validate log format' -ErrorAction 'Stop' }
        }

        foreach ($Line in $Content) {
            switch ($Type) {
                'JSON' {
                    $Output = $Line |
                    ConvertFrom-Json -Depth $JSONDepth |
                    Select-Object -Property *, @{ N = 'TimestampDatetime'; E = { $_.Timestamp -as [Datetime] } }

                    Write-Output $Output
                }

                'SCCM' {
                    # <![LOG[Testobjekt]LOG]!><time="18:24:56.722516" date="07-31-2021" component="Write-Logentry.ps1" context="" type="1" thread="" file="Write-Logentry.ps1">
                    # '<![LOG[{0}]LOG]!><time="{1:HH\:mm\:ss\.ffffff}" date="{1:MM-dd-yyyy}" component="{2}" context="" type="{3}" thread="" file="{2}">'
                    $Regex = 'LOG\[(?<Data>.+?)\].+time="(?<Time>.+?)" date="(?<Date>.+?)" component="(?<Callstack>.+?)".+type="(?<Type>.+?)"'

                    # TODO: Implement logic
                }
            }
        }
    }

    end {}
}
