# Automatic installation of custom packages for Windows
# Run from an elevated PowerShell prompt:
#   powershell -ExecutionPolicy Bypass -File .\setup\setup-windows.ps1

Write-Host "install chocolatey from the internet..."
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

Write-Host "install generic packages with chocolatey..."
choco install -y firefox paint.net vlc googlechrome 7zip
choco install -y pdfgear
choco install -y winscp
# choco install -y wireshark
choco install -y wget curl git openssh dbeaver kubernetes-cli
choco install -y oraclejdk maven
choco install -y nodejs
# choco install -y ngrok nmap
choco install -y sharex
# choco install -y soundswitch
choco install -y autohotkey
choco install -y eraser
choco install -y bruno
choco install -y docker-desktop
choco install -y uv
# choco install -y caffeine

Write-Host "install microsoft-specific packages with chocolatey..."
choco install -y vscode azure-cli dotnetcore-sdk powerbi visualstudio2022enterprise gh powershell-core dotnet-10.0-sdk
# choco install -y microsoftazurestorageexplorer sql-server-management-studio
choco install -y powertoys

Write-Host "install GitHub Copilot CLI..."
winget install --silent --accept-package-agreements --accept-source-agreements GitHub.Copilot

Write-Host "install kubelogin"
az aks install-cli
$targetDir = "$env:USERPROFILE\.azure-kubelogin"
$oldPath = [System.Environment]::GetEnvironmentVariable("Path", "User")
$oldPathArray = ($oldPath) -split ";"
if (-Not ($oldPathArray -Contains "$targetDir")) {
    Write-Host "Permanently adding $targetDir to User Path"
    $newPath = "$oldPath;$targetDir" -replace ";+", ";"
    [System.Environment]::SetEnvironmentVariable("Path", $newPath, "User")
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "User"), [System.Environment]::GetEnvironmentVariable("Path", "Machine") -join ";"
}

Write-Host "install Oh My Posh (the powerlevel10k equivalent for PowerShell)..."
choco install -y oh-my-posh

Write-Host "install a Nerd Font so prompt glyphs/icons render correctly..."
# refresh PATH so the freshly-installed oh-my-posh is callable in this session
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    oh-my-posh font install Meslo
}

Write-Host "install PowerShell modules (the oh-my-zsh plugin equivalents)..."
# PSReadLine: syntax highlighting + autosuggestions + history (zsh-syntax-highlighting / zsh-autosuggestions)
# posh-git: git completion (git plugin)        Terminal-Icons: ls icons
# PSFzf: fzf plugin                              DockerCompletion: docker plugin
# Az.Tools.Predictor: az completion
Install-Module -Name PSReadLine          -Scope CurrentUser -Force -AllowPrerelease -SkipPublisherCheck
foreach ($m in @('posh-git','Terminal-Icons','PSFzf','DockerCompletion','Az.Tools.Predictor')) {
    Write-Host "  installing module $m..."
    Install-Module -Name $m -Scope CurrentUser -Force -Repository PSGallery
}

Write-Host "install extra CLI tools used by the profile (zoxide=autojump, fnm=nvm, fzf, bat)..."
choco install -y zoxide fzf bat
winget install --silent --accept-package-agreements --accept-source-agreements Schniz.fnm

Write-Host "deploy PowerShell profile + Oh My Posh theme (mirrors setup-user.sh for zsh)..."
$repoRoot   = Split-Path -Parent $PSScriptRoot
$srcProfile = Join-Path $repoRoot "src\powershell\Microsoft.PowerShell_profile.ps1"
$srcTheme   = Join-Path $repoRoot "src\powershell\prompt.omp.json"

# resolve the *PowerShell 7* profile path (handles OneDrive-redirected Documents)
$profilePath = & pwsh -NoProfile -Command '$PROFILE' 2>$null
if (-not $profilePath) { $profilePath = "$HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1" }
$profileDir  = Split-Path -Parent $profilePath
New-Item -ItemType Directory -Force -Path $profileDir | Out-Null

# symlink the profile and theme (like setup-user.sh symlinks dotfiles); a `git
# pull` in the repo then instantly updates the live config on this machine.
New-Item -ItemType SymbolicLink -Path $profilePath        -Target $srcProfile -Force | Out-Null
New-Item -ItemType SymbolicLink -Path "$HOME\prompt.omp.json" -Target $srcTheme  -Force | Out-Null

# create the untracked machine-local override (only if missing), same pattern as
# ~/.zshrc.local. Loaded last by the profile so it can override anything above.
$localProfile = Join-Path $profileDir "Microsoft.PowerShell_profile.local.ps1"
if (-not (Test-Path $localProfile)) {
    "# local PowerShell overrides for $env:COMPUTERNAME (not tracked in the dotfiles repo)" |
        Out-File -FilePath $localProfile -Encoding utf8
}

Write-Host "install windows linux subsystem"
wsl --install
