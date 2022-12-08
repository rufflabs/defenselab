Configuration ADDomain_NewForest_Config
{
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]
        $SafeModePassword
    )

    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName ActiveDirectoryDsc

    node 'localhost'
    {
        WindowsFeature 'ADDS'
        {
            Name   = 'AD-Domain-Services'
            Ensure = 'Present'
        }

        WindowsFeature 'RSAT'
        {
            Name   = 'RSAT-AD-PowerShell'
            Ensure = 'Present'
        }

        ADDomain 'defense.local'
        {
            DomainName                    = 'defense.local'
            Credential                    = $Credential
            SafemodeAdministratorPassword = $SafeModePassword
            ForestMode                    = 'WinThreshold'
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

$Password = ConvertTo-SecureString -String "Defense0!" -AsPlainText -Force
$Credentials = New-Object -TypeName System.Management.Automation.PSCredential('vagrant', $Password)

Write-Host "Compiling ADDomain_NewForest_Config..."
ADDomain_NewForest_Config -Credential $Credentials -SafeModePassword $Credentials -ConfigurationData $ConfigurationData | Out-Null

Write-Host "Applying DSC Configuration..."
Start-DscConfiguration -Path .\ADDomain_NewForest_Config -Force -Wait