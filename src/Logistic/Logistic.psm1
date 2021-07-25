<#
################################################################################
Author:				Philipp Maier
Author Git:			https://github.com/philmph
Repository:			https://github.com/philmph/Frame

Notes & Usage:
-- Functions
- Create one .ps1 file per function and name it after the function within.
- Sort internal functions into ./functions/private and public functions
- into ./functions/public.

-- Classes & Enums
- Create one .ps1 file per class / enum and name it after the class / enum within.
- Sort classes into ./classes and enums into ./enums.
- Add the .ps1 file to the module .psd1 at # ScriptsToProcess @().

Automatically generated module wrapper by Frame_Project.
################################################################################
#>

$Functions = @(Get-ChildItem -Path "$PSScriptRoot\functions" -Filter "*.ps1" -Recurse)
$PublicFunctions = $Functions | Where-Object { $_.FullName -match "\\functions\\public\\" }

foreach ($Function in $Functions) {
    try {
        . $Function.FullName
    }
    catch {
        Write-Error -ErrorRecord $_ -ErrorAction Stop
    }
}

Export-ModuleMember -Function $PublicFunctions.BaseName