FROM debian:bullseye

# Add Sury PHP repository, then install PHP 8.2 packages
RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		ca-certificates \
		wget \
		gnupg2 \
		lsb-release \
		curl \
	&& wget -qO /usr/share/keyrings/php-sury.gpg https://packages.sury.org/php/apt.gpg \
	&& echo "deb [signed-by=/usr/share/keyrings/php-sury.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends \
		php8.2-fpm \
		php8.2-mysql \
		php8.2-curl \
		php8.2-gd \
		php8.2-intl \
		php8.2-mbstring \
		php8.2-soap \
		php8.2-xml \
		php8.2-zip \
	&& ln -s /usr/sbin/php-fpm8.2 /usr/local/bin/php-fpm \
	&& rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html

COPY conf/www.conf /etc/php/8.2/fpm/pool.d/

COPY tools/setup_wordpress.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/setup_wordpress.sh

COPY tools/homepage.html /tmp/

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/setup_wordpress.sh"]
