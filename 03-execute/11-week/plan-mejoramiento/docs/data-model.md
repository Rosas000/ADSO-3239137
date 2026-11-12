# Modelo de datos — Event Furniture

Ocho tablas de dominio más la tabla de tokens de Sanctum.
Referencia directa de las migraciones en api/database/migrations.

---

## 1. Convenciones

| Aspecto | Decisión |
|:---|:---|
| Nombres de tablas | inglés, plural, snake_case |
| Nombres de columnas | inglés, snake_case |
| Clave primaria | id, entero autoincremental |
| Claves foráneas | singular_id, con ON DELETE RESTRICT |
| Fechas | timestamp con zona horaria, almacenadas en UTC |
| Auditoría | created_at y updated_at en todas las tablas |
| Baja lógica | deleted_at únicamente en articles |
| Valores visibles al usuario | español, con acentuación correcta |

Los nombres de columna van en inglés por RNF02. Los valores que el usuario lee,
como el nombre de una categoría, van en español porque son datos, no identificadores.

### Prefijo de la devolución

La entidad de devolución se llama RentalReturn y su tabla rental_returns.
No se usa Return ni returns: return es palabra reservada de PHP y class Return
no compila. La convención completa está en la sección 15 de architecture.md.

---

## 2. Relaciones

    categories        1 ---- N  articles
    organizers        1 ---- N  rentals
    advisors          1 ---- N  rentals
    advisors          1 ---- N  rental_returns
    rentals           1 ---- N  rental_lines
    articles          1 ---- N  rental_lines
    rentals           1 ---- N  rental_returns
    rental_returns    1 ---- N  rental_return_lines
    rental_lines      1 ---- N  rental_return_lines
    advisors          1 ---- N  personal_access_tokens  (polimórfica de Sanctum)

Un alquiler tiene varias líneas. Cada línea apunta a un artículo del catálogo y
guarda además una copia congelada de sus datos. Una devolución pertenece a un
alquiler y detalla qué líneas y cuántas unidades se devolvieron.

Todas las claves foráneas usan ON DELETE RESTRICT. Ninguna operación del sistema
borra filas: la restricción es la última defensa de RN06 frente a un borrado
ejecutado fuera de la aplicación.

---

## 3. Tablas

### categories

Cinco registros sembrados. No editables ni eliminables por el usuario (SOP02).

| Columna | Tipo | Restricciones |
|:---|:---|:---|
| id | bigserial | clave primaria |
| name | varchar(50) | obligatorio, único |
| slug | varchar(50) | obligatorio, único |
| created_at | timestamptz | obligatorio |
| updated_at | timestamptz | obligatorio |

name es el texto que ve el usuario: Sillas, Mesas, Carpas, Tarimas, Decoración.
slug es la forma usada en filtros de URL: sillas, mesas, carpas, tarimas, decoracion.
El slug va en minúsculas y sin tildes para ser seguro en una URL.

No tiene deleted_at: las categorías no admiten baja.

### articles

Catálogo de artículos con inventario.

| Columna | Tipo | Restricciones |
|:---|:---|:---|
| id | bigserial | clave primaria |
| category_id | bigint | obligatorio, foránea a categories, restrict |
| reference | varchar(50) | obligatorio, único |
| name | varchar(150) | obligatorio |
| description | text | opcional |
| total_units | integer | obligatorio, mayor que 0 |
| available_units | integer | obligatorio |
| created_at | timestamptz | obligatorio |
| updated_at | timestamptz | obligatorio |
| deleted_at | timestamptz | opcional, baja lógica |

Restricciones de tabla:

    CONSTRAINT articles_total_units_positive
      CHECK (total_units > 0)

    CONSTRAINT articles_available_units_range
      CHECK (available_units >= 0 AND available_units <= total_units)

