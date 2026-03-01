#!/bin/sh

# Reads the passwords
MYSQL_PASSWORD=$(cat /run/secrets/db_password)
MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)

# Check if the database is started
if [ ! -d "/var/lib/mysql/mysql" ]; then
    
    echo "Initializing MariaDB..."
    
    # Install the data system
    mysql_install_db --user=mysql --datadir=/var/lib/mysql

    # Start the server to create the users
    /usr/bin/mysqld_safe --datadir=/var/lib/mysql &
    
    # Wait to open the server
    sleep 5

    # Criate a temp file to SQL configs
    cat << EOF > /tmp/init_db.sql
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';
FLUSH PRIVILEGES;
EOF
    
    # Execute SQL
    mysql -u root --password="" < /tmp/init_db.sql
    
    # Stop the temp server safe
    mysqladmin -u root -p$MYSQL_ROOT_PASSWORD shutdown
    sleep 2
fi

echo "Starting the Mariadb Safe..."
exec /usr/bin/mysqld_safe --datadir=/var/lib/mysql