FROM debian:bookworm

EXPOSE 9000

RUN apt-get update && apt-get install -y --no-install-recommends \
    php-fpm php-mysql php-cli php-curl php-gd php-mbstring php-xml php-zip \
    curl ca-certificates wget mariadb-client \
  && rm -rf /var/lib/apt/lists/*

# FPM config
COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf

RUN mkdir -p /run/php /var/www/inception /tmp \
 && chown -R www-data:www-data /var/www/inception

# wp-cli
RUN wget -O /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
 && chmod +x /usr/local/bin/wp

# scripts + wp-config template
COPY tools/setup.sh /usr/local/bin/setup.sh
RUN chmod +x /usr/local/bin/setup.sh
COPY conf/wp-config.php /tmp/wp-config.php

CMD ["setup.sh", "php-fpm8.2", "-F"]