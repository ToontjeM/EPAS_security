export PGCLUSTERNAME=NOTDE
export PGDATA=/var/lib/edb/as17/datanotde
export PGLOG=${PGDATA}/log
export PGWAL=${PGDATA}/pg_wal
export PGPORT=6444

/usr/edb/as17/bin/initdb -D ${PGDATA} --encoding=UTF8 --locale=en_US.utf8
/usr/edb/as17/bin/pg_ctl -D ${PGDATA} start  
