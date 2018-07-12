enum PackageManager {
    scoop
    chocolatey
}

function checkAndInstall([PackageManager]$type) {
    if (!(Get-Command $type -ErrorAction SilentlyContinue)) {
        Write-Host "$type was not detected on the system... installing $type now." -ForegroundColor DarkYellow
        if ((install($type)) -eq 0) {
            Write-Host "Successfully installed $type." -ForegroundColor Green
        } else {
            Write-Host "Failed to install $type! Aborting..." -ForegroundColor Red
        }
    } else {
        Write-Host "$type already exists, skipping its installation." -ForegroundColor DarkGray
    }
}

function install([PackageManager]$type) {
    switch ([PackageManager]$type) {
        "scoop" {
            $p = Start-Process powershell.exe "-NoProfile -WindowStyle Hidden -ExecutionPolicy RemoteSigned -File `"$(Get-Location)\package\scoop.ps1`"" -Verb RunAs -PassThru
            $p.WaitForExit()
            return $p.ExitCode
        }
        "chocolatey" {
            $p = Start-Process powershell.exe "-NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$(Get-Location)\package\chocolatey.ps1`"" -Verb RunAs -PassThru
            $p.WaitForExit()
            return $p.ExitCode
        }
        Default {
            Write-Error "ERROR: Received an invalid request to install an unknown package manager."
        }
    }
}

# Check for scoop and chocolatey installs
Write-Host "Checking installs for scoop and chocolatey..."
checkAndInstall([PackageManager]::scoop)
checkAndInstall([PackageManager]::chocolatey)

Write-Host "Adding scoop-extra bucket"
scoop bucket add extras

# Install scoop tools
Write-Host "Installing scoop tools:"
scoop install concfg
scoop install fd
scoop install ripgrep
scoop install curl
scoop install which
scoop install neovim
scoop install micro
scoop install ffmpeg
scoop install youtube-dl
scoop install nvm
scoop install ln
scoop install jq
scoop install shasum
scoop install time
scoop install touch
scoop install less
scoop install yarn
scoop install handbrake-cli
scoop install rclone
scoop install python
scoop install jetbrains-toolbox
scoop install 7zip
scoop install tar
scoop install bzip2
scoop install gzip
scoop install unrar
scoop install unzip

# Install scoop-extra tools
scoop install vscode
scoop install android-sdk
scoop install keepassxc
scoop install keypirinha
scoop install qbittorent
scoop install coretemp
scoop install rainmeter
scoop install inkscape
scoop install handbrake
scoop install obs-studio
scoop install meld
scoop install etcher
scoop install taiga
scoop install youtube-dl-gui
scoop install calibre
scoop install sharex
scoop install audacity

Write-Host "Done!" -ForegroundColor Green

# TODO: add chocolatey install commands

# Wait for user-input to exit
Read-Host "Press ENTER to exit. "
exit
