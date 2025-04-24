#!/bin/bash
. config/config.sh
clear
printf "${G}--- Create redaction functions for credit card number and password ---${N}\n"
printf "${R}CREATE OR REPLACE FUNCTION redact_cc (creditcard varchar(20)) RETURN varchar(20) IS\n
BEGIN\n\
   return overlay (creditcard placing 'xxxxxxxxxxxx' from 1);\n\
END;${N}\n\n"

psql -c "\
CREATE OR REPLACE FUNCTION redact_cc(creditcard varchar(20)) RETURN varchar(20) IS \
BEGIN \
   return overlay (creditcard placing 'xxxxxxxxxxxx' from 1) ; \
END; \
" edb

printf "${R}CREATE OR REPLACE FUNCTION redact_password(password varchar(10)) RETURN varchar(10) IS\n\
BEGIN \n\
   return 0::varchar(10);\n\
END;${N}\n\n"

psql -c "CREATE OR REPLACE FUNCTION redact_password(password varchar(10)) RETURN varchar(10) IS BEGIN return 0::varchar(10); END;" edb

printf "${G}\n--- Create redaction policies for credit card number and password ---${N}\n"
printf "${R}CREATE REDACTION POLICY redact_policy_hide_cc ON customers FOR (session_user != 'hr')
ADD COLUMN creditcard USING redact_cc(creditcard) WITH OPTIONS (SCOPE query, EXCEPTION equal);${N}\n\n"
psql -c "DROP REDACTION POLICY IF EXISTS redact_policy_hide_cc on customers;" edb >/dev/null
psql -c "CREATE REDACTION POLICY redact_policy_hide_cc ON customers FOR (session_user = 'dba') ADD COLUMN creditcard USING redact_cc(creditcard) WITH OPTIONS (SCOPE query, EXCEPTION equal);" edb

printf "${R}\n
CREATE REDACTION POLICY redact_policy_hide_password ON customers FOR (session_user != 'dba')
ADD COLUMN password USING redact_password() WITH OPTIONS (SCOPE query, EXCEPTION equal);${N}\n\n"
psql -c "DROP REDACTION POLICY IF EXISTS redact_policy_hide_password on customers;" edb >/dev/null
psql -c "CREATE REDACTION POLICY redact_policy_hide_password ON customers FOR (session_user = 'hr') ADD COLUMN password USING redact_password(password) WITH OPTIONS (SCOPE query, EXCEPTION equal);" edb
