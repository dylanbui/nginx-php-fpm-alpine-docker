#!/bin/sh

echo "Build IMAGE nginx-php-fpm-alpine-v2:1.0 "
docker build -t nginx-php-fpm-alpine-v2:1.0 --force-rm -f Dockerfile .

echo "Build XOA Container fpm-7.4-alpine-v2 "
docker container rm fpm-7.4-alpine-v2

echo "Chay Container fpm-7.4-alpine-v2 port 8886 "
docker run -it --name fpm-7.4-alpine-v2 -p 8886:80 nginx-php-fpm-alpine-v2:1.0
