# Use an official PHP image as the base image
FROM php:8.1-apache

# Set the working directory to /var/www/html
WORKDIR /var/www/html

# Install system dependencies and PHP extensions required by Drupal
RUN apt-get update && \
    apt-get install -y \
        libpng-dev \
        libjpeg-dev \
        libpq-dev \
        libzip-dev \
        unzip \
        git && \
    docker-php-ext-configure gd --with-jpeg && \
    docker-php-ext-install gd pdo pdo_mysql pdo_pgsql zip

# Download and install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install Drush (optional, but helpful for clearing the cache and other tasks)
RUN composer require drush/drush

# Copy the existing Drupal application code into the container
COPY . /var/www/html/

# Install Drupal and its dependencies using Composer
#RUN composer install

# Set the correct permissions for files and directories
RUN chown -R www-data:www-data sites modules themes
RUN chmod 755 sites/default
# Expose port 80 to the host machine
EXPOSE 80

# The entry point command to start Apache when the container runs
CMD ["apache2-foreground"]
