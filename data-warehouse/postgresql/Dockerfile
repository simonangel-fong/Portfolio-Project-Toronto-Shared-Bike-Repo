# Dockerfile
FROM postgres:15

# ---- Defaults you can override at build or run time ----
ARG POSTGRES_USER=postgres
ARG POSTGRES_PASSWORD=SecurePassword123
ARG POSTGRES_DB=toronto_shared_bike
ARG PGDATA=/var/lib/postgresql/data

ENV POSTGRES_USER=${POSTGRES_USER} \
    POSTGRES_PASSWORD=${POSTGRES_PASSWORD} \
    POSTGRES_DB=${POSTGRES_DB} \
    PGDATA=${PGDATA}

# Create directories to mount volume
RUN mkdir -p /scripts /data /export "${PGDATA}" \
 && chown -R postgres:postgres /scripts /data /export /var/lib/postgresql

# Copy your scripts
COPY ./scripts/setup/ /docker-entrypoint-initdb.d/
COPY ./scripts/ /scripts/

# Grant perms to run
RUN find /docker-entrypoint-initdb.d -type f -name "*.sh" -exec chmod +x {} \; \
 && find /docker-entrypoint-initdb.d -type f -name "*.sql" -exec chmod 644 {} \; \
 && chown -R postgres:postgres /docker-entrypoint-initdb.d

# Expose pgdb port
EXPOSE 5432

# Healthcheck
HEALTHCHECK --interval=30s --timeout=10s --retries=30 --start-period=30s \
  CMD pg_isready -U "${POSTGRES_USER}" -d "${POSTGRES_DB}" || exit 1

# Declare volumes
VOLUME ["${PGDATA}", "/data", "/export"]
