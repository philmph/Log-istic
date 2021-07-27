class Logistic {
    [string]$Path
    [string]$Fullpath
    [LogisticType]$Type
    [LogisticFormat]$Format

    hidden [System.IO.StreamWriter]$StreamWriter

    # Hidden init methods
    hidden Init ([string]$Path) {
        # Set Outfile as default when not specified
        $this.Init($Path, 'Outfile')
    }

    hidden Init ([string]$Path, [LogisticType]$Type) {
        # Set JSON as default when not specified
        $this.Init($Path, $Type, 'JSON')
    }

    hidden Init([string]$Path, [LogisticType]$Type, [LogisticFormat]$Format) {
        if (-not (Test-Path -Path $Path -PathType Container) -and (Test-Path -Path $Path -IsValid)) {
            if (-not (Test-Path -Path $Path -PathType Leaf)) {
                $null = New-Item -Path $Path -ItemType File -Force
            }
            $Fullname = (Get-Item -Path $Path).Fullname
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

    # Constructors (calling hidden init methods)
    Logistic ([string]$Path) {
        $this.Init($Path)
    }

    Logistic ([string]$Path, [LogisticType]$Type) {
        $this.Init($Path, $Type)
    }

    Logistic ([string]$Path, [LogisticType]$Type, [LogisticFormat]$Format) {
        $this.Init($Path, $Type, $Format)
    }

    # Class methods
    # InitializeStreamWriter is hidden because it will be done during instance of class initialization
    # Should not be needed for end user interaction
    hidden [void] InitializeStreamWriter () {
        if ($this.Type -eq [LogisticType]::StreamWriter) {
            try {
                $this.StreamWriter = [System.IO.StreamWriter]::new($this.Fullpath, [System.Text.Encoding]::UTF8)
            } catch {
                throw "Cannot initialize StreamWriter for $($this.Fullpath): $_"
            }
        } else {
            throw 'Logistic type is not StreamWriter; nothing to initialize'
        }
    }

    [void] CloseStreamWriter () {
        ($this.StreamWriter).Close()
    }
}
