# Download
$MsiFile = "$($env:temp)\corretto.msi"
Invoke-WebRequest -Uri "https://corretto.aws/downloads/latest/amazon-corretto-11-x64-windows-jdk.msi" -OutFile $MsiFile

$MsiArguments = @(
    "/i"
    $MsiFile
    "/qn"
    "/norestart"
)

Start-Process "msiexec.exe" -ArgumentList $MsiArguments -Wait -NoNewWindow

# Set JAVA_HOME variable
# Find install
$Version = (Get-ChildItem -Path "C:\Program Files\Amazon Corretto").Name

$env:JAVA_HOME = "C:\Program Files\Amazon Corretto\$($Version)"
[Environment]::SetEnvironmentVariable("JAVA_HOME", $env:JAVA_HOME, "Machine")

# Add to path
[Environment]::SetEnvironmentVariable("PATH", "$($env:PATH);$($env:JAVA_HOME)\bin", "Machine")