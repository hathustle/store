FROM postgres:17

RUN apt-get update && apt-get install -y openssl cron

# Conditionally clear the data directory if CLEAR_DB is set
ARG CLEAR_DB=false
RUN if [ "$CLEAR_DB" = "true" ]; then \
    echo "CLEAR_DB is true. Clearing Postgres data directory..."; \
    rm -rf /var/lib/postgresql/data; \
    mkdir -p /var/lib/postgresql/data; \
    chown -R postgres:postgres /var/lib/postgresql/data; \
    fi

# Copy SSL init script
COPY postgres-ssl-init.sh /usr/local/bin/postgres-ssl-init.sh
RUN chmod +x /usr/local/bin/postgres-ssl-init.sh

# Ensure the data directory exists with correct permissions
RUN mkdir -p /var/lib/postgresql/data && \
    chown -R postgres:postgres /var/lib/postgresql/data

# Traefik Labels for SSL Passthrough
LABEL "traefik.enable"="true"
LABEL "traefik.tcp.routers.postgres.rule"="HostSNI(`postgres.internal`)"
LABEL "traefik.tcp.routers.postgres.entrypoints"="https"
LABEL "traefik.tcp.routers.postgres.tls"="true"
LABEL "traefik.tcp.services.postgres.loadbalancer.server.port"="5432"

EXPOSE 5432

CMD ["postgres"]
