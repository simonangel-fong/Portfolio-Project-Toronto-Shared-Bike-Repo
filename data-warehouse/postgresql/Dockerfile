FROM postgres:15

RUN apt-get update && apt-get install -y --no-install-recommends bash && rm -rf /var/lib/apt/lists/*

# Copy init and scripts into the image
COPY --chown=postgres:postgres init/ /docker-entrypoint-initdb.d/
COPY --chown=postgres:postgres scripts/ /scripts/

# set executable
RUN find /docker-entrypoint-initdb.d -type f -name '*.sh' -exec chmod +x {} \;