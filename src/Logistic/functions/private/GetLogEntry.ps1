function GetLogentry {
    [CmdletBinding()]

    param (
        # Message, Type,
    )

    begin {
        Set-StrictMode -Version 3
    }

    process {
        $Date = Get-Date -Format 'yyyy-MM-dd\ HH\:mm\:ss\.fff'

        if ($MyInvocation.PSCommandPath) {
            $File = Split-Path -Path $MyInvocation.PSCommandPath -Leaf
        } else {
            $File = $MyInvocation.CommandOrigin
        }

        # TODO: Rework to split JSON / SCCM

        if ($JSONFormat) {
            $Data = [PSCustomObject] @{
                Date = (Get-Date )
                Type = $Type
                Data = $InputObject
            } | ConvertTo-Json -Compress
        }

        if ($SCCMFormat) {


            $Line = '<![LOG[{0}]LOG]!><time="{1:HH\:mm\:ss\.ffffff}" date="{1:MM-dd-yyyy}" component="{2}" context="" type="{3}" thread="" file="{2}">' -f `
            $Message, $Date, $File, $TypeShort
        }

        # TODO: Return String
    }

    end {}
}
