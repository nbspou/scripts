#!/bin/sh
set -x

add-apt-repository ppa:chris-lea/redis-server
apt-get update
apt-get dist-upgrade -y

# See: https://redis.io/topics/admin

sysctl vm.overcommit_memory=1
echo 'vm.overcommit_memory=1' | sudo tee -a /etc/sysctl.conf

# echo never > /sys/kernel/mm/transparent_hugepage/enabled

# See: https://docs.mongodb.com/manual/tutorial/transparent-huge-pages/

wget https://raw.githubusercontent.com/nbspou/scripts/master/data/disable-transparent-hugepage
mv disable-transparent-hugepage /etc/init.d/disable-transparent-hugepages
chmod 755 /etc/init.d/disable-transparent-hugepages
bash /etc/init.d/disable-transparent-hugepages

# See: https://launchpad.net/~chris-lea/+archive/ubuntu/redis-server

apt-get install redis-server -y
systemctl enable redis-server
