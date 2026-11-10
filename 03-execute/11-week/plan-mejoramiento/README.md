Este proyecto es la solución del plan de mejoramiento del aprendiz A14, ficha 3239137, dominio event-furniture.

## Descripción
Sistema web para gestionar el alquiler de mobiliario para eventos (sillas, mesas, carpas, tarimas, decoración).

## Tecnologías
- Frontend: React
- Backend: PHP con Laravel
- Base de datos: PostgreSQL
- Contenedores: Docker

## Reglas de negocio
1. Máximo 5 artículos sin devolver por organizador
2. Plazo de alquiler de 3 días
3. Unidades disponibles entre 0 y total
4. Operaciones y devoluciones no se borran (baja lógica)
5. Fechas en UTC, mensajes en español
6. Concurrencia: 409 Conflict si dos operadores alquilan la última unidad
7. Reporte de artículos más solicitados
EOF 

