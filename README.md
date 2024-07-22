# EDB Failover Manager demo (WIP)

## Intro
This demo is deployed using Vagrant and will deploy an EDB Postgres Advanced Server node.

## Demo prep
### Pre-requisites
To deploy this demo the following needs to be installed in the PC from which you are going to deploy the demo:

- VirtualBox (https://www.virtualbox.org/)
- Vagrant (https://www.vagrantup.com/)
- Vagrant Hosts plug-in (`vagrant plugin install vagrant-hosts`)
- Vagrant Reload plug-in (`vagrant plugin install vagrant-reload`)
- A file called `.edbtoken` with your EDB repository 2.0 token. This token can be found in your EDB account profile here: https://www.enterprisedb.com/accounts/profile

The environment is deloyed in a VirtualBox private network. Adjust the IP addresses to your needs in `vars.yml`.

### Provisioning VM's.
Provision the host using `vagrant up`. This will create the bare virtual machine and will take appx. 5 minutes to complete. 

After provisioning, the hosts will have the current directory mounted in their filesystem under `/vagrant`


### Passwords
Postgres and Enterprisedb users have passwords `postgres` and `enterprisedb`.


## Demo cleanup
To clean up the demo environment you just have to run `vagrant destroy`. This will remove the virtual machines and everything in it.

## TODO / To fix
