#!/bin/sh
set -x

rm /var/lib/apt/lists/*
rm /var/lib/apt/lists/partial/*

apt-get update
DEBIAN_FRONTEND=noninteractive apt-get upgrade -y
DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y
apt-get autoremove -y

apt-get install aptitude -y

timedatectl set-timezone UTC

# See: https://www.digitalocean.com/community/tutorials/how-to-add-swap-space-on-ubuntu-16-04

sysctl vm.swappiness=10
echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.conf

sysctl vm.vfs_cache_pressure=50
echo 'vm.vfs_cache_pressure=50' | sudo tee -a /etc/sysctl.conf

# Install common packages

apt-get install nano screen command-not-found psmisc -y

# Remove common packages

apt-get remove vim vim-tiny -y
apt purge snapd -y
apt autoremove -y
rm -rf ~/snap
apt autoclean

# Disable SSH password authentication
sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
systemctl restart ssh

# Get rid of any bashrc customizations

/bin/cp /etc/skel/.bashrc ~/
source ~/.bashrc

# Set up some useful things for the root user

curl -sSL https://raw.githubusercontent.com/nbspou/scripts/master/provision_me_base.sh | bash

# Set up GPU stuff

curl -sSL https://raw.githubusercontent.com/nbspou/scripts/master/pv_provision_llama.sh | bash
