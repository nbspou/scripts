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

# DNS Lookup

# sed -i 's/nameservers:/nameservers:\n        search:\n          - ryzom.dev/' /etc/netplan/01-netcfg.yaml
nano /etc/netplan/99-ryzom-core.yaml
network:
  version: 2
  ethernets:
    eth0:
      nameservers:
        search:
          - ryzom.dev
netplan apply

# SSH Password

sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config

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

# Install common packages

apt-get install nodejs build-essential git mercurial cmake -y
apt-get install prometheus-node-exporter -y
apt-get install nano screen command-not-found psmisc -y
apt-get remove vim -y

# Dependencies

apt update
apt install cmake build-essential gdb bison autoconf automake \
libpng-dev libjpeg-dev libgif-dev libfreetype6-dev \
liblua5.2-dev libluabind-dev libcpptest-dev \
libogg-dev libvorbis-dev libopenal-dev \
libavcodec-dev libavformat-dev libavdevice-dev libswscale-dev libpostproc-dev \
libmysqlclient-dev libxml2-dev libcurl4-openssl-dev libssl-dev \
libsquish-dev liblzma-dev libgsf-1-dev \
p7zip-full screen nano \
-y

# Get rid of any bashrc customizations

/bin/cp /etc/skel/.bashrc ~/
source ~/.bashrc

# Set up some useful things for the root user

curl -sSL https://raw.githubusercontent.com/nbspou/scripts/master/provision_me_base.sh | bash

# Disable overcommit checks and disable transparent huge pages

sysctl vm.overcommit_memory=1
echo 'vm.overcommit_memory=1' | sudo tee -a /etc/sysctl.conf

wget https://raw.githubusercontent.com/nbspou/scripts/master/data/disable-transparent-hugepage
mv disable-transparent-hugepage /etc/init.d/disable-transparent-hugepages
chmod 755 /etc/init.d/disable-transparent-hugepages
/etc/init.d/disable-transparent-hugepages start
update-rc.d disable-transparent-hugepages defaults

# User accounts

curl -sSL https://raw.githubusercontent.com/nbspou/scripts/master/provision_root_adduser.sh | bash -s kaetemi
curl -sSL https://raw.githubusercontent.com/nbspou/scripts/master/provision_root_adduser.sh | bash -s nevrax
