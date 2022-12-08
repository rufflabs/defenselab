<#
Updates the DEFENSE\Administrator password and sets it to not expire for the lab.
#>

Write-Host "Updating DEFENSE\Administrator password..."
Set-ADAccountPassword -Identity "Administrator" -Reset -NewPassword (ConvertTo-SecureString -AsPlainText "Defense0!" -Force)

Write-Host "Setting DEFENSE\Administrator password to never expire..."
Set-ADUser -Identity "Administrator" -PasswordNeverExpires $true

Write-Host "Setting Domain group memberships for DEFENSE\Vagrant..."
"Schema Admins", "Domain Admins" | ForEach-Object {Add-ADGroupMember -Identity $_ -Members (Get-ADUser -Identity "Vagrant")}

Write-Host "Installing GroupPolicy AD Module"
Install-WindowsFeature -Name GPMC

Write-Host "Adjusting Password Policy"
secedit /export /cfg c:\secpol.cfg
(Get-Content C:\secpol.cfg).replace("PasswordComplexity = 1", "PasswordComplexity = 0") | Out-File C:\secpol.cfg
secedit /configure /db c:\windows\security\local.sdb /cfg c:\secpol.cfg /areas SECURITYPOLICY
Remove-Item -force c:\secpol.cfg -confirm:$false