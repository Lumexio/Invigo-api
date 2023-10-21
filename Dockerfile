# Use an official PHP runtime with Apache as a parent image
FROM php:8.0-apache

# Install system dependencies
RUN apt-get update \
    && apt-get install -y curl git unzip mariadb-client \
    && apt-get clean

# Install Composer globally
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

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
COPY apache2.conf /etc/apache2/apache2.conf

# Command to run Apache in the foreground
CMD ["apache2-foreground"]
