Import-Module "$PSScriptRoot\..\src\Logistic.psd1" -Force
$Logfile = "$env:TEMP\Logistic-$(Get-Random).tests.log"

Describe {
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

        Remove-Item -Path $Logfile
    }
}
