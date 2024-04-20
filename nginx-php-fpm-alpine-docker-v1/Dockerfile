ARG PHP_VERSION=7.4
ARG GD="--with-png-dir=/usr/lib/ --with-jpeg-dir=/usr/lib/ --with-gd"

FROM php:${PHP_VERSION}-fpm-alpine

# Da chay dc file nay 19/04/2024

########################################################################################################################
# PHP                                                                                                                  #
########################################################################################################################
RUN mkdir -p /usr/share/man/man1 /usr/share/man/man7 && \
    apk add --update --no-cache --virtual .build-deps icu-dev jpeg-dev libjpeg-turbo-dev libpng-dev libzip-dev \
             postgresql-dev tzdata autoconf alpine-sdk linux-headers && \
    apk --no-cache add postgresql-client libpq libpng libjpeg icu-libs libzip tzdata bash curl git && \
    pecl channel-update pecl.php.net && \
    # Install php module
    pecl install redis && docker-php-ext-enable redis && \
    docker-php-ext-configure gd ${GD} && \
    docker-php-ext-install bcmath exif gd intl mysqli opcache pcntl pdo pdo_mysql pdo_pgsql pgsql sockets zip && \
    apk del .build-deps && \
    rm -rf /usr/src && \
    mv "${PHP_INI_DIR}/php.ini-production" "${PHP_INI_DIR}/php.ini"

COPY php/limits.ini ${PHP_INI_DIR}/conf.d/

########################################################################################################################
# NGINX                                                                                                                #
########################################################################################################################
RUN set -x \
    && addgroup -g 101 -S nginx \
    && adduser -S -D -H -u 101 -h /var/cache/nginx -s /sbin/nologin -G nginx -g nginx nginx \
    && apk add --no-cache nginx \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY nginx/default.conf /etc/nginx/conf.d/default.conf

########################################################################################################################
# COMPOSE                                                                                                             #
########################################################################################################################

RUN apk --no-cache add npm nodejs
# Install the latest version of Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

########################################################################################################################
# Set timezone                                                                                                           #
########################################################################################################################

RUN cp /usr/share/zoneinfo/Asia/Ho_Chi_Minh /etc/localtime && \
    echo "Asia/Ho_Chi_Minh" >  /etc/timezone

########################################################################################################################
# supervisor                                                                                                           #
########################################################################################################################
# Install S6 overlay only linux/amd64 
ARG S6_OVERLAY_VERSION=2.2.0.3
RUN wget -P /tmp https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-amd64.tar.gz && \
    gunzip -c /tmp/s6-overlay-amd64.tar.gz | tar -xf - -C / && \
    rm -rf /usr/src && rm -rf /tmp/*


COPY general /

# User www-data:nginx
WORKDIR /www

EXPOSE 80

CMD ["/init"]
