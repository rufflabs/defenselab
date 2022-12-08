# Installs the Wazuh agent pointing to SOC01.defense.local

Write-Host "Downloading Wazuh Agent..."
Invoke-WebRequest "https://packages.wazuh.com/4.x/windows/wazuh-agent-4.3.10-1.msi" -OutFile "C:\wazuh-agent-4.3.10-1.msi"

Write-Host "Installing Wazuh Agent..."
& C:\wazuh-agent-4.3.10-1.msi /q WAZUH_MANAGER="172.25.30.3"