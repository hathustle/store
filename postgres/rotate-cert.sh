#!/bin/bash

set -e

echo "Rotating SSL cert for Postgres..."

# Generate new certs
openssl req -new -x509 -days 90 -nodes -text \
    -out /var/lib/postgresql/server/server.crt \
    -keyout /var/lib/postgresql/server/server.key \
    -subj "/CN=localhost"

# Update permissions
chmod 600 /var/lib/postgresql/server/server.key
chown postgres:postgres /var/lib/postgresql/server/*

# Reload Postgres to apply new cert
pg_ctl reload

echo "SSL cert rotated successfully."
