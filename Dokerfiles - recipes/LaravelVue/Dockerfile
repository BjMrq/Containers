FROM bjmrq/laravel:php-7.4-node-10

# Add user for laravel application
RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www

# Change permission to allow www to add packages
RUN chown -R www:www .

# Change current user to www
USER www

# Install npm dependencies
COPY --chown=www:www package.json package-lock.json* yarn.lock* /var/www/
RUN yarn --ignore-engines --pure-lockfile

# Add to PATH
ENV PATH /var/www/node_modules/.bin/:$PATH

# Run tour production command
RUN yarn production

# Copy existing application directory permissions
COPY --chown=www:www . /var/www

# Install Composer dependencies
RUN composer self-update
RUN composer install --ignore-platform-reqs --no-interaction --prefer-dist --no-suggest --optimize-autoloader

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm", "--allow-to-run-as-root"]
