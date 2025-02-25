export PGCLUSTERNAME=TDE
export PGDATA=/var/lib/edb/as17/datawithtde
export PGLOG=${PGDATA}/log
export PGWAL=${PGDATA}/pg_wal
export PGPORT=6445

export PGDATAKEYWRAPCMD='-'
export PGDATAKEYUNWRAPCMD='-'

# Hashicorp Vault config examples
#export PGDATAKEYWRAPCMD='base64 | vault write -field=ciphertext transit/encrypt/pg-tde-master-1 plaintext=- > %p'
#export PGDATAKEYUNWRAPCMD='vault write -field=plaintext transit/decrypt/pg-tde-master-1 ciphertext=- < %p | base64 -d'

# Python example
#export PGDATAKEYWRAPCMD='python3 ${kmip_path}/edb_tde_kmip_client.py encrypt --pykmip-config-file=${kmip_path}/pykmip.conf --key-uid=${secret} --out-file=%p --variant=pykmip'
#export PGDATAKEYUNWRAPCMD='python3 ${kmip_path}/edb_tde_kmip_client.py decrypt --pykmip-config-file=${kmip_path}/pykmip.conf --key-uid=${secret} --in-file=%p --variant=pykmip'

# OpenSSL example
#export PGDATAKEYWRAPCMD='openssl enc -e -aes256 -pass pass:ok -out %p'
#export PGDATAKEYUNWRAPCMD='openssl enc -d -aes256 -pass pass:ok -in %p'

/usr/edb/as17/bin/initdb  --data-encryption -D ${PGDATA} --encoding=UTF8 --locale=en_US.utf8
/usr/edb/as17/bin/pg_ctl -D ${PGDATA} start -o "-p ${PGPORT}"
