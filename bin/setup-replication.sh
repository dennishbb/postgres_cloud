#!/bin/bash

# Stop PostgreSQL if it's running
gosu postgres pg_ctl -D /var/lib/postgresql/data stop || true

# Wait for a few seconds to ensure all processes are stopped
sleep 5

# Kill any remaining PostgreSQL processes
pkill -u postgres || true

# Forcefully remove and recreate the data directory
rm -rf /var/lib/postgresql/data
mkdir -p /var/lib/postgresql/data
chown -R postgres:postgres /var/lib/postgresql/data

# Set PostgreSQL parameters for replication
cat <<EOF > /var/lib/postgresql/data/postgresql.conf
wal_level = replica
archive_mode = on
archive_command = '/bin/true'
max_wal_senders = 10
EOF

cat <<EOF > /var/lib/postgresql/data/pg_hba.conf
host replication all 0.0.0.0/0 md5
EOF

# Initialize the database
gosu postgres pg_ctl -D /var/lib/postgresql/data initdb

# Start PostgreSQL
gosu postgres pg_ctl -D /var/lib/postgresql/data -w start

