#!/bin/bash
. config/config.sh

printf "${G}\n--- Switching to active state ---${N}\n\n"
printf "${R}alter system set edb_sql_protect.level to 'active';${N}\n\n"
psql  -U enterprisedb -c "alter system set edb_sql_protect.level to 'active';" webapp
psql  -U enterprisedb -c "select pg_reload_conf();" webapp
psql  -U enterprisedb -c "select * from pg_settings where name = 'edb_sql_protect.level';" -x webapp

printf "${G}\n--- Running legal query ---${N}\n\n"
printf "${R}select * from customers where lastname = 'Bean';${N}\n\n"
psql  -U webuser -c "select * from customers where lastname = 'Bean';" webapp

printf "${G}\n--- Running SQL Injection ---${N}\n\n"
printf "${R}select * from customers where lastname = 'Bean' OR '1' = '1';${N}\n\n"
psql  -U webuser -c "select * from customers where lastname = 'Bean' OR '1' = '1';" webapp
