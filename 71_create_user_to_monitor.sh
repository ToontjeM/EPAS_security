#!/bin/bash
. ./env.sh

printf "${G}\n--- Enable SQL/Protect for user webuser ---${N}\n\n"
printf "${R}SELECT protect_role('webuser');${N}\n\n"
psql -h $DBHOST -p 5444 -U enterprisedb -c "SELECT sqlprotect.protect_role('webuser');" edb

printf "${R}SELECT * FROM list_protected_users;${N}\n\n"
psql -h $DBHOST -p 5444 -U enterprisedb -c "SELECT * FROM sqlprotect.list_protected_users;" -x edb
