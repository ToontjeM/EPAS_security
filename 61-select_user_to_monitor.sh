#!/bin/bash
. config/config.sh

printf "${G}\n--- Enable SQL/Protect for user webuser ---${N}\n\n"
printf "${R}SELECT protect_role('webuser');${N}\n\n"
psql  -U enterprisedb -c "SELECT sqlprotect.protect_role('webuser');" webapp

printf "${R}SELECT * FROM list_protected_users;${N}\n\n"
psql  -U enterprisedb -c "SELECT * FROM sqlprotect.list_protected_users;" -x webapp
