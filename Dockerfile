FROM composer:latest as composer
FROM wordpress:6.1-fpm-alpine as wordpress
FROM wordpress:6.1-fpm-alpine as php

COPY --from=composer /usr/bin/composer /usr/bin/composer
ENV COMPOSER_ALLOW_SUPERUSER=1

#define wordpress version
ARG WP_VERSION=6.1

#define env vars for wordpress tests, wordpress tests needs to know the wordpress folder installation and tests folder
ENV WP_TESTS_DIR=/app/wordpress/tests
ENV WP_CORE_DIR=/usr/src/wordpress/

# Install subversion, needed to transfer the tests files.
RUN apk add subversion
RUN mkdir -p "$WP_TESTS_DIR"

# Get phpunit tests tool from wordpress svn
RUN svn co --quiet https://develop.svn.wordpress.org/branches/${WP_VERSION}/tests/phpunit/includes/ $WP_TESTS_DIR/includes
RUN svn co --quiet https://develop.svn.wordpress.org/branches/${WP_VERSION}/tests/phpunit/data/ $WP_TESTS_DIR/data

COPY --from=wordpress /usr/src/wordpress/ ./

# to avoid errors in tests we need to create the uploads folder
RUN mkdir "$WP_CORE_DIR/wp-content/uploads"

COPY ./wp-config.php "$WP_TESTS_DIR/wp-tests-config.php"

#install xdebug
RUN apk add --no-cache $PHPIZE_DEPS \
    && pecl install xdebug > /dev/null \
    && docker-php-ext-enable xdebug

## Add line to php file to use xdebug
RUN echo 'xdebug.mode=coverage' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

WORKDIR /theme

USER 1001
