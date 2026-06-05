# **************************************************************************** #
#                                    Names                                     #
# **************************************************************************** #


# **************************************************************************** #
#                                    Path's                                    #
# **************************************************************************** #

DATA_PATH				= /home/$(USER)/data/volumes
MARIADB_PATH			= $(DATA_PATH)/srcs_mariadb_data
WORDPRESS_PATH			= $(DATA_PATH)/srcs_wordpress_data

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

$(MARIADB_PATH):
	sudo mkdir -p $(MARIADB_PATH)/_data

$(WORDPRESS_PATH):
	sudo mkdir -p $(WORDPRESS_PATH)/_data

build: $(MARIADB_PATH) $(WORDPRESS_PATH)
	docker compose -f $(COMPOSE_FILE) build

up:
	docker compose -f $(COMPOSE_FILE) up -d

down:
	docker compose -f $(COMPOSE_FILE) down

clean:
	docker compose -f $(COMPOSE_FILE) down
	docker system prune -af

re: clean all

vclean: clean
	docker volume prune -f
	sudo rm -fr $(MARIADB_PATH) $(WORDPRESS_PATH)

vre: vclean all
