ARG IMAGE_PLATFORM=linux/amd64
FROM --platform=$IMAGE_PLATFORM php:8.4-fpm

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
RUN composer --version && php -v

RUN apt-get update && apt-get install -y --no-install-recommends \
        libpng-dev \
        libjpeg-dev \
        zlib1g-dev \
        libzip-dev \
        unzip \
        cron \
        supervisor \
        libpq-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

RUN docker-php-ext-configure gd --with-jpeg \
    && docker-php-ext-install gd zip exif opcache \
    && docker-php-ext-enable exif opcache \
    && docker-php-ext-install mysqli pdo pdo_mysql \
    && docker-php-ext-enable pdo_mysql \
    && docker-php-ext-install pcntl \
    && docker-php-ext-enable pcntl \
    && docker-php-ext-install pgsql pdo_pgsql \
    && docker-php-ext-enable pgsql pdo_pgsql

RUN pecl install redis \
    && docker-php-ext-enable redis