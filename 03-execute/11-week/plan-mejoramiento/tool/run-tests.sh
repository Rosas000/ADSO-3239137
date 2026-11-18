#!/usr/bin/env bash
set -euo pipefail

# Ejecuta la suite contra la base de pruebas, inyectando el entorno de
# pruebas como variables reales del proceso (ganan sobre cualquier .env).

cd "$(dirname "$0")/.."

docker compose \
    --env-file infra/.env \
    -f infra/docker-compose.yml \
    exec \
    -e APP_ENV=testing \
    -e DB_CONNECTION=pgsql \
    -e DB_HOST=db \
    -e DB_PORT=5432 \
    -e DB_DATABASE=event_furniture_testing \
    -e DB_USERNAME=event_furniture \
    -e DB_PASSWORD=cambiar_esta_clave \
    -e CACHE_STORE=array \
    -e SESSION_DRIVER=array \
    -e QUEUE_CONNECTION=sync \
    -e MAIL_MAILER=array \
    api php artisan test "$@"
