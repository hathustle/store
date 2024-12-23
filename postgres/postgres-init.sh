#!/bin/bash

# Add SSL configuration to postgresql.conf
echo "ssl = on" >> "$PGDATA/postgresql.conf"
echo "ssl_cert_file = '/var/lib/postgresql/server/server.crt'" >> "$PGDATA/postgresql.conf"
echo "ssl_key_file = '/var/lib/postgresql/server/server.key'" >> "$PGDATA/postgresql.conf"

# Ensure permissions are correct
chown -R postgres:postgres /var/lib/postgresql/server
chmod 600 /var/lib/postgresql/server/server.key
