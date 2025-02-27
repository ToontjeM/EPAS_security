#!/bin/bash

echo "--- Running install.sh ---"

. /vagrant_config/config.sh

echo "--- Configuring repo with repo token ${EDB_SUBSCRIPTION_TOKEN} ---"
curl -1sLf "https://downloads.enterprisedb.com/${EDB_SUBSCRIPTION_TOKEN}/enterprise/setup.rpm.sh" | sudo -E bash

echo "--- Running updates ---"
dnf update && dnf upgrade -y
sudo systemctl stop firewalld.service
sudo systemctl disable firewalld.service

echo "--- Installing ${DATABASE} ${DATABASEVERSION} ---"

if [ "$DATABASE" == "epas" ]; then
    DATABASEPREFIX="as"
    DATABASEPREFIXEDB="edb-as"
fi

sudo dnf install -y epel-release python3-pip ${DATABASEPREFIXEDB}${DATABASEVERSION}-server ${DATABASEPREFIXEDB}${DATABASEVERSION}-server-sqlprotect
sudo PGSETUP_INITDB_OPTIONS="-E UTF-8" /usr/edb/as${DATABASEVERSION}/bin/${DATABASEPREFIXEDB}-${DATABASEVERSION}-setup initdb
sudo mkdir -p /var/lib/edb/${DATABASEPREFIX}${DATABASEVERSION}/data/conf.d
sudo chmod 700 /var/lib/edb/${DATABASEPREFIX}${DATABASEVERSION}/data/conf.d
sudo chown -R enterprisedb:enterprisedb /var/lib/edb/${DATABASEPREFIX}${DATABASEVERSION}/data/conf.d
sudo systemctl enable ${DATABASEPREFIXEDB}-${DATABASEVERSION}
sudo systemctl start ${DATABASEPREFIXEDB}-${DATABASEVERSION}

echo "--- Configuring pg_hba.conf ---"
sudo sed -i 's/127.0.0.1\/32,0.0.0.0\/0/g' /var/lib/edb/${DATABASEPREFIX}${DATABASEVERSION}/data/pg_hba.conf

sudo systemctl restart ${DATABASEPREFIXEDB}-${DATABASEVERSION}

echo "--- Enabling data redaction ---"
sudo sed -i 's/#edb_data_redaction/edb_data_redaction/g' /var/lib/edb/${DATABASEPREFIX}${DATABASEVERSION}/data/postgresql.conf

echo "--- Enabling auditing ---"
cat <<EOF >>/var/lib/edb/${DATABASEPREFIX}${DATABASEVERSION}/data/postgresql.auto.conf

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
sudo sed -i 's/libdir\/dbms_aq/libdir\/dbms_aq,\$libdir\/sqlprotect/g' /var/lib/edb/as${DATABASEVERSION}/data/postgresql.conf
cat <<EOF >>/var/lib/edb/${DATABASEPREFIX}${DATABASEVERSION}/data/postgresql.auto.conf

# --- SQL/Protect ---
edb_sql_protect.enabled = on
edb_sql_protect.level = learn
edb_sql_protect.max_protected_roles = 64
edb_sql_protect.max_protected_relations = 1024
edb_sql_protect.max_queries_to_save = 5000
EOF

sudo systemctl restart ${DATABASEPREFIXEDB}-${DATABASEVERSION}

echo "--- Configure SQL/Protect (cont) ---"
echo "--- Create webuser for running web application ---"
sudo su - enterprisedb -c "psql -c \"CREATE USER webuser WITH PASSWORD 'webuser';\" edb"
sudo su - enterprisedb -c "psql -c \"CREATE DATABASE webapp OWNER webuser;\" edb"
sudo su - enterprisedb -c "psql -c \"CREATE SCHEMA webapp;\" webapp"
sudo su - enterprisedb -c "psql -c \"ALTER SCHEMA webapp OWNER TO webuser;\" webapp"
sudo su - enterprisedb -c "psql -c \"SET search_path = webapp, pg_catalog;\" webapp"
sudo su - enterprisedb -c "psql -f /usr/edb/${DATABASEPREFIX}${DATABASEVERSION}/share/contrib/sqlprotect.sql webapp"

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

sudo systemctl restart ${DATABASEPREFIXEDB}-${DATABASEVERSION}
sudo systemctl status ${DATABASEPREFIXEDB}-${DATABASEVERSION}

echo "--- Creating demo database ---"
sudo su - enterprisedb -c "psql -f /vagrant_scripts/create_table.sql edb"
sudo su - enterprisedb -c "psql -c \"\copy customers FROM '/vagrant_scripts/customer_data.csv' WITH CSV HEADER;\" edb"
sudo su - enterprisedb -c "psql -c \"DELETE FROM customers WHERE length(creditcard) != 16;\" edb"

echo "--- Setting password for user enterprisedb ---"
sudo su - enterprisedb -c "psql -c \"ALTER ROLE enterprisedb IDENTIFIED BY enterprisedb superuser;\" edb"
