#!/bin/sh
set -x

#cd ~
#sudo npm install -g pm2
#sudo pm2 startup -u $USER

# See: http://pm2.keymetrics.io/docs/usage/startup/

sudo npm install -g pm2
pm2 startup

# [PM2] To setup the Startup Script, copy/paste the following command:
# sudo env PATH=$PATH:/usr/bin /usr/lib/node_modules/pm2/bin/pm2 startup systemd -u me --hp /home/me
