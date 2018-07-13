#!/bin/sh
set -x

rm /var/lib/apt/lists/*
rm /var/lib/apt/lists/partial/*

apt-get update
DEBIAN_FRONTEND=noninteractive apt-get upgrade -y
DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y
apt-get autoremove -y

timedatectl set-timezone UTC

# See: https://www.digitalocean.com/community/tutorials/how-to-add-swap-space-on-ubuntu-16-04

fallocate -l 8G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

swapon --show
free -h

sysctl vm.swappiness=10
echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.conf

sysctl vm.vfs_cache_pressure=50
echo 'vm.vfs_cache_pressure=50' | sudo tee -a /etc/sysctl.conf

curl -sSL https://deb.nodesource.com/setup_10.x | bash
apt-get install nodejs build-essential git mercurial cmake -y
apt-get install prometheus-node-exporter -y

curl -sSL https://raw.githubusercontent.com/nbspou/scripts/master/provision_me_base.sh | bash

# See: https://www.digitalocean.com/community/tutorials/initial-server-setup-with-ubuntu-16-04

# adduser --disabled-password --gecos "" me
# mkdir /home/me/.ssh
# chown me:me /home/me/.ssh
# cp /root/.ssh/authorized_keys /home/me/.ssh/authorized_keys
# chown me:me /home/me/.ssh/authorized_keys

# curl -sSL https://raw.githubusercontent.com/nbspou/scripts/master/provision_me_base.sh | su me -c bash
