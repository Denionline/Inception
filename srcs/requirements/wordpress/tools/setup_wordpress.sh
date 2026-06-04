#!/bin/bash
set -e

WP_PATH="/var/www/html"

# Read password from secret file
if [ -n "$WORDPRESS_DB_PASSWORD_FILE" ] && [ -f "$WORDPRESS_DB_PASSWORD_FILE" ]; then
	WORDPRESS_DB_PASSWORD=$(cat "$WORDPRESS_DB_PASSWORD_FILE")
	export WORDPRESS_DB_PASSWORD
fi

echo "Setting up WordPress..."

# Download and configure WordPress if not present
if [ ! -f "$WP_PATH/wp-config.php" ]; then
	echo "Downloading WordPress..."

	wget -q https://wordpress.org/latest.tar.gz -O /tmp/wordpress.tar.gz
	tar -xzf /tmp/wordpress.tar.gz -C /tmp
	rm /tmp/wordpress.tar.gz

	# Copy only missing files (avoid overwriting existing content)
	cp -rn /tmp/wordpress/* "$WP_PATH" || true
	rm -rf /tmp/wordpress

	if [ ! -f wp-cli.phar ]; then
		curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
		chmod +x wp-cli.phar
	fi

	WP="./wp-cli.phar"

	if [ ! -f wp-config-sample.php ]; then
		$WP core download --allow-root
	fi

	if [ ! -f wp-config.php ]; then
		$WP config create \
			--dbname="$WORDPRESS_DB_NAME" \
			--dbuser="$WORDPRESS_DB_USER" \
			--dbpass="$WORDPRESS_DB_PASSWORD" \
			--dbhost="$WORDPRESS_DB_HOST" \
			--allow-root
	fi

	if ! $WP core is-installed --allow-root >/dev/null 2>&1; then
		$WP core install \
			--url="$DOMAIN_NAME" \
			--title="$WP_TITLE" \
			--admin_user="$WP_ADMIN_USER" \
			--admin_password="$WP_ADMIN_PASSWORD" \
			--admin_email="$WP_ADMIN_EMAIL" \
			--allow-root \
			--skip-email
	fi

	if ! $WP user get "$WP_GUEST_USER" --allow-root >/dev/null 2>&1; then
		$WP user create "$WP_GUEST_USER" "$WP_GUEST_EMAIL" \
			--role=subscriber\
			--user_pass="$WP_GUEST_PASSWORD" \
			--allow-root
	fi

	HOME_ID=$( $WP post create \
		--post_type=page \
		--post_title="Well come" \
		--post_status=publish \
		--post_content="$(cat /tmp/homepage.html)" \
		--porcelain \
		--allow-root)

	$WP option update show_on_front page --allow-root
	$WP option update page_on_front "$HOME_ID" --allow-root

	echo "WordPress setup complete."
else
	echo "WordPress already initialized, skipping setup."
fi

echo "Starting PHP-FPM..."
exec php-fpm8.2 -F
