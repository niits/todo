FROM php:7.4-fpm-alpine3.12

ENV PHPIZE_DEPS \
    autoconf \
    cmake \
    file \
    g++ \
    gcc \
    libc-dev \
    pcre-dev \
    make \
    git \
    pkgconf \
    re2c \
    # for GD
    freetype-dev \
    libpng-dev  \
    libjpeg-turbo-dev \
    # for xslt
    libxslt-dev \
    # for intl extension
    icu-dev \
    openssl-dev
RUN apk add --no-cache --virtual .persistent-deps \
    icu-libs \
    postgresql-dev \
    libxml2-dev \
    libressl-dev \
    freetype \
    libpng \
    libjpeg-turbo \
    libxslt \
    oniguruma-dev \
    libgcrypt
RUN set -xe \
    && ln -s /usr/lib /usr/local/lib64 \
    && ln -s /usr/lib/libgcrypt.so.20 /usr/lib/libgcrypt.so \
    && ln -s /usr/lib/libgpg-error.so.0 /usr/lib/libgpg-error.so \
    && apk add --no-cache --virtual .build-deps \
    $PHPIZE_DEPS \
    && docker-php-ext-configure gd \
    --enable-gd \
    --with-freetype=/usr/include/ \
    --with-jpeg=/usr/include/ \
    && docker-php-ext-configure bcmath --enable-bcmath \
    && docker-php-ext-configure intl --enable-intl \
    && docker-php-ext-configure pcntl --enable-pcntl \
    && docker-php-ext-configure mysqli --with-mysqli \
    && docker-php-ext-configure pdo_mysql --with-pdo-mysql \
    && docker-php-ext-configure pdo_pgsql --with-pdo-pgsql \
    && docker-php-ext-configure mbstring --enable-mbstring \
    && docker-php-ext-configure soap --enable-soap \
    && docker-php-ext-install -j$(nproc) \
    gd \
    bcmath \
    intl \
    pcntl \
    mysqli \
    pdo_mysql \
    pdo_pgsql \
    mbstring \
    soap \
    iconv \
    xsl

ENV PHP_REDIS_VERSION 5.3.1
RUN git clone --branch ${PHP_REDIS_VERSION} https://github.com/phpredis/phpredis /tmp/phpredis \
    && cd /tmp/phpredis \
    && phpize  \
    && ./configure  \
    && make  \
    && make install \
    && make test

ENV PHP_PROTOBUF_VERSION v0.12.4
RUN git clone --branch ${PHP_PROTOBUF_VERSION} https://github.com/allegro/php-protobuf /tmp/phpprotobuf \
    && cd /tmp/phpprotobuf \
    && phpize  \
    && ./configure  \
    && make  \
    && make install \
    && make test

RUN apk add --no-cache --no-progress --virtual .build_deps_php_amqp rabbitmq-c-dev \
    && apk add --no-cache --no-progress rabbitmq-c \
    && apk add --no-cache git autoconf automake gawk build-base \
    && pecl install amqp \
    && apk del .build_deps_php_amqp


ENV PHP_SIMDJSON_VERSION master

ENV PHPIZE_DEPS \
    autoconf \
    g++ \
    gcc \
    make \
    pkgconf \
    git \
    re2c
RUN set -xe \
    && apk add --no-cache --virtual .build-deps \
    $PHPIZE_DEPS \
    && git clone --branch ${PHP_SIMDJSON_VERSION} https://github.com/crazyxman/simdjson_php /tmp/simdjson \
    && cd /tmp/simdjson \
    && phpize  \
    && ./configure  \
    && make  \
    && make install \
    && make test


RUN apk del .build-deps \
    && rm -rf /tmp/* \
    && rm -rf /app \
    && mkdir /app

WORKDIR /var/www