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

sysctl vm.swappiness=10
echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.conf

sysctl vm.vfs_cache_pressure=50
echo 'vm.vfs_cache_pressure=50' | sudo tee -a /etc/sysctl.conf

curl -sSL https://deb.nodesource.com/setup_22.x | bash
apt autoclean
apt-get install nodejs build-essential git mercurial cmake -y
apt-get install prometheus-node-exporter -y

apt purge snapd -y
apt autoremove -y
rm -rf ~/snap

curl -sSL https://raw.githubusercontent.com/nbspou/scripts/master/provision_me_base.sh | bash
