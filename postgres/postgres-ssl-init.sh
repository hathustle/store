#!/bin/bash

SSL_CERTS_DIR="/usr/local/share/ca-certificates"
SSL_TARGET_DIR="/etc/postgresql/ssl"

# Validate certificates
# [ ! -f "$SSL_CERTS_DIR/ca.crt" ] ||
if [ ! -f "$SSL_CERTS_DIR/postgres.crt" ] || [ ! -f "$SSL_CERTS_DIR/postgres.key" ]; then
    echo "Error: Missing SSL certificate files in $SSL_CERTS_DIR"
    exit 1
fi

# Copy certificates
mkdir -p "$SSL_TARGET_DIR"
# cp "$SSL_CERTS_DIR/ca.crt" "$SSL_TARGET_DIR/ca.crt"
cp "$SSL_CERTS_DIR/postgres.crt" "$SSL_TARGET_DIR/postgres.crt"
cp "$SSL_CERTS_DIR/postgres.key" "$SSL_TARGET_DIR/postgres.key"

# Set permissions
chmod 600 "$SSL_TARGET_DIR/postgres.key"
chown -R postgres:postgres "$SSL_TARGET_DIR"

# Initialize database if necessary
if [ -z "$(ls -A /var/lib/postgresql/data)" ]; then
    echo "Initializing database cluster..."
    initdb -D /var/lib/postgresql/data
else
    echo "Data directory exists and is not empty, skipping initdb."
fi

# Start Postgres
exec docker-entrypoint.sh postgres

