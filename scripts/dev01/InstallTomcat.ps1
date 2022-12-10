$ExeFile = "$($env:temp)\tomcat.exe"

Invoke-WebRequest -Uri "https://dlcdn.apache.org/tomcat/tomcat-10/v10.0.27/bin/apache-tomcat-10.0.27.exe" -OutFile $ExeFile

$ExeArguments = @(
    "/S"
    "/D=C:\Tomcat"
)

Start-Process $ExeFile -ArgumentList $ExeArguments -Wait

Set-Service -Name Tomcat10 -StartupType Automatic

New-NetFirewallRule -Name "Tomcat" -DisplayName "Tomcat" -Direction Inbound -LocalPort 8080 -Protocol TCP -Action Allow -Profile Domain | Out-Null

Copy-Item -Path "C:\Vagrant\Scripts\DEV01\tomcat-users.xml" -Destination "C:\Tomcat\conf\" -Force

Start-Service -Name Tomcat10