ARG GD="--with-png-dir=/usr/lib/ --with-jpeg-dir=/usr/lib/ --with-gd"

FROM php:7.4-fpm-alpine

LABEL maintainer="Bui Van Tien Duc <buivantienduc@gmail.com>"

# ENV php_conf /usr/local/etc/php-fpm.conf
ENV fpm_conf /usr/local/etc/php-fpm.d/www.conf
# ENV php_vars /usr/local/etc/php/conf.d/docker-vars.ini


########################################################################################################################
# PHP                                                                                                                  #
########################################################################################################################
RUN mkdir -p /usr/share/man/man1 /usr/share/man/man7 && \
    apk add --update --no-cache --virtual .build-deps icu-dev jpeg-dev libjpeg-turbo-dev libpng-dev libzip-dev \
             postgresql-dev tzdata autoconf alpine-sdk linux-headers && \
    apk --no-cache add postgresql-client libpq libpng libjpeg icu-libs libzip tzdata bash curl git supervisor && \
    pecl channel-update pecl.php.net && \
    # Install php module
    pecl install redis && docker-php-ext-enable redis && \
    docker-php-ext-configure gd ${GD} && \
    docker-php-ext-install bcmath exif gd intl mysqli opcache pcntl pdo pdo_mysql pdo_pgsql pgsql sockets zip && \
    apk del .build-deps && \
    rm -rf /usr/src && \
    mv "${PHP_INI_DIR}/php.ini-production" "${PHP_INI_DIR}/php.ini"

COPY files/etc/php/conf.d/limits.ini ${PHP_INI_DIR}/conf.d/

########################################################################################################################
# NGINX                                                                                                                #
########################################################################################################################
RUN set -x \
    && addgroup -g 101 -S nginx \
    && adduser -S -D -H -u 101 -h /var/cache/nginx -s /sbin/nologin -G nginx -g nginx nginx \
    && apk add --no-cache nginx \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

COPY files/etc/nginx/nginx.conf /etc/nginx/nginx.conf
COPY files/etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf


# tweak php-fpm config
# RUN echo "cgi.fix_pathinfo=0" > ${php_vars} &&\
#     echo "upload_max_filesize = 100M"  >> ${php_vars} &&\
#     echo "post_max_size = 100M"  >> ${php_vars} &&\
#     echo "variables_order = \"EGPCS\""  >> ${php_vars} && \
#     echo "memory_limit = 128M"  >> ${php_vars} && \
RUN sed -i \
        -e "s/;catch_workers_output\s*=\s*yes/catch_workers_output = yes/g" \
        -e "s/pm.max_children = 5/pm.max_children = 4/g" \
        -e "s/pm.start_servers = 2/pm.start_servers = 3/g" \
        -e "s/pm.min_spare_servers = 1/pm.min_spare_servers = 2/g" \
        -e "s/pm.max_spare_servers = 3/pm.max_spare_servers = 4/g" \
        -e "s/;pm.max_requests = 500/pm.max_requests = 200/g" \
        -e "s/user = www-data/user = nginx/g" \
        -e "s/group = www-data/group = nginx/g" \
        -e "s/;listen.mode = 0660/listen.mode = 0666/g" \
        -e "s/;listen.owner = www-data/listen.owner = nginx/g" \
        -e "s/;listen.group = www-data/listen.group = nginx/g" \
        -e "s/listen = 127.0.0.1:9000/listen = \/var\/run\/php-fpm.sock/g" \
        -e "s/^;clear_env = no$/clear_env = no/" \
        ${fpm_conf}


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

ADD files/etc/supervisord.conf /etc/supervisord.conf

ADD files/start.sh /start.sh
RUN chmod 755 /start.sh

# COPY general /

RUN mkdir -p /var/www
# copy in code
COPY src /var/www

EXPOSE 80

# User www-data:nginx
WORKDIR /var/www

CMD ["/start.sh"]
