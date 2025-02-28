#!/bin/bash
. ./env.sh

printf "${G}\n--- Switching to passive state ---${N}\n\n"
printf "${R}alter system set edb_sql_protect.level to 'passive';${N}\n\n"
psql -h $DBHOST -p 5444 -U enterprisedb -c "alter system set edb_sql_protect.level to 'passive';" webapp
psql -h $DBHOST -p 5444 -U enterprisedb -c "select pg_reload_conf();" webapp
psql -h $DBHOST -p 5444 -U enterprisedb -c "select * from pg_settings where name = 'edb_sql_protect.level';" -x webapp

printf "${G}\n--- Running legal query ---${N}\n\n"
printf "${R}select * from customers where lastname = 'Bean';${N}\n\n"
psql -h $DBHOST -p 5444 -U webuser -c "select * from customers where lastname = 'Bean';" webapp

printf "${G}\n--- Running SQL Injection ---${N}\n\n"
printf "${R}select * from customers where lastname = 'Bean' OR '1' = '1';${N}\n\n"
psql -h $DBHOST -p 5444 -U webuser -c "select * from customers where lastname = 'Bean' OR '1' = '1';" webapp
