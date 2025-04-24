#!/bin/bash
. config/config.sh
clear
printf "${G}--- Show table customers ---${N}\n\n"
printf "${R}select * from customers limit 1;${N}\n\n"
psql  -U enterprisedb -c "select * from customers limit 1;" -x edb

printf "${R}select count(*) from customers;${N}\n"
psql  -U enterprisedb -c "select count(*) from customers;" edb
