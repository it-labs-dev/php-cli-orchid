FROM php:8.2.1-cli-alpine

ENV COMPOSER_ALLOW_SUPERUSER=1
ENV COMPOSER_MEMORY_LIMIT=-1

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

RUN apk update && \
    apk add --no-cache --virtual .build-deps $PHPIZE_DEPS \
        git \
    	zip \
        unzip \
        curl \
    	icu-dev \
        libpq-dev \
    	imagemagick-dev \
    	libzip-dev \
        linux-headers && \
    docker-php-ext-install zip pdo pdo_pgsql pgsql pdo_mysql intl exif sockets && \
    pecl install  -o -f imagick && \
	docker-php-ext-enable imagick && \
    pecl install -o -f redis && \
    docker-php-ext-enable redis && \
    pecl install -o -f grpc && \
    install-php-extensions grpc && \
	#apk del .build-deps && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /app