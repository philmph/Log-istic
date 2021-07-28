function GetLogentry {
    [CmdletBinding()]

    # Data is verified in public funtions
    param (
        [Parameter(Mandatory)]
        [string]$Format,

        [Parameter(Mandatory)]
        [psobject]$InputObject,

        [Parameter(Mandatory)]
        [string]$Type
    )

    $Timestamp = Get-Date

    # TODO: Should be moved to public functions since this will always be the calling function
    # TODO: -> Param
    if ($MyInvocation.PSCommandPath) {
        $CallOrigin = Split-Path -Path $MyInvocation.PSCommandPath -Leaf
    } else {
        $CallOrigin = $MyInvocation.CommandOrigin
    }

    switch ($Format) {
        'JSON' {
            $Output = [PSCustomObject] @{
                Timestamp  = $Timestamp.ToString('yyyy-MM-dd\ HH\:mm\:ss\.fff')
                CallOrigin = $CallOrigin
                Data       = $InputObject
                Type       = $Type
            } | ConvertTo-Json -Compress
        }

        'SCCM' {
            $TypeShort = switch ($Type) {
                'Verbose' { '1' }
                'Warning' { '2' }
                'Error' { '3' }
            }

            $Output = '<![LOG[{0}]LOG]!><time="{1:HH\:mm\:ss\.ffffff}" date="{1:MM-dd-yyyy}" component="{2}" context="" type="{3}" thread="" file="{2}">' -f
            $Message, $Timestamp, $File, $TypeShort
        }

        # We should never get here, since data is tested in public functions
        default { throw 'Format for logentry creation unknown' }
    }
    Write-Output -InputObject $Output
}
