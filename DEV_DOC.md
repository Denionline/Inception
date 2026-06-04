# Developer Documentation

This guide explains how to set up, build, and manage the Inception project as a developer.

## Environment setup

Before building the project, ensure you have:

- Docker installed
- Docker Compose available
- A virtual machine environment
- The repository checked out locally

The project expects the following files and folders:

- `Makefile` at the repository root
- `srcs/docker-compose.yml`
- `srcs/.env`
- `srcs/requirements/` with one folder per service
- `secrets/` for confidential values

## Configuration files and secrets

- `srcs/.env` contains non-sensitive runtime variables such as domain name and database service settings.
- `secrets/db_password.txt` and `secrets/db_root_password.txt` contain database credentials.
- Nginx, MariaDB, and WordPress each have their own Dockerfile and service-specific configuration.

## Build and launch

From the repository root:

```bash
make build
make up
```

The `Makefile` creates the host directories required for persistent data and then builds the service images using the Compose file.

## Useful commands

```bash
make down
make clean
make re
make vclean
make vre
```

## Container and volume management

- `make up` starts the stack.
- `make down` stops the stack.
- `make clean` stops the stack and prunes Docker system resources.
- `make vclean` also prunes volumes and removes the host data directory used by the project.

## Data persistence

The project stores persistent data in Docker named volumes backed by the host path `/home/$USER/docker-data`.

- MariaDB data is stored in the database volume.
- WordPress website files are stored in the website volume.

This persistence ensures that database and site content survive container recreation.