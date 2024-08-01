#!/bin/bash

echo "--- Running Bootstrap_general.sh ---"
export EDBTOKEN=$(cat /vagrant/.edbtoken)

echo "--- Configuring repo ---"
curl -1sLf 'https://downloads.enterprisedb.com/pdZe6pcnWIgmuqdR7v1L38rG6Z6wJEsY/enterprise/setup.rpm.sh' | sudo -E bash

echo "--- Running updates ---"
dnf update && dnf upgrade -y
sudo systemctl stop firewalld.service
sudo systemctl disable firewalld.service

echo "--- Installing EPAS 16 ---"
sudo dnf install epel-release python-pip edb-as16-server edb-as16-server-sqlprotect -y

sudo PGSETUP_INITDB_OPTIONS="-E UTF-8" /usr/edb/as16/bin/edb-as-16-setup initdb
sudo mkdir -p /var/lib/edb/as16/data/conf.d
sudo chmod 700 /var/lib/edb/as16/data/conf.d
sudo chown -R enterprisedb:enterprisedb /var/lib/edb/as16/data/conf.d
sudo systemctl enable edb-as-16
sudo systemctl start edb-as-16

echo "--- Configuring pg_hba.conf ---"
sudo su - enterprisedb -c 'echo "
local   all             all                                 trust
host    all             all             127.0.0.1/32        md5
host    all             all             192.168.0.0/24      md5

$(cat /var/lib/edb/as16/data/pg_hba.conf)" > /var/lib/edb/as16/data/pg_hba.conf'
sudo systemctl restart edb-as-16

echo "--- Enabling data redaction ---"
sudo sed -i 's/#edb_data_redaction/edb_data_redaction/g' /var/lib/edb/as16/data/postgresql.conf

echo "--- Enabling auditing ---"
cat <<EOF >>/var/lib/edb/as16/data/postgresql.auto.conf

# --- EDB Audit ---
edb_audit = 'csv'
edb_audit_directory = 'edb_audit'
edb_audit_filename = 'audit-%Y-%m-%d_%H%M%S' 
edb_audit_rotation_day = 'every' 
#edb_audit_rotation_size = 0
edb_audit_connect = 'all'           # none, failed, all
edb_audit_disconnect = 'none'          # none, all
edb_audit_statement = 'all'
edb_audit_destination = 'file'         # file or syslog
EOF

echo "--- Configure SQL/Protect ---"
sudo sed -i 's/libdir\/dbms_aq/libdir\/dbms_aq,\$libdir\/sqlprotect/g' /var/lib/edb/as16/data/postgresql.conf
cat <<EOF >>/var/lib/edb/as16/data/postgresql.auto.conf

# --- SQL/Protect ---
edb_sql_protect.enabled = on
edb_sql_protect.level = learn
edb_sql_protect.max_protected_roles = 64
edb_sql_protect.max_protected_relations = 1024
edb_sql_protect.max_queries_to_save = 5000
EOF

sudo systemctl restart edb-as-16

echo "--- Configure SQL/Protect (cont) ---"
echo "--- Create webuser for running web application ---"
sudo su - enterprisedb -c "psql -c \"CREATE USER webuser WITH PASSWORD 'webuser';\" edb"
sudo su - enterprisedb -c "psql -c \"CREATE DATABASE webapp OWNER webuser;\" edb"
sudo su - enterprisedb -c "psql -c \"CREATE SCHEMA webapp;\" webapp"
sudo su - enterprisedb -c "psql -c \"ALTER SCHEMA webapp OWNER TO webuser;\" webapp"
sudo su - enterprisedb -c "psql -c \"SET search_path = webapp, pg_catalog;\" webapp"
sudo su - enterprisedb -c "psql -f /usr/edb/as16/share/contrib/sqlprotect.sql webapp"

echo "--- Configuring Flask application ---"
sudo yum install python3-pip python3-devel gcc
sudo dnf install nginx supervisor -y
sudo systemctl start supervisord.service 
sudo systemctl enable supervisord.service 
pip3 install gunicorn flask psycopg2-binary
sudo cat <<EOF >>/etc/supervisord.d/sqlprotect.ini
[program:sqlprotect]                                                                  
command = python sqlinjection.py                                      
directory = /vagrant                            
autostart = true                                                                
autorestart = true
EOF
sudo systemctl start supervisord
sudo supervisorctl update
sudo supervisorctl status

sudo systemctl restart edb-as-16
sudo systemctl status edb-as-16

echo "--- Creating demo database ---"
sudo su - enterprisedb -c "psql -f /vagrant/create_table.sql edb"
sudo su - enterprisedb -c "psql -c \"\copy customers FROM '/vagrant/customer_data.csv' WITH CSV HEADER;\" edb"
sudo su - enterprisedb -c "psql -c \"DELETE FROM customers WHERE length(creditcard) != 16;\" edb"
sudo su - enterprisedb -c "psql -U webuser -f /vagrant/create_table.sql webapp"
sudo su - enterprisedb -c "psql -U webuser -c \"\copy customers FROM '/vagrant/customer_data.csv' WITH CSV HEADER;\" webapp"

echo "--- Setting password for user enterprisedb ---"
sudo su - enterprisedb -c "psql -c \"ALTER ROLE enterprisedb IDENTIFIED BY enterprisedb superuser;\" edb"
