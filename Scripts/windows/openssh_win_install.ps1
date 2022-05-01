#######
#
# OpenSSh Server for Windows
# Version 1
# By sebastienc
########
# First step launch in powershell
# Set-Executionpolicy bypass ExecutionPolicy Unrestricted -Force
# Download openssh zip file

$source = 'https://github.com/PowerShell/Win32-OpenSSH/releases/download/V8.6.0.0p1-Beta/OpenSSH-Win64.zip'
$destination_zip = $env:TEMP + "\OpenSSH.zip"

Invoke-WebRequest -Uri $source -OutFile $destination_zip

# Unzip file

Expand-Archive -LiteralPath $destination_zip -DestinationPath "C:\Program Files\"

# install

Set-Location -Path "C:\Program Files\OpenSSH-Win64"
powershell.exe -ExecutionPolicy Bypass -File install-sshd.ps1

# Open Firewall
#netsh advfirewall firewall add rule name=sshd dir=in action=allow protocol=TCP localport=22
New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22

# Start and Autostart
net start sshd
start-Sleep -s 5
Set-Service sshd -StartupType Automatic

# configure default shell
start-Sleep -s 5
New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -PropertyType String -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShellCommandOption -Value "/c" -PropertyType String -Force
