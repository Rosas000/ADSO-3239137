# Contrato de API — Event Furniture

Contrato HTTP entre el frontend React y el backend Laravel.
Base: /api/v1. Identificadores en inglés; mensajes al usuario en español.

---

## 1. Convenciones

| Aspecto | Valor |
|:---|:---|
| Base URL | /api/v1 |
| Autenticación | Authorization: Bearer <token> (Sanctum) |
| Content-Type | application/json |
| Fechas | ISO 8601 en UTC con sufijo Z |
| Paginación | ?page=N&per_page=M; respuesta con data, meta, links |
| Errores | { "message": "...", "errors": { "campo": ["..."] } } |

Códigos de estado usados:

| Código | Cuándo |
|:---|:---|
| 200 | consulta o actualización exitosa |
| 201 | creación exitosa |
| 401 | sin token o token inválido |
| 404 | recurso inexistente |
| 409 | conflicto de estado (duplicado, inventario insuficiente, deadlock evitado) |
| 422 | datos mal formados o regla de negocio violada |

No se usa 403: existe un único rol operativo.

Mensajes de error estándar:

| Situación | Código | Mensaje |
|:---|:---|:---|
| Sin token o token inválido | 401 | Las credenciales no son válidas. / No autenticado. |
| Recurso inexistente | 404 | Recurso no encontrado. |
| Referencia duplicada | 409 | Ya existe un artículo con esa referencia. |
| Documento duplicado | 409 | Ya existe un organizador con ese documento. |
| Inventario insuficiente | 409 | No hay unidades suficientes del artículo solicitado. |
| RN03 — organizador con vencidos | 422 | El organizador tiene alquileres vencidos. Debe devolverlos antes de recibir más artículos. |
| RN01 — límite de cinco | 422 | El organizador no puede tener más de 5 artículos sin devolver. |
| Baja lógica con pendientes | 422 | No se puede dar de baja un artículo con unidades sin devolver. |
| Total por debajo de lo alquilado | 422 | El total de unidades no puede ser menor a las unidades alquiladas. |
| Devolver más de lo pendiente | 422 | La cantidad a devolver supera las unidades pendientes. |
| Alquiler ya devuelto | 422 | El alquiler ya fue devuelto por completo. |
| Línea no pertenece al alquiler | 422 | La línea indicada no pertenece al alquiler. |
| Cantidad cero o negativa | 422 | La cantidad debe ser mayor que cero. |
| Validación de campos | 422 | {campo}: [lista de mensajes específicos] |
| Rango de fechas inválido | 422 | El rango de fechas no es válido. |

---

## 2. Autenticación (SOP01)

### POST /api/v1/auth/login

Sin autenticación.

Request:

    { "email": "asesor@eventfurniture.co", "password": "********" }

Éxito 200:

    { "token": "1|abc...", "advisor": { "id": 1, "name": "...", "email": "..." } }

Error 401:

    { "message": "Las credenciales no son válidas.", "errors": {} }

---

## 3. Categorías (SOP02)

### GET /api/v1/categories

Requiere token. Solo lectura.

Éxito 200:

    { "data": [ { "id": 1, "name": "Sillas", "slug": "sillas" }, ... ] }

---

## 4. Artículos

### GET /api/v1/articles  (HU02)

Requiere token. Parámetros: category (slug), search (referencia o nombre, coincidencia parcial),
page, per_page. Excluye artículos con baja lógica.

Éxito 200:

    {
      "data": [
        {
          "id": 1,
          "category_id": 1,
          "reference": "SIL-001",
          "name": "Silla Tiffany blanca",
          "description": "...",
          "total_units": 100,
          "available_units": 80,
          "created_at": "2026-11-12T00:00:00Z",
          "updated_at": "2026-11-12T00:00:00Z"
        }
      ],
      "meta": { "current_page": 1, "total": 42 },
      "links": { "next": null }
    }

