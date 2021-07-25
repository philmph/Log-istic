class Logistic
{
    [LogisticType]$Type
    [LogisticFormat]$Format
    [string]$Path

    # Constructor with overloads
    Logistic ([LogisticType]$Type, [LogisticFormat]$Format, [string]$Path) {
        <#
        # ! Needs rework
        # Initialize StreamWriter if neccessary
        if ($this.Type -eq [LogisticType]::StreamWriter) {
            if (Test-Path -Path $this.Path -PathType Leaf) {
                $Fullname = (Get-Item -Path $Path).FullName
            } elseif ((-not (Test-Path -Path $this.Path -PathType Container)) -and (Test-Path -Path $this.Path -IsValid)) {
                $Fullname = (New-Item -Path $Path -ItemType File -Force).Fullname
            } else {
                throw "Cannot initialize StreamWriter for $Path"
            }

            try {
                $this.StreamWriter = [System.IO.StreamWriter]::new($FullName, [System.Text.Encoding]::UTF8)
            } catch {
                throw "Cannot initialize StreamWriter for $Path"
            }
        }
        #>

        $this.Type = $Type
        $this.Format = $Format
        $this.Path = $Path
    }

    [System.IO.StreamWriter] InitializeStreamWriter () {
        if (-not (Test-Path -Path $this.Path -PathType Leaf)) {
            $Fullname = (New-Item -Path $this.Path -ItemType File -Force).Fullname
        } elseif ((-not (Test-Path -Path $this.Path -PathType Container)) -and (Test-Path -Path $this.Path -IsValid)) {
            $Fullname = (Get-Item -Path $this.Path).Fullname
        } else {
            throw "Cannot initialize StreamWriter for $($this.Path)"
        }

        $this.StreamWriter = [System.IO.StreamWriter]::new($Fullname, [System.Text.Encoding]::UTF8)
        return $this.StreamWriter
    }

    [void] CloseStreamWriter () {
        ($this.StreamWriter).Close()
    }
}
