#!/bin/bash

# Token
if [ -f "/tokens/.edb_subscription_token" ]; then
# Running inside a VM
  export EDB_SUBSCRIPTION_TOKEN=(`cat /tokens/.edb_subscription_token`)
fi

# Terminal 
export N=$(tput sgr0)
export R=$(tput setaf 1)
export G=$(tput setaf 2)

# Host
export DBHOST=localhost
export PGPASSFILE=./passfile

# Software
export DATABASE="epas"
export DATABASEVERSION=17

# TDE
export tde="--data-encryption=256"
export PGDATAKEYWRAPCMD='openssl enc -e -aes256 -pass pass:ok -out %p'
export PGDATAKEYUNWRAPCMD='openssl enc -d -aes256 -pass pass:ok -in %p'
