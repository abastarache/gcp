#!/bin/bash

# Uninstall google-cloud-cli
apt-get remove -y google-cloud-cli 

# Update
apt-get update
apt-get upgrade -y

# Setup 1 GB swap space
fallocate -l 1G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
cp /etc/fstab /etc/fstab.bak
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

# Configure swappiness and cache pressure
sysctl vm.swappiness=10
sysctl vm.vfs_cache_pressure=50

# Make swappiness and cache pressure settings permanent
echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.conf
echo 'vm.vfs_cache_pressure=50' | sudo tee -a /etc/sysctl.conf

# Add webmin repository
curl -o setup-repos.sh https://raw.githubusercontent.com/webmin/webmin/master/setup-repos.sh
sh setup-repos.sh
echo y | command

# Install Cockpit, Webmin, htop and tuned
apt-get install -y cockpit cockpit-pcp webmin tuned htop

# Install AdGuard Home
curl -s -S -L https://raw.githubusercontent.com/AdguardTeam/AdGuardHome/master/scripts/install.sh | sh -s -- -v
