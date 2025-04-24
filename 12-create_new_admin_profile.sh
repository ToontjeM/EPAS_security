#!/bin/bash
. config/config.sh
clear
printf "${G}--- Create new Admin profile ---${N}\n\n"
printf "${R}CREATE PROFILE admin_profile LIMIT\
  PASSWORD_LIFE_TIME 30\
  PASSWORD_GRACE_TIME 5\
  PASSWORD_REUSE_TIME 365\
  PASSWORD_REUSE_MAX 5\
  FAILED_LOGIN_ATTEMPTS 3\
  PASSWORD_LOCK_TIME 1;${N}\n\n"
psql  -U enterprisedb -c "
CREATE PROFILE admin_profile LIMIT
  PASSWORD_LIFE_TIME 30
  PASSWORD_GRACE_TIME 5
  PASSWORD_REUSE_TIME 365
  PASSWORD_REUSE_MAX 5
  FAILED_LOGIN_ATTEMPTS 3
  PASSWORD_LOCK_TIME 1;
" edb

read 

printf "${G}--- New profile created ---${N}\n\n"
printf "${R}SELECT * FROM pg_catalog.edb_profile WHERE prfname = 'admin_profile';${N}\n\n"
psql -c "SELECT * FROM pg_catalog.edb_profile WHERE prfname = 'admin_profile';" -x edb

read 

printf "${G}--- Assign admin_profile to new admin2 user ---${N}\n\n"
printf "${R}CREATE ROLE admin2 PASSWORD 'initial_password_admin2' LOGIN PROFILE admin_profile;${N}\n\n"
psql -c "CREATE ROLE admin2 PASSWORD 'initial_password_admin2' LOGIN PROFILE admin_profile;" edb

read 

printf "${G}--- Admin_profile assinged to new admin2 user ---${N}\n\n"
printf "${R}SELECT rolname, rolprofile FROM pg_catalog.pg_authid WHERE rolname = 'admin2';${N}\n\n"
psql -c "SELECT rolname, rolprofile FROM pg_catalog.pg_authid WHERE rolname = 'admin2';" edb


