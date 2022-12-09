<#
Sets DNS servers on all interfaces to the DC01
#>

$DnsServer = "172.25.30.2"

$AdapterIndex = Get-NetAdapter -Name 'Ethernet*' | Select-Object -ExpandProperty 'ifIndex'

Set-DnsClientServerAddress -InterfaceIndex $AdapterIndex -ServerAddresses $DnsServer