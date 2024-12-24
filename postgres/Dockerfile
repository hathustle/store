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

# Entrypoint wrapper to set permissions at runtime
COPY entrypoint-wrapper.sh /usr/local/bin/entrypoint-wrapper.sh
RUN chmod +x /usr/local/bin/entrypoint-wrapper.sh

# Ensure proper permissions for the Postgres data directory
RUN mkdir -p /var/lib/postgresql/data && \
    chown -R postgres:postgres /var/lib/postgresql/data

# Traefik Labels for Postgres SSL Passthrough
LABEL "traefik.enable"="true"
LABEL "traefik.tcp.routers.postgres.rule"="HostSNI(`postgres.internal`)"
LABEL "traefik.tcp.routers.postgres.entrypoints"="https"
LABEL "traefik.tcp.routers.postgres.tls"="true"
LABEL "traefik.tcp.services.postgres.loadbalancer.server.port"="5432"

EXPOSE 5432

ENTRYPOINT ["/usr/local/bin/entrypoint-wrapper.sh"]
CMD ["postgres"]
