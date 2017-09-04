#!/bin/sh
set -x

cd ~
cd dogcat
git pull
cd build
cmake ..
make
cd ..
cd ..
cp ~/dogcat/build/bin/dogcat /usr/bin/dogcat
