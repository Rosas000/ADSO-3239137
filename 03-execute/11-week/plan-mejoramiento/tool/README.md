# Herramientas — Event Furniture

Scripts de apoyo para la operación del proyecto.

## run-tests.sh

Ejecuta la suite completa de pruebas dentro del contenedor de la API.

    ./tool/run-tests.sh
    ./tool/run-tests.sh --filter OrganizerBlockTest

Requiere `ef-api` levantado con `docker compose up -d api`.

## seed-api.sh

Siembra datos consumiendo la API por HTTP, autenticando un asesor y
creando artículos, organizadores, alquileres y devoluciones.

    API_BASE=http://localhost:8000/api/v1 ./tool/seed-api.sh

Requiere `ef-api` levantado y los endpoints publicados.
No implementa reglas de negocio: confía en que la API las aplica.

## evidence/

Carpeta para capturas de verificación manual (T03, T04, T24).
No se versionan archivos de evidencia binarios: se crean en cada
ejecución y se adjuntan al informe por separado.
