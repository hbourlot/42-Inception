#!/bin/bash

# Read secrets
MYSQL_PASSWORD=$(cat /run/secrets/db_password)
MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)

# Get database info from environment
MYSQL_DATABASE=${MYSQL_DATABASE:-wordpress_db}
MYSQL_USER=${MYSQL_USER:-wordpress}

# Check if database is already initialized
if [ ! -d "/var/lib/mysql/mysql" ]; then
    
    echo "Initializing MariaDB..."
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql
    
    # Start MariaDB temporarily
    cd '/usr' ; /usr/bin/mariadbd-safe --datadir='/var/lib/mysql' &
    
    # Wait for MariaDB to start
    echo "Waiting for MariaDB to start..."
    for i in {1..30}; do
        if mysqladmin ping -h localhost --silent 2>/dev/null; then
            break
        fi
        sleep 1
    done

    # Create initialization SQL
    echo "Setting up database and users..."
    /usr/bin/mariadb -u root << EOF
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};

CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'localhost' IDENTIFIED BY '${MYSQL_PASSWORD}';

GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'localhost';
FLUSH PRIVILEGES;
EOF
    
    # Shutdown temporary server
    /usr/bin/mariadb-admin -u root -p${MYSQL_ROOT_PASSWORD} shutdown

    
    echo "MariaDB initialized successfully!"
else
    echo "MariaDB already initialized."
fi

sleep 2

# Start MariaDB normally
echo "Starting MariaDB server..."
exec /usr/bin/mariadbd --user=mysql --datadir=/var/lib/mysql > /dev/null