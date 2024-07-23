#!/bin/bash
. ./env.sh
clear

printf "${G}--- Unlock account ---${N}\n\n"
printf "${R}ALTER USER admin2 ACCOUNT UNLOCK;${N}\n\n"
psql -h $DBHOST -p 5444 -U enterprisedb -c "ALTER USER admin2 ACCOUNT UNLOCK;" -x edb

read 

printf "${G}--- Login as admin2 (password is new_password_admin2) ---${N}\n\n"
printf "${R}psql -h $DBHOST -p 5444 -U admin2 edb${N}\n\n"
psql -h $DBHOST -p 5444 -U admin2 edb

