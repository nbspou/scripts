#!/bin/sh
set -x

#cd ~
#sudo npm install -g pm2
#sudo pm2 startup -u $USER

# See: http://pm2.keymetrics.io/docs/usage/startup/

sudo npm install -g pm2
pm2 startup
