#!/bin/bash

DEBIAN_FRONTEND=noninteractive

echo -e "\e[96m*************************** Upgrade Packages ***************************\e[0m"
sudo -E apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get -y upgrade

echo -e "\e[96m*************************** Install Apache/PHP *************************\e[0m"
sudo -E apt-get install -y apache2
sudo -E apt-get install -y php

echo -e "\e[96m*************************** Install Extra PHP Packages *****************\e[0m"
sudo -E apt-get install -y php-xml
sudo -E apt-get install -y php-gd
sudo -E apt-get install -y php.mbstring
sudo -E apt-get install -y php-json

echo -e "\e[96m*************************** Install Misc Packages **********************\e[0m"
sudo -E apt-get install -y vim
sudo -E apt-get install -y unzip

echo -e "\e[96m*************************** Install Latest Bludit **********************\e[0m"
cd /var/www/
sudo -E wget https://www.bludit.com/releases/bludit-latest.zip -O temp.zip;
sudo -E unzip temp.zip 
sudo -E rm temp.zip
sudo -E rsync -a bludit*/ html/
sudo -E rm -rf bludit*
cd ~

echo -e "\e[96m*************************** Remove Default Index File ******************\e[0m"
if [ -f "/var/www/html/index.html" ]; then
  sudo -E rm /var/www/html/index.html
fi

echo -e "\e[96m*************************** Enable Mod Rewrite *************************\e[0m"
sudo -E a2enmod rewrite

echo -e "\e[96m*************************** Update Apache Conf *************************\e[0m"
sudo -E echo "<Directory /var/www/html>" | sudo -E  tee -a /etc/apache2/sites-available/000-default.conf
sudo -E echo "    Options Indexes FollowSymLinks" | sudo -E tee -a /etc/apache2/sites-available/000-default.conf
sudo -E echo "    AllowOverride All" | sudo -E tee -a /etc/apache2/sites-available/000-default.conf
sudo -E echo "    Require all granted" | sudo -E tee -a /etc/apache2/sites-available/000-default.conf
sudo -E echo "</Directory>" | sudo -E tee -a /etc/apache2/sites-available/000-default.conf

echo -e "\e[96m*************************** Restart Apache *****************************\e[0m"
sudo -E service apache2 restart
