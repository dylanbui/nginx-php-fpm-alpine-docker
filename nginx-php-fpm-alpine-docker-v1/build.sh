#!/bin/sh

echo "Build IMAGE nginx-php-fpm-alpine-v1:1.0 "
docker build -t nginx-php-fpm-alpine-v1:1.0 --force-rm -f Dockerfile .

echo "Build XOA Container fpm-7.4-alpine-v1 "
docker container rm fpm-7.4-alpine-v1

echo "Chay Container fpm-7.4-alpine-v1 port 8887 "
docker run -it --name fpm-7.4-alpine-v1 -p 8887:80 nginx-php-fpm-alpine-v1:1.0
