# Bludit-Vagrant

Vagrant setup for [Bludit Flat File CMS](https://www.bludit.com/).

The goal of this project is to create a quick virtual machine environment with a Bludit installation for testing and development purposes. You can halt and resume the VM without overwriting your Bludit install.

The following technologies are automatically installed for you:

* Ubuntu Jammy (22.04 LTS)
* Apache 2
* PHP 8
* [Bludit](https://www.bludit.com/) (Latest Version)

## Pre-Installation

1. Install [Vagrant](https://www.vagrantup.com/)
2. Install [VirtualBox](https://www.virtualbox.org/)

## Installation Instructions

1. Find a directory on your computer where you'd like to install this repo
2. Run `git clone https://github.com/jeremehancock/Bludit-Vagrant.git`
3. Run `cd Bludit-Vagrant`
4. Run `vagrant up`

On the first `vagrant up` the provisioner will:

* Install Apache 2, PHP 8, and the required PHP extensions
* Query the GitHub API for the **latest** Bludit release
* Download and extract the zip into `/var/www/html/bludit` (synced to `localhost/www/html/bludit` on your host)
* Drop a marker file (`.bludit-installed`) so subsequent provisions skip the download
* Configure Apache (`mod_rewrite`, virtual host with `DocumentRoot` pointing at the Bludit directory)
* Start Apache

## Usage

1. Wait for the `vagrant up` process to finish and the VM to be ready
2. Point your web browser to [http://localhost:8080](http://localhost:8080) to view your Bludit site
3. Follow the steps to complete the Bludit installation
4. If you'd like a shell inside the running VM:
   ```
   vagrant ssh
   ```
5. Bludit files are located in `localhost/www/html/bludit` on your local machine and are synced to `/var/www/html/bludit` inside the VM

## Start / Stop

Because Bludit lives in a synced folder on your host, you can halt and resume the VM freely without losing your site.

* Halt the VM (keep data):
  ```
  vagrant halt
  ```
* Start it again later:
  ```
  vagrant up
  ```
* Reload the VM (apply Vagrantfile changes):
  ```
  vagrant reload
  ```

## Upgrade

Bludit is only downloaded and copied on the **first** `vagrant up`. After that, re-running `vagrant provision` or `vagrant up --provision` will re-apply the Apache/PHP provisioning steps but will **not** touch your existing Bludit install. This is tracked by the marker file `localhost/www/html/bludit/.bludit-installed`.

To force a fresh Bludit download (overwriting your site):

1. Back up `localhost/www/html/bludit` first
2. Delete the marker file:
   ```
   rm localhost/www/html/bludit/.bludit-installed
   ```
3. Re-run provisioning:
   ```
   vagrant provision
   ```

> A forced re-install will overwrite custom modifications to Bludit. It will not overwrite the content or settings that you have applied in the Bludit admin panel (those live under `bl-content/` and are preserved), but you should still back up first.

## Cleanup

* Halt the VM but keep your Bludit site on disk:
  ```
  vagrant halt
  ```
* Destroy the VM, **but** keep your local Bludit install:
  ```
  vagrant destroy -f
  ```
* Destroy the VM **and** remove your local Bludit install:
  ```
  vagrant destroy -f
  rm -rf localhost/www/html/bludit
  ```

## Project Layout

```
Bludit-Vagrant/
├── Vagrantfile              # VM definition (Ubuntu 22.04), port forward, synced folder
├── setup/
│   └── bootstrap.sh         # Installs Apache/PHP and downloads latest Bludit on first run
└── localhost/
    └── www/
        └── html/            # Synced to /var/www/html inside the VM
            └── bludit/      # Bludit lives here after first vagrant up (gitignored)
```

## AI Disclaimer

This project was originally developed without the use of AI. It has since been updated to a more modern stack with the help of AI.
