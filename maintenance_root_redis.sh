#!/bin/sh
set -x

apt-get update
apt-get dist-upgrade -y

cd redis_exporter
GOPATH=/root/redis_exporter go get
GOPATH=/root/redis_exporter go build
cd ..
cp /root/redis_exporter/redis_exporter /usr/bin/prometheus-redis-exporter
wget https://raw.githubusercontent.com/nbspou/scripts/master/data/redis_exporter.service
mv redis_exporter.service /etc/systemd/system/redis_exporter.service
systemctl restart redis_exporter

redis-cli shutdown
systemctl start redis
