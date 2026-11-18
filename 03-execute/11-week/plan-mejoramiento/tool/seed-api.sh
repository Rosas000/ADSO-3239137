#!/usr/bin/env bash
set -euo pipefail

# Sembrador por API: todo por HTTP contra el contrato de api-contract.md.
# No usa PHP en el host: solo curl, grep y cut.

BASE="${API_BASE:-http://localhost:8000/api/v1}"
EMAIL="${ADVISOR_EMAIL:-asesor@eventfurniture.co}"
PASSWORD="${ADVISOR_PASSWORD:-secreto}"

json() { curl -sS -X "$1" "$BASE$2" -H "Content-Type: application/json" -H "Accept: application/json" "${@:3}"; }

TOKEN=$(json POST /auth/login -d "{\"email\":\"$EMAIL\",\"password\":\"$PASSWORD\"}" | grep -o '"token":"[^"]*"' | head -1 | cut -d'"' -f4)
if [ -z "$TOKEN" ]; then echo "ERROR: no se pudo autenticar"; exit 1; fi
echo "Autenticado."
AUTH="Authorization: Bearer $TOKEN"

echo "Categorias disponibles:"
json GET /categories -H "$AUTH" | grep -o '"slug":"[^"]*"' | cut -d'"' -f4

echo "Creando articulos..."
json POST /articles -H "$AUTH" -d '{"category_id":1,"reference":"SIL-001","name":"Silla Tiffany","total_units":100}' >/dev/null
json POST /articles -H "$AUTH" -d '{"category_id":2,"reference":"MES-001","name":"Mesa redonda","total_units":30}' >/dev/null
json POST /articles -H "$AUTH" -d '{"category_id":3,"reference":"CAR-001","name":"Carpa 6x6","total_units":10}' >/dev/null

echo "Creando organizadores..."
json POST /organizers -H "$AUTH" -d '{"document_number":"1001","full_name":"Ana Ruiz","phone":"3001111111"}' >/dev/null
json POST /organizers -H "$AUTH" -d '{"document_number":"1002","full_name":"Luis Mora","phone":"3002222222"}' >/dev/null

echo "Creando alquiler..."
json POST /rentals -H "$AUTH" -d '{"organizer_id":1,"lines":[{"article_id":1,"quantity":20}]}' >/dev/null

echo "Devolucion parcial..."
json POST /rentals/1/returns -H "$AUTH" -d '{"lines":[{"rental_line_id":1,"quantity":5}]}' >/dev/null

echo "Reporte de mas solicitados:"
json GET /reports/most-requested -H "$AUTH"

echo ""
echo "Siembra completa por HTTP."
