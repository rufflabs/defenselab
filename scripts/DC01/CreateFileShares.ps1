<#
Creates sample file shares.
#>

$ShareCsv = "C:\Vagrant\Scripts\DC01\FileShares.csv"

if(-not (Test-Path -Path $ShareCsv)) {
    Write-Host "File Share CSV file not found!"
    exit
}

$Shares = ConvertFrom-Csv (Get-Content -Path $ShareCsv)

