# Developer Documentation

## 1. Environment Setup From Scratch

### Prerequisites

- Docker Engine
- Docker Compose plugin (docker compose)
- GNU Make
- sudo access (used by clean target to remove local data folders)

### Required Configuration Files

- srcs/.env
- secrets/db_password.txt
- secrets/db_root_password.txt
- secrets/credentials.txt

Expected values in srcs/.env include:

- DOMAIN_NAME
- MYSQL_USER
- MYSQL_DATABASE
- DB_PORT
- DB_DATA_PATH
- WP_DATA_PATH
- MARIADB_IMAGE_TAG
- WORDPRESS_IMAGE_TAG
- NGINX_IMAGE_TAG
- WP_PATH
- WP_URL

## 2. Build And Launch Workflow

### With Makefile (recommended)

From repository root:

```sh
make
```

The Makefile:

- validates shell scripts syntax,
- creates data directories from .env (DB_DATA_PATH and WP_DATA_PATH),
- runs docker compose up --build -d.

### With Docker Compose directly

```sh
docker compose -f srcs/docker-compose.yml up --build -d
```

Stop stack:

```sh
docker compose -f srcs/docker-compose.yml down
```

## 3. Useful Commands For Containers And Volumes

### Makefile shortcuts

```sh
make              # build + launch all services
make clean        # down + remove compose volumes + remove local data folders
make clean-images # remove compose images
make fclean       # full cleanup (containers, images, named volumes)
make re           # full rebuild
```

### Docker/Compose commands

```sh
docker ps
docker compose -f srcs/docker-compose.yml ps
docker compose -f srcs/docker-compose.yml logs -f
docker volume ls
docker network ls
```

Inspect one service quickly:

```sh
docker logs mariadb
docker logs wordpress
docker logs nginx
```

## 4. Data Storage And Persistence

Persistent service data is mounted through compose volumes whose host paths come from .env:

- DB_DATA_PATH (MariaDB data)
- WP_DATA_PATH (WordPress files)

In srcs/docker-compose.yml, volumes are configured with driver_opts (type: none, o: bind), meaning:

- data is stored on host filesystem,
- data survives container recreation,
- deleting containers alone does not delete persistent data.

To fully reset persisted data, use:

```sh
make fclean
```

Then relaunch with:

```sh
make
```
