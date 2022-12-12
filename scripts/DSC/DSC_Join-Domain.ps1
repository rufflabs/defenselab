Configuration JoinDomainConfiguration
{
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullorEmpty()]
        [System.Management.Automation.PSCredential]
        $Credential
    )
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -Module ComputerManagementDsc
    Node 'localhost'
    {
        Computer JoinDomain
        {
            Name       = $env:COMPUTERNAME
            DomainName = 'DEFENSE'
            Credential = $Credential
        }
    }
}

$ConfigurationData = @{
    AllNodes = @(
        @{
            NodeName = 'localhost'
            PSDscAllowPlainTextPassword = $true
            PSDscAllowDomainUser = $true
         }
    )
}

$Password = ConvertTo-SecureString "vagrant" -AsPlainText -Force
$Credentials = New-Object System.Management.Automation.PSCredential('defense\vagrant',$Password)

Write-Host "Compiling JoinDomainConfiguration..."
JoinDomainConfiguration -Credential $Credentials -ConfigurationData $ConfigurationData | Out-Null

Write-Host "Applying DSC Configuration..."
Start-DscConfiguration -Path .\JoinDomainConfiguration -Force -Wait