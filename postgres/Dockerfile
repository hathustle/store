FROM postgres:17

RUN apt-get update && apt-get install -y openssl cron

# Generate SSL certs
RUN mkdir -p /var/lib/postgresql/server && \
    openssl req -new -x509 -days 90 -nodes -text \
    -out /var/lib/postgresql/server/server.crt \
    -keyout /var/lib/postgresql/server/server.key \
    -subj "/CN=localhost" && \
    chmod 600 /var/lib/postgresql/server/server.key && \
    chown postgres:postgres /var/lib/postgresql/server/*

# Add cert rotation script
COPY rotate-cert.sh /usr/local/bin/rotate-cert.sh
RUN chmod +x /usr/local/bin/rotate-cert.sh

# Cron job for cert rotation (every 3 months)
RUN echo "0 0 1 */3 * /usr/local/bin/rotate-cert.sh" >> /etc/crontab

# Conditionally clear data directory
ARG CLEAR_DB=false
RUN if [ "$CLEAR_DB" = "true" ]; then \
    echo "Clearing Postgres data directory..."; \
    rm -rf /var/lib/postgresql/data/*; \
    fi

# Ensure SSL configuration is applied during runtime
COPY postgres-init.sh /docker-entrypoint-initdb.d/postgres-init.sh
RUN chmod +x /docker-entrypoint-initdb.d/postgres-init.sh

EXPOSE 5432
