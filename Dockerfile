# Use an official PHP runtime with Apache as a parent image
FROM php:8.1-apache

# Install system dependencies
RUN apt-get update \
    && apt-get install -y curl git unzip mariadb-client \
    && apt-get clean

# Install Composer globally
RUN curl -sS https://getcomposer.org/installer -o composer-setup.php \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && rm composer-setup.php
# Enable bcmath extension
RUN docker-php-ext-install bcmath
# # Create a non-root user and switch to that user
# RUN groupadd -g 1000 composer && useradd -u 1000 -g composer -m -s /bin/bash composer
# USER composer

# Set the working directory in the container
WORKDIR /var/www/html

# Copy the application files to the container
COPY . .

# Install dependencies
RUN composer install --no-scripts --no-autoloader

# Expose port 80
EXPOSE 80

# Apache configuration
RUN a2enmod rewrite
RUN chmod 644 /usr/lib/apache2/modules/mod_mpm_prefork.so
RUN a2enmod mpm_prefork
RUN apachectl configtest
# Mod mpm_prefork.so check in the container
RUN ls /etc/apache2/modules/mod_mpm_prefork.so

COPY apache2.conf /etc/apache2/apache2.conf

# Command to run Apache in the foreground
CMD ["apache2-foreground"]
