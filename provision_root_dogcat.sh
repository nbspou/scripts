#!/bin/sh
set -x

apt-get update
apt-get dist-upgrade -y

git clone -q https://github.com/nbspou/dogcat.git dogcat
cd dogcat
mkdir build
cd build
cmake ..
cd ..
cd ..
cp ~/dogcat/build/bin/dogcat /usr/bin/dogcat
