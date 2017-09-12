#!/bin/sh
set -x

apt-get update
apt-get dist-upgrade -y

# See: https://www.digitalocean.com/community/tutorials/how-to-add-swap-space-on-ubuntu-16-04

sysctl vm.swappiness=10
echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.conf

sysctl vm.vfs_cache_pressure=50
echo 'vm.vfs_cache_pressure=50' | sudo tee -a /etc/sysctl.conf

# Install common packages

curl -sSL https://deb.nodesource.com/setup_6.x | bash
apt-get install nodejs build-essential git mercurial cmake -y
apt-get install prometheus-node-exporter -y
apt-get install nano screen command-not-found -y

# Get rid of any bashrc customizations

/bin/cp /etc/skel/.bashrc ~/
source ~/.bashrc

# Set up some useful things for the root user

curl -sSL https://raw.githubusercontent.com/nbspou/scripts/master/provision_me_base.sh | bash
