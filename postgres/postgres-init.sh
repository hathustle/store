#!/bin/bash

# Ensure SSL certs exist before configuring
if [ ! -f "/var/lib/postgresql/server-certs/server.crt" ]; then
    echo "SSL cert not found. Exiting..."
    exit 1
fi

# Configure Postgres to use SSL
echo "ssl = on" >> "/var/lib/postgresql/data/postgresql.conf"
echo "ssl_cert_file = '/var/lib/postgresql/server-certs/server.crt'" >> "/var/lib/postgresql/data/postgresql.conf"
echo "ssl_key_file = '/var/lib/postgresql/server-certs/server.key'" >> "/var/lib/postgresql/data/postgresql.conf"
