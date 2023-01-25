# Defense Lab
The Defense Lab is a Vagrant project that will launch a VM lab network with a full Active Directory
domain with multiple users, groups, and computer objects. It includes a Wazuh server for log management and
alerting, and both an analyst VM for defensive actions and a Kali attack VM for offensive actions.

The Windows VM's and SQL Server 2016 are installed using Evaluation licenses. This allows you to destroy
and rebuild the lab once the evaluation licenses expire.

This lab is currently a work in progress, see GitHub Issues to track current enhancement ideas and issues with the lab.

**Note:** This lab works best with VirtualBox. I tried some Vagrant boxes that supported VMware Workstation or
Hyper-V but they were not nearly as reliable and predictable as the Virtaulbox counterparts. 

**I highly recommend using VIrtualBox for this lab.** The supplied `Vagrantfile` is only configured for VirtualBox providers. 

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