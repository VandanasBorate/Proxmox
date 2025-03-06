#!/usr/bin/env bash

# Copyright (c) 2021-2025 tteck
# Author: tteck
# Co-Author: MickLesk (Canbiz)
# License: MIT
# https://github.com/community-scripts/ProxmoxVE/raw/main/LICENSE
# Source: https://www.mysql.com/products/community | https://www.phpmyadmin.net

source /dev/stdin <<< "$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

#msg_info "Installing Dependencies"
$STD apt-get install -y \
  sudo \
  lsb-release \
  curl \
  gnupg \
  mc
msg_ok "Installed Dependencies"

# Set the MySQL version automatically (no user prompt)
RELEASE_REPO="mysql-8.0"
RELEASE_AUTH="mysql_native_password"

#msg_info "Installing MySQL"
curl -fsSL https://repo.mysql.com/RPM-GPG-KEY-mysql-2023 | gpg --dearmor  -o /usr/share/keyrings/mysql.gpg
echo "deb [signed-by=/usr/share/keyrings/mysql.gpg] http://repo.mysql.com/apt/debian $(lsb_release -sc) ${RELEASE_REPO}" >/etc/apt/sources.list.d/mysql.list
$STD apt-get update
export DEBIAN_FRONTEND=noninteractive
$STD apt-get install -y \
  mysql-community-client \
  mysql-community-server
msg_ok "Installed MySQL  Version 8.0.41"

#msg_info "Configure MySQL Server"
ADMIN_PASS="$(openssl rand -base64 18 | cut -c1-13)"
$STD mysql -uroot -p"$ADMIN_PASS" -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH $RELEASE_AUTH BY '$ADMIN_PASS'; FLUSH PRIVILEGES;"
echo "" >~/mysql.creds
echo -e "MySQL user: root" >>~/mysql.creds
echo -e "MySQL password: $ADMIN_PASS" >>~/mysql.creds
msg_ok "MySQL Server configured"

# PhpMyAdmin installation will be automatic (no user prompt)
#msg_info "Installing PHPMyAdmin"
$STD apt-get install -y \
  apache2 \
  php \
  php-mysqli \
  php-mbstring \
  php-zip \
  php-gd \
  php-json \
  php-curl

wget -q "https://files.phpmyadmin.net/phpMyAdmin/5.2.1/phpMyAdmin-5.2.1-all-languages.tar.gz"
mkdir -p /var/www/html/phpMyAdmin
tar xf phpMyAdmin-5.2.1-all-languages.tar.gz --strip-components=1 -C /var/www/html/phpMyAdmin
cp /var/www/html/phpMyAdmin/config.sample.inc.php /var/www/html/phpMyAdmin/config.inc.php
SECRET=$(openssl rand -base64 24)
sed -i "s#\$cfg\['blowfish_secret'\] = '';#\$cfg['blowfish_secret'] = '${SECRET}';#" /var/www/html/phpMyAdmin/config.inc.php
chmod 660 /var/www/html/phpMyAdmin/config.inc.php
chown -R www-data:www-data /var/www/html/phpMyAdmin
systemctl restart apache2
msg_ok "Installed PHPMyAdmin version 5.2.1"

#msg_info "Start Service"
systemctl enable -q --now mysql
msg_ok "Service started"

motd_ssh
customize

#msg_info "Cleaning up"
$STD apt-get -y autoremove
$STD apt-get -y autoclean
#msg_ok "Cleaned"
