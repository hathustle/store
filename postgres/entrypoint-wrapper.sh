#!/bin/bash

echo "Checking for SSL certificate updates..."

# Only handle SSL certs; don't clear the DB unless explicitly requested
if [ -f "/usr/local/share/ca-certificates/postgres.crt" ] && \
   [ -f "/usr/local/share/ca-certificates/postgres.key" ]; then
    echo "SSL certs found. Applying permissions..."
    chown postgres:postgres /usr/local/share/ca-certificates/postgres.*
    chmod 600 /usr/local/share/ca-certificates/postgres.key

    # Apply SSL config to existing Postgres installation
    echo "ssl = on" >> /var/lib/postgresql/data/postgresql.conf
    echo "ssl_cert_file = '/usr/local/share/ca-certificates/postgres.crt'" >> /var/lib/postgresql/data/postgresql.conf
    echo "ssl_key_file = '/usr/local/share/ca-certificates/postgres.key'" >> /var/lib/postgresql/data/postgresql.conf
else
    echo "SSL certificates not found. Skipping SSL configuration."
fi

# Clear DB only if CLEAR_DB is explicitly set
if [ "$CLEAR_DB" = "true" ]; then
    echo "CLEAR_DB is set. Resetting Postgres data directory..."
    rm -rf /var/lib/postgresql/data
    mkdir -p /var/lib/postgresql/data
    chown -R postgres:postgres /var/lib/postgresql/data
fi

echo "Starting Postgres..."
exec docker-entrypoint.sh "$@"
