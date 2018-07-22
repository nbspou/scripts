# Scripts
Common scripts for various tasks

```
curl -sSL https://raw.githubusercontent.com/nbspou/scripts/master/provision_root_base.sh | bash
```

```
curl -sSL https://raw.githubusercontent.com/nbspou/scripts/master/provision_root_redis.sh | bash
```

```
curl -sSL https://raw.githubusercontent.com/nbspou/scripts/master/provision_root_dogcat.sh | bash
```

* Redis Server: 127.0.0.1:6379
* Prometheus Node Exporter: http://localhost:9100/metrics
* Prometheus Redis Exporter: http://localhost:9121/metrics
* Prometheus MongoDB Exporter: http://localhost:9001/metrics

```
curl -sSL https://raw.githubusercontent.com/nbspou/scripts/master/provision_root_adduser.sh | bash -s me
```

To add `sudo` access through password:

```
usermod -aG sudo me
passwd me
```

To add `sudo` access without password (on DigitalOcean):

```
usermod -aG sudo me
echo 'me ALL=(ALL) NOPASSWD:ALL' | sudo EDITOR='tee -a' visudo -f /etc/sudoers.d/90-cloud-init-users
```

Ensure that `/etc/ssh/sshd_config` has `PasswordAuthentication no`!

```
git config --global user.name "Jan Boon"
git config --global user.email "kaetemi@no-break.space"
git config --global push.default simple
```

```
git config --global user.name "NO-BREAK SPACE OÜ"
git config --global user.email "support@no-break.space"
git config --global push.default simple
```

```
cat ~/.ssh/id_rsa.pub
```

```
curl -sSL https://raw.githubusercontent.com/nbspou/scripts/master/maintenance_root_redis.sh | bash
```

```
curl -sSL https://raw.githubusercontent.com/nbspou/scripts/master/maintenance_root_dogcat.sh | bash
```

Fix broken npm
```
apt install aptitude
aptitude reinstall nodejs
```

## Ubuntu 18.04 LTS

### MariaDB

```
sudo aptitude install mariadb-server mariadb-client
sudo systemctl status mysql
sudo mysql_secure_installation
```
Y to all questions.

To create user with full privileges.
```
sudo mysql -u root -p
```
```
CREATE USER 'me'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON *.* TO 'me'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;
```
