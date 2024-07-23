from __future__ import print_function
from flask import Flask, request, jsonify, render_template
import psycopg2
try:
    from psycopg2 import sql
except ImportError:
    sql = psycopg2

app = Flask(__name__)

# Updated Database connection parameters
DB_PARAMS = {
    "dbname": "edb",
    "user": "enterprisedb",
    "password": "enterprisedb",
    "host": "localhost",
    "port": 5444  # Updated port number
}

def get_db_connection():
    return psycopg2.connect(**DB_PARAMS)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/unsafe/customers', methods=['GET'])
def unsafe_get_customers():
    lastname = request.args.get('lastname', '')
    
    conn = get_db_connection()
    cur = conn.cursor()
    
    query = "SELECT * FROM customers WHERE lastname = '{0}'".format(lastname)
    cur.execute(query)
    
    customers = cur.fetchall()
    cur.close()
    conn.close()
    
    return jsonify(customers)

@app.route('/safe/customers', methods=['GET'])
def safe_get_customers():
    lastname = request.args.get('lastname', '')
    
    conn = get_db_connection()
    cur = conn.cursor()
    
    query = "SELECT * FROM customers WHERE lastname = %s"
    cur.execute(query, (lastname,))
    
    customers = cur.fetchall()
    cur.close()
    conn.close()
    
    return jsonify(customers)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)