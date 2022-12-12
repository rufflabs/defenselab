if(-not (Test-Path -Path "C:\SQLServer2016")) {
    New-Item -Path "C:\SQLServer2016" -ItemType Directory | Out-Null
}
$BakFile = "C:\SQLServer2016\AdventureWorks.bak"

Invoke-WebRequest -Uri "https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorksLT2016.bak" -OutFile $BakFile

$SqlArguments = @(
    "-Q"
    "RESTORE DATABASE AdventureWorks FROM DISK = '$($BakFile)'"
)

Start-Process "c:\Program Files\Microsoft SQL Server\Client SDK\ODBC\130\Tools\Binn\SQLCMD.EXE" -ArgumentList $SqlArguments -Wait