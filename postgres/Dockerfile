FROM postgres:17

RUN apt-get update && apt-get install -y openssl cron nano

# Copy SSL init script
COPY postgres-ssl-init.sh /usr/local/bin/postgres-ssl-init.sh
RUN chmod +x /usr/local/bin/postgres-ssl-init.sh
RUN rm -rf /var/lib/postgresql/data
# Ensure the data directory exists with correct permissions
RUN if [ ! -d "/var/lib/postgresql/data" ]; then \
      mkdir -p /var/lib/postgresql/data; \
    fi && \
    chown -R postgres:postgres /var/lib/postgresql/data

# Traefik Labels for SSL Passthrough
LABEL "traefik.enable"="true"
# LABEL "traefik.tcp.routers.postgres.rule"="HostSNI(postgres.internal)"
# LABEL "traefik.tcp.routers.postgres.entrypoints"="https"
# LABEL "traefik.tcp.routers.postgres.tls"="true"
LABEL "traefik.tcp.services.postgres.loadbalancer.server.port"="5432"
# LABEL "traefik.tcp.routers.postgres.entrypoints"="dbsecure"
# Entrypoint to initialize SSL and start Postgres
ENTRYPOINT ["/usr/local/bin/postgres-ssl-init.sh"]

EXPOSE 5432
