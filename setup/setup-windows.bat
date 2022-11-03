@echo off

title "Automatic installation of custom packages for Windows"

cls

echo install chocolatey from the internet...
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass ^
-Command " [System.Net.ServicePointManager]::SecurityProtocol = 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" ^
&& SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

rem echo install packages with chocolatey...
rem choco install -y cygwin cyg-get nmap wget curl virtualbox vagrant nodepadplusplus filezilla firefox ^
rem paint.net putty winscp git vlc googlechrome javaruntime wireshark adobereader 7zip sysinternals openssh ^
rem kubernetes-cli dbeaver greenshot eraser vscode caffeine

echo install generic packages with chocolatey...
choco install -y nodepadplusplus firefox paint.net vlc googlechrome adobereader 7zip
choco install -y winscp wireshark filezilla
choco install -y wget curl git openssh dbeaver kubernetes-cli
choco install -y dotnetcore-sdk dotnet-5.0-sdk
choco install -y oraclejdk maven
choco install -y nodejs
choco install -y ngrok
choco install -y screenpresso
rem choco install -y eraser caffeine soundswitch

echo install microsoft-specific packages with chocolatey...
choco install -y sysinternals vscode microsoftazurestorageexplorer azure-cli sql-server-management-studio dotnetcore-sdk powerbi visualstudio2019enterprise gh
choco install -y zoomit

echo install windows linux subsystem
wsl --install
