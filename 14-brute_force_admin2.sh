#!/bin/bash
. config/config.sh
clear

printf "${G}--- review admin_profile ---${N}\n\n"
printf "${R}SELECT * FROM pg_catalog.edb_profile WHERE prfname = 'admin_profile';${N}\n\n"
psql -c "SELECT * FROM pg_catalog.edb_profile WHERE prfname = 'admin_profile';" -x edb

read 

printf "${G}--- Brute-force password for admin2 (attempt 1) ---${N}\n\n"
printf "${R}psql  -U admin2 edb${N}\n\n"
psql  -h localhost -U admin2 edb

read 

printf "${G}--- Brute-force password for admin2 (attempt 2) ---${N}\n\n"
printf "${R}psql -h localhost -U admin2 edb${N}\n\n"
psql  -h localhost -U admin2 edb

read 

printf "${G}--- Brute-force password for admin2 (attempt 3) ---${N}\n\n"
printf "${R}psql -h localhost  -U admin2 edb${N}\n\n"
psql  -h localhost -U admin2 edb

read 

printf "${G}--- Brute-force password for admin2 (attempt 4) ---${N}\n\n"
printf "${R}psql -h localhost  -U admin2 edb${N}\n\n"
psql  -h localhost -U admin2 edb

