
#!/bin/bash
. ./env.sh
clear
printf "${G}--- Create users hr and dba ---${N}\n\n"
printf "${R}CREATE USER hr WITH PASSWORD 'hr';${N}\n"
psql -h $DBHOST -p 5444 -U enterprisedb -c "CREATE USER hr WITH PASSWORD 'hr';" edb
printf "${R}CREATE USER dba WITH PASSWORD 'dba';${N}\n"
psql -h $DBHOST -p 5444 -U enterprisedb -c "CREATE USER dba WITH PASSWORD 'dba';" edb
printf "${R}GRANT ALL ON customers TO hr, dba;${N}\n"
psql -h $DBHOST -p 5444 -U enterprisedb -c "GRANT ALL ON customers TO hr, dba;" edb
