# Bludit-Vagrant
Vagrant for [Bludit Flat File CMS](https://www.bludit.com/)

The goal of this project is to create a quick virtual machine setup with a Bludit installation for testing and development purposes. The following technologies are automatically installed for you.
* Ubuntu Bionic (18.04)
* Apache
* PHP
* [Bludit](https://www.bludit.com/) (Latest Version)

## Pre-Installation
1. Install [Vagrant](https://www.vagrantup.com/)
2. Install [Virtual Box](https://www.virtualbox.org/)

## Installation Instructions
1. Find a directory on your computer where you'd like to install this repo
2. Run `git clone https://github.com/mhancoc7/Bludit-Vagrant.git`
3. Run `cd Bludit-Vagrant`
4. Run `vagrant up`

## Usage
1. Make sure the vagrant process is completed and your virtual machine is ready
2. Point your web browser to http://localhost:8080 to view your Bludit site
3. Follow the steps to complete the Bludit installation
4. If you'd like to login into your virtual machine - `vagrant ssh` 
5. Bludit files are located in `localhost/www/html` on your local machine and are syncronized with `/var/www/html` on your virtual machine

## Upgrade
* If vagrant is already up - `vagrant provision`
* If vagrant has been halted - `vagrant up --provision`

> Keep in mind upgrading will remove any custom modifications that you have made to Bludit. It will not overwrite the content or settings that you have applied in the Bludit admin panel. 

## Cleanup
1. If you are ready to delete your Bludit virtual machine from your local machine - `vagrant destroy -f`

## Disclaimer
All code is provided as-is without any warranty. Use at your own risk.
