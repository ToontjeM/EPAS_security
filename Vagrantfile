# -*- mode: ruby -*-
# vi: set ft=ruby :

# VM
var_box            = "bento/almalinux-9.5"
var_box_version    = "202502.21.0"

Vagrant.configure("2") do |config|

  if Vagrant.has_plugin?("vagrant-vbguest") then
    config.vbguest.auto_update = false
  end

  # Box
  config.vm.box = var_box
  config.vm.box_version = var_box_version

  # Share files
  #config.vm.synced_folder ".", "/vagrant", type: "rsync"
  #config.vm.synced_folder "./scripts", "/scripts", type: "rsync"
  #config.vm.synced_folder "./config", "/config", type: "rsync"
  #config.vm.synced_folder "#{ENV['HOME']}/tokens", "/tokens", type: "rsync"
  config.vm.synced_folder ".", "/vagrant"
  config.vm.synced_folder "./scripts", "/scripts"
  config.vm.synced_folder "./config", "/config"
  config.vm.synced_folder "#{ENV['HOME']}/tokens", "/tokens"
  config.vm.provision :hosts, :sync_hosts => true
  
  # VM config
  config.vm.define "epas" do |node|
    node.vm.network "private_network", ip: "192.168.56.10"
    node.vm.network "forwarded_port", guest: 5000, host: 1234
    node.vm.network "forwarded_port", guest: 5444, host: 5444
    node.vm.provider "virtualbox" do |v|
      v.cpus   = 1
      v.memory = 1024
      v.name   = "epas17"
    end
    node.vm.provision "shell", path: "scripts/install.sh"
  end
end