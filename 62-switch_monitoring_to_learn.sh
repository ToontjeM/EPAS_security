#!/bin/bash
. ./env.sh

printf "${G}\n--- Switching to learn state ---${N}\n\n"
printf "${R}alter system set edb_sql_protect.level to 'learn';${N}\n\n"
psql -h $DBHOST -p 5444 -U enterprisedb -c "alter system set edb_sql_protect.level to 'learn';" webapp
psql -h $DBHOST -p 5444 -U enterprisedb -c "select pg_reload_conf();" webapp
psql -h $DBHOST -p 5444 -U enterprisedb -c "select * from pg_settings where name = 'edb_sql_protect.level';" -x webapp

printf "${G}\n--- Run query --${N}\n\n"
printf "${R}SELECT * FROM customers WHERE lastname = 'Bean';${N}\n\n"
psql -h $DBHOST -p 5444 -U webuser -c "SELECT * FROM customers WHERE lastname = 'Bean';" webapp

printf "${G}\n--- Relations learned --${N}\n\n"
printf "${R}SELECT * FROM sqlprotect.list_protected_rels;${N}\n\n"
psql -h $DBHOST -p 5444 -U enterprisedb -c "SELECT * FROM sqlprotect.list_protected_rels;" webapp

printf "${G}\n--- Queries learned --${N}\n\n"
printf "${R}SELECT * FROM sqlprotect.edb_sql_protect_queries;${N}\n\n"
psql -h $DBHOST -p 5444 -U enterprisedb -c "SELECT * FROM sqlprotect.edb_sql_protect_queries;" webapp