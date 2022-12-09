#!/bin/bash

echo "Copying website files..."
mkdir -p /var/www/html/logs
cp -r /vagrant/files/bWAPP/* /var/www/html/

cp -f /vagrant/scripts/web01/settings.php /var/www/html/admin/
rm -f /var/www/html/index.html

# Set permissions according to install document
echo "Modifying permissions..."
chmod 777 /var/www/html/passwords /var/www/html/images /var/www/html/documents /var/www/html/logs