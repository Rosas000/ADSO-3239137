# Especificación funcional — Event Furniture

Dominio: alquiler de mobiliario para eventos.
Identificador: event-furniture.
Referencia de adaptación: Manager Library.

---

## 1. Equivalencias con Manager Library

| Manager Library | Event Furniture | Identificador en código |
|:---|:---|:---|
| Libro | Artículo (identificado por referencia) | Article |
| Ejemplares | Unidades | units |
| Socio | Organizador | Organizer |
| Bibliotecario | Asesor | Advisor |
| Préstamo | Alquiler | Rental |
| Categoría | Cinco categorías sembradas | Category |

Categorías sembradas: sillas, mesas, carpas, tarimas, decoración.

---

## 2. Actores

| Actor | Descripción | Permisos |
|:---|:---|:---|
| Asesor (Advisor) | Operador autenticado del sistema | Gestiona catálogo, organizadores, alquileres y devoluciones. Consulta reportes. |
| Visitante | Usuario no autenticado del sitio público | Solo lectura del sitio estático de presentación |

El organizador es una entidad del dominio, no un usuario del sistema.
No inicia sesión: es registrado y atendido por un asesor.

Existe un único rol operativo. No hay jerarquía de permisos entre asesores:
todo asesor autenticado puede ejecutar todas las operaciones del sistema.

---

## 3. Entidades del dominio

| Entidad | Responsabilidad |
|:---|:---|
| Category | Agrupa artículos. Cinco registros sembrados, no editables. |
| Article | Artículo del catálogo con referencia única, total de unidades y disponibles. |
| Organizer | Cliente que recibe mobiliario en alquiler. |
| Advisor | Operador autenticado que registra las operaciones. |
| Rental | Operación de alquiler. Cabecera con organizador, fechas y estado. |
| RentalLine | Detalle del alquiler: artículo, cantidad y datos congelados del catálogo. |
| RentalReturn | Registro de devolución asociado a un alquiler. |
| RentalReturnLine | Detalle de qué artículos y cuántas unidades se devolvieron. |

El detalle de campos y relaciones está en data-model.md.

---

## 4. Reglas de negocio

### RN01 — Límite de artículos sin devolver
Un organizador no puede tener más de 5 artículos sin devolver.

- Se cuentan unidades pendientes: suma de (quantity - returned_quantity)
  de todas las líneas de alquiler activas o vencidas del organizador.
- Si la suma actual más la cantidad solicitada supera 5, se rechaza.
- Respuesta: 422 Unprocessable Entity.
- Mensaje: "El organizador no puede tener más de 5 artículos sin devolver."

### RN02 — Plazo de alquiler
Todo alquiler tiene un plazo de 3 días.

- due_at = rented_at + 3 días, calculado en UTC por el backend.
- El cliente no puede enviar ni modificar due_at.
- Un alquiler está vencido cuando la fecha actual UTC supera due_at
  y quedan unidades sin devolver.

### RN03 — Bloqueo por vencimiento
Un organizador con alquileres vencidos no recibe más artículos hasta devolverlos.

- Se evalúa antes que RN01.
- Respuesta: 422 Unprocessable Entity.
- Mensaje: "El organizador tiene alquileres vencidos. Debe devolverlos antes de recibir más artículos."

### RN04 — Inventario acotado
Las unidades disponibles están siempre entre 0 y el total.

- available_units nunca es negativo ni mayor que total_units.
- Al crear un alquiler: available_units disminuye en quantity.
- Al registrar devolución: available_units aumenta en returned_quantity.
- Si la cantidad solicitada supera available_units, se rechaza con 409 Conflict.
- Mensaje: "No hay unidades suficientes del artículo solicitado."
- La restricción se aplica también en base de datos mediante CHECK.

### RN05 — Datos congelados en la línea
Lo congelado en la línea de la operación no sigue al catálogo.

- Al crear una RentalLine se copian reference y name del artículo
  en los campos article_reference y article_name de la línea.
- Si el artículo se renombra, cambia de categoría o se da de baja,
  la línea histórica conserva los valores originales.
- El detalle de alquiler lee los datos congelados, no el catálogo.

### RN06 — Sin borrado físico
Las operaciones y devoluciones no se borran; el catálogo solo tiene baja lógica.

- Rental, RentalLine, RentalReturn y RentalReturnLine no tienen endpoint DELETE.
- Article solo admite baja lógica mediante deleted_at.
- Un artículo dado de baja no aparece en el catálogo ni puede alquilarse,
  pero sus líneas históricas siguen siendo consultables.
- No se puede dar de baja un artículo con unidades pendientes de devolución.
- Mensaje: "No se puede dar de baja un artículo con unidades sin devolver."

---

