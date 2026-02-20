#!/bin/bash
set -euo pipefail

: "${DB_NAME:?DB_NAME is required}"
: "${DB_USER:?DB_USER is required}"
: "${DB_PASSWORD:?DB_PASSWORD is required}"
: "${DB_PASS_ROOT:?DB_PASS_ROOT is required}"

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

# Initialize datadir if needed
if [ ! -d /var/lib/mysql/mysql ]; then
  mariadb-install-db --user=mysql --datadir=/var/lib/mysql >/dev/null
fi

mysqld_safe --datadir=/var/lib/mysql &
pid="$!"

for i in {1..60}; do
  mariadb-admin ping -u root --silent >/dev/null 2>&1 && break
  sleep 1
done

# Init only once (marker file in the datadir/volume)
if [ ! -f /var/lib/mysql/.inception_init_done ]; then
  mariadb -u root <<EOF
CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;
CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_PASS_ROOT}';
FLUSH PRIVILEGES;
EOF
  touch /var/lib/mysql/.inception_init_done
fi

# Stop temp server, then exec the real one
mysqladmin -u root shutdown >/dev/null 2>&1 || true
wait "$pid" 2>/dev/null || true

exec "$@"