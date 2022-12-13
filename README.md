# Defense Network Lab
The Defense Network Lab is a Vagrant project that will launch a VM lab network with a full Active Directory
domain with multiple users, groups, and computer objects. It includes a Wazuh server for log management and
alerting, and both an analyst VM for defensive actions and a Kali attack VM for offensive actions.

The Windows VM's and SQL Server 2016 are installed using Evaluation licenses. This allows you to destroy
and rebuild the lab once the evaluation licenses expire.

This lab is currently a work in progress, see the To Do section below for the current list of items I intend
to update.

## Setup and Usage
You will need to have the following pre-requisites to build this lab:
- Virtualbox (Tested on 7.0)
- Vagrant (Tested on 2.3.3)
- 110GB+ of free disk space
    - 17GB for Vagrant boxes
    - 85GB for built lab VM's
    - 5GB for software downloads (SQL, etc)
- 10GB+ of RAM (Tested on Windows 10 with 16GB)
- Tested with 6 core CPU

In my testing I had all 8 VM's operating at the same time, and the Analyst and Wazuh VM's were responsive. 
If you have less resources available, or are experiencing performance issues you can choose to only bring up
the specific VM's you need for a particular testing scenario. 

For example, to test a `Responder` attack, you only need DC01, Analyst and Attack. 

If disk space is a concern, you can choose to only bring up the specific VM's you want to test with and destroy
them when finished. As a base you will probably at least always want DC01, Analyst, and potentially Attack available.

## Bringing the lab online
Once you have Virtualbox and Vagrant installed you can bring the entire lab up with all 8 VM's by opening a
command prompt in the `defenselab` folder where the `Vagrantfile` and `scripts/` are. Then run:
```
vagrant up
```

If you only want to bring up specific VM's, always start with DC01, and then others. For example:
```
vagrant up dc01

# Wait until dc01 boots
vagrant up analyst

# Wait until that one comes up
vagrant up attack
```

The entire lab will take about 2 hours to be built and configured from scratch, not including download time for downloading the various Vagrant template boxes. 

# To Do
- Update IP's to Virtualbox's approved private IP's for Linux/Mac to minimize issues
    - 192.168.56.0/21
- Update support scripts with new IP's
    - linux/60-defense-net-dns.yaml
    - windows/Set-DnsServer.ps1
    - windows/Install-WazuhAgent.ps1
    - web01/InstallTomcat.ps1 context file update.
- Create CSV to update defense.local DNS entries for linux servers
- Add LAPS

**DC01**
- Potential issue with createfiles script?
- Install PKI

**SOC01**
- Join to AD Domain
- Add pre-configured users to Wazuh, if possible
- Move from Wazuh to Splunk or ELK?

**SQL01**
- Load sample database of some kind

**DEV01**


**WEB01**
- Join domain
- Add domain account as local sudo user
- Install Wazuh agent

**DB02**
- Join domain
- Add domain account as local sudo user
- Install wazuh agent

**ANALYST**
- Update `analyst/InstallSSMS.ps1` to download if needed.

**ATTACK**
- Create kali user
- Configure DNS?