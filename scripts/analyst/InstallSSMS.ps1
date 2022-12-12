# cmd.exe /c start \"\" /w C:\\Vagrant\\Programs\\SSMS\\SSMS-Setup-ENU.exe /Quiet SSMSInstallRoot=\"C:\\Program Files (x86)\\Microsoft SQL Server Management Studio 18\""

$CacheLocation = "C:\Vagrant\Files\SSMS\SSMS-Setup-ENU.exe"

if(Test-Path -Path $CacheLocation) {
    $SsmsExe = $CacheLocation
}else{
    # TODO: Download SSMS and silently download.
    $SsmsExe = $null
}

$ExeArguments = @(
    "/Quiet"
    'SSMSInstallRoot="C:\Program Files (x86)\Microsoft SQL Server Management Studio 18"'
)

Start-Process $SsmsExe -ArgumentList $ExeArguments -Wait