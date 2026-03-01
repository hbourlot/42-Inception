

LOGIN = hbourlot

PATH = /home/$(LOGIN)/data
WP_DATA = $(PATH)/wordpress
DB_DATA = $(PATH)/mariadb

COMPOSE_FILE = srcs/docker-compose.yml

all: build


build:
	@/bin/mkdir -p $(WP_DATA)
	@/bin/mkdir -p $(DB_DATA)
	@/bin/docker-compose -f $(COMPOSE_FILE) up --build -d