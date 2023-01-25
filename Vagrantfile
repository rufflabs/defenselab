Vagrant.configure("2") do |config|

  # Base Vagrant boxes
  basebox_windows_core = "gusztavvargadr/windows-server-core"
  basebox_windows_server = "gusztavvargadr/windows-server"
  basebox_ubuntu = "bento/ubuntu-22.04"
  basebox_windows_10 = "gusztavvargadr/windows-10"
  basebox_windows_11 = "gusztavvargadr/windows-11"

  # Networking
  private_network_subnet = "255.255.255.0"
  private_network_gateway = "172.25.30.1"
  private_network_ips = {
    "dc01" => {
      ip: "172.25.30.2"
    },
    "soc01" => {
      ip: "172.25.30.3"
    },
    "sql01" => {
      ip: "172.25.30.4"
    },
    "dev01" => {
      ip: "172.25.30.5"
    },
    "web01" => {
      ip: "172.25.30.6"
    },
    "db02" => {
      ip: "172.25.30.7"
    },
    "analyst" => {
      ip: "172.25.30.8"
    },
    "attack" => {
      ip: "172.25.30.9"
    }
  }
  
  # Global options
  config.vm.boot_timeout = 600
  config.vm.synced_folder ".", "/vagrant", disabled: false

  config.vm.define "dc01" do |box|
    box.vm.box = basebox_windows_core
    box.vm.hostname = "dc01"
  
    box.vm.communicator = "winrm"
    box.winrm.transport = :plaintext
    box.winrm.basic_auth_only = true

    box.vm.network "private_network", ip: private_network_ips["dc01"][:ip], subnet: private_network_subnet, gateway: private_network_gateway

    box.vm.provider "virtualbox" do |vb|
      vb.name = "defense_dc01"
      vb.memory = 1024
      vb.cpus = 2
    end

    box.vm.provision "shell", path: "scripts/windows/Install-DscRequirements.ps1", name: "Install DSC Requirements"
    box.vm.provision "shell", path: "scripts/dsc/DSC_Create-Domain.ps1", name: "Create Domain via DSC"
    box.vm.provision "shell", reboot: true, name: "Reboot after Domain creation"
    box.vm.provision "shell", path: "scripts/dc01/SetDefenseAdministratorPassword.ps1", name: "Update DEFENSE\\Administrator password"
    box.vm.provision "shell", path: "scripts/dc01/SetPasswordPolicy.ps1", name: "Updating Domain Password Policy"
    box.vm.provision "shell", path: "scripts/dc01/New-DefenseNetADUsersAndGroups.ps1", name: "Populating Active Directory with accounts"
    box.vm.provision "shell", path: "scripts/dc01/CreateFileShares.ps1", name: "Create file shares"
    box.vm.provision "shell", path: "scripts/windows/Install-WazuhAgent.ps1", name: "Install Wazuh Agent"
  end

  config.vm.define "soc01" do |box|
    box.vm.box = basebox_ubuntu
    box.vm.hostname = "soc01"

    box.vm.network "private_network", ip: private_network_ips["soc01"][:ip], subnet: private_network_subnet, gateway: private_network_gateway

    box.vm.provider "virtualbox" do |vb|
      vb.name = "defense_soc01"
      vb.memory = 1024
      vb.cpus = 2
    end

    box.vm.provision "shell", path: "scripts/linux/adduser.sh", name: "Create administrator user"
    box.vm.provision "shell", path: "scripts/linux/netplan.sh", name: "Apply netplan DNS configuration"
    box.vm.provision "shell", path: "scripts/linux/wazuh.sh", name: "Install Wazuh"
    box.vm.provision "shell", path: "scripts/soc01/wazuhpasswords.sh", name: "Extract Wazuh passwords"
  end

  config.vm.define "sql01" do |box|
    box.vm.box = basebox_windows_core
    box.vm.hostname = "sql01"
  
    box.vm.communicator = "winrm"
    box.winrm.transport = :plaintext
    box.winrm.basic_auth_only = true

    box.vm.network "private_network", ip: private_network_ips["sql01"][:ip], subnet: private_network_subnet, gateway: private_network_gateway

    box.vm.provider "virtualbox" do |vb|
      vb.name = "defense_sql01"
      vb.memory = 1024
      vb.cpus = 2
    end

    box.vm.provision "shell", path: "scripts/windows/Install-DscRequirements.ps1", name: "Install DSC Requirements"
    box.vm.provision "shell", path: "scripts/windows/Set-DnsServer.ps1", name: "Set DNS Server"
    box.vm.provision "shell", path: "scripts/DSC/DSC_Join-Domain.ps1", name: "Join Domain"
    box.vm.provision "shell", reboot: true
    box.vm.provision "shell", path: "scripts/windows/Install-WazuhAgent.ps1", name: "Install Wazuh Agent"
    box.vm.provision "shell", path: "scripts/sql01/DownloadSQLServer2016.ps1", name: "Download SQL Server 2016 Evalulation"
    box.vm.provision "shell", path: "scripts/dsc/DSC_Install-SqlServer.ps1", name: "Install SQL Server 2016 Evaluation via DSC"
    box.vm.provision "shell", inline: "net localgroup Administrators defense\\sql.admin /ADD ", name: "Add local administrator user"
  end

  config.vm.define "dev01" do |box|
    box.vm.box = basebox_windows_core
    box.vm.hostname = "dev01"

    box.vm.network "private_network", ip: private_network_ips["dev01"][:ip ], subnet: private_network_subnet, gateway: private_network_gateway
    box.vm.network "forwarded_port", guest: 9090, host: 9090 # For testing VM setup

    box.vm.provider "virtualbox" do |vb|
      vb.name = "defense_dev01"
      vb.memory = 1024
      vb.cpus = 2
    end

    box.vm.provision "shell", path: "scripts/windows/Install-DscRequirements.ps1", name: "Install DSC Requirements"
    box.vm.provision "shell", path: "scripts/windows/Set-DnsServer.ps1", name: "Set DNS Server"
    box.vm.provision "shell", path: "scripts/DSC/DSC_Join-Domain.ps1", name: "Join Domain"
    box.vm.provision "shell", reboot: true, name: "Rebooting after domain join"
    box.vm.provision "shell", path: "scripts/windows/Install-WazuhAgent.ps1", name: "Install Wazuh Agent"
    box.vm.provision "shell", path: "scripts/dev01/InstallCorretto.ps1", name: "Install Amazon Corretto"
    box.vm.provision "shell", path: "scripts/dev01/InstallJenkins.ps1", name: "Install Jenkins"
    box.vm.provision "shell", path: "scripts/dev01/InstallTomcat.ps1", name: "Install Tomcat"
    box.vm.provision "shell", inline: "net localgroup Administrators defense\\dev.admin /ADD ", name: "Add local administrator user"
  end

  config.vm.define "web01" do |box|
    box.vm.box = basebox_ubuntu
    box.vm.hostname = "web01"

    box.vm.network "private_network", ip: private_network_ips["web01"][:ip], subnet: private_network_subnet, gateway: private_network_gateway

    box.vm.provider "virtualbox" do |vb|
      vb.name = "defense_web01"
      vb.memory = 1024
      vb.cpus = 2
    end

    box.vm.provision "shell", path: "scripts/linux/netplan.sh", name: "Apply netplan DNS configuration"
    #box.vm.provision "shell", path: "scripts/join-domain.sh", name: "Join domain" # TODO: Get linux box joined to AD
    box.vm.provision "shell", path: "scripts/web01/apache-php.sh", name: "Install apache and php"
    box.vm.provision "shell", path: "scripts/web01/bwapp.sh", name: "Create bWAPP website"
  end

  config.vm.define "db02" do |box|
    box.vm.box = basebox_ubuntu
    box.vm.hostname = "db02"

    box.vm.network "private_network", ip: private_network_ips["db02"][:ip], subnet: private_network_subnet, gateway: private_network_gateway

    box.vm.provider "virtualbox" do |vb|
      vb.name = "defense_db02"
      vb.memory = 1024
      vb.cpus = 2
    end

    box.vm.provision "shell", path: "scripts/linux/netplan.sh", name: "Apply netplan DNS configuration"
    #box.vm.provision "shell", path: "scripts/join-domain.sh", name: "Join domain" # TODO: Get linux box joined to AD
    box.vm.provision "shell", path: "scripts/db02/mariadb.sh"
  end

  config.vm.define "analyst" do |box|
    box.vm.box = basebox_windows_server
    box.vm.hostname = "analyst"

    box.vm.network "private_network", ip: private_network_ips["analyst"][:ip], subnet: private_network_subnet, gateway: private_network_gateway

    box.vm.provider "virtualbox" do |vb|
      vb.name = "defense_analyst"
      vb.gui = true
      vb.memory = 2048
      vb.cpus = 2
    end

    box.vm.provision "shell", path: "scripts/windows/Install-DscRequirements.ps1", name: "Install DSC Requirements"
    box.vm.provision "shell", path: "scripts/windows/Set-DnsServer.ps1", name: "Set DNS Server"
    box.vm.provision "shell", path: "scripts/DSC/DSC_Join-Domain.ps1", name: "Join Domain"
    box.vm.provision "shell", reboot: true, name: "Reboot after domain join"
    box.vm.provision "shell", path: "scripts/windows/Install-WazuhAgent.ps1", name: "Install Wazuh Agent"
    box.vm.provision "shell", path: "scripts/analyst/InstallSSMS.ps1", name: "Install SQL Server Management Studio"
    box.vm.provision "shell", inline: "Get-WindowsFeature -Name RSAT* | Install-WindowsFeature", name: "Install RSAT"
    box.vm.provision "shell", reboot: true, name: "Reboot after software installs"
  end

  config.vm.define "attack" do |box|
    config.vm.box = "kalilinux/rolling"
    box.vm.hostname = "attack"

    box.vm.network "private_network", ip: private_network_ips["attack"][:ip], subnet: private_network_subnet, gateway: private_network_gateway

    box.vm.provider "virtualbox" do |vb|
      vb.name = "defense_attack"
      vb.gui = true
      vb.memory = 2048
      vb.cpus = 2
    end

    #box.vm.provision "shell", path: "scripts/linux/netplan.sh", name: "Apply netplan DNS configuration" # TODO: No netplan on kali
  end
end