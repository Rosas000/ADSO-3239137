# Imagen de la API: Nginx + PHP-FPM 8.4 + Laravel 12 + pdo_pgsql.
# Contexto de construccion: raiz de plan-mejoramiento (context: ..).

FROM composer:2 AS build
WORKDIR /build
COPY api/composer.json api/composer.lock ./
RUN composer install --no-scripts --no-interaction --prefer-dist

FROM php:8.4-fpm-alpine

RUN apk add --no-cache nginx supervisor curl libpq-dev \
    && docker-php-ext-install pdo_pgsql

WORKDIR /var/www/html

COPY --from=build /build/vendor ./vendor
COPY api/ ./

RUN cp .env.example .env

COPY infra/nginx/api.conf /etc/nginx/http.d/default.conf
COPY infra/docker/api-supervisord.conf /etc/supervisord.conf
COPY infra/docker/api-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh \
    && chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]
