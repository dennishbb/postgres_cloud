#!/bin/bash

# Stop PostgreSQL if it's running
gosu postgres pg_ctl -D /var/lib/postgresql/data stop || true

# Remove any existing data directory and recreate it
rm -rf /var/lib/postgresql/data
mkdir -p /var/lib/postgresql/data
chown -R postgres:postgres /var/lib/postgresql/data

# Initialize the database
gosu postgres initdb -D /var/lib/postgresql/data

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

