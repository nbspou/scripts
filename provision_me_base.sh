#!/bin/sh
set -x

# sed -i 's/#force_color_prompt/force_color_prompt/g' ~/.bashrc
# source ~/.bashrc

yes "y" | ssh-keygen -t rsa -N "" -C $HOSTNAME"-"$USER -f ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub

if ! grep -q "min-release-age" ~/.npmrc 2>/dev/null; then
    echo "min-release-age=14" >> ~/.npmrc
fi
