#!/bin/bash
mkdir -p /var/www/html/logs

# Check if bWAPP is already available in /vagrant/files
if [ ! -f "/vagrant/files/bWAPPv2.2.zip" ]
then
# Download bWAPP
echo "Downloading bWAPP..."
wget https://sourceforge.net/projects/bwapp/files/bWAPP/bWAPPv2.2/bWAPPv2.2.zip -O /vagrant/files/bWAPPv2.2.zip
fi

# Unzip bWAPP
echo "Extracting bWAPP..."
mkdir /tmp/bWAPP
cd /tmp/bWAPP
unzip /vagrant/files/bWAPPv2.2.zip
cp -r /tmp/bWAPP/bWAPP/* /var/www/html/
cp -f /vagrant/scripts/web01/settings.php /var/www/html/admin/
rm -f /var/www/html/index.html

# Set permissions according to install document
echo "Setting permissions..."
chmod 777 /var/www/html/passwords /var/www/html/images /var/www/html/documents /var/www/html/logs