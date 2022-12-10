$MsiFile = "$($env:temp)\Jenkins.msi"
Invoke-WebRequest -Uri "https://get.jenkins.io/windows-stable/2.375.1/jenkins.msi" -OutFile $MsiFile

$MsiArguments = @(
    "/i"
    $MsiFile
    "INSTALLDIR=C:\Jenkins"
    "/qn"
    "/norestart"
)

Start-Process "msiexec.exe" -ArgumentList $MsiArguments -Wait -NoNewWindow
[Environment]::SetEnvironmentVariable('JENKINS_HOME',"C:\Jenkins", 'Machine')

Set-Content -Path "$($env:JENKINS_HOME)\jenkins.install.InstallUtil.lastExecVersion" -Value "2.0"
(Get-Content -Path "C:\Jenkins\jenkins.xml").Replace('8080', '9090') | Set-Content -Path "C:\Jenkins\jenkins.xml"

# Add firewall rule to allow access
New-NetFirewallRule -Name "Jenkins" -DisplayName "Jenkins" -Direction Inbound -LocalPort 9090 -Protocol TCP -Action Allow -Profile Domain | Out-Null

Set-Service -Name Jenkins -StartupType Automatic
Restart-Service -Name Jenkins