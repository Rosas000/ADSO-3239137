Este proyecto es la solución del plan de mejoramiento del aprendiz A14, ficha 3239137, dominio event-furniture.

# Event Furniture

Plan de mejoramiento individual, Acta No. 14 - 2026 (ADSO, ficha 3239137, SENA - CIES, Regional Huila).

---

## Descripción

**Event Furniture** es un sistema web para gestionar el alquiler de mobiliario para eventos. Permitirá a los asesores administrar el catálogo de artículos, registrar organizadores, crear alquileres, registrar devoluciones y consultar el reporte de artículos más solicitados.

El catálogo tendrá cinco categorías sembradas: sillas, mesas, carpas, tarimas y decoración.

---

## Equivalencias con Manager Library

El proyecto adapta la especificación de Manager Library al dominio de alquiler de mobiliario:

| Manager Library | Event Furniture |
|:---|:---|
| Libro | Artículo (identificado por referencia) |
| Ejemplares | Unidades |
| Socio | Organizador |
| Bibliotecario | Asesor |
| Préstamo | Alquiler |
| Categoría | Cinco categorías sembradas: sillas, mesas, carpas, tarimas, decoración |

---

## Reglas de negocio

| # | Regla |
|:--|:---|
| 1 | Un organizador no puede tener más de 5 artículos sin devolver. |
| 2 | Todo alquiler tiene un plazo de 3 días. |
| 3 | Un organizador con alquileres vencidos no recibe más artículos hasta devolverlos. |
| 4 | Las unidades disponibles están siempre entre 0 y el total. |
| 5 | Los datos congelados en la línea de la operación no cambian cuando cambia el catálogo. |
| 6 | Las operaciones y devoluciones no se borran; el catálogo solo tiene baja lógica. |

Reglas transversales: las fechas se manejan en UTC y los mensajes al usuario están en español.

**Concurrencia:** si dos operadores entregan la última unidad a la vez, uno la obtiene y el otro recibe un error `409 Conflict`.

**Reporte:** artículos más solicitados.

---

## Stack previsto

- **Frontend (`app`):** React.
- **Backend (`api`):** PHP con Laravel.
- **Base de datos y contenedores (`infra`):** Docker Compose, con la base de datos y un sembrador de datos por la API.
- **Sitio público (`page`):** sitio estático que presenta el producto.

Las versiones y decisiones técnicas definitivas quedarán en `docs/architecture.md` y en los ADR.

---

## Estructura de la entrega

    plan-mejoramiento/
    |-- docs/     # constitution, spec, plan, architecture, data-model, api-contract, tasks y al menos 3 ADR
    |-- api/      # Backend (Laravel)
    |-- app/      # Frontend (React)
    |-- page/     # Sitio público estático
    |-- infra/    # Contenedores y base de datos
    |-- tool/     # Scripts de apoyo
    `-- README.md

---

## Estado del proyecto

En desarrollo. Este README se actualiza a medida que avanza el trabajo.

- [ ] Especificación (`docs/`)
- [ ] Backend (`api/`)
- [ ] Frontend (`app/`)
- [ ] Sitio público (`page/`)
- [ ] Contenedores y sembrador de datos (`infra/`)
- [ ] Pruebas automatizadas
- [ ] Alcance completo: 10 historias, 6 reglas, 5 requisitos no funcionales y 23 tareas

---

## Ejecución

Pendiente: se documentará aquí cuando los contenedores estén listos.

---

## Entrega

- **Plan:** Acta No. 14 - 2026, vigente del 5 al 19 de noviembre de 2026.
- **Entrega:** jueves 19 de noviembre de 2026, 6:00 p. m.
- **Sustentación:** jueves 26 de noviembre de 2026.
- **Aprendiz:** código A14, ficha 3239137, Análisis y Desarrollo de Software (ADSO).
- **Centro:** Centro de la Industria, la Empresa y los Servicios (CIES), Regional Huila, SENA.
