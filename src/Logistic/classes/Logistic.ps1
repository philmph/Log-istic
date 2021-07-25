class Logistic
{
    [LogisticType]$Type
    [LogisticFormat]$Format
    [string]$Path
    hidden [System.IO.StreamWriter]$StreamWriter

    # Constructor with overloads
    Logistic ([LogisticType]$Type, [LogisticFormat]$Format, [string]$Path) {
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
