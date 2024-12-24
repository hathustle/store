FROM postgres:17

RUN apt-get update && apt-get install -y openssl cron

# Conditionally clear data directory
ARG CLEAR_DB=false
RUN if [ "$CLEAR_DB" = "true" ]; then \
    echo "Clearing Postgres data directory..."; \
    rm -rf /var/lib/postgresql/data/*; \
    fi

# Copy SSL certs to a Postgres-owned directory (server-certs)
RUN mkdir -p /var/lib/postgresql/server-certs

COPY /usr/local/share/ca-certificates/postgres.crt /var/lib/postgresql/server-certs/server.crt
COPY /usr/local/share/ca-certificates/postgres.key /var/lib/postgresql/server-certs/server.key

# Set permissions as root during build (avoiding runtime issues)
RUN chown -R postgres:postgres /var/lib/postgresql/server-certs && \
    chmod 600 /var/lib/postgresql/server-certs/server.key

# Ensure proper permissions for the Postgres data directory
RUN mkdir -p /var/lib/postgresql/data && \
    chown -R postgres:postgres /var/lib/postgresql/data

# Copy init script and set permissions
COPY postgres-init.sh /docker-entrypoint-initdb.d/postgres-init.sh
RUN chmod +x /docker-entrypoint-initdb.d/postgres-init.sh

# Traefik Labels for Postgres SSL Passthrough
LABEL "traefik.enable"="true"
LABEL "traefik.tcp.routers.postgres.rule"="HostSNI(`postgres.internal`)"
LABEL "traefik.tcp.routers.postgres.entrypoints"="https"
LABEL "traefik.tcp.routers.postgres.tls"="true"
LABEL "traefik.tcp.services.postgres.loadbalancer.server.port"="5432"

EXPOSE 5432

CMD ["postgres"]
