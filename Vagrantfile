# -*- mode: ruby -*-
# vi: set ft=ruby :

# VM
var_box            = "bento/almalinux-9.5"
var_box_version    = "202502.21.0"

# Credentials
file_token = "#{ENV['HOME']}/tokens/.edb_subscription_token"

if File.exist?(file_token)
  credentials = File.read(file_token)
  puts
  puts "Credential file exists"
else
  puts ""
  puts "***********************************************"
  puts "Error:"
  puts "~/.edb_subscription_token file doesn't exists."
  puts "Please, create file :"
  puts "echo '<your_token>' > ~/.edb_subscription_token"
  puts "***********************************************"
  puts ""
  exit(1) # Stop the program with an error code
end

vm_name            = ENV['VM1_NAME']
vm_memory          = ENV['VM1_MEMORY']
vm_cpu             = ENV['VM1_CPU']
vm_public_ip       = ENV['VM1_PUBLIC_IP']
vm_port            = ENV['VM1_PORT']
vm_ssh_port        = ENV['VM1_SSH_PORT']

if ENV['VM1_NAME'].nil? || ENV['VM1_NAME'].empty?
  puts ""
  puts "**************************************************"
  puts "Please, run this script from 00-provision.sh"
  puts "**************************************************"
  puts ""
  exit(1)
end

# Debug
puts
puts "IMAGE:       " + var_box
puts "BOX VERSION: " + var_box_version
puts "VM NAME:     " + vm_name
puts "VM MEMORY:   " + vm_memory
puts "VM CPU:      " + vm_cpu
puts "VM PORT:     " + vm_public_ip
puts "PUBLIC IP:   " + vm_port
puts "SSH PORT:    " + vm_ssh_port
puts""

Vagrant.configure("2") do |config|

  if Vagrant.has_plugin?("vagrant-vbguest") then
    config.vbguest.auto_update = false
  end

  # Upgrade hosts
  if Vagrant.has_plugin?("vagrant-host") then
    config.vm.provision :hosts, :sync_hosts => true
  end

  # Box
  config.vm.box = var_box
  config.vm.box_version = var_box_version

  # VM config
  config.vm.provider "virtualbox" do |vb|
    vb.cpus   = vm_cpu
    vb.memory = vm_memory
    vb.name   = vm_name
  end
    
  # Network
  config.vm.network "private_network", ip: vm_public_ip, netmask: "255.255.255.0"
  config.vm.network "forwarded_port", guest: 22, host: vm_ssh_port
  config.vm.network "forwarded_port", guest: 5000, host: 5000
  
  # Share files
  config.vm.synced_folder ".", "/vagrant", type: "rsync"
  config.vm.synced_folder "./scripts", "/vagrant_scripts", type: "rsync"
  config.vm.synced_folder "./config", "/vagrant_config", type: "rsync"
  config.vm.synced_folder "~/tokens", "/tokens", type: "rsync"

  # Install software
  config.vm.provision "shell", inline: <<-SHELL
    # Install Postgres
    sudo sh /vagrant_scripts/install.sh
#    sudo cp /vagrant_scripts/etc_motd.txt /etc/motd
  SHELL

end