### Vagrant To Do
#### Scripts
- Update IP of DC01
    - 60-defense-net-dns.yaml
    - Set-DnsServer.ps1
- Update IP of Wazuh server
    - Install-WazuhAgent.ps1
- Confirm DNS works, have CSV to import DNS?


#### DC01
- Re-IP to Virtualbox safe IP
- Create a couple of file shares
    - Add to New-DefenseNetADUsersAndGroups.ps1
    - Create new CSV with file share info

#### SOC01
- Re-IP
- Join to AD Domain

#### SQL01
- Re-IP
- Load sample database

#### DEV01
- Re-IP
- Install Amazon Corretto from download
- Set JAVA_HOME and add JAVA_HOME\bin to PATH
- Install Jenkins with admin:password
- Install Tomcat with admin:admin
- Give domain user local admin

#### WEB01
- Re-IP
- Join Domain
- Install bWAPP
- Load configuration (db config, usernames, etc)

#### DB02
- Re-IP
- Join domain
- Download/build/install MySQL so it can run as root
- Configure mysql, load bwapp database

#### ANALYST01
- Re-IP
- Download and install SQL Server Management Studio fresh, or cache it.

#### KALI
- Create, Kali 2022.04

#### PENTEST
- Create, Ubuntu 22.04 LTS
- Install tools according to Art of book appendix


## Lab Options
Full config as above for going through The Art of Network Penetration Testing book.

Mini-config consisting of:
DC01: AD, DNS, PKI, File share
SOC01: Wazuh, or Splunk/ELK
SQL01/DB02: SQL Server or MySQL
DEV01/WEB01: XAMPP with Tomcat/Jenkins or bWAPP or similar
ANALYST: RSAT, SSMS
KALI



### Build Guide To Do
- Plant default password `D3fense!` in document in file share for new users. Onboarding page?
- Set `Domain User` to have permission to join PC's to the domain.
- Configure file share on DC01, including allowing public write but not read.
- Basic LAPS install without modifying permissions. (Weak implementation)
- Create computers and server accounts in AD. 
    - Some default machine account password vulns, allowing takeover.
- Redo IP's to adhere to virtaulbox on mac/linux restrictions (192.168.x.x address range)
- 

# Defense Network Lab

The Defense Network Lab is built around the internal network of a ficticious company. The Defense Network
is an auditing and cybersecurity consulting firm. 

As they expanded their business they had to grow their IT services and executive management. With some new
business and potential clients they have had to start adhereing to various audit and security control requirements.

One of those requirements is to have a penetration test performed to test the security controls of the Defense Network.

Your role is to come in as a security contractor to audit the Defense Network and create a penetration test report. 

## Lab Requirements
The Defense Network lab is designed around using minimal resources, and uses VirtualBox and Vagrant to create a predictable
lab environment. To deploy the lab you will need to have VirtualBox and Vagrant installed. 

### VirtualBox

### Vagrant

## Lab Goals

## Guided Scenarios

## Resources

## Step by Step Setup

### VirtualBox

### Vagrant

### Deploying the Lab via Vagrant

