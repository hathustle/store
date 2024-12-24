#!/bin/bash
echo "Checking for database initialization..."

# Clear Postgres data directory if CLEAR_DB is set
if [ "$CLEAR_DB" = "true" ]; then
    echo "CLEAR_DB is true. Removing existing Postgres data..."
    rm -rf /var/lib/postgresql/data/*
fi

echo "Configuring SSL certificates for Postgres..."

# Ensure certs are present and adjust permissions
if [ -f "/usr/local/share/ca-certificates/postgres.crt" ] && \
   [ -f "/usr/local/share/ca-certificates/postgres.key" ]; then
    echo "SSL certs found. Applying permissions..."
    chown postgres:postgres /usr/local/share/ca-certificates/postgres.*
    chmod 600 /usr/local/share/ca-certificates/postgres.key
else
    echo "SSL certificates not found. Skipping SSL configuration."
fi

# Apply SSL config before Postgres starts
echo "ssl = on" >> /var/lib/postgresql/data/postgresql.conf
echo "ssl_cert_file = '/usr/local/share/ca-certificates/postgres.crt'" >> /var/lib/postgresql/data/postgresql.conf
echo "ssl_key_file = '/usr/local/share/ca-certificates/postgres.key'" >> /var/lib/postgresql/data/postgresql.conf

# Continue with the default entrypoint (Postgres)
echo "Starting Postgres..."
exec docker-entrypoint.sh "$@"
