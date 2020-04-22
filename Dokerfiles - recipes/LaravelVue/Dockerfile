FROM bjmrq/laravel:php-7.4-node-10

# Add user for laravel application
RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www

# Change permission to allow www to add packages
RUN chown -R www:www .

# Copy existing application directory permissions
COPY --chown=www:www . /var/www

# Change current user to www
USER www

# Install npm dependencies
RUN yarn install --ignore-engines --pure-lockfile

# Add to PATH
ENV PATH /var/www/node_modules/.bin/:$PATH

# Run tour production command
RUN yarn production

# Install Composer dependencies
RUN composer self-update
RUN composer install --ignore-platform-reqs --no-interaction --prefer-dist --no-suggest --optimize-autoloader

# Install Xdebug after Composer install because it can slow it down
RUN pecl install xdebug \
  && docker-php-ext-enable xdebug

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm", "--allow-to-run-as-root"]