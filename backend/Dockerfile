FROM php:8.3

WORKDIR /var/www

RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libzip-dev \
    && docker-php-ext-install zip pdo pdo_mysql

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

COPY . .

RUN composer install --no-progress --no-interaction

RUN php artisan migrate --force

EXPOSE 8000

CMD php artisan serve --host=0.0.0.0 --port=8000