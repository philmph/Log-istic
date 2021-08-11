function Get-LogisticLog {
    <#
    .SYNOPSIS
        Retrieves Logistic logfile data and converts them into PowerShell objects.

    .DESCRIPTION
        Retrieves Logistic logfile data and converts them into PowerShell objects.

    .PARAMETER Path
        Defines the path to the logfile.

    .PARAMETER JSONDepth
        Defines the object depth (only relevant for JSON logfiles).

    .EXAMPLE
        C:\> Get-LogisticLog -Path .\logistic_json.log

        Timestamp         : 2021-08-02 09:49:33.007
        Callstack         : Runspace
        Data              : Teststring
        Type              : Verbose
        TimestampDatetime : 02.08.2021 09:49:33

        # Content of logistic_json.log
        C:\> Get-Content .\logistic_json.log
        {"Timestamp":"2021-08-02 09:49:33.007","Callstack":"Runspace","Data":"Teststring","Type":"Verbose"}

    .EXAMPLE
        C:\Users\maierp\Documents\git\nogit> Get-LogisticLog -Path .\logistic_sccm.log

        Timestamp         : 2021-08-02 09:49:45.330436
        Callstack         : Runspace
        Data              : Teststring
        Type              : Verbose
        TimestampDatetime : 02.08.2021 09:49:45

        # Content of logistic_sccm.log
        C:\> Get-Content .\logistic_sccm.log
        <![LOG[Teststring]LOG]!><time="09:49:45.330436" date="2021-08-02" component="Runspace" context="" type="1" thread="" file="Runspace">

    .INPUTS
        [string]

    .OUTPUTS
        [psobject]

    .NOTES
        Author: Philipp Maier
        Author Git: https://github.com/philmph

    .LINK
        https://github.com/philmph/Log-istic/blob/main/docs/Get-LogisticLog.md
    #>

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

        [Parameter()]
        [string]$LogID = 'All',

        [Parameter()]
        [ValidateSet('All', 'Verbose', 'Warning', 'Error')]
        [string]$Type = 'All',

        [int16]$JSONDepth = 3
    )

    begin {
        Set-StrictMode -Version 3
    }

    process {
        $Content = @(Get-Content -Path $Path -Encoding utf8)

        $Type = switch -Regex ($Content[0]) {
            '^\{"' { 'JSON' }
            '^<!' { 'SCCM' }
            default { Write-Error -Message 'Cannot validate log format' -ErrorAction 'Stop' }
        }

        foreach ($Line in $Content) {
            switch ($Type) {
                'JSON' {
                    # Only use $JSONDepth when PSVersion >5
                    if ($PSVersionTable.PSVersion.Major -gt 5) {
                        $PSDefaultParameterValues = @{
                            'ConvertFrom-Json:Depth' = $JSONDepth
                        }
                    }

                    $Output = $Line |
                    ConvertFrom-Json |
                    # LogID filter only works for JSON objects
                    Where-Object -FilterScript { ($LogID -eq 'All') -or ($LogID -eq $_.LogID) }
                    Select-Object -Property *, @{ N = 'TimestampDatetime'; E = { $_.Timestamp -as [Datetime] } }
                }

                'SCCM' {
                    # '<![LOG[{0}]LOG]!><time="{1:HH\:mm\:ss\.ffffff}" date="{1:yyyy-MM-dd}" component="{2}" context="" type="{3}" thread="" file="{2}">'
                    $Regex = 'LOG\[(?<Data>.+?)\].+time="(?<Time>.+?)" date="(?<Date>.+?)" component="(?<Callstack>.+?)".+type="(?<Type>.+?)"'
                    $RegexMatches = [regex]::Matches($Line, $Regex)

                    $Timestamp = '{0} {1}' -f $RegexMatches[0].Groups['Date'], $RegexMatches[0].Groups['Time']

                    $TypeLong = switch ($RegexMatches[0].Groups['Type']) {
                        '1' { 'Verbose' }
                        '2' { 'Warning' }
                        '3' { 'Error' }
                    }

                    $Output = [PSCustomObject] @{
                        Timestamp         = $Timestamp
                        Callstack         = $RegexMatches[0].Groups['Callstack']
                        Data              = $RegexMatches[0].Groups['Data']
                        Type              = $TypeLong
                        TimestampDatetime = $Timestamp -as [Datetime]
                    }
                }
            }

            if (($Type -eq 'All') -or ($Type -eq $Output.Type)) {
                Write-Output -InputObject $Output
            }
        }
    }

    end {}
}
