<# 
Sets the default domain policy
#>

Import-Module ActiveDirectory

Set-ADDefaultDomainPasswordPolicy -Identity (Get-ADDomain) -ComplexityEnabled $false -MinPasswordLength 4