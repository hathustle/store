FROM postgres:17

RUN apt-get update && apt-get install -y cron

# Conditionally clear data directory
ARG CLEAR_DB=false
RUN if [ "$CLEAR_DB" = "true" ]; then \
    echo "Clearing Postgres data directory..."; \
    rm -rf /var/lib/postgresql/data/*; \
    fi

# Ensure proper permissions for the Postgres data directory
RUN mkdir -p /var/lib/postgresql/data && \
    chown -R postgres:postgres /var/lib/postgresql/data

# Traefik Labels for SSL Management
LABEL "traefik.enable"="true"
LABEL "traefik.tcp.routers.postgres.rule"="HostSNI(`postgres.internal`)"
LABEL "traefik.tcp.routers.postgres.entrypoints"="https"
LABEL "traefik.tcp.routers.postgres.tls"="true"
LABEL "traefik.tcp.services.postgres.loadbalancer.server.port"="5432"


EXPOSE 5432

CMD ["postgres"]
