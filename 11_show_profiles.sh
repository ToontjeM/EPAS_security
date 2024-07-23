#!/bin/bash
. ./env.sh
clear
printf "${G}--- Show available profiles ---${N}\n\n"

psql -h $DBHOST -p 5444 -U enterprisedb -c "SELECT * FROM pg_catalog.edb_profile;" -x edb

printf "${G}--- Show profiles per role ---${N}\n\n"

psql -h $DBHOST -p 5444 -U enterprisedb -c "SELECT rolname, rolprofile FROM pg_catalog.pg_authid;" edb
