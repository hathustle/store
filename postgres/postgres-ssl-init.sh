#!/bin/bash
TRAFFIC_CERTS_DIR="/usr/local/share/ca-certificates/"
SSL_TARGET_DIR="/etc/postgresql/ssl"
POSTGRES_DATA_DIR="/var/lib/postgresql/data"

# Check if CLEAR_DB is true and remove PostgreSQL configuration and data files
if [ "$CLEAR_DB" = "true" ]; then
    echo "CLEAR_DB is set to true. Removing PostgreSQL data and configuration files..."
    rm -rf "$POSTGRES_DATA_DIR/*"
    echo "PostgreSQL data directory cleared."
else
    echo "Skipping DB removal..."
fi

# Ensure the target directory exists
mkdir -p "$SSL_TARGET_DIR"

# Check and copy Traefik certificates
if [ ! -f "$TRAFFIC_CERTS_DIR/server.crt" ] || [ ! -f "$TRAFFIC_CERTS_DIR/server.key" ]; then
    echo "Error: SSL certificate files not found in $TRAFFIC_CERTS_DIR"
    exit 1
else
    echo "Copying certificates from Traefik directory to PostgreSQL SSL directory..."
    cp "$TRAFFIC_CERTS_DIR/server.crt" "$SSL_TARGET_DIR/server.crt"
    cp "$TRAFFIC_CERTS_DIR/server.key" "$SSL_TARGET_DIR/server.key"
fi

# Set permissions for PostgreSQL to access the certificates
chmod 600 "$SSL_TARGET_DIR/server.key"
chown -R postgres:postgres "$SSL_TARGET_DIR"

# Check if the database is already initialized
if [ -z "$(ls -A $POSTGRES_DATA_DIR)" ]; then
    echo "Initializing database cluster with SSL enabled..."
    su - postgres -c "/usr/lib/postgresql/17/bin/initdb -D $POSTGRES_DATA_DIR \
        --pwfile=<(echo $POSTGRES_PASSWORD) \
        --auth-host=md5 \
        --auth-local=md5"

    # Enable SSL in postgresql.conf
    POSTGRES_CONF="$POSTGRES_DATA_DIR/postgresql.conf"
    if [ -f "$POSTGRES_CONF" ]; then
        echo "Configuring PostgreSQL to enable SSL..."
        echo "ssl = on" >> "$POSTGRES_CONF"
        echo "ssl_cert_file = '$SSL_TARGET_DIR/server.crt'" >> "$POSTGRES_CONF"
        echo "ssl_key_file = '$SSL_TARGET_DIR/ssl/server.key'" >> "$POSTGRES_CONF"
    else
        echo "Error: PostgreSQL configuration file not found at $POSTGRES_CONF"
        exit 1
    fi
else
    echo "Data directory exists and is not empty, skipping initdb."
fi

# Enable SSL in PostgreSQL configuration
POSTGRES_CONF="/var/lib/postgresql/data/postgresql.conf"
if [ ! -f "$POSTGRES_CONF" ]; then
    echo "Error: PostgreSQL configuration file not found at $POSTGRES_CONF"
    exit 1
fi

echo "Configuring PostgreSQL to enable SSL..."
su - postgres -c "echo \"ssl = on\" >> $POSTGRES_CONF"
su - postgres -c "echo \"ssl_cert_file = '$SSL_TARGET_DIR/server.crt'\" >> $POSTGRES_CONF"
su - postgres -c "echo \"ssl_key_file = '$SSL_TARGET_DIR/server.key'\" >> $POSTGRES_CONF"

# Start PostgreSQL
exec docker-entrypoint.sh postgres