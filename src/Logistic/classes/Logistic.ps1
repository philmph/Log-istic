class Logistic {
    [string]$Path
    hidden [string]$Fullpath
    [LogisticType]$Type
    [LogisticFormat]$Format

    hidden [System.IO.StreamWriter]$StreamWriter

    # Hidden init methods for constructor use
    hidden Init ([string]$Path) {
        # Set Outfile as default
        $this.Init($Path, 'Outfile', 'JSON')
    }

    hidden Init([string]$Path, [LogisticType]$Type, [LogisticFormat]$Format) {
        if (-not (Test-Path -Path $Path -PathType Container) -and (Test-Path -Path $Path -IsValid)) {
            if (Test-Path -Path $Path -PathType Leaf) {
                $Fullname = (Get-Item -Path $Path).Fullname
            } else {
                $Fullname = (New-Item -Path $Path -ItemType File -Force).Fullname
            }
        } else {
            throw "$Path is not valid"
        }

        $this.Path     = $Path
        $this.Fullpath = $Fullname
        $this.Type     = $Type
        $this.Format   = $Format

        if ($Type -eq [LogisticType]::StreamWriter) {
            $this.InitializeStreamWriter()
        }
    }

    # Constructor with overloads
    Logistic ([string]$Path) {
        $this.Init($Path)
    }

    # Constructor with overloads
    Logistic ([string]$Path, [LogisticType]$Type, [LogisticFormat]$Format) {
        $this.Init($Path, $Type, $Format)
    }

    [void] InitializeStreamWriter () {
        try {
            $this.StreamWriter = [System.IO.StreamWriter]::new($this.Fullpath, [System.Text.Encoding]::UTF8)
        } catch {
            throw "Cannot initialize StreamWriter for $($this.Fullpath): $_"
        }
    }

    [void] CloseStreamWriter () {
        ($this.StreamWriter).Close()
    }
}
