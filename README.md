_This project has been created as part of the 42 curriculum by hbourlot._

# Inception

## Project Docs

- User guide: `USER_DOC.md`
- Developer guide: `DEV_DOC.md`

## Description

This project is my hands-on intro to real service orchestration with Docker.

The idea is simple: instead of running everything on one machine in one messy setup, I split the app into separate containers and make them talk to each other cleanly and securely.

My stack has 3 services:

- MariaDB: stores WordPress data.
- WordPress + PHP-FPM: runs the application logic.
- Nginx: serves HTTPS traffic and forwards PHP requests.

Everything is managed with Docker Compose, one service per container.

### Docker Architecture And Included Sources

Main files and folders in this repo:

- `srcs/docker-compose.yml`: service orchestration, volumes, network, and secrets wiring.
- `srcs/requirements/mariadb/`: MariaDB image, config, and init script.
- `srcs/requirements/wordpress/`: WordPress + PHP-FPM image and init script using `wp-cli`.
- `srcs/requirements/nginx/`: Nginx image, TLS generation script, and Nginx configuration.
- `secrets/`: local secret files used by Docker secrets.
- `Makefile`: build, clean, and rebuild workflow.

Main design:

- Custom Dockerfiles are used for each service instead of prebuilt all-in-one images.
- Services communicate only through a dedicated Docker bridge network.
- Persistent data is stored in host-backed Docker volumes for MariaDB and WordPress files.
- Sensitive values are injected with Docker secrets when possible.
- HTTPS is terminated in Nginx with TLS 1.2/1.3.

### Required Technical Comparisons

#### Virtual Machines vs Docker

- Virtual machines run full operating systems. Great isolation, but heavy and slower.
- Docker containers share the host kernel. Lighter, faster startup, and easier to reproduce.
- VMs are better when you need strong OS-level isolation.
- Docker is better when you want fast dev/test cycles and portable setups.

#### Secrets vs Environment Variables

- Environment variables are convenient, but they can be exposed in logs or inspection output.
- Docker secrets are mounted as files in `/run/secrets`, which is safer for passwords.
- I use secrets for sensitive values and `.env` for normal config values.

In this project, database credentials and app credentials come from Docker secrets.

#### Docker Network vs Host Network

- Docker bridge network gives isolation and built-in DNS (containers can call each other by service name).
- Host network removes that layer and directly uses host networking.
- For this kind of architecture, bridge is cleaner and safer.

I use a dedicated bridge network (`inception`) so services can communicate internally without exposing everything to the host.

#### Docker Volumes vs Bind Mounts

- Docker volumes are managed by Docker and are usually the best default for persistent container data.
- Bind mounts map exact host paths and are handy when you want direct host control.

In this project, data path locations come from `.env` variables (`DB_DATA_PATH` and `WP_DATA_PATH`) and are used by compose volume devices.

## Instructions

### Prerequisites

- Docker Engine
- Docker Compose plugin (`docker compose`)
- `make`
- A local host entry for your configured domain if needed (for example, `hbourlot.42.fr`)

### Build And Run

1. Clone the repository.
2. Go to the project root.
3. Make sure secret files exist in `secrets/`.
4. Make sure `srcs/.env` is correctly filled (for example: `DOMAIN_NAME`, `MYSQL_USER`, `MYSQL_DATABASE`, `DB_PORT`, `DB_DATA_PATH`, `WP_DATA_PATH`, `MARIADB_IMAGE_TAG`, `WORDPRESS_IMAGE_TAG`, `NGINX_IMAGE_TAG`, `WP_PATH`, `WP_URL`).
5. Start everything:

```sh
make
```

This builds the images, prepares data directories, and starts containers in detached mode.

### Useful Commands

```sh
make              # build and start all services
make clean        # stop stack and remove containers/volumes + data directories
make clean-images # remove compose images
make fclean       # full cleanup including named volumes
make re           # full rebuild from scratch
```

### Verification

- Check running services:

```sh
docker ps
```

- Check logs:

```sh
docker logs nginx
docker logs wordpress
docker logs mariadb
```

- Validate compose file:

```sh
docker compose -f srcs/docker-compose.yml config
```

## Resources

Useful references:

- Docker documentation: https://docs.docker.com/
- Docker Compose specification: https://docs.docker.com/compose/
- Nginx documentation: https://nginx.org/en/docs/
- MariaDB documentation: https://mariadb.com/kb/en/documentation/
- WordPress + WP-CLI references:
    - https://developer.wordpress.org/
    - https://developer.wordpress.org/cli/commands/
- OpenSSL documentation: https://www.openssl.org/docs/

### AI Usage Disclosure

I used AI as a helper for:

- Improving and polishing the README wording and structure.
- Clarifying explanations for architecture trade-offs (VM vs Docker, secrets vs env vars, network and storage choices).
