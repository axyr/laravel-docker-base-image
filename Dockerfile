FROM php:8.4-fpm

RUN apt-get update;

RUN apt-get -y --no-install-recommends install \
        libpng-dev \
        libjpeg-dev \
        zlib1g-dev \
        libzip-dev \
        unzip \
        cron \
        supervisor;

RUN apt-get -y --no-install-recommends install \
        php8.4-zip \
        php8.4-gd \
        php8.4-mysql \
        php8.4-exif \
        php8.4-sqlite3 ; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

RUN docker-php-ext-configure gd --with-jpeg && \
    docker-php-ext-configure pcntl --enable-pcntl && \
    docker-php-ext-install gd && \
    docker-php-ext-install zip && \
    docker-php-ext-install exif && \
    docker-php-ext-install opcache && \
    docker-php-ext-enable exif && \
    docker-php-ext-install mysqli pdo pdo_mysql && \
    docker-php-ext-enable pdo_mysql && \
    docker-php-ext-install pcntl && \
    pecl install redis && \
    docker-php-ext-enable redis;
