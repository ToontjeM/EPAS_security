
#!/bin/bash
. ./env.sh
clear
printf "${G}--- Connect as HR (password hr) and select data ---${N}\n\n"
psql -h $DBHOST -p 5444 -U hr -c "SELECT * from customers LIMIT 1;" -x edb

printf "${G}--- Connect as DBA (password dba) and select data ---${N}\n\n"
psql -h $DBHOST -p 5444 -U dba -c "SELECT * from customers LIMIT 1;" -x edb
