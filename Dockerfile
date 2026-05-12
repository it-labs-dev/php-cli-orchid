FROM 8.4-alpine3.23-fips

ENV COMPOSER_ALLOW_SUPERUSER=1
ENV COMPOSER_MEMORY_LIMIT=-1

ARG PROTOC_VERSION=32.1
ARG PROTOC_PLUGIN_VERSION=0.1.4

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
    docker-php-ext-install zip pdo pdo_pgsql pgsql pdo_mysql intl exif sockets bcmath && \
    install-php-extensions imagick && \
    install-php-extensions redis && \
    install-php-extensions grpc && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN apk add --no-cache curl unzip && \
    curl -LO "https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOC_VERSION}/protoc-${PROTOC_VERSION}-linux-x86_64.zip" && \
    unzip "protoc-${PROTOC_VERSION}-linux-x86_64.zip" -d /usr/local && \
    rm "protoc-${PROTOC_VERSION}-linux-x86_64.zip" && \
    curl -L https://github.com/thesis-php/protoc-plugin/releases/download/${PROTOC_PLUGIN_VERSION}/protoc-gen-php \
    -o /usr/local/bin/protoc-gen-php \
    && chmod +x /usr/local/bin/protoc-gen-php

WORKDIR /app