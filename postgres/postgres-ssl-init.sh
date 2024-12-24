#!/bin/bash

echo "Configuring SSL for Postgres..."

CONF_FILE="/var/lib/postgresql/data/postgresql.conf"
CERT_FILE="/usr/local/share/ca-certificates/postgres.crt"
KEY_FILE="/usr/local/share/ca-certificates/postgres.key"

# Ensure cert files exist
if [ ! -f "$CERT_FILE" ] || [ ! -f "$KEY_FILE" ]; then
    echo "SSL certificates not found!"
    exit 1
fi

# Remove existing SSL configurations
sed -i '/^ssl =/d' "$CONF_FILE"
sed -i '/^ssl_cert_file =/d' "$CONF_FILE"
sed -i '/^ssl_key_file =/d' "$CONF_FILE"

# Add new SSL configurations at the end of the file
cat <<EOF >> "$CONF_FILE"
ssl = on
ssl_cert_file = '$CERT_FILE'
ssl_key_file = '$KEY_FILE'
EOF

echo "SSL configuration updated. Restart Postgres to apply changes."
