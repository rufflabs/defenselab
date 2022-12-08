#!/bin/bash

# Install updates
sudo apt update
# && sudo apt upgrade -y

# Install Wazuh
curl -sO https://packages.wazuh.com/4.3/wazuh-install.sh && sudo bash ./wazuh-install.sh -a -i

# Copy out passwords for ease of access
sudo tar -O -xvf wazuh-install-files.tar wazuh-install-files/wazuh-passwords.txt | tee /vagrant/Files/wazuh-passwords.txt

