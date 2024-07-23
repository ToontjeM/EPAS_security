# EDB Postgres Advanced Server security enhancements

## Intro
This demo is deployed using Vagrant and will deploy one EDB Postgres Advanced Server node.

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

### Userid and Passwords
- enterprisedb / enterprisedb (Owner of the instance)

## Demo flow
### Use case 1: Password Profile Management
1. `11_show_profiles.sh` shows which profiles are available on the server.
2. `12_create_new_admin_profile.sh` creates a new, more restricted, password profile for a second admin user `admin2`
3. `13_change_password.sh` shows a failed password re-use attempt because of the more restrictive password policy in place.
```
ERROR:  password cannot be reused
DETAIL:  The password_reuse_time constraint failed.
```
4. `14_brute_force_admin2.sh` attempts to connect to the database using incorrect credentials. At the 4th attempt, the `admin2` account will be locked.
```
psql: error: connection to server at "192.168.0.211", port 5444 failed: FATAL:  role "admin2" is locked
```
5. `15_unlock_account.sh` unlocks the account.
```
psql -h 192.168.0.211 -p 5444 -U admin2 edb

Password for user admin2: 
psql (16.3 (Homebrew), server 16.3.0)
WARNING: psql major version 16, server major version 16.
         Some psql features might not work.
Type "help" for help.

edb=> 
```

### Use case 2: Virtual Private Databases


### Use case 3: Redacting data
1. `21_show_customers.sh` shows the content of the `customers` table.
2. `22_create_users.sh` created two users, `hr` and `dba`.
3. `23_create_retention_policies.sh` will create two posicies:
    1. User `hr` will be able to see the full credit card number, but will not be able to see the users password.
    2. User `dba` will be able to see the passwords, but will not be able to see the credit card details.
    
    First the redaction functions will be created, then the policies will be defined using those functions.
4. `24_connect_as_hr_and_dba.sh` will show the data when connected as `hr` or as `dba`.
```
edb=> \c edb hr
psql (16.3 (Homebrew), server 16.3.0)
WARNING: psql major version 16, server major version 16.
         Some psql features might not work.
You are now connected to database "edb" as user "hr".
edb=> select * from customers limit 1;
-[ RECORD 1 ]--------+------------------------
customerid           | 1
firstname            | Justin
lastname             | Elliott
address1             | 373 Wendy Island
address2             | Suite 539
city                 | Gravesville
state                | 
zip                  | 74741
country              | Pitcairn Islands
region               | 3
email                | claytonking@example.net
phone                | 
creditcardtype       | 3
creditcard           | 4549209759447656
creditcardexpiration | 08/29
username             | shelly12
password             | 0
age                  | 49
income               | 133186
gender               | M


edb=> \c edb dba
Password for user dba: 
psql (16.3 (Homebrew), server 16.3.0)
WARNING: psql major version 16, server major version 16.
         Some psql features might not work.
You are now connected to database "edb" as user "dba".
edb=> select * from customers limit 1;
-[ RECORD 1 ]--------+------------------------
customerid           | 1
firstname            | Justin
lastname             | Elliott
address1             | 373 Wendy Island
address2             | Suite 539
city                 | Gravesville
state                | 
zip                  | 74741
country              | Pitcairn Islands
region               | 3
email                | claytonking@example.net
phone                | 
creditcardtype       | 3
creditcard           | xxxxxxxxxxx47656
creditcardexpiration | 08/29
username             | shelly12
password             | 3@l2LuHBG(
age                  | 49
income               | 133186
gender               | M
```




## Demo cleanup
To clean up the demo environment you just have to run `vagrant destroy`. This will remove the virtual machines and everything in it.

## TODO / To fix
### Prep
Create web application that allows for SQL injection

Enable Audit logging

### Demos

Virtual Private Database


SQL Wrap

Transparent Data Encryption

SQL Protect

Audit Log
