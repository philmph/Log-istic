

Describe 'Module Tests' {
    $ModuleName = "Logistic"
    $TestRoot = $PSScriptRoot
    $ModuleRoot = Resolve-Path -Path "$TestRoot\..\src\$ModuleName"
    $Functions = Get-ChildItem "$ModuleRoot\functions" -Recurse -Filter *.ps1

    Context 'Module and manifest tests' {
        # Required in Pester v5 syntax
        $PSDefaultParameterValues = @{
            "It:TestCases" = @{
                ModuleName = $ModuleName
                ModuleRoot = $ModuleRoot
            }
        }

        It -Name '<ModuleName> has a .psm1 file' {
            "$ModuleRoot\$ModuleName.psm1" | Should -Exist
        }

        It -Name '<ModuleName> has a .psd1 file' {
            "$ModuleRoot\$ModuleName.psd1" | Should -Exist
        }

        It -Name "<ModuleName>.psd1 passes Test-ModuleManifest" {
            [bool](Test-ModuleManifest -Path "$ModuleRoot\$ModuleName.psd1") | Should -Be $true
        }
    }

    Context 'Function tests' {
        It -Name "<Name> passes PSScriptAnalyzer" -TestCases @(
            foreach ($Function in $Functions) {
                @{
                    Name = $Function.Name
                    FullName = $Function.FullName
                }
            }
        ) {
            @(Invoke-ScriptAnalyzer -Path $FullName) | Should -BeNullOrEmpty
        }
    }
}
