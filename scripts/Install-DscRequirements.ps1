Write-Host "Installing PowerShell DesiredStateConfiguration Requirements..."

Write-Host "Installing Module ActiveDirectoryDsc..."
Install-Module -Name ActiveDirectoryDsc -Force

Write-Host "Installing Module PSDscResources..."
Install-Module -Name PSDscResources -Force

Write-Host "Installing ComputerManagedmentDsc..."
Install-Module -Name ComputerManagementDsc -Force

Write-Host "Installing SqlServerDsc..."
Install-Module -Name SqlServerDsc -Force

Write-Host "Completed pre-requisites."