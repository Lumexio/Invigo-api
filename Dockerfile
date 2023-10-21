# Use an official PHP Apache image as the base
FROM php:8.0-apache

# Install system dependencies
#RUN apt-get update && \apt-get install -y \git \unzip

RUN apt-get update \
    && apt-get install -y curl git unzip mariadb-client \
    && apt-get clean
# Install Composer globally
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
# Set the working directory in the container
WORKDIR /var/www/html

# Copy the application files to the container
# COPY . .
 COPY ./app /var/www/html/

# Install dependencies
RUN composer install --no-scripts --no-autoloader
# Install Composer
#RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install PHP extensions required by your application
RUN docker-php-ext-install pdo pdo_mysql


# Install application dependencies using Composer
RUN composer install --no-interaction --optimize-autoloader && php artisan config:cache && php artisan event:cache && php artisan route:cache && php artisan view:cache

# Expose port 80
EXPOSE 80

# Set up Apache virtual host
RUN a2enmod rewrite
COPY apache.conf /etc/apache2/sites-available/000-default.conf


# Start Apache server
CMD ["apache2-foreground"]