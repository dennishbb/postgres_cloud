FROM postgres:latest

# Install gosu
RUN apt-get update && apt-get install -y gosu && rm -rf /var/lib/apt/lists/*

# Create the necessary directory with correct permissions
RUN mkdir -p /home/postgres && \
    chown -R postgres:postgres /home/postgres && \
    chmod -R 700 /home/postgres

# Copy the initialization script and make it executable
COPY initialize-standby.sh /usr/local/bin/initialize-standby.sh
RUN chmod +x /usr/local/bin/initialize-standby.sh

# Initialize the database
RUN /usr/local/bin/initialize-standby.sh

# Ensure PostgreSQL runs in the foreground
CMD ["postgres"]

