

LOGIN = hbourlot

DATA_PATH = /home/$(LOGIN)/data
WP_DATA = $(DATA_PATH)/wordpress
DB_DATA = $(DATA_PATH)/mariadb

COMPOSE_FILE = srcs/docker-compose.yml

all: build


build:
	@mkdir -p $(WP_DATA)
	@mkdir -p $(DB_DATA)
	@docker-compose -f $(COMPOSE_FILE) up --build -d

clean:
	@/bin/docker-compose -f $(COMPOSE_FILE) down
	@sudo rm -rf $(WP_DATA)
	@sudo rm -rf $(DB_DATA)

