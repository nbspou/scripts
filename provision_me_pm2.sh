#!/bin/sh
set -x

cd ~
sudo npm install -g pm2
sudo pm2 startup -u $USER
