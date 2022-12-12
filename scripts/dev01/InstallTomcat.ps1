$ExeFile = "$($env:temp)\tomcat.exe"

Invoke-WebRequest -Uri "https://dlcdn.apache.org/tomcat/tomcat-10/v10.0.27/bin/apache-tomcat-10.0.27.exe" -OutFile $ExeFile

$ExeArguments = @(
    "/S"
    "/D=C:\Tomcat"
)

Start-Process $ExeFile -ArgumentList $ExeArguments -Wait

Set-Service -Name Tomcat10 -StartupType Automatic

New-NetFirewallRule -Name "Tomcat" -DisplayName "Tomcat" -Direction Inbound -LocalPort 8080 -Protocol TCP -Action Allow -Profile Domain | Out-Null

# Update context.xml to allow remote access of the manager endpoint
$ContextXml = "C:\Tomcat\webapps\manager\META-INF\context.xml"
Set-Content -Path $ContextXml -Value (Get-Content -Path $ContextXml).Replace('127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1', '127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1|172\.25\.30\.\d+') -Force

# Add user
$UsersXml = "C:\Tomcat\conf\tomcat-users.xml"
Set-Content -Path $UsersXml -Value (Get-Content -Path $UsersXml).Replace('</tomcat-users>', '<user username="admin" password="admin" roles="manager-gui"/></tomcat-users>') -Force

Start-Service -Name Tomcat10