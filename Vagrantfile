
Vagrant.configure("2") do |config|

  basebox_windows_core = "gusztavvargadr/windows-server-core"
  basebox_windows_server = "gusztavvargadr/windows-server"
  basebox_ubuntu = "bento/ubuntu-22.04"
  basebox_windows_10 = "gusztavvargadr/windows-10"
  basebox_windows_11 = "gusztavvargadr/windows-11"

  private_network_ips = {
    "dc01" => {
      ip: "172.25.30.2",
      subnet: "255.255.255.0",
      gateway: "172.25.30.1"
    },
    "soc01" => {
      ip: "172.25.30.3",
      subnet: "255.255.255.0",
      gateway: "172.25.30.1"
    },
    "sql01" => {
      ip: "172.25.30.4",
      subnet: "255.255.255.0",
      gateway: "172.25.30.1"
    },
    "dev01" => {
      ip: "172.25.30.5",
      subnet: "255.255.255.0",
      gateway: "172.25.30.1"
    },
    "web01" => {
      ip: "172.25.30.6",
      subnet: "255.255.255.0",
      gateway: "172.25.30.1"
    },
    "db02" => {
      ip: "172.25.30.7",
      subnet: "255.255.255.0",
      gateway: "172.25.30.1"
    },
    "analyst" => {
      ip: "172.25.30.8",
      subnet: "255.255.255.0",
      gateway: "172.25.30.1"
    },
    "attacker" => {
      ip: "172.25.30.9",
      subnet: "255.255.255.0",
      gateway: "172.25.30.1"
    }
  
  }
  

  config.vm.define "dc01" do |box|
    box.vm.box = basebox_windows_core
    box.vm.hostname = "dc01"
  
    box.vm.communicator = "winrm"
    box.winrm.transport = :plaintext
    box.winrm.basic_auth_only = true

    box.vm.network :private_network, ip: private_network_ips["dc01"][:ip], subnet: private_network_ips["dc01"][:subnet], gateway: private_network_ips["dc01"][:gateway]

    box.vm.provider :virtualbox do |vb|
      vb.name = "defense_dc01"
      vb.memory = 2048
      vb.cpus = 2
    end

    box.vm.provision "shell", path: "scripts/windows/Install-DscRequirements.ps1", name: "Install DSC Requirements"
    box.vm.provision "shell", path: "scripts/DSC/DSC_Create-Domain.ps1", name: "Create Domain via DSC"
    box.vm.provision "shell", reboot: true, name: "Reboot after Domain creation"
    box.vm.provision "shell", path: "scripts/DC01/SetDefenseAdministratorPassword", name: "Update DEFENSE\\Administrator password"
    #box.vm.provision "shell", path: "scripts/DC01/CreateFileShares.ps1", name: "Create file shares"
    box.vm.provision "shell", path: "scripts/DC01/SetPasswordPolicy.ps1", name: "Updating Domain Password Policy"
    box.vm.provision "shell", path: "scripts/AD/New-DefenseNetADUsersAndGroups.ps1", name: "Populating Active Directory with accounts"
    box.vm.provision "shell", path: "scripts/windows/Install-WazuhAgent.ps1", name: "Install Wazuh Agent"
  end

  config.vm.define "soc01" do |box|
    box.vm.box = basebox_ubuntu
    box.vm.hostname = "soc01"

    box.vm.network :private_network, ip: private_network_ips["soc01"][:ip], subnet: private_network_ips["soc01"][:subnet], gateway: private_network_ips["soc01"][:gateway]


    box.vm.provider :virtualbox do |vb|
      vb.name = "defense_soc01"

      vb.memory = 2048
      vb.cpus = 2
    end

    box.vm.provision "shell", path: "scripts/linux/adduser.sh", name: "Create administrator user"
    box.vm.provision "shell", path: "scripts/linux/netplan.sh", name: "Apply netplan DNS configuration"
    box.vm.provision "shell", path: "scripts/linux/wazuh.sh", name: "Install Wazuh"
  end

  config.vm.define "sql01" do |box|
    box.vm.box = basebox_windows_server
    box.vm.hostname = "sql01"
  
    box.vm.communicator = "winrm"
    box.winrm.transport = :plaintext
    box.winrm.basic_auth_only = true

    box.vm.network :private_network, ip: private_network_ips["sql01"][:ip], subnet: private_network_ips["sql01"][:subnet], gateway: private_network_ips["sql01"][:gateway]


    box.vm.provider :virtualbox do |vb|
      vb.name = "defense_sql01"
      vb.memory = 2048
      vb.cpus = 2
    end

    box.vm.provision "shell", path: "scripts/windows/Install-DscRequirements.ps1", name: "Install DSC Requirements"
    box.vm.provision "shell", path: "scripts/windows/Set-DnsServer.ps1", name: "Set DNS Server"
    box.vm.provision "shell", path: "scripts/DSC/DSC_Join-Domain.ps1", name: "Join Domain"
    box.vm.provision "shell", reboot: true
    box.vm.provision "shell", path: "scripts/windows/Install-WazuhAgent.ps1", name: "Install Wazuh Agent"
    box.vm.provision "shell", path: "scripts/DSC_Install-SqlServer.ps1", name: "Install SQL Server via DSC"
    box.vm.provision "shell", inline: "net localgroup Administrators defense\\sql.admin /ADD ", name: "Add local administrator user"

  end

  config.vm.define "dev01" do |box|
    box.vm.box = basebox_windows_core
    box.vm.hostname = "dev01"

    box.vm.network :private_network, ip: private_network_ips["dev01"][:ip], subnet: private_network_ips["dev01"][:subnet], gateway: private_network_ips["dev01"][:gateway]


    box.vm.provider :virtualbox do |vb|
      vb.name = "defense_dev01"

      vb.memory = 2048
      vb.cpus = 2
    end

    box.vm.provision "shell", path: "scripts/windows/Install-DscRequirements.ps1", name: "Install DSC Requirements"
    box.vm.provision "shell", path: "scripts/windows/Set-DnsServer.ps1", name: "Set DNS Server"
    box.vm.provision "shell", path: "scripts/DSC/DSC_Join-Domain.ps1", name: "Join Domain"
    box.vm.provision "shell", reboot: true
    box.vm.provision "shell", path: "scripts/windows/Install-WazuhAgent.ps1", name: "Install Wazuh Agent"
    #box.vm.provision "shell", path: "scripts/DEV01-AdditionalConfiguration.ps1", name: "Additional DEV01 Configuration"
    # TODO: Create above script, move below installs and configs to that script.
    box.vm.provision "shell", inline: "cmd.exe /c msiexec.exe /i c:\\vagrant\\programs\\amazon-corretto-17.0.5.8.1-windows-x64.msi /qn", name: "Install Amazon Corretto"
    # TODO: Set JAVA_HOME and add JAVA_HOME\bin to PATH. 
    # TODO: Install Jenkins 
    # TODO: Install Tomcat
    box.vm.provision "shell", inline: "Programs/xampp-windows-x64-7.4.33-0-VC15-installer.exe", args: "--mode unattended", name: "Install XAMPP"

    # Install jenkins with admin:password
    # Install tomcat admin:admin via xampp
    # --mode unattended --optionfile <file> --enable-components xampp_server,xampp_apache,xampp_mysql,xampp_filezilla,xampp_mercury,xampp_tomcat,xampp_program_languages,xampp_php,xampp_perl,xampp_tools,xampp_phpmyadmin,xampp_webalizer,xampp_sendmail
    # Give a domain user local admin
  end

  config.vm.define "web01" do |box|
    box.vm.box = basebox_ubuntu
    box.vm.hostname = "web01"

    box.vm.network :private_network, ip: private_network_ips["web01"][:ip], subnet: private_network_ips["web01"][:subnet], gateway: private_network_ips["web01"][:gateway]


    box.vm.provider :virtualbox do |vb|
      vb.name = "defense_web01"

      vb.memory = 2048
      vb.cpus = 2
    end

    box.vm.provision "shell", path: "scripts/linux/netplan.sh", name: "Apply netplan DNS configuration"
    #box.vm.provision "shell", path: "scripts/join-domain.sh", name: "Join domain"
    #box.vm.provision "shell", path: "scripts/wazuh.sh", name: "Install Wazuh" TODO: Switch this to wazuh agent
    box.vm.provision "shell", path: "scripts/web01/apache-php.sh", name: "Install apache and php"
    box.vm.provision "shell", path: "scripts/web01/bwapp.sh", name: "Create bWAPP website"

    # TODO: Configure bwapp according to install.txt, setup mysql on db02. Pre-configure admin/settings.php
    # TODO: Possibly install, export, and import SQL database?

    # Join to domain, set DNS
    # Install simple web app vulnerable to initial compromise, non-root initial access. Store creds to db02
    # Add domain account as local admin/sudo rights. 
  end

  config.vm.define "db02" do |box|
    box.vm.box = basebox_ubuntu
    box.vm.hostname = "db02"

    box.vm.network :private_network, ip: private_network_ips["db02"][:ip], subnet: private_network_ips["db02"][:subnet], gateway: private_network_ips["db02"][:gateway]


    box.vm.provider :virtualbox do |vb|
      vb.name = "defense_db02"

      vb.memory = 2048
      vb.cpus = 2
    end

    box.vm.provision "shell", path: "scripts/linux/netplan.sh", name: "Apply netplan DNS configuration"
    #box.vm.provision "shell", path: "scripts/join-domain.sh", name: "Join domain"
    box.vm.provision "shell", path: "scripts/db02/mariadb.sh"
    #box.vm.provision "shell", inline: "" this is for mysql command to restore /vagrant/files/bwapp.sql TODO: Create this.
    # Join to domain, set DNS
    # Install mysql with creds stored in web directory on web01. run mysql as root.
  end

  config.vm.define "analyst" do |box|
    box.vm.box = basebox_windows_server
    box.vm.hostname = "analyst"

    box.vm.network :private_network, ip: private_network_ips["analyst"][:ip], subnet: private_network_ips["analyst"][:subnet], gateway: private_network_ips["analyst"][:gateway]


    box.vm.provider :virtualbox do |vb|
      vb.name = "defense_analyst"
      vb.memory = 4096
      vb.cpus = 2
    end

    box.vm.provision "shell", path: "scripts/windows/Install-DscRequirements.ps1", name: "Install DSC Requirements"
    box.vm.provision "shell", path: "scripts/windows/Set-DnsServer.ps1", name: "Set DNS Server"
    box.vm.provision "shell", path: "scripts/DSC/DSC_Join-Domain.ps1", name: "Join Domain"
    box.vm.provision "shell", reboot: true, name: "Reboot after domain join"
    box.vm.provision "shell", path: "scripts/windows/Install-WazuhAgent.ps1", name: "Install Wazuh Agent"
    box.vm.provision "shell", inline: "cmd.exe /c start \"\" /w C:\\Vagrant\\Programs\\SSMS\\SSMS-Setup-ENU.exe /Quiet SSMSInstallRoot=\"C:\\Program Files (x86)\\Microsoft SQL Server Management Studio 18\"", name: "Installing SQL Server Management Studio"
    box.vm.provision "shell", inline: "Get-WindowsFeature -Name RSAT* | Install-WindowsFeature", name: "Install RSAT"
    box.vm.provision "shell", reboot: true, name: "Reboot after software installs"
 
 
  end

  # TODO: kali/pentest/audit box
end