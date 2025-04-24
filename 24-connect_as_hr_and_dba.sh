#!/bin/bash
. config/config.sh
clear
printf "${G}--- Connect as HR (password hr) and select data ---${N}\n\n"
psql  -h localhost -U hr -c "SELECT * from customers LIMIT 1;" -x edb

printf "${G}--- Connect as DBA (password dba) and select data ---${N}\n\n"
psql  -h localhost -U dba -c "SELECT * from customers LIMIT 1;" -x edb
