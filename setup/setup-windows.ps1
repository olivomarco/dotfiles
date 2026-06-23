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

Write-Host "install windows linux subsystem"
wsl --install
