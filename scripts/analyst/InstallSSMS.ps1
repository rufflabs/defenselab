# cmd.exe /c start \"\" /w C:\\Vagrant\\Programs\\SSMS\\SSMS-Setup-ENU.exe /Quiet SSMSInstallRoot=\"C:\\Program Files (x86)\\Microsoft SQL Server Management Studio 18\""

$CacheLocation = "C:\Vagrant\Files\SSMS\"
$ExeFilename = "SSMS-Setup-ENU.exe"

if(Test-Path -Path "$($CacheLocation)\$($ExeFilename)") {
    $SsmsExe = "$($CacheLocation)\$($ExeFilename)"
}else{
    # Download

    if(-not (Test-Path -Path $CacheLocation)) {
        New-Item -Path $CacheLocation -ItemType Directory -Force | Out-Null
    }
    Invoke-WebRequest -Uri "https://aka.ms/ssmsfullsetup" -OutFile "$($CacheLocation)\$($ExeFilename)"
    $SsmsExe = "$($CacheLocation)\$($ExeFilename)"
}

$ExeArguments = @(
    "/Quiet"
    'SSMSInstallRoot="C:\Program Files (x86)\Microsoft SQL Server Management Studio 18"'
)

Start-Process $SsmsExe -ArgumentList $ExeArguments -Wait