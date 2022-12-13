Configuration SQLInstall
{
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]
        $Credential
    )
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName SqlServerDsc

    node localhost
    {
        WindowsFeature 'NetFramework45'
        {
            Name   = 'NET-Framework-45-Core'
            Ensure = 'Present'
        }

        SqlSetup 'InstallDefaultInstance'
        {
            InstanceName        = 'MSSQLSERVER'
            Features            = 'SQLENGINE'
            SourcePath          = 'C:\SQLServer2016' # Set to ISO file location
            SQLSysAdminAccounts = @('Administrators')
            DependsOn           = '[WindowsFeature]NetFramework45'
            SecurityMode        = 'SQL'
            SAPwd               = $Credential
        }
    }


}

$ConfigurationData = @{
    AllNodes = @(
        @{
            NodeName = 'localhost'
            PSDscAllowPlainTextPassword = $true
         }
    )
}

$Password = ConvertTo-SecureString -String "Password123!" -AsPlainText -Force
$Credentials = New-Object -TypeName System.Management.Automation.PSCredential('sa', $Password)

Write-Host "Compiling SQLInstall..."
SQLInstall -Credential $Credentials -ConfigurationData $ConfigurationData | Out-Null

Write-Host "Applying DSC Configuration..."
Start-DscConfiguration -Path .\SQLInstall -Wait -Force
