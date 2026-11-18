#!/usr/bin/env bash
set -euo pipefail

# Sembrador por API: autentica un asesor, crea categorias, articulos,
# organizadores, alquileres y devoluciones, todo por HTTP consumiendo el
# contrato de api-contract.md.
#
# Uso: ./tool/seed-api.sh
# Requiere: ef-api levantado y las rutas de api-contract.md publicadas.
#
# Este script no implementa reglas de negocio: confía en que la API las
# aplica. Si un endpoint falla con 422 o 409, el script se detiene con error.

BASE="${API_BASE:-http://localhost:8000/api/v1}"
EMAIL="${ADVISOR_EMAIL:-asesor@eventfurniture.co}"
PASSWORD="${ADVISOR_PASSWORD:-secreto}"

http() {
    local method="$1" path="$2"; shift 2
    curl -sS -X "$method" "$BASE$path" -H "Content-Type: application/json" \
         -H "Accept: application/json" "$@"
}

# 1. Autenticar (SOP01)
TOKEN=$(http POST /auth/login -d "{\"email\":\"$EMAIL\",\"password\":\"$PASSWORD\"}" \
        | php -r 'echo json_decode(file_get_contents("php://stdin"), true)["token"];')
echo "Autenticado."

auth=(-H "Authorization: Bearer $TOKEN")

# 2. Categorias (SOP02) - solo lectura, deben existir por CategorySeeder
echo "Verificando categorias..."
http GET /categories "${auth[@]}" | php -r 'echo "Categorias: " . count(json_decode(file_get_contents("php://stdin"), true)["data"]) . PHP_EOL;'

# 3. Articulos (HU01)
ARTICLES='[
  {"reference":"SIL-001","name":"Silla Tiffany blanca","category_id":1,"total_units":100},
  {"reference":"MES-001","name":"Mesa redonda 1.5m","category_id":2,"total_units":30},
  {"reference":"CAR-001","name":"Carpa 6x6 blanca","category_id":3,"total_units":10}
]'
echo "Creando articulos..."
for art in $(echo "$ARTICLES" | php -r 'foreach(json_decode(file_get_contents("php://stdin"), true) as $a) echo json_encode($a).PHP_EOL;'); do
    http POST /articles "${auth[@]}" -d "$art" >/dev/null
done
echo "Articulos creados."

# 4. Organizadores (HU04)
ORGS='[
  {"document_number":"1001","full_name":"Ana Ruiz","phone":"3001111111"},
  {"document_number":"1002","full_name":"Luis Mora","phone":"3002222222"}
]'
echo "Creando organizadores..."
for org in $(echo "$ORGS" | php -r 'foreach(json_decode(file_get_contents("php://stdin"), true) as $o) echo json_encode($o).PHP_EOL;'); do
    http POST /organizers "${auth[@]}" -d "$org" >/dev/null
done
echo "Organizadores creados."

# 5. Alquiler (HU06)
echo "Creando alquiler de prueba..."
http POST /rentals "${auth[@]}" -d '{
  "organizer_id":1,
  "lines":[{"article_id":1,"quantity":20}]
}' >/dev/null
echo "Alquiler creado."

echo "Siembra completa."