Decisión sobre total_units: se exige mayor que cero. Un artículo sin unidades
totales nunca puede alquilarse y no aparece en ninguna de las diez historias.
El caso «ya no se ofrece este artículo» se resuelve con la baja lógica de RN06,
no con un total en cero. En cambio available_units en cero sí es válido y
frecuente: significa que todo el inventario está alquilado.

articles_available_units_range es la garantía de RN04 en la capa de datos.
Si un defecto de código intentara escribir un valor imposible, PostgreSQL
rechaza la escritura.

Decisión sobre reference: la unicidad aplica a todas las filas, incluidas las que
tienen baja lógica. Una referencia dada de baja no se puede reutilizar.
Razón: la referencia es un identificador de negocio permanente; reutilizarla
haría ambiguo cualquier reporte histórico que la mencione.

### organizers

Clientes que reciben mobiliario. No son usuarios del sistema.

| Columna | Tipo | Restricciones |
|:---|:---|:---|
| id | bigserial | clave primaria |
| document_number | varchar(20) | obligatorio, único |
| full_name | varchar(150) | obligatorio |
| phone | varchar(20) | obligatorio |
| email | varchar(150) | opcional |
| created_at | timestamptz | obligatorio |
| updated_at | timestamptz | obligatorio |

No tiene deleted_at ni credenciales. El contrato no expone borrado de
organizadores ni inicio de sesión para ellos.

### advisors

Operadores autenticados. Único rol del sistema.

| Columna | Tipo | Restricciones |
|:---|:---|:---|
| id | bigserial | clave primaria |
| name | varchar(150) | obligatorio |
| email | varchar(150) | obligatorio, único |
| password | varchar(255) | obligatorio, almacenado con hash |
| created_at | timestamptz | obligatorio |
| updated_at | timestamptz | obligatorio |

La contraseña nunca se almacena ni se devuelve en claro. El modelo la excluye
de la serialización.

### rentals

Cabecera de la operación de alquiler.

| Columna | Tipo | Restricciones |
|:---|:---|:---|
| id | bigserial | clave primaria |
| organizer_id | bigint | obligatorio, foránea a organizers, restrict |
| advisor_id | bigint | obligatorio, foránea a advisors, restrict |
| rented_at | timestamptz | obligatorio |
| due_at | timestamptz | obligatorio |
| returned_at | timestamptz | opcional |
| status | varchar(20) | obligatorio, active o returned |
| created_at | timestamptz | obligatorio |
| updated_at | timestamptz | obligatorio |

Restricciones de tabla:

    CONSTRAINT rentals_status_allowed
      CHECK (status IN ('active', 'returned'))

    CONSTRAINT rentals_returned_consistent
      CHECK ((status = 'returned') = (returned_at IS NOT NULL))

rentals_returned_consistent impide que el estado y la marca de cierre se
desincronicen. Rechaza los dos casos imposibles: un alquiler marcado returned
sin fecha de cierre, y un alquiler active con fecha de cierre registrada.

due_at lo calcula el backend como rented_at más tres días en UTC (RN02).
advisor_id se toma del token autenticado, nunca del cuerpo de la petición.
returned_at se registra cuando no quedan unidades pendientes en ninguna línea.

No tiene deleted_at: RN06 prohíbe el borrado de operaciones.

### rental_lines

Detalle del alquiler con los datos congelados del catálogo.

| Columna | Tipo | Restricciones |
|:---|:---|:---|
| id | bigserial | clave primaria |
| rental_id | bigint | obligatorio, foránea a rentals, restrict |
| article_id | bigint | obligatorio, foránea a articles, restrict |
| article_reference | varchar(50) | obligatorio, copia congelada |
| article_name | varchar(150) | obligatorio, copia congelada |
| quantity | integer | obligatorio, mayor que 0 |
| returned_quantity | integer | obligatorio, por defecto 0 |
| created_at | timestamptz | obligatorio |
| updated_at | timestamptz | obligatorio |

Restricciones de tabla:

    CONSTRAINT rental_lines_quantity_positive
      CHECK (quantity > 0)

    CONSTRAINT rental_lines_returned_within_quantity
      CHECK (returned_quantity >= 0 AND returned_quantity <= quantity)