## 5. Reglas transversales

| Regla | Aplicación |
|:---|:---|
| Fechas en UTC | Almacenadas y expuestas en ISO 8601 con sufijo Z |
| Mensajes en español | Toda respuesta visible al usuario |
| Identificadores en inglés | Código, tablas, columnas y rutas |
| Validación en backend | Ninguna regla depende del frontend |

---

## 6. Concurrencia

Escenario: dos asesores intentan alquilar la última unidad disponible
del mismo artículo en el mismo instante.

Comportamiento exigido:
1. Ambas peticiones llegan a la API.
2. La primera transacción que obtiene el bloqueo decrementa available_units a 0 y confirma.
3. La segunda detecta que ya no hay unidades y aborta.
4. La primera recibe 201 Created. La segunda recibe 409 Conflict.
5. available_units queda en 0. Nunca en -1.

Mensaje para la petición rechazada:
"No hay unidades suficientes del artículo solicitado."

Estrategia: bloqueo pesimista de fila dentro de una transacción. Ver ADR-002.

---

## 7. Historias de usuario

### HU01 — Registrar artículo
Como asesor quiero registrar un artículo en el catálogo para poder alquilarlo.

Criterios de aceptación:
- Referencia única, nombre, categoría y total de unidades obligatorios. Descripción opcional.
- El total de unidades debe ser mayor que cero.
- Al crear, available_units igual a total_units.
- Referencia duplicada responde 409 Conflict.
- Categoría inexistente responde 422.
- Éxito: 201 Created.

### HU02 — Consultar catálogo
Como asesor quiero listar y filtrar artículos por categoría y referencia
para encontrar rápidamente lo que necesita el organizador.

Criterios de aceptación:
- Lista paginada. Excluye artículos con baja lógica.
- Filtro por categoría y búsqueda parcial por referencia o nombre.
- Cada registro expone total_units y available_units.
- Éxito: 200 OK.

### HU03 — Editar y dar de baja un artículo
Como asesor quiero corregir los datos de un artículo o darlo de baja
para mantener el catálogo actualizado.

Criterios de aceptación:
- Permite editar nombre, categoría y total de unidades.
- Reducir total_units por debajo de las unidades alquiladas responde 422.
- Cambiar el catálogo no altera líneas de alquiler existentes (RN05).
- Baja lógica con unidades pendientes responde 422 (RN06).
- Éxito: 200 OK.

### HU04 — Registrar organizador
Como asesor quiero registrar un organizador para poder entregarle mobiliario.

Criterios de aceptación:
- Documento de identidad único, nombre y teléfono obligatorios.
- Documento duplicado responde 409 Conflict.
- Éxito: 201 Created.

### HU05 — Consultar estado del organizador
Como asesor quiero ver el estado de un organizador antes de atenderlo
para saber si puede recibir artículos.

Criterios de aceptación:
- Expone unidades pendientes, alquileres activos y alquileres vencidos.
- Expone indicador booleano de bloqueo por vencimiento (RN03).
- Organizador inexistente responde 404.
- Éxito: 200 OK.

### HU06 — Crear alquiler
Como asesor quiero registrar un alquiler con uno o varios artículos
para entregar mobiliario al organizador.

Criterios de aceptación:
- Valida RN03, luego RN01, luego RN04, en ese orden.
- Calcula due_at en el backend (RN02).
- Congela referencia y nombre en cada línea (RN05).
- Descuenta available_units de forma atómica.
- Artículo con baja lógica responde 422.
- Éxito: 201 Created con el detalle del alquiler.

### HU07 — Consultar alquileres
Como asesor quiero listar los alquileres por estado y por organizador
para hacer seguimiento a las entregas.

Criterios de aceptación:
- Filtros por estado (active, overdue, returned) y por organizador.
- Lista paginada.
- El estado vencido se calcula en UTC al momento de la consulta.
- Éxito: 200 OK.

### HU08 — Consultar detalle de alquiler
Como asesor quiero ver el detalle de un alquiler con los datos originales
para resolver reclamos sobre lo que se entregó.

Criterios de aceptación:
- Lee article_reference y article_name congelados (RN05).
- Expone quantity, returned_quantity y pendientes por línea.
- Alquiler inexistente responde 404.
- Éxito: 200 OK.

### HU09 — Registrar devolución
Como asesor quiero registrar la devolución de artículos
para liberar unidades y desbloquear al organizador.

Criterios de aceptación:
- Permite devolución parcial o total por línea.
- Devolver más de lo pendiente responde 422.
- Incrementa available_units sin exceder total_units (RN04).
- Crea RentalReturn y RentalReturnLine; no borra ni edita el alquiler (RN06).
- Cuando no quedan unidades pendientes, el alquiler pasa a estado returned.
- Una devolución libera el bloqueo por vencimiento (RN03).
- Éxito: 201 Created.

