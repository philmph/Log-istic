class Logistic
{
    [LogisticType]$Type
    [LogisticFormat]$Format
    [string]$Path

    hidden [string]$Fullname
    hidden [System.IO.StreamWriter]$StreamWriter

    # Hidden init methods for constructor use
    hidden Init ([string]$Path) {
        # Set Outfile as default
        $this.Init('Outfile', $Path)
    }

    hidden Init ([LogisticType]$Type, [string]$Path) {
        # TODO: Logic snippet for when SQL or WindowsEventlog is added
        # if ($Type -in @([LogisticType]::Outfile, [LogisticType]::StreamWriter)) {}

        # Set JSON as default
        $this.Init($Type, 'JSON', $Path)
    }

    hidden Init([LogisticType]$Type, [LogisticFormat]$Format, [string]$Path) {
        if ((Test-Path -Path $Path -PathType 'Container') -or (-not (Test-Path -Path $Path -IsValid))) {
            throw "$Path is not valid"
        }

        # TODO: Evaluate Upper or Lower

        if (-not (Test-Path -Path $Path -PathType Leaf)) {
            $Fullname = (New-Item -Path $Path -ItemType File -Force).Fullname
        } elseif ((-not (Test-Path -Path $Path -PathType Container)) -and (Test-Path -Path $Path -IsValid)) {
            $Fullname = (Get-Item -Path $Path).Fullname
        } else {
            throw "$Path is not valid"
        }

        $this.Type = $Type
        $this.Format = $Format
        $this.Path = $Path
    }

    # Constructor with overloads
    Logistic ([string]$Path) {
        $this.Init($Path)
    }

    Logistic ([LogisticType]$Type, [string]$Path) {
        $this.Init($Type, $Path)
    }

    # Constructor with overloads
    Logistic ([LogisticType]$Type, [LogisticFormat]$Format, [string]$Path) {
        $this.Init($Type, $Format, $Path)
    }

    [System.IO.StreamWriter] InitializeStreamWriter () {
        # TODO: Required here?

        if (-not (Test-Path -Path $this.Path -PathType Leaf)) {
            $Fullname = (New-Item -Path $this.Path -ItemType File -Force).Fullname
        } elseif ((-not (Test-Path -Path $this.Path -PathType Container)) -and (Test-Path -Path $this.Path -IsValid)) {
            $Fullname = (Get-Item -Path $this.Path).Fullname
        } else {
            throw "Cannot initialize StreamWriter for $($Fullname)"
        }

        try {
            $this.StreamWriter = [System.IO.StreamWriter]::new($Fullname, [System.Text.Encoding]::UTF8)
        } catch {
            throw "Cannot initialize StreamWriter for $($Fullname): $_"
            return $null
        }
        return $this.StreamWriter
    }

    [void] CloseStreamWriter () {
        ($this.StreamWriter).Close()
    }
}
