<#
Updates Group Policy password policy locally, to allow weak passwords.
#>

Write-Host "Installing GroupPolicy AD Module"
Install-WindowsFeature -Name GPMC

Write-Host "Adjusting Password Policy"
secedit /export /cfg c:\secpol.cfg
(Get-Content C:\secpol.cfg).replace("PasswordComplexity = 1", "PasswordComplexity = 0") | Out-File C:\secpol.cfg
secedit /configure /db c:\windows\security\local.sdb /cfg c:\secpol.cfg /areas SECURITYPOLICY
Remove-Item -force c:\secpol.cfg -confirm:$false