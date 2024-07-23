#!/bin/bash

echo "--- Running Bootstrap_general.sh ---"
export EDBTOKEN=$(cat /vagrant/.edbtoken)

echo "--- Configuring repo ---"
EDBTOKEN=$(cat /vagrant/.edbtoken)
curl -1sLf 'https://downloads.enterprisedb.com/pdZe6pcnWIgmuqdR7v1L38rG6Z6wJEsY/enterprise/setup.rpm.sh' | sudo -E bash

echo "--- Running updates ---"
dnf update && dnf upgrade -y
sudo systemctl stop firewalld.service
sudo systemctl disable firewalld.service

echo "--- Installing EPAS 16 ---"
dnf install edb-as16-server -y

sudo PGSETUP_INITDB_OPTIONS="-E UTF-8" /usr/edb/as16/bin/edb-as-16-setup initdb
sudo mkdir -p /var/lib/edb/as16/data/conf.d
sudo chmod 700 /var/lib/edb/as16/data/conf.d
sudo chown -R enterprisedb:enterprisedb /var/lib/edb/as16/data/conf.d
sudo systemctl enable edb-as-16
sudo systemctl start edb-as-16

echo "--- Configuring pg_hba.conf ---"
sudo systemctl stop edb-as-16
sudo su - enterprisedb -c 'echo "
local   all             all                                 trust
host    all             all             127.0.0.1/32        md5
host    all             all             192.168.0.0/24      md5

$(cat /var/lib/edb/as16/data/pg_hba.conf)" > /var/lib/edb/as16/data/pg_hba.conf'
sudo systemctl restart edb-as-16
sudo systemctl status edb-as-16

echo "--- Setting password for user enterprisedb ---"
sudo su - enterprisedb -c "psql -c \"ALTER ROLE enterprisedb IDENTIFIED BY enterprisedb superuser;\" edb"
echo "--- Creating database ---"
psql -h $DBHOST -p 5444 -U enterprisedb -f create_table.sql edb
psql -h $DBHOST -p 5444 -U enterprisedb -c "\copy customers FROM 'customer_data.csv' WITH CSV HEADER;" edb
