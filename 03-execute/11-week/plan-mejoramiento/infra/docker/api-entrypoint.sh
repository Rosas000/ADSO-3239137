#!/bin/sh
set -e
cd /var/www/html

if [ -z "$APP_KEY" ]; then
    php artisan key:generate --force
fi

php artisan migrate --force

# El bind mount de desarrollo trae storage/ y bootstrap/cache de Windows;
# php-fpm (www-data) necesita escritura. Se garantiza en cada arranque.
chmod -R 777 storage bootstrap/cache || true

exec /usr/bin/supervisord -c /etc/supervisord.conf
