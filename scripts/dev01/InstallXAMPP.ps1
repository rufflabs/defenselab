# Download the XAMPP installer
$ExeFile = "$($env:temp)\xampp-installer.exe"
Invoke-WebRequest -Uri "https://gigenet.dl.sourceforge.net/project/xampp/XAMPP%20Windows/7.4.33/xampp-windows-x64-7.4.33-0-VC15-installer.exe" -OutFile $ExeFile

# Install XAMPP silently
Start-Process -FilePath $ExeFile -ArgumentList "--mode unattended" -Wait

# Start the Apache and Tomcat services
Start-Service -Name "Apache"
Start-Service -Name "Tomcat"

# Enable the Apache and Tomcat services to start automatically
Set-Service -Name "Apache" -StartupType Automatic
Set-Service -Name "Tomcat" -StartupType Automatic
