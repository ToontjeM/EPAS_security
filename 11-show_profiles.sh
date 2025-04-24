#!/bin/bash
. config/config.sh

clear
printf "${G}--- Show available profiles ---${N}\n\n"

psql -c "SELECT * FROM pg_catalog.edb_profile;" -x edb

printf "${G}--- Show profiles per role ---${N}\n\n"

psql -c "SELECT rolname, rolprofile FROM pg_catalog.pg_authid;" edb
