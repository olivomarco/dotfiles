@echo off

title "Automatic installation of custom packages for Windows"

cls

echo install chocolatey from the internet...
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass ^
-Command " [System.Net.ServicePointManager]::SecurityProtocol = 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" ^
&& SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

rem echo install packages with chocolatey...
rem choco install -y cygwin cyg-get nmap virtualbox vagrant nodepadplusplus putty javaruntime caffeine

echo install generic packages with chocolatey...
choco install -y nodepadplusplus firefox paint.net vlc googlechrome adobereader 7zip
choco install -y winscp wireshark filezilla
choco install -y wget curl git openssh dbeaver kubernetes-cli
choco install -y dotnetcore-sdk dotnet-5.0-sdk
choco install -y oraclejdk maven
choco install -y nodejs
choco install -y ngrok
choco install -y screenpresso
choco install -y soundswitch
choco install -y autohotkey
choco install -y eraser
rem choco install -y caffeine

echo install microsoft-specific packages with chocolatey...
choco install -y sysinternals vscode microsoftazurestorageexplorer azure-cli sql-server-management-studio dotnetcore-sdk powerbi visualstudio2019enterprise gh
choco install -y zoomit

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