### HU10 — Reporte de artículos más solicitados
Como asesor quiero consultar el reporte de artículos más solicitados
para decidir compras de inventario.

Criterios de aceptación:
- Ordena por total de unidades alquiladas, descendente.
- Suma las cantidades de las líneas, no el número de operaciones.
- Incluye artículos dados de baja que tuvieron movimientos.
- Lee los datos congelados de las líneas (RN05).
- Acepta rango de fechas opcional en UTC.
- Éxito: 200 OK.

---

## 8. Operaciones de soporte

Las siguientes operaciones no son historias de usuario: son requisitos
estructurales para que las diez historias puedan ejecutarse. Se declaran
aquí para que su implementación no se considere fuera de alcance.

### SOP01 — Inicio de sesión del asesor
El asesor se autentica para obtener un token de acceso.

- Endpoint: POST /api/v1/auth/login
- Recibe correo y contraseña.
- Credenciales válidas: 200 OK con token.
- Credenciales inválidas: 401 Unauthorized.
- Mensaje: "Las credenciales no son válidas."
- Todas las operaciones de escritura y el reporte exigen token válido.
- Sin token o token inválido: 401 Unauthorized.
- El asesor inicial se siembra; no hay registro público de asesores.

Justificación: sin autenticación no existe el actor Asesor ni la trazabilidad
de quién registró cada operación.

### SOP02 — Consulta de categorías
Lista las cinco categorías sembradas para poblar los selectores del formulario
de artículos y los filtros del catálogo.

- Endpoint: GET /api/v1/categories
- Requiere token válido.
- Solo lectura. No se crean, editan ni eliminan categorías.
- Éxito: 200 OK con las cinco categorías.

Justificación: HU01 y HU02 dependen de conocer las categorías disponibles.
Las categorías son datos de estructura, no gestionables por el usuario.

---

### SOP03 — Búsqueda de organizador por documento
El asesor busca un organizador por su documento de identidad antes de crear un
alquiler, para no registrarlo dos veces.

- Endpoint: GET /api/v1/organizers?document_number=...
- Requiere token válido.
- Respuesta 200 OK con el organizador o lista vacía si no existe.
- No crea, edita ni borra.

Justificación: HU06 requiere un organizer_id; sin búsqueda, el asesor tendría
que conocer el id interno.

### SOP04 — Obtener artículo por id
El asesor obtiene el detalle completo de un artículo por su id para poblar el
formulario de edición o confirmar el stock antes de alquilar.

- Endpoint: GET /api/v1/articles/{id}
- Requiere token válido.
- Respuesta 200 OK con el artículo completo, incluido available_units.
- Respuesta 404 si no existe o tiene baja lógica.

Justificación: HU03 requiere el artículo completo para editar; HU06 requiere
confirmar stock antes de alquilar.

---

## 9. Requisitos no funcionales

### RNF01 — Seguridad de concurrencia
Bajo peticiones simultáneas sobre la última unidad, el sistema nunca
produce inventario negativo. Una petición tiene éxito y las demás reciben 409.
Verificable con prueba automatizada de concurrencia.

### RNF02 — Consistencia de idioma y tiempo
Fechas en UTC ISO 8601. Mensajes al usuario en español, con ortografía
y acentuación correctas. Identificadores de código en inglés.
Verificable por revisión del código y de las respuestas de la API.

### RNF03 — Entorno reproducible
El entorno completo levanta con un único comando, desde plan-mejoramiento: docker compose --env-file infra/.env -f infra/docker-compose.yml up --build
Incluye base de datos, API, aplicación y sitio público. Los datos iniciales
se cargan con un sembrador que consume la API. Verificable en máquina limpia.

### RNF04 — Cobertura de pruebas
Mínimo 15 archivos de prueba automatizada en el backend.
Cada regla RN01 a RN06 tiene al menos una prueba que la cubre.
Ejecutables con un único comando.

### RNF05 — Higiene del repositorio
El historial no contiene archivos .env, node_modules ni vendor.
Los commits son pequeños y se reparten en al menos ocho días distintos.
No se reescribe el historial publicado.
Verificable por inspección del historial de Git.

---

## 10. Fuera de alcance

No se implementa: facturación, pagos, tarifas, notificaciones, múltiples bodegas,
aplicación móvil, ni reportes distintos al de artículos más solicitados.

Tampoco se implementan herramientas de medición de rendimiento, pruebas de carga,
ni verificadores automáticos de estilo o idioma. La verificación de RNF02 y RNF05
es por revisión, no por herramienta adicional.

Cualquier función no listada en este documento se considera fuera de alcance.
