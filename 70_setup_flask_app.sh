#!/bin/bash
. ./env.sh

if [ -d "venv" ]; then rm -Rf venv; fi

virtualenv venv
. venv/bin/activate
pip install flask psycopg2
python sqlinjection.py