function ConvertTo-Logentry {
    [CmdletBinding()]

    param (

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
    }

    end {}
}
