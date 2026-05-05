# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/jammy64"

  config.vm.network "forwarded_port", guest: 80, host: 8080

  config.vm.synced_folder "localhost/www/", "/var/www", owner: "www-data", group: "www-data"

  # Disable the vagrant-vbguest plugin if it is installed. The plugin can
  # cause provisioning failures on modern Ubuntu boxes that already ship
  # with working VirtualBox Guest Additions.
  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vbguest.auto_update = false
    config.vbguest.no_install  = true
    config.vbguest.no_remote   = true
  end

  # Define the bootstrap file: A (shell) script that runs after first setup of your box (= provisioning)
  config.vm.provision :shell, path: "setup/bootstrap.sh"

end
