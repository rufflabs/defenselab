#!/bin/bash

# Extract the Wazuh passwords
tar -O -xvf /home/vagrant/wazuh-install-files.tar wazuh-install-files/wazuh-passwords.txt > /vagrant/files/wazuh-passwords.txt