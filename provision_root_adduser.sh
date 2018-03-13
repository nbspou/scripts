# See: https://www.digitalocean.com/community/tutorials/initial-server-setup-with-ubuntu-16-04

adduser --disabled-password --gecos "" $1
mkdir /home/$1/.ssh
chown $1:$1 /home/$1/.ssh
cp /root/.ssh/authorized_keys /home/$1/.ssh/authorized_keys
chown $1:$1 /home/$1/.ssh/authorized_keys

curl -sSL https://raw.githubusercontent.com/nbspou/scripts/master/provision_me_base.sh | su $1 -c bash
