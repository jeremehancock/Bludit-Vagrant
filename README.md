# Bludit-Vagrant
Vagrant for [Bludit Flat File CMS](https://www.bludit.com/)

The goal of this project is to create a quick virtual machine setup with a Bludit installation for testing and development purposes. The following technologies are automatically installed for you.
* Ubuntu Jammy (22.04 LTS)
* Apache 2
* PHP 8
* [Bludit](https://www.bludit.com/) (Latest Version)

## Pre-Installation
1. Install [Vagrant](https://www.vagrantup.com/)
2. Install [Virtual Box](https://www.virtualbox.org/)

## Installation Instructions
1. Find a directory on your computer where you'd like to install this repo
2. Run `git clone https://github.com/jeremehancock/Bludit-Vagrant.git`
3. Run `cd Bludit-Vagrant`
4. Run `vagrant up`

## Usage
1. Make sure the vagrant process is completed and your virtual machine is ready
2. Point your web browser to http://localhost:8080 to view your Bludit site
3. Follow the steps to complete the Bludit installation
4. If you'd like to login into your virtual machine - `vagrant ssh` 
5. Bludit files are located in `localhost/www/html/bludit` on your local machine and are syncronized with `/var/www/html/bludit` on your virtual machine

## Upgrade
The Bludit files are only downloaded and copied on the **first** `vagrant up`. After that, re-running `vagrant provision` or `vagrant up --provision` will re-run the other provisioning steps (Apache, PHP, etc.) but will **not** touch your existing Bludit install. This is tracked by the marker file `localhost/www/html/bludit/.bludit-installed`.

To force a fresh Bludit download (overwriting your site):
1. Back up `localhost/www/html/bludit` first
2. Delete the marker file: `rm localhost/www/html/bludit/.bludit-installed`
3. Run `vagrant provision` (or `vagrant up --provision`)

> ####  *A forced re-install will overwrite custom modifications to Bludit. It will not overwrite the content or settings that you have applied in the Bludit admin panel.*

## Cleanup
1. If you are ready to delete your Bludit virtual machine from your local machine - `vagrant destroy -f`

## AI Disclaimer
This project was originally developed without the use of AI. It has since been updated to a more modern stack with the help of AI.

## Disclaimer
All code is provided as-is without any warranty. Use at your own risk.
