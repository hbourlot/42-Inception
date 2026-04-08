# User Documentation

## What This Stack Provides

This project provides a small web platform made of 3 services:

- Nginx: HTTPS entry point on port 443.
- WordPress + PHP-FPM: website and admin panel.
- MariaDB: database used by WordPress.

As a user or admin, you mainly interact with the website and WordPress admin panel.

## Start And Stop The Project

From the repository root:

```sh
make
```

This builds and starts all services in background mode.

To stop and clean containers and volumes:

```sh
make clean
```

For a complete reset (containers, images, and named volumes):

```sh
make fclean
```

## Access The Website And Admin Panel

Default access URL:

- Website: https://hbourlot.42.fr
- Admin panel: https://hbourlot.42.fr/wp-admin

If your local DNS/hosts is not configured, add the domain to your hosts file and map it to your local machine IP.

## Locate And Manage Credentials

Credentials are managed through files in the root secrets folder:

- secrets/db_password.txt
- secrets/db_root_password.txt
- secrets/credentials.txt

Notes:

- Database passwords come from secrets files.
- WordPress admin/user credentials are defined in secrets/credentials.txt.
- If credentials are changed after first initialization, existing database data may still keep old values.

If needed, reset everything and recreate with the latest secrets:

```sh
make fclean && make
```

## Check Services Health

Check running services:

```sh
docker ps
```

Check service logs:

```sh
docker logs nginx
docker logs wordpress
docker logs mariadb
```

Verify Compose configuration:

```sh
docker compose -f srcs/docker-compose.yml config
```
