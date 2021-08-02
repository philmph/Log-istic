$ModuleName = "Logistic"
$TestRoot = Split-Path -Path $MyInvocation.MyCommand.Path -Parent
$ModuleRoot = Resolve-Path -Path "$TestRoot\..\src\$ModuleName"

Describe 'Module Tests' {
    Context "Testing module $ModuleName" {
        It 'has a .psm1 file' {
            "$ModuleRoot\$ModuleName.psm1" | Should -Exist
        }

        It 'has a .psd1 file' {
            "$ModuleRoot\$ModuleName.psd1" | Should -Exist
        }

        It "passes Test-ModuleManifest against manifest" {
            [bool](Test-ModuleManifest -Path "$ModuleRoot\$ModuleName.psd1") | Should -Be $true
        }
    }

    Context 'Function tests' {
        It "<Name> should pass PSScriptAnalyzer" -TestCases @(
            foreach ($Function in (Get-ChildItem "$ModuleRoot\Functions" -Recurse -Filter *.ps1)) {
                @{
                    Name = $Function.Name
                    FullName = $Function.FullName
                }
            }
        ) {
            param(
                $Name, $FullName
            )

            @(Invoke-ScriptAnalyzer -Path $FullName) | Should -BeNullOrEmpty
        }
    }
}
