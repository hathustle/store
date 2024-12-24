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

COPY postgres-init.sh /docker-entrypoint-initdb.d/postgres-init.sh
RUN chmod +x /docker-entrypoint-initdb.d/postgres-init.sh
    

# Traefik Labels for SSL Management
LABEL "traefik.enable"="true"
LABEL "traefik.http.routers.medusa.rule"="Host(`hathustle-store-backend.eqmyej.easypanel.host`)"
LABEL "traefik.http.routers.medusa.entrypoints"="https"
LABEL "traefik.http.routers.medusa.tls.certresolver"="le"
LABEL "traefik.http.services.medusa.loadbalancer.server.port"="9000"

EXPOSE 5432

CMD ["postgres"]
