#!/bin/bash
. config/config.sh
clear
printf "${G}--- Change password for admin2 ---${N}\n\n"
printf "${R}ALTER ROLE admin2 PASSWORD 'new_password_admin2';${N}\n\n"
psql -c "ALTER ROLE admin2 PASSWORD 'new_password_admin2';" edb

read 

printf "${G}--- Re-use old password ---${N}\n\n"
printf "${R}ALTER ROLE admin2 PASSWORD 'initial_password_admin2';${N}\n\n"
psql -c "ALTER ROLE admin2 PASSWORD 'initial_password_admin2';" -x edb
