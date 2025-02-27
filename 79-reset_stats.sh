#!/bin/bash
. ./env.sh
psql -h $DBHOST -p 5444 -U enterprisedb -c "SELECT sqlprotect.drop_stats('webuser');" webapp
psql -h $DBHOST -p 5444 -U enterprisedb -c "SELECT sqlprotect.drop_queries('webuser');" webapp
psql -h $DBHOST -p 5444 -U enterprisedb -c "SELECT * FROM sqlprotect.edb_sql_protect_stats;" webapp
psql -h $DBHOST -p 5444 -U enterprisedb -c "SELECT * FROM sqlprotect.edb_sql_protect_queries;" webapp