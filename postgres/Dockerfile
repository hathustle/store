FROM postgres:17

RUN apt-get update && apt-get install -y openssl cron

# Generate SSL certs
RUN mkdir /var/lib/postgresql/server && \
    openssl req -new -x509 -days 90 -nodes -text \
    -out /var/lib/postgresql/server/server.crt \
    -keyout /var/lib/postgresql/server/server.key \
    -subj "/CN=localhost" && \
    chmod 600 /var/lib/postgresql/server/server.key && \
    chown postgres:postgres /var/lib/postgresql/server/*

# Modify the active Postgres config to use SSL
RUN echo "ssl = on" >> /var/lib/postgresql/data/postgresql.conf && \
    echo "ssl_cert_file = '/var/lib/postgresql/server/server.crt'" >> /var/lib/postgresql/data/postgresql.conf && \
    echo "ssl_key_file = '/var/lib/postgresql/server/server.key'" >> /var/lib/postgresql/data/postgresql.conf

# Add cert rotation script
COPY rotate-cert.sh /usr/local/bin/rotate-cert.sh
RUN chmod +x /usr/local/bin/rotate-cert.sh

# Cron job for cert rotation (every 3 months)
RUN echo "0 0 1 */3 * /usr/local/bin/rotate-cert.sh" >> /etc/crontab

# Start cron and Postgres
CMD service cron start && docker-entrypoint.sh postgres
EXPOSE 5432
