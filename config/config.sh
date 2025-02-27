#!/bin/bash

# Token
export EDB_SUBSCRIPTION_TOKEN=(`cat /tokens/.edb_subscription_token`)

# Software
export DATABASE="epas"
export DATABASEVERSION=17

# TDE
export tde="--data-encryption=256"
export PGDATAKEYWRAPCMD='openssl enc -e -aes256 -pass pass:ok -out %p'
export PGDATAKEYUNWRAPCMD='openssl enc -d -aes256 -pass pass:ok -in %p'

export VM1_NAME="$DATABASE${DATABASEVERSION}"
export VM1_MEMORY="1024"
export VM1_CPU="1"
export VM1_PUBLIC_IP="192.168.56.11"
export VM1_PORT="5444"
export VM1_SSH_PORT="2211"