### GET /api/v1/articles/{id}  (SOP04)

Requiere token. Devuelve el artículo completo, incluido available_units.

Éxito 200: el objeto completo.
Error 404: si no existe o tiene baja lógica.

### POST /api/v1/articles  (HU01)

Requiere token.

Request:

    {
      "category_id": 1,
      "reference": "SIL-001",
      "name": "Silla Tiffany blanca",
      "description": "...",
      "total_units": 100
    }

description es opcional. total_units debe ser mayor que cero.
Éxito 201: el artículo creado con available_units igual a total_units.

Errores:
- 409 { "message": "Ya existe un artículo con esa referencia.", "errors": {} }
- 422 { "message": "El total de unidades debe ser mayor que cero.", "errors": { "total_units": [...] } }
- 422 categoría inexistente: { "message": "La categoría indicada no existe.", "errors": { "category_id": [...] } }

### PUT /api/v1/articles/{id}  (HU03)

Requiere token. Edita name, category_id, description y total_units.
reference no se puede editar: es identificador de negocio permanente.

Errores:
- 422 si total_units queda por debajo de las unidades actualmente alquiladas
- 422 si la categoría indicada no existe
- 404 si no existe

### DELETE /api/v1/articles/{id}  (HU03, baja lógica)

Requiere token. Aplica baja lógica (deleted_at); no borra la fila físicamente.

Éxito 200: { "message": "El artículo fue dado de baja.", "data": {...} }

Error 422: { "message": "No se puede dar de baja un artículo con unidades sin devolver.", "errors": {} }

---

## 5. Organizadores

### GET /api/v1/organizers  (HU04, SOP03)

Requiere token. Paginado. Parámetros: document_number (búsqueda exacta), full_name (parcial), page, per_page.

Éxito 200: lista paginada. Lista vacía si ningún organizador coincide con el filtro.

### POST /api/v1/organizers  (HU04)

Request:

    { "document_number": "123456789", "full_name": "...", "phone": "...", "email": "..." }

Éxito 201.
Error 409: { "message": "Ya existe un organizador con ese documento.", "errors": {} }

### GET /api/v1/organizers/{id}  (HU05)

Éxito 200:

    {
      "data": {
        "id": 1,
        "document_number": "123456789",
        "full_name": "...",
        "pending_units": 3,
        "active_rentals": 1,
        "overdue_rentals": 0,
        "blocked": false
      }
    }

active_rentals cuenta los alquileres con status active; incluye los vencidos.
overdue_rentals cuenta los alquileres active con due_at superada y unidades pendientes.
blocked es verdadero cuando overdue_rentals > 0 (RN03).
Error 404 si no existe.

---

## 6. Alquileres

### GET /api/v1/rentals  (HU07)

Requiere token. Parámetros: status (active, overdue, returned), organizer_id, page, per_page.
El estado overdue se calcula en UTC al momento de la consulta (ver ADR-003).

Éxito 200: lista paginada con cabeceras y resumen por alquiler.

### POST /api/v1/rentals  (HU06)

Request:

    {
      "organizer_id": 1,
      "lines": [ { "article_id": 1, "quantity": 20 } ]
    }

El cliente no envía due_at ni advisor_id: los fija el backend.

Validación de forma previa a cualquier regla:
- 422 si organizer_id no existe: { "message": "Recurso no encontrado.", "errors": { "organizer_id": [...] } }
- 422 si algún article_id no existe: { "message": "Recurso no encontrado.", "errors": { "lines.0.article_id": [...] } }
- 422 si lines está vacío
- 422 si hay article_id repetido dentro de lines
- 422 si quantity es 0 o negativa

Orden de validación de reglas de negocio (cuando la forma es válida):

1. RN03: organizador con alquileres vencidos
2. RN01: límite de 5 artículos sin devolver (suma quantity de todas las líneas)
3. Por cada línea, en orden ascendente de article_id:
   - 422 si el artículo tiene baja lógica
   - 409 si available_units < quantity

