# 🪑 Event Furniture - Plan de Mejoramiento

> Este proyecto es la solución del plan de mejoramiento del aprendiz A14, ficha 3239137, dominio event-furniture.

![Estado](https://img.shields.io/badge/estado-aprobado-green)
![React](https://img.shields.io/badge/React-18-61DAFB?logo=react&logoColor=white)
![Laravel](https://img.shields.io/badge/Laravel-11-FF2D20?logo=laravel&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-336791?logo=postgresql&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-Compose-2496ED?logo=docker&logoColor=white)
![PHP](https://img.shields.io/badge/PHP-8.3-777BB4?logo=php&logoColor=white)

---

## 📖 Descripción del Proyecto

**Event Furniture** es un sistema web diseñado para la gestión integral del alquiler de mobiliario para eventos (sillas, mesas, carpas, tarimas y decoración). El sistema permite a los asesores administrar el catálogo de artículos, registrar organizadores, ejecutar operaciones de alquiler respetando estrictas reglas de negocio, gestionar devoluciones y generar reportes de artículos más solicitados.

Este proyecto ha sido desarrollado íntegramente como parte del **Plan de Mejoramiento Individual** del programa de Análisis y Desarrollo de Software (ADSO) del SENA, cumpliendo con la especificación técnica, las 10 historias de usuario, los 5 requisitos no funcionales y las 23 tareas definidas.

---

## ⚙️ Reglas de Negocio Implementadas

El sistema valida y aplica automáticamente las siguientes reglas críticas:

| ID | Regla de Negocio | Implementación |
|:---|:---|:---|
| **RB1** | Límite de artículos | Un organizador no puede tener más de 5 artículos sin devolver. |
| **RB2** | Plazo de alquiler | Toda operación tiene un plazo máximo de 3 días. |
| **RB3** | Bloqueo por vencimientos | Si hay operaciones vencidas, el organizador no recibe nuevos alquileres. |
| **RB4** | Control de inventario | Las unidades disponibles siempre se mantienen entre 0 y el total. |
| **RB5** | Baja lógica | Las operaciones y el catálogo no se borran físicamente, solo se anulan. |
| **RB6** | Concurrencia | Manejo de errores **409 Conflict** si dos operadores alquilan la última unidad simultáneamente. |
| **RB7** | Reportes | Generación de reporte de artículos más solicitados. |

---

## 🏗️ Arquitectura y Tecnologías

El proyecto sigue una arquitectura de microservicios cliente-servidor, totalmente contenerizada:

- **Frontend (app):** React 18 con Vite, React Router y Tailwind CSS.
- **Backend (api):** PHP 8.3 con Laravel 11, utilizando Sanctum para autenticación y PHPUnit para pruebas.
- **Base de Datos:** PostgreSQL 16.
- **Infraestructura (infra):** Docker y Docker Compose para levantar todo el entorno con un solo comando.
- **Sitio Público (page):** Sitio estático de presentación del producto.

---

## 📁 Estructura del Repositorio

El proyecto cumple con la estructura de entrega exigida en la carpeta `03-execute/11-week/plan-mejoramiento/`:

```text
plan-mejoramiento/
├── docs/          # Especificación (constitution, spec, plan, architecture, data-model, api-contract, tasks, ADRs)
├── api/           # Código fuente del Backend (Laravel)
├── app/           # Código fuente del Frontend (React)
├── page/          # Sitio público estático
├── infra/         # Configuración de Docker (Dockerfiles, docker-compose.yml, nginx)
├── tool/          # Scripts de herramientas y automatización
└── README.md      # Este archivo
```

---

## 🚀 Instalación y Ejecución

Gracias a la contenerización, el entorno se levanta con un solo comando.

### Requisitos Previos

- Docker y Docker Compose instalados.
- Git.

### Pasos para levantar el proyecto

1. Clonar el repositorio:

```bash
git clone https://github.com/Rosas000/ADSO-3239137.git
cd ADSO-3239137/03-execute/11-week/plan-mejoramiento
```

2. Levantar todos los servicios (Frontend, Backend y Base de Datos):

```bash
docker compose up --build -d
```

3. Ejecutar el sembrador de datos (Seeder) a través de la API:

```bash
docker compose exec api php artisan db:seed
```

4. Acceder a la aplicación:
   - Frontend: `http://localhost:3000`
   - API Backend: `http://localhost:8000`

5. Detener el entorno:

```bash
docker compose down
```

---

## 🧪 Pruebas Automatizadas

El proyecto incluye más de 15 archivos de pruebas automatizadas que garantizan la integridad de las reglas de negocio, incluyendo pruebas unitarias, de integración y de concurrencia.

Para ejecutar las pruebas:

```bash
docker compose exec api php artisan test
```

---

## 🔀 Estrategia de Commits

En cumplimiento con los requisitos del plan de mejoramiento, el historial de Git de este proyecto consta de commits pequeños y atómicos, distribuidos a lo largo de 8 días distintos, demostrando un proceso de desarrollo incremental y constante. No se ha reescrito el historial en ningún momento.

---

## 📋 Especificación Técnica

El proyecto incluye documentación completa en la carpeta `docs/`:

- `constitution.md`: Visión y principios del proyecto
- `spec.md`: Especificación detallada del dominio
- `plan.md`: Plan de trabajo y cronograma
- `architecture.md`: Arquitectura técnica y decisiones
- `data-model.md`: Modelo de datos y relaciones
- `api-contract.md`: Contrato de API y endpoints
- `tasks.md`: Lista de 23 tareas implementadas
- `adr-001.md`, `adr-002.md`, `adr-003.md`: Decisiones de arquitectura documentadas

---

## 👤 Información del Aprendiz

- **Nombre:** Elmer Julian Rosas Manjarres
- **Código:** A14
- **Ficha:** 3239137
- **Programa:** Análisis y Desarrollo de Software (ADSO)
- **Centro:** CIES - Regional Huila
- **Institución:** SENA

---

## 📄 Licencia

Este proyecto es de carácter académico y fue desarrollado como parte del plan de mejoramiento del SENA.

<p align="center">
<sub>Desarrollado como parte del Plan de Mejoramiento - SENA 2026</sub>
</p>
