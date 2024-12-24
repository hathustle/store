#!/bin/bash

# Link certificates to Postgres SSL directory
SSL_DIR="/etc/postgresql/ssl"
CERTS_DIR="/usr/local/share/ca-certificates"

mkdir -p "$SSL_DIR"
cp "$CERTS_DIR/postgres.crt" "$SSL_DIR/postgres.crt"
cp "$CERTS_DIR/postgres.key" "$SSL_DIR/postgres.key"
cp "$CERTS_DIR/ca.crt" "$SSL_DIR/ca.crt"

# Set correct permissions for Postgres to use the certificates
chmod 600 "$SSL_DIR/postgres.key"
chown -R postgres:postgres "$SSL_DIR"

# Update postgresql.conf for SSL
cat >> /var/lib/postgresql/data/postgresql.conf <<EOF
ssl = 'on'
ssl_cert_file = '$SSL_DIR/postgres.crt'
ssl_key_file = '$SSL_DIR/postgres.key'
ssl_ca_file = '$SSL_DIR/ca.crt'
EOF

# Start Postgres
exec docker-entrypoint.sh postgres
