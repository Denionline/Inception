*This project has been created as part of the 42 curriculum by dximenes.*

# Description

Inception is a system administration project that builds a small Docker-based infrastructure with three services: Nginx, WordPress with PHP-FPM, and MariaDB. The goal is to understand how containers, volumes, networks, secrets, and service orchestration work together in a real deployment.

The project sources are organized under `srcs/`, and the stack is started from the root `Makefile` through `docker-compose.yml`.

## Project description

This infrastructure uses Docker to separate responsibilities into dedicated containers:

- Nginx handles HTTPS traffic and acts as the single public entry point.
- WordPress runs with PHP-FPM and hosts the web application.
- MariaDB stores the database for WordPress.

### Design choices

- Docker Compose is used to define and connect the services.
- Named volumes are used for persistent WordPress files and database data.
- Docker secrets are used for confidential credentials instead of storing passwords in Dockerfiles.
- A private bridge network is used so the services can communicate without exposing internal ports.
- The public entry point is restricted to TLS on port 443.

### Comparisons

#### Virtual Machines vs Docker

Virtual machines emulate full operating systems and are heavier to run. Docker containers share the host kernel, start faster, and are better suited for lightweight service isolation in this project.

#### Secrets vs Environment Variables

Environment variables are useful for general configuration, while secrets are better for sensitive data such as passwords. In this project, both are used: configuration values come from `.env`, while credentials are stored in secret files.

#### Docker Network vs Host Network

A Docker network isolates the stack and lets services communicate by container name. Host networking would remove that isolation and is not used here.

#### Docker Volumes vs Bind Mounts

Named volumes are managed by Docker and are the required choice for persistent database and website data. Bind mounts are not used for the required persistence layer.

# Instructions

## Requirements

- Run the project inside a virtual machine.
- Use Docker Compose from the root `Makefile`.
- Keep all service configuration under `srcs/`.
- Use the `.env` file for environment variables.
- Keep passwords out of Dockerfiles.

## Build and launch

```bash
make build
make up
```

## Stop the project

```bash
make down
```

## Full cleanup

```bash
make clean
make fclean
make re
```

# Resources

## References

- Docker documentation: https://docs.docker.com/
- Docker Compose documentation: https://docs.docker.com/compose/
- MariaDB documentation: https://mariadb.com/kb/en/documentation/
- WordPress documentation: https://wordpress.org/documentation/
- Nginx documentation: https://nginx.org/en/docs/
- PHP-FPM documentation: https://www.php.net/manual/en/install.fpm.php

## AI usage

AI was used to help structure the documentation, summarize the service flow, and organize the comparison sections required by the subject. The final content was verified against the project files and the subject PDF before being kept in the repository.
