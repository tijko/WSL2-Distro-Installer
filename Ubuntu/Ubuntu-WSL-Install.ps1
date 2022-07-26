# 
# Installing WSL2 Distribution without Windows Store Access
#
Write-Host "Installing WSL2 Linux Distribution (default Ubuntu)"
# Set current working directory to TEMP
Write-Host "Setting working directory to $TEMP"
cd $env:TEMP

# Set the download progress to not display
$ProgressPreference = "SilentlyContinue"

# Install 7z
if (!(Get-Command 7z)) {
Write-Host "Installing 7-Zip...."
$dlurl = 'https://7-zip.org/' + (Invoke-WebRequest -UseBasicParsing -Uri 'https://7-zip.org/' | Select-Object -ExpandProperty Links | Where-Object {($_.outerHTML -match 'Download')-and ($_.href -like "a/*") -and ($_.href -like "*-x64.exe")} | Select-Object -First 1 | Select-Object -ExpandProperty href)
# modified to work without IE
# above code from: https://perplexity.nl/windows-powershell/installing-or-updating-7-zip-using-powershell/
$installerPath = Join-Path $env:TEMP (Split-Path $dlurl -Leaf)
Invoke-WebRequest $dlurl -OutFile $installerPath
Start-Process -FilePath $installerPath -Args "/S" -Verb RunAs -Wait
Remove-Item $installerPath }

# If full ISO is needed hit this URL
#http://ftp5.gwdg.de/pub/linux/oracle/OL7/u8/x86_64/OracleLinux-R7-U8-Server-x86_64-dvd.iso

# XXX Get hostname of system being deployed to
$hname = [System.Net.Dns]::GetHostName() | Out-File -FilePath .\hostname; 

# Create WSL ubuntu install directory
if ((Test-Path "C:\wsl-ubuntu-test")) {
rm c:\wsl-ubuntu-test
} 
mkdir c:\wsl-ubuntu-test

# Download Ubuntu rootfs archive
Write-Host "Downloading Ubuntu rootfs...."
Invoke-WebRequest https://github.com/EXALAB/Anlinux-Resources/blob/master/Rootfs/Ubuntu/amd64/ubuntu-rootfs-amd64.tar.xz?raw=true -OutFile ubuntu.tar.xz

# Decompress .xz archive
7z x ubuntu.tar.xz

# Install WSL Ubuntu
Write-Host "Installing WSL2 Ubuntu distribution..."
wsl --import Ubuntu-Test C:\wsl-ubuntu-test ubuntu.tar 

# Set hostname of new distribution
Write-Host "Setting hostname of distribution"
#mv hostname C:\wsl-ubuntu\rootfs\etc\

Write-Host "Cleaning up...."
rm ubuntu.*

Write-Host "Finished!"