article_reference y article_name se copian del artículo al crear la línea (RN05).
No se actualizan nunca, aunque el catálogo cambie. article_id se conserva como
relación viva para poder agrupar el reporte por artículo.

No tiene deleted_at.

### rental_returns

Cabecera de la devolución.

| Columna | Tipo | Restricciones |
|:---|:---|:---|
| id | bigserial | clave primaria |
| rental_id | bigint | obligatorio, foránea a rentals, restrict |
| advisor_id | bigint | obligatorio, foránea a advisors, restrict |
| returned_at | timestamptz | obligatorio |
| created_at | timestamptz | obligatorio |
| updated_at | timestamptz | obligatorio |

Un alquiler puede tener varias devoluciones, porque se admite devolución parcial.
Cada devolución registra qué asesor la recibió y cuándo.

No tiene deleted_at.

### rental_return_lines

Detalle de qué se devolvió.

| Columna | Tipo | Restricciones |
|:---|:---|:---|
| id | bigserial | clave primaria |
| rental_return_id | bigint | obligatorio, foránea a rental_returns, restrict |
| rental_line_id | bigint | obligatorio, foránea a rental_lines, restrict |
| quantity | integer | obligatorio, mayor que 0 |
| created_at | timestamptz | obligatorio |
| updated_at | timestamptz | obligatorio |

Restricción de tabla:

    CONSTRAINT rental_return_lines_quantity_positive
      CHECK (quantity > 0)

La suma de quantity de las rental_return_lines asociadas a una rental_line debe
ser igual a rental_lines.returned_quantity. Esa igualdad la mantiene
RentalReturnService dentro de la misma transacción; no se delega a un disparador
ni a una restricción de base de datos, porque cruza dos tablas.
ReturnCreateTest la verifica.

No tiene deleted_at.

### personal_access_tokens

Tabla estándar de Laravel Sanctum. Implementa SOP01.

| Columna | Tipo | Restricciones |
|:---|:---|:---|
| id | bigserial | clave primaria |
| tokenable_type | varchar(255) | obligatorio |
| tokenable_id | bigint | obligatorio |
| name | varchar(255) | obligatorio |
| token | varchar(64) | obligatorio, único |
| abilities | text | opcional |
| last_used_at | timestamptz | opcional |
| expires_at | timestamptz | opcional |
| created_at | timestamptz | obligatorio |
| updated_at | timestamptz | obligatorio |

La genera la migración publicada por Sanctum. No se modifica su estructura.

---

## 4. Estado del alquiler: almacenado y derivado

La enumeración RentalStatus tiene tres valores, pero solo dos se persisten.

| Estado | Se almacena | Cómo se determina |
|:---|:---|:---|
| active | sí | valor inicial al crear el alquiler |
| returned | sí | se asigna cuando no quedan unidades pendientes |
| overdue | no | se calcula al consultar |

Cálculo de vencimiento:

    overdue = (status = 'active') AND (due_at < ahora en UTC) AND (pendientes > 0)

Razón de no almacenar overdue: el vencimiento depende del paso del tiempo, no de
una acción del usuario. Si se guardara como valor, habría que ejecutar un proceso
programado que actualizara filas cada día, y el estado quedaría desfasado entre
ejecuciones. Derivarlo en la consulta garantiza que siempre sea correcto y evita
introducir un componente que no está en el alcance.

La condición de unidades pendientes es defensiva. El invariante «un alquiler
active tiene pendientes» lo mantiene RentalService, y la base de datos no puede
hacerlo cumplir porque depende de rental_lines, que es otra tabla. Si un defecto
rompiera ese invariante, la condición evita que un alquiler sin pendientes se
marque como vencido y bloquee al organizador indebidamente.

Esto respalda el criterio de HU07: el estado vencido se calcula en UTC al momento
de la consulta.

---

## 5. Cálculos derivados del dominio

