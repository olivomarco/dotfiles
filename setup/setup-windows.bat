@echo off

title "Automatic installation of custom packages for Windows"

cls

echo install chocolatey from the internet...
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

echo install packages with chocolatey...
rem choco install -y cygwin cyg-get putty
rem choco install -y virtualbox vagrant

echo install generic packages with chocolatey...
choco install -y firefox paint.net vlc googlechrome adobereader 7zip
choco install -y winscp filezilla
rem choco install -y wireshark
choco install -y wget curl git openssh dbeaver kubernetes-cli
choco install -y oraclejdk maven
choco install -y nodejs
rem choco install -y ngrok nmap
choco install -y screenpresso
rem choco install -y soundswitch
choco install -y autohotkey
choco install -y eraser
choco install -y bruno
choco install -y docker-desktop
choco install -y uv
rem choco install -y caffeine

echo install microsoft-specific packages with chocolatey...
choco install -y sysinternals vscode azure-cli dotnetcore-sdk powerbi visualstudio2022enterprise gh powershell-core dotnet-9.0-sdk
rem choco install -y microsoftazurestorageexplorer sql-server-management-studio
rem choco install -y zoomit
choco install -y powertoys

echo install kubelogin
az aks install-cli
$targetDir="$env:USERPROFILE\.azure-kubelogin"
$oldPath = [System.Environment]::GetEnvironmentVariable("Path","User")
$oldPathArray=($oldPath) -split ";"
if(-Not($oldPathArray -Contains "$targetDir")) {
    write-host "Permanently adding $targetDir to User Path"
    $newPath = "$oldPath;$targetDir" -replace ";+", ";"
    [System.Environment]::SetEnvironmentVariable("Path",$newPath,"User")
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","User"),[System.Environment]::GetEnvironmentVariable("Path","Machine") -join ";"
}

echo install windows linux subsystem
wsl --install
