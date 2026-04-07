FROM alpine:3.22

RUN apk add --no-cache \
    bash \
    ca-certificates \
    wget \
    curl \
    tar \
    mariadb-client \
    php82 \
    php82-fpm \
    php82-curl \
    php82-mbstring \
    php82-xml \
    php82-zip \
    php82-phar \
    php82-mysqli

RUN sed -i 's|^memory_limit = .*|memory_limit = 512M|' /etc/php82/php.ini

RUN sed -i 's|^listen = .*|listen = 9000|' /etc/php82/php-fpm.d/www.conf \
    && sed -i 's|^;clear_env = no|clear_env = no|' /etc/php82/php-fpm.d/www.conf

COPY ./tools/wp_init.sh /usr/local/bin/wp_init.sh

RUN chmod +x /usr/local/bin/wp_init.sh

RUN ln -sf /usr/bin/php82 /usr/bin/php

RUN wget -qO /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&& chmod +x /usr/local/bin/wp

RUN wget -qO /tmp/wordpress.tar.gz https://wordpress.org/latest.tar.gz

RUN mkdir -p /var/www/html

RUN tar -xzf /tmp/wordpress.tar.gz -C /var/www/html --strip-components=1

EXPOSE 9000


ENTRYPOINT [ "/usr/local/bin/wp_init.sh"]
