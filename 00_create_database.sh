#!/bin/bash
. ./env.sh
clear
printf "${G}--- Creating database ---${N}\n\n"
psql -h $DBHOST -p 5444 -U enterprisedb -f create_table.sql edb
psql -h $DBHOST -p 5444 -U enterprisedb -c "\copy customers FROM 'customer_data.csv' WITH CSV HEADER;" edb
