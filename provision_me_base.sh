#!/bin/sh
set -x

yes "y" | ssh-keygen -t rsa -N "" -C $HOSTNAME"-"$USER -f ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub
