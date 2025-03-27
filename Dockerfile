ARG IMAGE_PLATFORM=linux/amd64
FROM --platform=$IMAGE_PLATFORM php:8.4-fpm-alpine AS builder

RUN apk add --no-cache \
        build-base \
        autoconf \
        libpng-dev \
        libjpeg-turbo-dev \
        zlib-dev \
        libzip-dev \
        unzip \
        libpq-dev \
        curl \
        ca-certificates

RUN docker-php-ext-configure gd --with-jpeg \
    && docker-php-ext-install gd zip exif opcache \
    && docker-php-ext-enable exif opcache \
    && docker-php-ext-install mysqli pdo pdo_mysql \
    && docker-php-ext-enable pdo_mysql \
    && docker-php-ext-install pcntl \
    && docker-php-ext-enable pcntl \
    && docker-php-ext-install pgsql pdo_pgsql \
    && docker-php-ext-enable pgsql pdo_pgsql \
    && pecl install redis \
    && docker-php-ext-enable redis

FROM --platform=$IMAGE_PLATFORM php:8.4-fpm-alpine

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

COPY --from=builder /usr/local/lib/php/extensions/no-debug-non-zts-* /usr/local/lib/php/extensions/no-debug-non-zts-/

RUN apk add --no-cache \
        libpng-dev \
        libjpeg-turbo-dev \
        zlib-dev \
        libzip-dev \
        unzip \
        cronie \
        supervisor \
        libpq-dev \
        curl \
        ca-certificates \
        nodejs \
        npm \
    && rm -rf /var/cache/apk/* /tmp/* /var/tmp/*