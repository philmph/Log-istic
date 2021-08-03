Describe 'Module Tests' {
    $ModuleName = "Logistic"
    $TestRoot = $PSScriptRoot
    $ModuleRoot = Resolve-Path -Path "$TestRoot\..\src\$ModuleName"

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
        # Gather functions
        $Functions = Get-ChildItem "$ModuleRoot\functions" -Recurse -Filter *.ps1

        # Get PSScriptAnalyzerRules
        $PSScriptAnalyzerSettings = Resolve-Path -Path "$TestRoot\PSScriptAnalyzerSettings.ps1"
        $Rules = (. $PSScriptAnalyzerSettings)["IncludeRules"]

        # Generate TestCases
        $TestCases = @(
            foreach ($Function in $Functions) {
                $Result = @(Invoke-ScriptAnalyzer -Path $Function.FullName -Settings $PSScriptAnalyzerSettings)

                foreach ($Rule in $Rules) {
                    @{
                        Rule = $Rule
                        Name = $Function.Name
                        Result = $Result
                    }
                }
            }
        )

        It -Name "<Name> passes rule <Rule>" -TestCases $TestCases {
            $Result |
            Where-Object { $Rule -eq $_.RuleName } |
            Select-Object -ExpandProperty Message |
            Should -BeNullOrEmpty
        }
    }
}
