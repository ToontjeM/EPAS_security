#!/bin/bash
. ./env.sh

printf "${G}\n--- Current monitoring status ---${N}\n\n"
printf "${R}select * from pg_settings where name = 'edb_sql_protect.level';${N}\n\n"
psql -h $DBHOST -p 5444 -U enterprisedb -c "select * from pg_settings where name = 'edb_sql_protect.level';" -x edb

printf "${G}\n--- Switchng to passive state---${N}\n\n"
printf "${R}alter system set edb_sql_protect.level to 'passive';${N}\n\n"
psql -h $DBHOST -p 5444 -U enterprisedb -c "alter system set edb_sql_protect.level to 'passive';" edb
psql -h $DBHOST -p 5444 -U enterprisedb -c "select pg_reload_conf();" edb
psql -h $DBHOST -p 5444 -U enterprisedb -c "select * from pg_settings where name = 'edb_sql_protect.level';" -x edb