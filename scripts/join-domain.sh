#!/bin/bash

# Prevent apt from questioning on service restarts
export DEBIAN_FRONTEND=noninteractive

# Update repository cache
sudo apt update

# Install pre-requisuites
sudo DEBIAN_FRONTEND=noninteractive apt install -y ntp realmd sssd adcli krb5-user sssd-tools samba-common packagekit samba-common-bin samba-libs

# Copy config files over
sudo cp /vagrant/files/realmd.conf /etc/realmd.conf
sudo chown root:root /etc/realmd.conf
sudo chmod 0644 /etc/realmd.conf

sudo cp /vagrant/files/krb5.conf /etc/krb5.conf
sudo chown root:root /etc/krb5.conf
sudo chmod 0644 /etc/krb5.conf

# Copy configuration files
sudo cp /vagrant/files/ntp.conf /etc/ntp.conf
sudo service ntp restart


# Join domain
echo "Defense0!" | realm join defense.local --user=Administrator --computer-ou="OU=Servers,DC=defense,dc=local"

# Update sudoers
sudo cp /etc/sudoers /etc/sudoers.tmp
sudo echo "%domain\ admins ALL=(ALL:ALL) ALL" >> /etc/sudoers.tmp
sudo visudo -q -c -f /etc/sudoers.tmp && sudo cp -f /etc/sudoers.tmp /etc/sudoers

# Copy configuration files
sudo cp /vagrant/files/sssd.conf /etc/sssd/sssd.conf
sudo chown root:root /etc/sssd/sssd.conf
sudo chmod 0644 /etc/sssd/sssd.conf

sudo cp /vagrant/files/common-session /etc/pam.d/common-session
sudo chown root:root /etc/pam.d/common-session
sudo chmod 0644 /etc/pam.d/common-session

sudo reboot
