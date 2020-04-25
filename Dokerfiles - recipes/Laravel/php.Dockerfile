FROM bjmrq/laravel:php-7.4-node-10

# Set development env
ENV APP_ENV=local

# Install Xdebug after Composer install because it can slow it down
RUN pecl install xdebug \
  && docker-php-ext-enable xdebug

# Add user for laravel application
RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www

# # Change permission to allow www to add packages
RUN chown -R www:www .

# Change current user to www
USER www

COPY --chown=www:www database/ /var/www/database/

# Install Composer dependencies
COPY --chown=www:www composer.json composer.lock /var/www/
RUN composer install \
  --ignore-platform-reqs \
  --no-interaction \
  --no-plugins \
  --no-scripts \
  --prefer-dist \
  --no-autoloader

# Copy existing application directory permissions
COPY --chown=www:www . /var/www

# Optimize composer
RUN composer dump-autoload --no-scripts --optimize

# Expose port 9000 and start php-fpm server
EXPOSE 9000

# CMD ["php-fpm"]
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
