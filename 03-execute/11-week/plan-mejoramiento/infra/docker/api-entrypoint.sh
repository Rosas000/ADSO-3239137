#!/bin/sh
set -e
cd /var/www/html

if [ -z "$APP_KEY" ]; then
    php artisan key:generate --force
fi

php artisan migrate --force

exec /usr/bin/supervisord -c /etc/supervisord.conf