| Cálculo | Definición | Uso |
|:---|:---|:---|
| Pendiente por línea | quantity - returned_quantity | detalle de alquiler |
| Pendiente por alquiler | suma de pendientes de sus líneas | estado y vencimiento |
| Pendiente por organizador | suma de pendientes de los alquileres con status active (incluye los vencidos) | RN01 |
| Alquiler vencido | ver sección 4 | RN03, HU07 |
| Organizador bloqueado | existe al menos un alquiler vencido | RN03, HU05 |
| Demanda de un artículo | suma de quantity de sus rental_lines | HU10 |

Aclaración sobre el pendiente por organizador: los alquileres vencidos conservan
status active, porque overdue es un estado derivado y no persistido. Por eso la
suma sobre active los incluye. Un organizador con artículos vencidos sigue
acumulando pendientes para el límite de RN01.

El reporte de artículos más solicitados suma quantity, no cuenta operaciones.
Un alquiler de 20 sillas cuenta como 20 unidades de demanda, no como 1.

---

## 6. Índices

| Tabla | Índice | Motivo |
|:---|:---|:---|
| categories | unique(slug) | filtro por categoría en el catálogo |
| articles | unique(reference) | HU01 y búsqueda por referencia |
| articles | index(category_id) | filtro del catálogo (HU02) |
| articles | index(deleted_at) | exclusión de bajas lógicas |
| organizers | unique(document_number) | HU04 y búsqueda |
| advisors | unique(email) | autenticación (SOP01) |
| rentals | index(organizer_id) | estado del organizador (HU05) |
| rentals | index(status, due_at) | cálculo de vencidos (RN03) |
| rental_lines | index(rental_id) | detalle del alquiler (HU08) |
| rental_lines | index(article_id) | agregación del reporte (HU10) |
| rental_returns | index(rental_id) | histórico de devoluciones |
| rental_return_lines | index(rental_return_id) | detalle de la devolución |
| rental_return_lines | index(rental_line_id) | suma de lo devuelto por línea |

---

## 7. Datos sembrados

| Dato | Mecanismo | Razón |
|:---|:---|:---|
| Cinco categorías | CategorySeeder de Laravel | estructura previa a cualquier operación autenticada |
| Asesor inicial | AdvisorSeeder de Laravel | sin él no hay quién se autentique para llamar a la API |
| Artículos | tool/seed-api.sh, por HTTP | ejercita HU01 y sus validaciones |
| Organizadores | tool/seed-api.sh, por HTTP | ejercita HU04 |
| Alquileres y devoluciones | tool/seed-api.sh, por HTTP | deja el reporte con datos y ejercita HU06 y HU09 |

Las categorías y el asesor no pueden sembrarse por API: las categorías no tienen
endpoint de escritura y el asesor inicial es previo al primer inicio de sesión.
Todo lo demás se siembra por la API, como exige el acta.

---

## 8. Trazabilidad con las reglas de negocio

| Regla | Dónde se sostiene en el modelo |
|:---|:---|
| RN01 límite de cinco | suma de pendientes por organizador sobre rentals active |
| RN02 plazo de tres días | rentals.due_at calculado desde rented_at |
| RN03 bloqueo por vencidos | derivado de status y due_at |
| RN04 inventario acotado | CHECK articles_available_units_range y articles_total_units_positive |
| RN05 datos congelados | rental_lines.article_reference y article_name |
| RN06 sin borrado físico | deleted_at solo en articles; foráneas en restrict |
| RNF01 concurrencia | bloqueo de fila sobre articles dentro de transacción |
| RNF02 UTC | todas las columnas de fecha son timestamptz |

---

## 9. Lo que el modelo no incluye

No existen tablas de facturación, pagos, tarifas, notificaciones, bodegas ni roles.
No hay tabla de auditoría genérica: la trazabilidad se resuelve con advisor_id y
las marcas de tiempo en cada operación.

Cualquier tabla no listada en este documento está fuera de alcance.
