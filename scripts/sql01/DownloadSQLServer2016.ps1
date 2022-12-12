$IsoFilename = "SQLServer2016SP2-FullSlipstream-x64-ENU.iso"
$CacheLocation = "C:\Vagrant\Files\SQLServer"
$SetupFilesPath = "C:\SQLServer2016"
$LocalCache = "C:\SQLServer2016ISO"

# Check if a cached version already exists in the project files
if((Test-Path -Path "$($CacheLocation)\$($IsoFilename)")) {
    # Exists!
    # Copy locally, otherwise Mount-DiskImage won't work
    if(-not (Test-Path -Path $LocalCache)) {
        New-Item -Path $LocalCache -ItemType Directory | Out-Null
    }
    Copy-Item -Path "$($CacheLocation)\$($IsoFilename)" -Destination $LocalCache
    $IsoPath = "$($LocalCache)\$($IsoFilename)"
}else{
    $IsoPath = "$($env:temp)\$($IsoFilename)"

    # Download the downloader
    $ExeFile = "$($env:temp)\SQLDownloader.exe"
    
    Invoke-WebRequest -Uri "https://go.microsoft.com/fwlink/?linkid=799011&clcid=0x409&culture=en-us&country=us" -OutFile $ExeFile
    
    $ExeArguments = @(
        "/Action=Download"
        "/MediaPath=$($env:temp)"
        "/MediaType=ISO"
        "/Quiet"
    )
    
    Start-Process $ExeFile -ArgumentList $ExeArguments -Wait
}

# Extract the ISO contents
$IsoDrive = Mount-DiskImage -ImagePath $IsoPath -PassThru | Get-Volume
if(-not (Test-Path -Path $SetupFilesPath)) {
    New-Item -Path $SetupFilesPath -ItemType Directory | Out-Null
}
Copy-Item -Path "$($IsoDrive.DriveLetter):\*" -Destination $SetupFilesPath -Recurse

Dismount-DiskImage -ImagePath $IsoPath | Out-Null
Remove-Item -Path $IsoPath | Out-Null