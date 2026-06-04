# **************************************************************************** #
#                                    Names                                     #
# **************************************************************************** #


# **************************************************************************** #
#                                    Path's                                    #
# **************************************************************************** #

DATA_PATH				= /home/$(USER)/docker-data

# **************************************************************************** #
#                                    Files                                     #
# **************************************************************************** #

COMPOSE_FILE			= srcs/docker-compose.yml

# **************************************************************************** #
#                                  Compiler                                    #
# **************************************************************************** #

MAKE				= make --no-print-directory
RM					= rm -rf

# **************************************************************************** #
#                                    Comands                                   #
# **************************************************************************** #

.PHONY: all build up down clean fclean re

all: build up

$(DATA_PATH)/mariadb:
	mkdir -p $(DATA_PATH)/mariadb

$(DATA_PATH)/wordpress:
	mkdir -p $(DATA_PATH)/wordpress

build: $(DATA_PATH)/mariadb $(DATA_PATH)/wordpress
	docker compose -f $(COMPOSE_FILE) build

up:
	docker compose -f $(COMPOSE_FILE) up

down:
	docker compose -f $(COMPOSE_FILE) down

clean:
	docker compose -f $(COMPOSE_FILE) down
	docker system prune -af

re: clean all

vclean: clean
	docker volume prune -f
	sudo rm -rf $(DATA_PATH)

vre: vclean all
