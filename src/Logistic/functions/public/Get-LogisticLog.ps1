function Get-LogisticLog {
    <#
    .SYNOPSIS
        Retrieves Logistic logfile data and converts them into PowerShell objects.

    .DESCRIPTION
        Retrieves Logistic logfile data and converts them into PowerShell objects.

    .PARAMETER Path
        Defines the path to the logfile. Possible values 'All' (default) or a GUID.

    .PARAMETER LogID
        Defines the LogID to filter the log. Possible values 'All' (default), 'Verbose', 'Warning' and 'Error'.

    .PARAMETER Type
        Defines the Type of entry to filter the log.

    .PARAMETER JSONDepth
        Defines the object depth (only relevant for JSON logfiles). Only used in major PowerShell version >= 5.

    .EXAMPLE
        Get-LogisticLog -Path .\logistic_json.log
        LogID             : 6200096f-1311-45ba-a67c-22b8710152f2
        Timestamp         : 2021-08-02 09:49:33.007
        Callstack         : Runspace
        Data              : Teststring
        Type              : Verbose
        TimestampDatetime : 02.08.2021 09:49:33

    .EXAMPLE
        Get-LogisticLog -Path .\logistic_json.log -LogID '4c7cd194-7059-4f36-822d-3b4722b7cdc8'
        LogID             : 4c7cd194-7059-4f36-822d-3b4722b7cdc8
        Timestamp         : 2021-08-11 22:28:13.961
        Callstack         : Runspace
        Data              : Teststring
        Type              : Error
        TimestampDatetime : 11.08.2021 22:28:13

        Using -LogID to filter for '4c7cd194-7059-4f36-822d-3b4722b7cdc8'. Alternatively you can filter for -Type.

    .EXAMPLE
        Get-LogisticLog -Path .\logistic_sccm.log
        Timestamp         : 2021-08-02 09:49:45.330436
        Callstack         : Runspace
        Data              : Teststring
        Type              : Verbose
        TimestampDatetime : 02.08.2021 09:49:45

        Note that SCCM doesn't provide the LogID functionality.

    .INPUTS
        [string]

    .OUTPUTS
        [psobject]

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

        # Only use $JSONDepth when PSVersion >5
        if ($PSVersionTable.PSVersion.Major -gt 5) {
            $PSDefaultParameterValues = @{
                'ConvertFrom-Json:Depth' = $JSONDepth
            }
        }
    }

    process {
        $Content = @(Get-Content -Path $Path -Encoding utf8)

        $ContentType = switch -Regex ($Content[0]) {
            '^\{"' { 'JSON' }
            '^<!' { 'SCCM' }
            default { Write-Error -Message 'Cannot validate log format' -ErrorAction 'Stop' }
        }

        Write-Verbose -Message "Filtering output for LogID $LogID"
        Write-Verbose -Message "Filtering output for Type $Type"

        foreach ($Line in $Content) {
            switch ($ContentType) {
                'JSON' {
                    $Output = $Line |
                    ConvertFrom-Json |
                    # LogID filter only works for JSON objects
                    Where-Object -FilterScript { ($LogID -eq 'All') -or ($LogID -eq $_.LogID) } |
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
