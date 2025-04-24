#!/bin/bash
. config/config.sh
psql  -U enterprisedb -c "SELECT sqlprotect.drop_stats('webuser');" webapp
psql  -U enterprisedb -c "SELECT sqlprotect.drop_queries('webuser');" webapp
psql  -U enterprisedb -c "SELECT * FROM sqlprotect.edb_sql_protect_stats;" webapp
psql  -U enterprisedb -c "SELECT * FROM sqlprotect.edb_sql_protect_queries;" webapp