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

To create a development user with full privileges.
```
sudo mysql -u root -p
```
```
CREATE USER 'me'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON *.* TO 'me'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EXIT
```

### Nginx

```
sudo aptitude install nginx
sudo systemctl status nginx
```
Let's Encrypt!
```
sudo add-apt-repository ppa:certbot/certbot
sudo aptitude update
sudo aptitude install letsencrypt
```
Set default configuration to handle Let's Encrypt and redirect to HTTPS
```
sudo mkdir -p /var/www/letsencrypt
sudo nano /etc/nginx/sites-available/default
```
```
server {
	listen 80 default_server;
	listen [::]:80 default_server;

	# listen 443 ssl default_server;
	# listen [::]:443 ssl default_server;

	root /var/www/html;

	# Add index.php to the list if you are using PHP
	index index.html index.htm index.nginx-debian.html;

	server_name _;

	location ~ /\.well-known/acme-challenge/ {
		allow all;
		root /var/www/letsencrypt;
		try_files $uri =404;
	}

	location / {
		# First attempt to serve request as file, then
		# as directory, then fall back to displaying a 404.
		try_files $uri $uri/ =404;
	}

	# pass PHP scripts to FastCGI server
	#location ~ \.php$ {
	#	include snippets/fastcgi-php.conf;
	#
	#	# With php-fpm (or other unix sockets):
	#	fastcgi_pass unix:/var/run/php/php7.2-fpm.sock;
	#}

	# deny access to .htaccess files, if Apache's document root
	# concurs with nginx's one
	#
	#location ~ /\.ht {
	#	deny all;
	#}
}

# Virtual Host configuration for example.com
#
# You can move that to a different file under sites-available/ and symlink that
# to sites-enabled/ to enable it.
#
#server {
#	listen 443 ssl;
#	listen [::]:443 ssl;
#
#	server_name example.com;
#
#	root /var/www/example.com;
#	index index.html;
#
#	location / {
#		try_files $uri $uri/ =404;
#	}
#}

```
