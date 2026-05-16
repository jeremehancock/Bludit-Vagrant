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
sudo -E apt-get install -y vim unzip rsync curl

echo -e "\e[96m*************************** Install Latest Bludit **********************\e[0m"
BLUDIT_INSTALL_MARKER=/var/www/html/bludit/.bludit-installed
if [ -f "$BLUDIT_INSTALL_MARKER" ]; then
  echo "Bludit is already installed at /var/www/html/bludit. Skipping download to preserve your site."
  echo "To force a fresh install, remove $BLUDIT_INSTALL_MARKER (and back up your site first)."
else
  TMP_DIR=$(mktemp -d)
  BLUDIT_ZIP_URL=$(curl -fsSL https://api.github.com/repos/bludit/bludit/releases/latest \
    | grep -Eo '"zipball_url"\s*:\s*"[^"]+"' \
    | head -n1 \
    | sed -E 's/.*"zipball_url"\s*:\s*"([^"]+)".*/\1/')
  if [ -z "$BLUDIT_ZIP_URL" ]; then
    echo "Failed to determine latest Bludit release URL" >&2
    exit 1
  fi
  echo "Latest Bludit release: $BLUDIT_ZIP_URL"
  sudo -E wget -nv -L "$BLUDIT_ZIP_URL" -O "$TMP_DIR/bludit.zip" 2>&1
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
  sudo -E touch "$BLUDIT_INSTALL_MARKER"
  sudo -E chown www-data:www-data "$BLUDIT_INSTALL_MARKER"
fi

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
