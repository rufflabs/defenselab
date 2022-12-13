#!/bin/bash

cp /vagrant/scripts/linux/60-defense-net-dns.yaml /etc/netplan/
netplan apply