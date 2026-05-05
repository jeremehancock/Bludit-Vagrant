#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

echo -e "\e[96m*************************** Upgrade Packages ***************************\e[0m"
sudo -E apt-get update
sudo -E apt-get -y upgrade

echo -e "\e[96m*************************** Install Apache/PHP *************************\e[0m"
sudo -E apt-get install -y apache2 php libapache2-mod-php

echo -e "\e[96m*************************** Install Extra PHP Packages *****************\e[0m"
sudo -E apt-get install -y php-xml php-gd php-mbstring php-curl php-zip

echo -e "\e[96m*************************** Install Misc Packages **********************\e[0m"
sudo -E apt-get install -y vim unzip rsync

echo -e "\e[96m*************************** Install Latest Bludit **********************\e[0m"
TMP_DIR=$(mktemp -d)
sudo -E wget -nv https://www.bludit.com/releases/bludit-latest.zip -O "$TMP_DIR/bludit.zip" 2>&1
sudo -E unzip -q -o "$TMP_DIR/bludit.zip" -d "$TMP_DIR/extracted"
sudo -E mkdir -p /var/www/html/bludit
# The Bludit zip may extract either directly or inside a single wrapper
# directory (e.g. bludit-3.x.x/). Handle both layouts.
EXTRACTED_ENTRIES=("$TMP_DIR"/extracted/*)
if [ ${#EXTRACTED_ENTRIES[@]} -eq 1 ] && [ -d "${EXTRACTED_ENTRIES[0]}" ]; then
  SRC_DIR="${EXTRACTED_ENTRIES[0]}"
else
  SRC_DIR="$TMP_DIR/extracted"
fi
sudo -E rsync -a "$SRC_DIR/" /var/www/html/bludit/
sudo -E rm -rf "$TMP_DIR"
sudo -E chown -R www-data:www-data /var/www/html/bludit

echo -e "\e[96m*************************** Enable Mod Rewrite *************************\e[0m"
sudo -E a2enmod rewrite

echo -e "\e[96m*************************** Update Apache Conf *************************\e[0m"
sudo -E tee /etc/apache2/sites-available/bludit.conf > /dev/null <<'EOF'
<VirtualHost *:80>
    DocumentRoot /var/www/html/bludit
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
<Directory /var/www/html/bludit>
    Options Indexes FollowSymLinks
    AllowOverride All
    Require all granted
</Directory>
EOF
sudo -E a2dissite 000-default.conf
sudo -E a2ensite bludit.conf

echo -e "\e[96m*************************** Restart Apache *****************************\e[0m"
sudo -E systemctl restart apache2
