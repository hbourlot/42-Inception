

LOGIN = hugobourlot

DATA_PATH = /Users/$(LOGIN)/data
WP_DATA = $(DATA_PATH)/wordpress
DB_DATA = $(DATA_PATH)/mariadb

NGINX_SCRIPT_PATH = srcs/requirements/nginx/tools/nginx_gen.sh
DB_SCRIPT_PATH = srcs/requirements/mariadb/tools/db_init.sh


COMPOSE_FILE = srcs/docker-compose.yml

RESET = \033[0m
BOLD = \033[1m
GREEN = \033[0;32m
YELLOW = \033[0;33m
BLUE = \033[0;34m
RED = \033[0;31m

.PHONY: all check-script build clean

all: check-script build


check-script:
	@printf "$(BLUE)$(BOLD) Checking scripts syntax...$(RESET)\n"
	@sh -n $(NGINX_SCRIPT_PATH) && printf "$(GREEN) ✔ nginx_gen.sh syntax: OK ✅$(RESET)\n"
	@sh -n $(DB_SCRIPT_PATH) && printf "$(GREEN) ✔ db_init.sh syntax: OK ✅$(RESET)\n"


build:
	@printf "$(YELLOW)$(BOLD) Starting build...$(RESET)\n"
	@mkdir -p $(WP_DATA)
	@mkdir -p $(DB_DATA)
	@docker compose -f $(COMPOSE_FILE) up --build -d
	@printf "$(GREEN) ✔ Build completed$(RESET)\n"

clean:
	@printf "$(RED)$(BOLD)Cleaning containers and volumes...$(RESET)\n"
	@docker compose -f $(COMPOSE_FILE) down -v
	@rm -rf $(WP_DATA)
	@rm -rf $(DB_DATA)
	@printf "$(GREEN)✔ Clean completed$(RESET)\n"

