#!/bin/bash

echo "Starting SSL configuration for PostgreSQL..."

CERT_DIR="/usr/local/share/ca-certificates"
CONF_DIR="/var/lib/postgresql/data"
CONF_FILE="${CONF_DIR}/postgresql.conf"
CERT_FILE="${CERT_DIR}/postgres.crt"
KEY_FILE="${CERT_DIR}/postgres.key"

# Verify if certs exist
if [ ! -f "$CERT_FILE" ] || [ ! -f "$KEY_FILE" ]; then
    echo "ERROR: SSL certificates not found in $CERT_DIR"
    exit 1
fi

# Apply permissions to certs
echo "Applying permissions to SSL certificates..."
chown postgres:postgres "$CERT_FILE" "$KEY_FILE"
chmod 600 "$KEY_FILE"

# Enable SSL in postgresql.conf
echo "Configuring SSL in postgresql.conf..."
cat <<EOF >> "$CONF_FILE"
ssl = on
ssl_cert_file = '$CERT_FILE'
ssl_key_file = '$KEY_FILE'
EOF

echo "SSL configuration complete. Restart PostgreSQL to apply changes."
