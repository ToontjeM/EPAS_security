# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'
vars = YAML.load_file 'vars.yml'

VAGRANT_BOX = vars['epas']['box']
VAGRANT_BOX_VERSION = vars['epas']['box_version']
CPUS_PG_NODE = vars['epas']['cpus']
MEMORY_PG_NODE = vars['epas']['mem_size']
NETWORK = vars['epas']['network']

Vagrant.configure("2") do |config|

  if Vagrant.has_plugin?("vagrant-vbguest") then
    config.vbguest.auto_update = false
  end

  config.vm.synced_folder ".", "/vagrant"
  config.vm.provision :hosts, :sync_hosts => true

  # epas
  config.vm.define "epas" do |node|
    node.vm.box               = VAGRANT_BOX
    node.vm.box_check_update  = false
    node.vm.hostname          = "epas.home"
    node.vm.network "public_network", bridge: "en6: Thunderbolt Ethernet Slot 1", ip: NETWORK + "1"
    node.vm.provider :virtualbox do |v|
      v.name    = "epas"
      v.memory  = MEMORY_PG_NODE
      v.cpus    = CPUS_PG_NODE
    end      
    node.vm.provision "shell", path: "bootstrap_epas.sh"
  end

  # Reboot all nodes after provisioning
  config.vm.provision :reload

end