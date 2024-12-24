#!/bin/bash

# Ensure SSL certs exist before configuring
if [ ! -f "/usr/local/share/ca-certificates/postgres.crt" ]; then
    echo "SSL cert not found. Exiting..."
    exit 1
fi

# Configure Postgres to use SSL
echo "ssl = on" >> "/var/lib/postgresql/data/postgresql.conf"
echo "ssl_cert_file = '/usr/local/share/ca-certificates/postgres.crt'" >> "/var/lib/postgresql/data/postgresql.conf"
echo "ssl_key_file = '/usr/local/share/ca-certificates/postgres.key'" >> "/var/lib/postgresql/data/postgresql.conf"

# Set permissions
chown -R postgres:postgres /usr/local/share/ca-certificates
chmod 600 /usr/local/share/ca-certificates/postgres.key