El orden ascendente por article_id evita deadlocks cuando dos peticiones
concurren sobre varios artículos. Ver ADR-002.

due_at se calcula en el backend como rented_at más tres días en UTC (RN02).
Se ignora cualquier due_at enviado por el cliente.

Éxito 201:

    {
      "data": {
        "id": 1,
        "organizer_id": 1,
        "advisor_id": 1,
        "rented_at": "2026-11-13T10:00:00Z",
        "due_at": "2026-11-16T10:00:00Z",
        "returned_at": null,
        "status": "active",
        "lines": [
          {
            "id": 1,
            "article_id": 1,
            "article_reference": "SIL-001",
            "article_name": "Silla Tiffany blanca",
            "quantity": 20,
            "returned_quantity": 0
          }
        ]
      }
    }

### GET /api/v1/rentals/{id}  (HU08)

Requiere token. Lee los datos congelados de cada línea (RN05).

Éxito 200: el alquiler con todas sus líneas y pendientes por línea.
Error 404 si no existe.

### POST /api/v1/rentals/{id}/returns  (HU09)

Request:

    { "lines": [ { "rental_line_id": 1, "quantity": 10 } ] }

Validación:
- 404 si el alquiler no existe
- 422 si el alquiler ya está returned: { "message": "El alquiler ya fue devuelto por completo.", "errors": {} }
- 422 si alguna rental_line_id no pertenece a ese alquiler: { "message": "La línea indicada no pertenece al alquiler.", "errors": { "lines.0.rental_line_id": [...] } }
- 422 si quantity es 0 o negativa
- 422 si quantity supera (quantity - returned_quantity) de la línea
- 422 si hay rental_line_id repetido dentro de lines

Éxito 201: la devolución con sus líneas y el alquiler actualizado.
Si no quedan unidades pendientes, el alquiler pasa a returned.
La devolución libera el bloqueo por vencimiento (RN03).

No existe DELETE sobre alquileres ni devoluciones (RN06).

---

## 7. Reporte

### GET /api/v1/reports/most-requested  (HU10)

Requiere token. Parámetros opcionales: from, to (UTC ISO 8601).

Validación:
- 422 si from o to no son fechas válidas ISO 8601
- 422 si from > to

Éxito 200:

    {
      "data": [
        { "article_id": 1, "article_reference": "SIL-001", "article_name": "Silla Tiffany blanca", "total_units_rented": 140 }
      ]
    }

Ordenado por total_units_rented descendente. Suma quantity de las líneas,
no cuenta operaciones. Incluye artículos con baja lógica que tuvieron movimientos.

article_name se toma de la línea más reciente del artículo dentro del rango,
para reflejar el nombre vigente al momento del último alquiler.
Agrupación por article_id, no por article_reference.

---

## 8. Trazabilidad

| Endpoint | Historia o soporte | Reglas que aplica |
|:---|:---|:---|
| POST /auth/login | SOP01 | — |
| GET /categories | SOP02 | — |
| GET /articles | HU02 | — |
| GET /articles/{id} | SOP04 | — |
| POST /articles | HU01 | RN04 |
| PUT /articles/{id} | HU03 | RN05 |
| DELETE /articles/{id} | HU03 | RN06 |
| GET /organizers | HU04, SOP03 | — |
| POST /organizers | HU04 | — |
| GET /organizers/{id} | HU05 | RN03 |
| GET /rentals | HU07 | — |
| POST /rentals | HU06 | RN01, RN02, RN03, RN04, RN05, RNF01 |
| GET /rentals/{id} | HU08 | RN05 |
| POST /rentals/{id}/returns | HU09 | RN03, RN04, RN06 |
| GET /reports/most-requested | HU10 | RN05 |

Todo endpoint no listado aquí está fuera de alcance.
