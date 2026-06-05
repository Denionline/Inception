# User Documentation

This guide explains how to use the Inception stack as an end user or administrator.

## Services provided

The stack provides three services:

- Nginx serves the website over HTTPS.
- WordPress provides the public site and administration panel.
- MariaDB stores the WordPress database.

## Start and stop the project

Start the stack from the repository root running it:

```bash
make
```

Stop it with:

```bash
make down
```

If you need a full cleanup, use:

```bash
make clean
```

If you need to restart, use:

```bash
make re
```

## Access the website and administration panel

- Open `https://dximenes.42.fr` in your browser.
- The WordPress homepage is served by Nginx.
- The WordPress administration panel is available under the standard WordPress admin path, usually `https://dximenes.42.fr/wp-admin`.

## Locate and manage credentials

- Runtime configuration values are stored in `srcs/.env`.
- Database passwords are stored in the `secrets/` directory.

## Check that the services are running correctly

You can verify the stack by checking that:

- `docker compose -f srcs/docker-compose.yml ps` shows all services running.
- `https://dximenes.42.fr` opens successfully in the browser.
- WordPress loads and the administration panel accepts the configured admin credentials.

## Notes for administrators

- The Nginx container is the only public entry point.
- The stack uses persistent named volumes for the website files and database data.
- Restarting the containers should preserve the WordPress installation and database content.