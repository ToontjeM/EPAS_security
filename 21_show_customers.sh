#!/bin/bash
. ./env.sh
clear
printf "${G}--- Show table customers ---${N}\n\n"

psql -h $DBHOST -p 5444 -U enterprisedb -c "select * from customers limit 3;" -x edb
echo ""
psql -h $DBHOST -p 5444 -U enterprisedb -c "select count(*) from customers;" -x edb
