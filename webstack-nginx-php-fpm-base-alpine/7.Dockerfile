#FROM alpine:3.10.3
FROM alpine:3.13.12

LABEL maintainer="buivantienduc@gmail.com"

ARG S6_OVERLAY_VERSION=2.2.0.3
ARG BUILDPLATFORM

# Install webserver packages
RUN apk -U upgrade && apk add --no-cache \
    curl \
    nginx \
    php7-fpm php7-json php7-gd php7-pdo_mysql \
	git \
	tzdata \
    && ln -s /usr/sbin/php-fpm7 /usr/sbin/php-fpm \
    && addgroup -S php \
    && adduser -S -G php php \
    && rm -rf /var/cache/apk/* /etc/nginx/http.d/* /etc/php7/conf.d/* /etc/php7/php-fpm.d/*

# Install S6 overlay only linux/amd64 
RUN wget -P /tmp https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-amd64.tar.gz && \
	gunzip -c /tmp/s6-overlay-amd64.tar.gz | tar -xf - -C / && \
	rm -rf /tmp/*

COPY files/general files/php7 /

WORKDIR /www

ENTRYPOINT ["/init"]

EXPOSE 80

HEALTHCHECK --interval=5s --timeout=5s CMD curl -f http://127.0.0.1/php-fpm-ping || exit 1
