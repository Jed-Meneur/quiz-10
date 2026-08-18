FROM php:8.2-apache
RUN apt-get update && apt-get install -y unzip git curl libpng-dev libonig-dev libxml2-dev zip
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
WORKDIR /var/www/html
COPY . .
RUN composer install --no-dev --optimize-autoloader
RUN chown -R www-data:www-data /var/www/html
RUN sed -i 's/80/$PORT/g' /etc/apache2/ports.conf /etc/apache2/sites-available/000-default.conf
CMD php artisan serve --host=0.0.0.0 --port=$PORT
