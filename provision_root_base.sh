#!/bin/sh
set -x

apt-get update
apt-get dist-upgrade -y

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

curl -sL https://deb.nodesource.com/setup_6.x | bash
apt-get install nodejs build-essential git mercurial cmake -y
apt-get install prometheus-node-exporter -y

yes "y" | ssh-keygen -t rsa -N "" -C $HOSTNAME"-root" -f ~/.ssh/id_rsa
cat /root/.ssh/id_rsa.pub

adduser --disabled-password --gecos "" me
mkdir /home/me/.ssh
chown me:me /home/me/.ssh
cp /root/.ssh/authorized_keys /home/me/.ssh/authorized_keys
chown me:me /home/me/.ssh/authorized_keys

