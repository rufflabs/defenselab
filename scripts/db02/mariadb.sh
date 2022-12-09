#!/bin/bash

# Sets up mariadb to run as root insecurely
echo "Installing mariadb-server..."
apt update
DEBIAN_FRONTEND=noninteractive apt install -y mariadb-server

echo "Copying mariadb overrides configuration file..."
mkdir -p /etc/systemd/system/mariadb.service.d/
cp /vagrant/scripts/db02/override.conf /etc/systemd/system/mariadb.service.d/
cp -f /vagrant/scripts/db02/50-server.cnf /etc/mysql/mariadb.conf.d/
systemctl daemon-reload

echo "Restarting mariadb service..."
systemctl restart mariadb

echo "Loading sql file..."
mysql -u root < /vagrant/scripts/db02/bWAPP.sql