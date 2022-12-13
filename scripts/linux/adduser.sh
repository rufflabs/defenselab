#!/bin/bash

echo "Adding administrator user account..."
sudo useradd -p dfvwPzOU.Fsfc -G `groups vagrant | awk -F " : " '{print $2}' | sed 's/ /,/g'` -k /home/vagrant -m -s `grep 'vagrant' /etc/passwd | awk -F ":" '{print $7}'` -U administrator