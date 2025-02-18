# Use the official PHP image with Nginx and Alpine Linux
FROM php:8.2-fpm-alpine

# Install system dependencies
RUN apk update && apk add --no-cache \
    build-base \
    libzip-dev \
    libpng-dev \
    libjpeg-turbo-dev \
    libwebp-dev \
    freetype-dev \
    oniguruma-dev \
    libxml2-dev \
    zip \
    unzip \
    git \
    curl \
    nginx \
    supervisor

# Clear cache
RUN apk cache clean

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql zip exif pcntl bcmath gd

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set working directory
WORKDIR /var/www/html

# Copy the application files
COPY . .

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader

# Copy Nginx configuration
COPY docker/nginx/default.conf /etc/nginx/conf.d/default.conf

# Copy Supervisor configuration
COPY docker/supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Set permissions for storage and cache directories
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Expose port 80
EXPOSE 80

# Start Nginx and PHP-FPM
CMD ["supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
