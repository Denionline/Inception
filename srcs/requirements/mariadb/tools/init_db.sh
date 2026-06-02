#!/bin/bash

set -e

ROOT_PASSWORD=$(< ${MYSQL_ROOT_PASSWORD_FILE})
USER_PASSWORD=$(< ${MYSQL_PASSWORD_FILE})

echo "Starting MariaDB initialization..."

# Initialize MySQL data directory if it doesn't exist
if [ ! -d "/var/lib/mysql/mysql" ]; then
	echo "Initializing data directory..."
	mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null
fi

mkdir -p "/var/log/mysql/" && chmod 777 "/var/log/mysql/"

# Start the server (no networking for setup)
echo "Starting temporary MariaDB server for setup..."
mysqld --skip-networking --socket=/run/mysqld/mysqld.sock --user=mysql &
pid="$!"

# Wait for MariaDB to be ready
echo "Waiting for MariaDB to be ready..."
until mysqladmin --socket=/run/mysqld/mysqld.sock ping >/dev/null 2>&1; do
	sleep 1
done
echo "MariaDB is ready!"

# Run setup SQL: create database and users
if [ ! -f /var/lib/mysql/.initialized ]; then

echo "Running setup SQL..."
mysql --socket=/run/mysqld/mysqld.sock -u root << EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '$ROOT_PASSWORD';
CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$USER_PASSWORD';
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';
FLUSH PRIVILEGES;
EOF

touch /var/lib/mysql/.initialized

echo "SQL setup complete!"

else
	echo "Mariadb already initialized, skipping setup."
fi

# Shut down temporary server
echo "Shutting down temporary MariaDB..."
mysqladmin --socket=/run/mysqld/mysqld.sock -u root -p"${ROOT_PASSWORD}" shutdown

# Wait for shutdown
wait "$pid" || true

# Start MariaDB normally (with networking)
echo "Initialization complete. Starting MariaDB..."
exec mysqld --user=mysql --datadir=/var/lib/mysql --socket=/run/mysqld/mysqld.sock