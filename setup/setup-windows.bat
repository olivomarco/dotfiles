@echo off

title "Automatic installation of custom packages for Windows"

cls

echo install chocolatey from the internet...
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass ^
-Command " [System.Net.ServicePointManager]::SecurityProtocol = 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" ^
&& SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

echo install packages with chocolatey...
choco install -y cygwin cyg-get nmap wget curl virtualbox vagrant nodepadplusplus filezilla firefox ^
paint.net putty winscp git vlc googlechrome javaruntime wireshark adobereader 7zip sysinternals openssh ^
kubernetes-cli dbeaver greenshot eraser vscode caffeine bitwarden
