#!/bin/sh
set -x

cd ~
npm install -g pm2
pm2 startup
