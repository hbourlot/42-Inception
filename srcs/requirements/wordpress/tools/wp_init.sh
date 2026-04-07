#!/bin/sh
set -e

WP_PATH="/var/www/html"
DB_PASS=$(cat /run/secrets/db_password)

mkdir -p "$WP_PATH"

echo $WP_URL
# Loading credentials if they exist
[ -f "/run/secrets/credentials" ] && . /run/secrets/credentials

# Setting Default values
: "${WORDPRESS_DB_HOST:=mariadb:3306}"
: "${WORDPRESS_DB_NAME:=wordpress_db}"
: "${WORDPRESS_DB_USER:=wordpress}"
: "${WP_URL:=https://hbourlot.42.fr}"
: "${WP_TITLE:=Inception}"
: "${WP_ADMIN_USER:=sina}"
: "${WP_ADMIN_EMAIL:=sina@revelacao.com}"
: "${WP_ADMIN_PASSWORD:?WP_ADMIN_PASSWORD must be set via secrets}"
: "${WP_USER_PASSWORD:?WP_USER_PASSWORD must be set via secrets}"


# Checking if WordPress is COMPLETELY installed (not just config)
if ! wp core is-installed --path="$WP_PATH" --allow-root 2>/dev/null; then
    echo "Installing WordPress..."
    
    # # Downloading core if missing ( But in Downloading in the DOCKERFILE )
    # if [ ! -f "$WP_PATH/wp-settings.php" ] || [ ! -f "$WP_PATH/wp-includes/Requests/src/Autoload.php" ]; then
    #     if [ ! -f /tmp/wordpress.tar.gz ]; then
    #         wget -qO /tmp/wordpress.tar.gz https://wordpress.org/latest.tar.gz
    #     fi
    #     mkdir -p "$WP_PATH"
    #     tar -xzf /tmp/wordpress.tar.gz -C "$WP_PATH" --strip-components=1
    # fi

    # Creating config
    if [ ! -f "$WP_PATH/wp-config.php" ]; then
        wp config create \
            --path="$WP_PATH" \
            --dbname="$WORDPRESS_DB_NAME" \
            --dbuser="$WORDPRESS_DB_USER" \
            --dbpass="$DB_PASS" \
            --dbhost="$WORDPRESS_DB_HOST" \
            --skip-check \
            --allow-root
    fi
    
    # Waiting for database
    echo "Waiting for database..."
    until wp db check --path="$WP_PATH" --allow-root 2>/dev/null; do
        sleep 2
    done

    # Installing WordPress
    wp core install \
        --path="$WP_PATH" \
        --url="$WP_URL" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --allow-root

    # Installing WordPress
    wp user create $WP_USER $WP_USER_EMAIL --role=author --path="$WP_PATH" --user_pass="$WP_USER_PASSWORD"
    
    echo "WordPress installed successfully"
else
    echo "WordPress already fully installed"
    # Verifying integrity
    wp core verify-checksums --path="$WP_PATH" --allow-root || echo "Warning: Some WordPress files are modified"
fi

# Set permissions
chown -R nobody:nobody "$WP_PATH"

exec php-fpm82 -F