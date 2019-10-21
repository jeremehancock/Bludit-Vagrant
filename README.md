# Bludit-Vagrant
Vagrant for [Bludit Flat File CMS](https://www.bludit.com/)

The goal of this project is to create a quick virtual machine setup with a Bludit installation for testing and development purposes. The following technologies are automatically installed for you:
* Ubuntu Bionic (18.04)
* Apache
* PHP
* [Bludit](https://www.bludit.com/)

## Pre-Installation
1. Install [Vagrant](https://www.vagrantup.com/)
2. Install [Virtual Box](https://www.virtualbox.org/)

## Installation Instructions
1. Find a directory on your computer that you'd like to install this repo
2. Run `git clone git@github.com:mhancoc7/Bludit-Vagrant.git`
3. Run `cd Bludit-Vagrant`
4. Run `vagrant up`

## Usage
1. Make sure the vagrant process is completed and your virtual machine is ready
2. Point your web browser to http://localhost:8080 to view your Bludit site
3. Follow the steps to complete the Bludit installation
4. If you'd like to login into your virtual machine - `vagrant ssh` 
5. Bludit files are located in `localhost/www/html` on your local machine and are syncronized with `/var/www/html` on your virtual machine

## Cleanup
1. If you are ready to delete your Bludit virtual machine from your local machine - `vagrant destroy -f`
