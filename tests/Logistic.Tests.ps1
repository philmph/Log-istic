Describe 'Module Tests' {
    $ModuleName = 'Logistic'
    $TestRoot = $PSScriptRoot
    $ModuleRoot = Resolve-Path -Path "$TestRoot\..\src\$ModuleName"

    Context 'Module and manifest tests' {
        $PSDefaultParameterValues = @{
            'It:TestCases' = @{
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

        It -Name '<ModuleName>.psd1 passes Test-ModuleManifest' {
            $Result = [bool](Test-ModuleManifest -Path "$ModuleRoot\$ModuleName.psd1")

            $Result | Should -Be $true
        }
    }

    Context 'Function tests' {
        # Gather functions
        $Functions = Get-ChildItem "$ModuleRoot\functions" -Recurse -Filter *.ps1

        # Get PSScriptAnalyzerRules
        $PSScriptAnalyzerSettings = Resolve-Path -Path "$TestRoot\PSScriptAnalyzerSettings.ps1"
        $Rules = (. $PSScriptAnalyzerSettings)['IncludeRules']

        # Generate TestCases
        $TestCasesPSScriptAnalyzer = @(
            foreach ($Function in $Functions) {
                $Result = @(Invoke-ScriptAnalyzer -Path $Function.FullName -Settings $PSScriptAnalyzerSettings)

                foreach ($Rule in $Rules) {
                    @{
                        Name   = $Function.Name
                        Result = $Result
                        Rule   = $Rule
                    }
                }
            }
        )

        It -Name '<Name> passes rule <Rule>' -TestCases $TestCasesPSScriptAnalyzer {
            $Result |
            Where-Object { $_.RuleName -eq $Rule } |
            Select-Object -ExpandProperty Message |
            Should -BeNullOrEmpty
        }

        $TestCasesFunctionNaming = @(
            foreach ($Function in $Functions) {
                switch -regex ($Function.FullName) {
                    '\\Private\\' {
                        $Type = 'Private'
                        $Pattern = '^\s*[Ff]unction\s+(([A-Z]{1,4}[a-z]+){1,2}([A-Z]{1,4}[a-z\d]+)+)(\s+\{)?$'
                    }

                    '\\Public\\' {
                        $Type = 'Public'
                        $Pattern = '^\s*[Ff]unction\s+(([A-Z]{1,4}[a-z]+){1,2}\-([A-Z]{1,4}[a-z\d]+)+)(\s+\{)?$'
                    }
                }

                @{
                    BaseName = $Function.BaseName
                    FullName = $Function.FullName
                    Name     = $Function.Name
                    Type     = $Type
                    Pattern  = $Pattern
                }
            }
        )

        $PSDefaultParameterValues = @{
            'It:TestCases' = $TestCasesFunctionNaming
        }

        It -Name '<Name> contains one function' {
            $Result = @(Select-String -Path $FullName -Pattern '^\s*Function\s+')

            $Result.Count | Should -Be 1
        }

        It -Name '<Name> should fit naming standards for <type> functions' {
            $Result = @(Select-String -Path $FullName -Pattern $Pattern -CaseSensitive)

            $Result.Count | Should -Be 1
        }

        It -Name '<Name> should match ps1 file name' {
            $FunctionMatches = @(Select-String -Path $FullName -Pattern $Pattern -CaseSensitive)
            $Result = $false

            if ($FunctionMatches.Count -gt 0) {
                if ($FunctionMatches.Matches[0].Groups[1].Value -ceq $BaseName) {
                    $Result = $true
                }
            }

            $Result | Should -Be $true
        }
    }
}
