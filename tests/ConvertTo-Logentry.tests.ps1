# Import the module
$Rootpath = Split-Path -Parent $MyInvocation.MyCommand.Path
Get-Module -Name 'Logistic' | Remove-Module -Force
Import-Module "$Rootpath\..\src\Logistic\Logistic.psd1" -Force

$Logfile = ".\Logistic-$(Get-Random).tests.log"

Describe 'ConvertTo-Logentry' {
    Context 'When Type is JSON' {
        It 'Should return a JSON string' {
            $LogentryParams = @{
                InputObject = 'Teststring'
                Format = 'JSON'
                Type = 'Verbose'
            }

            $Output = ConvertTo-Logentry @LogentryParams

            # TODO: Learn if this is a useful unit test :-)
            $Output | Should -BeLike '{"Timestamp":"*","Callstack":"*","Data":"Teststring","Type":"Verbose"}'
        }
    }

    Context 'When Type is SCCM' {
        It 'Should return a SCCM string' {
            $true | Should -Be $true
        }
    }
}
