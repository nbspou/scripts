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

References
* https://www.tecmint.com/install-nginx-mariadb-php-in-ubuntu-18-04/
* https://itsyndicate.org/blog/install-letsencrypt-on-ubuntu-16-04-and-ubuntu-18-04/
* https://bjornjohansen.no/redirect-to-https-with-nginx

### MariaDB
```
sudo apt-get install software-properties-common
sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8
sudo add-apt-repository 'deb [arch=amd64,arm64,ppc64el] http://sgp1.mirrors.digitalocean.com/mariadb/repo/10.3/ubuntu bionic main'
```
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
Generate a self signed certificate for development
```
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt
```
Let's Encrypt! Generate a certificate for a domain
```
sudo add-apt-repository ppa:certbot/certbot
sudo aptitude update
sudo aptitude install letsencrypt
```
Set default configuration to handle Let's Encrypt and redirect to HTTPS
Use self signed certificate for non-domain
```
sudo mkdir -p /var/www/letsencrypt
sudo nano /etc/nginx/sites-available/default
```
```
server {
	listen 80 default_server;
	listen [::]:80 default_server;

	server_name _;

	location ~ /\.well-known/acme-challenge/ {
		allow all;
		root /var/www/letsencrypt;
		try_files $uri =404;
	}

	location / {
		return 301 https://$host$request_uri;
	}
}

server {
	# listen 80 default_server;
	# listen [::]:80 default_server;

	listen 443 ssl default_server;
	listen [::]:443 ssl default_server;
	
	ssl on;
	ssl_certificate /etc/ssl/certs/nginx-selfsigned.crt;
	ssl_certificate_key /etc/ssl/private/nginx-selfsigned.key;

	root /var/www/html;

	# Add index.php to the list if you are using PHP
	index index.html index.htm index.nginx-debian.html;

	server_name _;

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
```
```
sudo nginx -t
sudo service nginx reload
```
```
sudo letsencrypt certonly -a webroot --webroot-path=/var/www/letsencrypt -m mail@example.com --agree-tos -d example.com
```
```
sudo mkdir -p /var/www/example.com
sudo nano /etc/nginx/sites-available/default
```
```
server {
	listen 443 ssl;
	listen [::]:443 ssl;

	root /var/www/example.com;
	
	ssl on;
	ssl_certificate     /etc/letsencrypt/live/example.com/fullchain.pem;
	ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem;

	index index.html;
	
	server_name example.com;
	
	location / {
		try_files $uri $uri/ =404;
	}
}
```
```
sudo nginx -t
sudo service nginx reload
```
Set up automatic certificate renewal
```
sudo nano /etc/cron.daily/letsencrypt
```
```
#!/bin/bash
/usr/bin/letsencrypt renew --renew-hook "/etc/init.d/nginx reload"
```

### PHP

```
sudo aptitude install php-fpm php-common php-mysql php-gd php-cli
sudo systemctl status php7.2-fpm
sudo nano /etc/nginx/sites-available/default
```
Settings individual to each virtual host
```
	index index.html index.htm index.nginx-debian.html index.php;
```
```
	location ~ \.php$ {
		include snippets/fastcgi-php.conf;
		fastcgi_pass unix:/var/run/php/php7.2-fpm.sock;
	}
```
```
sudo nginx -t
sudo service nginx reload
```
```
echo "<?php phpinfo(); ?>" | sudo tee /var/www/html/info.php
```

### phpMyAdmin

```
sudo aptitude install phpmyadmin
```
No automatic install (tab, enter), automated password, don't put your root password here since it will be stored plaintext.

May replace `html` in path with `localhost` or with the public domain, whichever is needed.
```
sudo ln -s  /usr/share/phpmyadmin /var/www/html/phpmyadmin
```
