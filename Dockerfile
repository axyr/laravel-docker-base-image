ARG IMAGE_PLATFORM=linux/amd64

FROM --platform=$IMAGE_PLATFORM php:8.4-fpm-alpine AS builder

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

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
        libexif-dev \
        libexif \
        nodejs \
        npm \
        git \
        openssh \
        && rm -rf /var/cache/apk/* /tmp/* /var/tmp/*

RUN docker-php-ext-configure gd --with-jpeg \
    && docker-php-ext-install gd zip exif opcache mysqli pdo pdo_mysql pcntl pgsql pdo_pgsql \
    && docker-php-ext-enable exif opcache pdo_mysql pcntl pgsql pdo_pgsql \
    && pecl install redis \
    && docker-php-ext-enable redis