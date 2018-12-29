#!/bin/sh
set -x

# https://github.com/dart-lang/dart-protoc-plugin
# https://www.dartlang.org/tools/sdk#install

sudo apt-get install protobuf-compiler apt-transport-https

sudo sh -c 'curl https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -'
sudo sh -c 'curl https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_stable.list > /etc/apt/sources.list.d/dart_stable.list'

# sudo sh -c 'curl https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_unstable.list > /etc/apt/sources.list.d/dart_unstable.list'

sudo apt-get update
sudo apt-get install dart

echo 'PATH="$PATH:/usr/lib/dart/bin:$HOME/.pub-cache/bin"' >> ~/.profile

PATH="$PATH:/usr/lib/dart/bin:$HOME/.pub-cache/bin"
pub global activate protoc_plugin

# git clone https://github.com/dart-lang/pub.git

# git clone https://github.com/dart-lang/dart-protoc-plugin.git
# cd dart-protoc-plugin
# pub install --verbose

# nano .profile
# add bin/protoc-gen-dart to path
# restart

pub global activate stagehand
pub global activate webdev
