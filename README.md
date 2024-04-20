# Tham khảo từ các hệ thống

#### Bài viết

[laravel-applications-with-docker](https://adevait.com/laravel/containerizing-laravel-applications-with-docker)

[containerizing-nginx-php-fpm-on-alpine-linux](https://levelup.gitconnected.com/containerizing-nginx-php-fpm-on-alpine-linux-953430ea6dbc)

#### Đã xây dựng thực thế dùng cho CI/CD (tham khảo chủ yếu ở đây cho webstack)

[joseluisq-alpine-php-fpm](https://github.com/joseluisq/alpine-php-fpm)

#### Xây dựng đầy đủ và chi tiết nhất

[dwchiang-nginx-php-fpm](https://github.com/dwchiang/nginx-php-fpm)

#### Cấu hình dùng file start.sh, với nhiều option khi build

[richarvey-nginx-php-fpm](https://github.com/richarvey/nginx-php-fpm/tree/main)

#### Đơn giản dễ hiểu nhưng cần được cấu hình lại kết hợp với joseluisq mới có thể chạy tốt

[corbosman-nginx-php (Đang chủ yếu dùng thằng này, nhưng quản lý service thì dùng của thằng khác)](https://github.com/corbosman/nginx-php/)

[Justintime50 source này như trên nhưng được cái tham khảo thêm cấu hình email](https://github.com/Justintime50/nginx-php-docker/tree/main)

#### Ý tưởng build một con php:7.4-alpine với các phần mởi rộng, chạy php trên cổng 9000, share thư mục /var/www ra dùng chung với các server Nginx, Apache. Một server php-fpm:9000 sẽ thông dịch toàn bộ php files cho nhiều con server Nginx, Apache - Cần được đánh giá performance

https://varlock.net/how-to-run-nginx-and-php-in-docker/

#### Sử dụng cho source Lavarel thì cài đơn giản hơn, sử dụng "php artisan serve"

[laravel-in-docker](https://buddy.works/guides/laravel-in-docker)