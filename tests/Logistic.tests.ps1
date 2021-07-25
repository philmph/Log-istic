$Rootpath = Split-Path -Parent $MyInvocation.MyCommand.Path
$Logfile = "$env:TEMP\Logistic-$(Get-Random).tests.log"

Get-Module -Name 'Logistic' | Remove-Module -Force
Import-Module "$Rootpath\..\src\Logistic\Logistic.psd1" -Force

Describe 'Test' {
    Context 'Initialize Logistic class' {
        It 'Should initialize a logfile with default parameters' {
            $obj = [Logistic]::new($Logfile)

            $obj | Should -BeOfType [Logistic]
        }

        It 'Should initialize a logfile with StreamWriter constructor' {
            $obj = [Logistic]::new($Logfile, 'StreamWriter', 'JSON')

            $obj | Should -BeOfType [Logistic]
            $obj.StreamWriter | Should -BeOfType [System.IO.StreamWriter]
        }

        It 'Shouled close the StreamWriter' {
            $obj.CloseSteamWriter()
        }
    }
}

Remove-Item -Path $Logfile
