#!/usr/bin/env bash
set -euo pipefail

# Ejecuta la suite completa de pruebas dentro del contenedor de la API.
# Uso: ./tool/run-tests.sh
# Requiere: ef-api levantado con docker compose up -d api

cd "$(dirname "$0")/.."

docker compose \
    --env-file infra/.env \
    -f infra/docker-compose.yml \
    exec api php artisan test "$@"
