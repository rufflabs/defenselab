#!/bin/bash

echo "Copying website files..."
mkdir -p /var/www/html/logs
cp -r /vagrant/files/bWAPP/* /var/www/html/

# Set permissions according to install document
echo "Modifying permissions..."
chmod 777 /var/www/html/passwords /var/www/html/images /var/www/html/documents /var/www/html/logs