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
cd /var/www/html
sudo -E wget https://www.bludit.com/releases/bludit-latest.zip -O temp.zip;
sudo -E unzip temp.zip 
sudo -E rm temp.zip
sudo -E mkdir bludit
sudo -E rsync -a bludit-*/ bludit/
sudo -E rm -rf bludit-*
cd ~

echo -e "\e[96m*************************** Enable Mod Rewrite *************************\e[0m"
sudo -E a2enmod rewrite

echo -e "\e[96m*************************** Update Apache Conf *************************\e[0m"
if [ -f "/etc/apache2/sites-available/bludit.conf" ]; then
  sudo -E rm /etc/apache2/sites-available/bludit.conf
fi
sudo -E touch /etc/apache2/sites-available/bludit.conf
sudo -E echo "<VirtualHost *:80>" | sudo -E tee -a /etc/apache2/sites-available/bludit.conf
sudo -E echo "	  DocumentRoot /var/www/html/bludit" | sudo -E tee -a /etc/apache2/sites-available/bludit.conf
sudo -E echo "	  ErrorLog ${APACHE_LOG_DIR}/error.log" | sudo -E tee -a /etc/apache2/sites-available/bludit.conf
sudo -E echo "	  CustomLog ${APACHE_LOG_DIR}/access.log combined" | sudo -E tee -a /etc/apache2/sites-available/bludit.conf
sudo -E echo "</VirtualHost>" | sudo -E tee -a /etc/apache2/sites-available/bludit.conf
sudo -E echo "<Directory /var/www/html/bludit>" | sudo -E tee -a /etc/apache2/sites-available/bludit.conf
sudo -E echo "    Options Indexes FollowSymLinks" | sudo -E tee -a /etc/apache2/sites-available/bludit.conf
sudo -E echo "    AllowOverride All" | sudo -E tee -a /etc/apache2/sites-available/bludit.conf
sudo -E echo "    Require all granted" | sudo -E tee -a /etc/apache2/sites-available/bludit.conf
sudo -E echo "</Directory>" | sudo -E tee -a /etc/apache2/sites-available/bludit.conf
sudo -E a2dissite 000-default.conf
sudo -E a2ensite bludit.conf

echo -e "\e[96m*************************** Restart Apache *****************************\e[0m"
sudo -E service apache2 restart
