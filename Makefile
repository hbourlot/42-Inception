LOGIN = hbourlot

include srcs/.env

WP_DATA = $(WP_DATA_PATH)
DB_DATA = $(DB_DATA_PATH)

NGINX_SCRIPT_PATH = srcs/requirements/nginx/tools/nginx_gen.sh
DB_SCRIPT_PATH = srcs/requirements/mariadb/tools/db_init.sh

COMPOSE_FILE = srcs/docker-compose.yml
COMPOSE_PROJECT = srcs
WP_VOLUME = $(COMPOSE_PROJECT)_wordpress
DB_VOLUME = $(COMPOSE_PROJECT)_mariadb

RESET = \033[0m
BOLD = \033[1m
GREEN = \033[0;32m
YELLOW = \033[0;33m
BLUE = \033[0;34m
RED = \033[0;31m

.PHONY: all check-script build clean clean-images fclean re wordpress

all: check-script build

check-script:
	@printf "$(BLUE)$(BOLD)Checking scripts syntax...$(RESET)\n"
	@sh -n $(NGINX_SCRIPT_PATH) && printf "$(GREEN)nginx_gen.sh syntax: OK$(RESET)\n"
	@sh -n $(DB_SCRIPT_PATH) && printf "$(GREEN)db_init.sh syntax: OK$(RESET)\n"

build:
	@printf "$(YELLOW)$(BOLD)Starting build...$(RESET)\n"
	@mkdir -p $(WP_DATA)
	@mkdir -p $(DB_DATA)
	@docker compose -f $(COMPOSE_FILE) up --build -d
	@printf "$(GREEN)Build completed$(RESET)\n"

clean:
	@printf "$(RED)$(BOLD)Cleaning containers and volumes...$(RESET)\n"
	@docker compose -f $(COMPOSE_FILE) down --volumes --remove-orphans
	@sudo rm -rf $(WP_DATA)
	@sudo rm -rf $(DB_DATA)
	@printf "$(GREEN)Clean completed$(RESET)\n"

clean-images:
	@printf "$(RED)$(BOLD)Removing compose images...$(RESET)\n"
	@docker compose -f $(COMPOSE_FILE) down --rmi all --remove-orphans
	@printf "$(GREEN)Images removed$(RESET)\n"

fclean: clean clean-images
	@printf "$(RED)$(BOLD)Resetting compose volumes...$(RESET)\n"
	@docker volume rm -f $(WP_VOLUME) $(DB_VOLUME) >/dev/null 2>&1 || true
	@printf "$(GREEN)Full clean completed$(RESET)\n"

wordpress:
	@docker compose -f $(COMPOSE_FILE) up --build -d wordpress

mariadb:
	@docker compose -f $(COMPOSE_FILE) up --build -d mariadb


re: fclean all
