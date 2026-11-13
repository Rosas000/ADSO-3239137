# Tareas — Event Furniture

Inventario de las 23 tareas del alcance completo exigido por el acta.
Cada tarea declara su respaldo en la especificación, su criterio de verificación
y la prueba que la sostiene.

Convención de estado:
- pendiente: sin implementar
- en progreso: parcialmente implementada
- hecha: implementada y verificada contra su criterio

Una tarea solo pasa a hecha cuando su criterio de verificación se cumple
y su prueba asociada existe y pasa. No se marca por intención.

---

## Fase A — Especificación y entrega

### T01 — Especificación completa
Redactar los diez documentos de especificación propia del dominio.
Respaldo: requisito de especificación del acta, sección 6.
Subcarpeta: docs
Verificación: existen constitution, spec, plan, architecture, data-model,
api-contract, tasks y tres ADR, y son congruentes entre sí.
Estado: en progreso

### T02 — Estructura de entrega y documento del acta
Crear la carpeta de la semana con las seis subcarpetas, el README con la frase
exigida y el PDF del acta anonimizado.
Respaldo: sección 7 del acta.
Subcarpeta: docs y raíz de plan-mejoramiento
Verificación: la ruta es 03-execute/11-week/plan-mejoramiento/ con docs, api, app,
page, infra y tool; el README inicia con la frase literal; el PDF adjunto no
contiene nombre ni documento de identidad.
Estado: en progreso

---

## Fase B — Infraestructura

### T03 — Orquestación de servicios
Definir docker-compose con los cuatro servicios y sus dependencias.
Respaldo: RNF03, sección 12 y 17 de architecture.md.
Subcarpeta: infra
Verificación: docker compose --env-file infra/.env -f infra/docker-compose.yml up --build
levanta db, api, app y page. api espera el healthcheck de db antes de arrancar.
app espera el healthcheck de api. Puertos: page 8080, app 8081, api 8000.
La base de datos no se expone al anfitrión.
Evidencia: captura de pantalla de los cuatro contenedores en estado running,
guardada en tool/evidence/t03-compose.png al cierre.
Prueba: verificación manual en máquina limpia, registrada en el README.
Estado: en progreso

### T04 — Imágenes y configuración de servidor
Construir las tres imágenes y sus configuraciones de Nginx.
Respaldo: RNF03, secciones 10, 11, 12 y 17 de architecture.md.
Subcarpeta: infra
Verificación: existen infra/docker/api.Dockerfile, app.Dockerfile y page.Dockerfile,
más infra/nginx/api.conf, app.conf y page.conf. Cada Dockerfile declara su contexto
de construcción (context: ..). El api.Dockerfile incluye un entrypoint que genera
APP_KEY si está vacía. El healthcheck de api usa curl -f http://127.0.0.1/up,
con curl instalado en la imagen. app sirve el build de React, no el servidor de desarrollo de Vite.
Evidencia: captura de tool/evidence/t04-images.png mostrando los tres contenedores
respondiendo a sus healthchecks.
Prueba: verificación manual de que app responde contenido compilado en 8081.
Estado: pendiente

### T05 — Variables de entorno e higiene del repositorio
Versionar la plantilla de variables y excluir secretos y dependencias.
Respaldo: RNF05.
Subcarpeta: infra
Verificación: existe infra/.env.example. El historial no contiene .env,
node_modules ni vendor. Se comprueba con:

    git ls-files | grep -E "(^|/)\.env$|node_modules/|vendor/"

El comando debe devolver salida vacía en todo momento, no solo al cierre.
Estado: en progreso

---

## Fase C — Backend base

### T06 — Esqueleto de la API
Crear el proyecto Laravel con autenticación por token y zona horaria fija.
Respaldo: secciones 2, 8 y 9 de architecture.md, ADR-001, ADR-003.
Subcarpeta: api
Verificación: Laravel 12 sobre PHP 8.3. Sanctum ^4.4 instalado (composer require).
config/app.php con timezone en UTC. Las versiones de PHPUnit (^11.5.50) y
Sanctum (^4.4) quedan registradas en architecture.md según composer.json.
Prueba: AuthenticationTest (T09) verifica el arranque autenticado.
Estado: en progreso

### T07 — Migraciones y restricciones de integridad
Crear las ocho tablas del dominio con las restricciones declaradas.
Respaldo: data-model.md sección 3, RN04, sección 6 de architecture.md.
Subcarpeta: api
Verificación: existen las migraciones para categories, articles, organizers,
advisors, rentals, rental_lines, rental_returns y rental_return_lines.
Restricciones aplicadas:

- articles_total_units_positive: total_units > 0
- articles_available_units_range: available_units entre 0 y total_units
- rentals_status_allowed: status en ('active', 'returned')
- rentals_returned_consistent: status = 'returned' ⟺ returned_at IS NOT NULL
- rental_lines_quantity_positive: quantity > 0
- rental_lines_returned_within_quantity: returned_quantity entre 0 y quantity
- rental_return_lines_quantity_positive: quantity > 0

Columnas de fecha: timestamptz. Foráneas: ON DELETE RESTRICT.
Prueba: InventoryBoundsTest verifica que la base de datos rechaza un valor imposible.
Estado: pendiente

### T08 — Modelos y relaciones
Implementar los ocho modelos con sus relaciones y comportamiento de borrado.
Respaldo: RN05, RN06, sección 4 de architecture.md, sección 1 de data-model.md.
Subcarpeta: api
Verificación: Article usa SoftDeletes. Rental, RentalLine, RentalReturn y
RentalReturnLine no exponen borrado. La enumeración RentalStatus define active
y returned; overdue se deriva. Los casts de fecha producen salida UTC ISO 8601
con sufijo Z.
Prueba: SoftDeleteTest y RentalStatusTest.
Estado: pendiente

---

## Fase D — Operaciones de soporte

### T09 — Inicio de sesión del asesor
Implementar la autenticación y el asesor inicial.
Respaldo: SOP01.
Subcarpeta: api
Verificación: POST /api/v1/auth/login devuelve token con credenciales válidas
y 401 con credenciales inválidas. AdvisorSeeder crea el asesor inicial.
No existe registro público de asesores. El advisor_id de las operaciones
se toma del token, nunca del cuerpo de la petición.
Prueba: AuthenticationTest.
Estado: pendiente

### T10 — Consulta de categorías
Exponer las cinco categorías sembradas en modo de solo lectura.
Respaldo: SOP02.
Subcarpeta: api
Verificación: GET /api/v1/categories requiere token y devuelve sillas, mesas,
carpas, tarimas y decoración. CategorySeeder las crea. No existen endpoints
de creación, edición ni borrado de categorías.
Prueba: CategoryListTest.
Estado: pendiente

### T11 — Búsqueda de organizador por documento
Implementar el endpoint de búsqueda que respalda SOP03.
Respaldo: SOP03.
Subcarpeta: api
Verificación: GET /api/v1/organizers?document_number=... requiere token.
Responde 200 OK con el organizador o lista vacía si no existe.
Prueba: OrganizerSearchTest.
Estado: pendiente

### T12 — Obtener artículo por id
Implementar el endpoint de detalle que respalda SOP04.
Respaldo: SOP04.
Subcarpeta: api
Verificación: GET /api/v1/articles/{id} requiere token. Responde 200 con el
artículo completo, incluido available_units. Responde 404 si no existe o
tiene baja lógica.
Prueba: ArticleDetailTest.
Estado: pendiente

---

## Fase E — Catálogo

### T13 — Registrar artículo
Crear artículos con referencia única e inventario inicial.
Respaldo: HU01.
Subcarpeta: api
Verificación: POST /api/v1/articles crea el artículo con available_units igual
a total_units. El total debe ser mayor que cero (ver data-model.md).
La descripción es opcional. Referencia duplicada responde 409.
Categoría inexistente responde 422.
Prueba: ArticleCreateTest.
Estado: pendiente

### T14 — Consultar catálogo
Listar artículos con paginación y filtros.
Respaldo: HU02.
Subcarpeta: api
Verificación: GET /api/v1/articles pagina, filtra por categoría y busca por
referencia o nombre. Excluye artículos con baja lógica. Expone total_units
y available_units.
Prueba: ArticleCatalogTest.
Estado: pendiente

### T15 — Editar y dar de baja un artículo
Actualizar el catálogo sin alterar el histórico.
Respaldo: HU03, RN05, RN06.
Subcarpeta: api
Verificación: PUT /api/v1/articles/{id} edita nombre, categoría, descripción
y total. reference no se puede editar. Reducir el total por debajo de las
unidades alquiladas responde 422. DELETE /api/v1/articles/{id} aplica baja
lógica (no borra físicamente); con unidades pendientes responde 422.
Editar el catálogo no modifica las líneas de alquiler existentes.
Prueba: ArticleUpdateTest y SoftDeleteTest.
Estado: pendiente

---

## Fase F — Organizadores

### T16 — Registrar organizador
Crear organizadores con documento único.
Respaldo: HU04.
Subcarpeta: api
Verificación: POST /api/v1/organizers crea el organizador. Documento duplicado
responde 409. El organizador no tiene credenciales ni ruta de inicio de sesión.
Prueba: OrganizerCreateTest.
Estado: pendiente

### T17 — Consultar estado del organizador
Exponer la situación del organizador antes de atenderlo.
Respaldo: HU05, RN03.
Subcarpeta: api
Verificación: GET /api/v1/organizers/{id} expone unidades pendientes, alquileres
activos (incluye los vencidos), alquileres vencidos y el indicador booleano
de bloqueo. Organizador inexistente responde 404.
Prueba: OrganizerStatusTest y OrganizerBlockTest.
Estado: pendiente

---

## Fase G — Alquileres

### T18 — Crear alquiler: elegibilidad y plazo
Validar el derecho del organizador a recibir artículos y fijar el vencimiento.
Respaldo: HU06, RN01, RN02, RN03.
Subcarpeta: api
Verificación: POST /api/v1/rentals valida forma (organizer_id y article_id
existentes, lines no vacío, sin artículos repetidos, quantity positivo) antes
que cualquier regla. Luego valida en orden RN03, RN01 (suma quantity de todas
las líneas). Organizador con vencidos responde 422. Superar cinco unidades
pendientes responde 422. due_at se calcula en el backend como rented_at más
tres días en UTC (ADR-003); se ignora cualquier due_at enviado por el cliente.
Prueba: OrganizerBlockTest, RentalLimitTest, RentalDueDateTest,
DueDateCalculationTest y RentalFormValidationTest.
Estado: pendiente

### T19 — Crear alquiler: inventario, congelado y concurrencia
Descontar unidades de forma atómica y congelar los datos del catálogo.
Respaldo: HU06, RN04, RN05, RNF01, ADR-002.
Subcarpeta: api
Verificación: la creación ocurre en una transacción con bloqueo de fila
(lockForUpdate). Las líneas se bloquean en orden ascendente por article_id
para evitar deadlocks (ADR-002). Cantidad mayor que available_units responde
409. Cada línea guarda article_reference y article_name copiados del artículo.
Ante dos peticiones simultáneas por la última unidad, una responde 201 y la
otra 409, y el inventario queda en cero. Artículo con baja lógica responde 422.
Prueba: InventoryBoundsTest, FrozenSnapshotTest y ConcurrentRentalTest.
Estado: pendiente

### T20 — Consultar alquileres y su detalle
Listar por estado y organizador, y exponer el detalle histórico.
Respaldo: HU07, HU08, RN05.
Subcarpeta: api
Verificación: GET /api/v1/rentals pagina y filtra por estado y organizador.
El estado vencido se calcula contra la hora UTC actual (ADR-003).
GET /api/v1/rentals/{id} lee los datos congelados de cada línea y expone
quantity, returned_quantity y pendientes. Alquiler inexistente responde 404.
Prueba: RentalListTest, FrozenSnapshotTest y RentalStatusTest.
Estado: pendiente

---

## Fase H — Devoluciones y reporte

### T21 — Registrar devolución
Liberar unidades y desbloquear al organizador sin borrar el histórico.
Respaldo: HU09, RN04, RN06.
Subcarpeta: api
Verificación: POST /api/v1/rentals/{id}/returns admite devolución parcial o total.
Casos de error explícitos:

- 404 si el alquiler no existe
- 422 si el alquiler ya está returned
- 422 si alguna rental_line_id no pertenece a ese alquiler
- 422 si quantity es 0 o negativa
- 422 si quantity supera (quantity - returned_quantity) de la línea
- 422 si hay rental_line_id repetido dentro de lines

available_units aumenta sin exceder total_units. Se crean RentalReturn y
RentalReturnLine; el alquiler no se borra ni se edita. Cuando no quedan
unidades pendientes el alquiler pasa a returned. La devolución libera el
bloqueo por vencimiento. No existe DELETE sobre operaciones ni devoluciones.
ReturnCreateTest verifica además que la suma de rental_return_lines.quantity
coincide con rental_lines.returned_quantity.
Prueba: ReturnCreateTest, InventoryBoundsTest y PendingUnitsTest.
Estado: pendiente

### T22 — Reporte de artículos más solicitados
Agregar la demanda por unidades alquiladas.
Respaldo: HU10, RN05.
Subcarpeta: api
Verificación: GET /api/v1/reports/most-requested ordena por suma de quantity
de las líneas, descendente, no por número de operaciones. Incluye artículos
dados de baja con movimientos. Lee los datos congelados. article_name se toma
de la línea más reciente del artículo dentro del rango. Agrupa por article_id.
Acepta rango de fechas opcional en UTC. 422 si from o to no son fechas válidas
o si from > to.
Prueba: MostRequestedReportTest.
Estado: pendiente

---

## Fase I — Producto visible

### T23 — Aplicación del asesor
Construir la interfaz que consume la API y servirla compilada.
Respaldo: HU01 a HU10, SOP01 a SOP04, sección 10 de architecture.md.
Subcarpeta: app
Verificación: existen estas vistas: Login, Catalog, ArticleDetail,
Organizers, OrganizerDetail, RentalCreate, RentalDetail, ReturnCreate, Report.
La aplicación no implementa reglas de negocio: muestra lo que la API decide.
Los mensajes de error se muestran tal como los entrega la API. Las fechas se
convierten a hora local solo al renderizar. El formulario de alquiler consulta
el bloqueo del organizador antes de habilitarse. Se sirve el build con vite
build y Nginx. Las versiones de Vite quedan registradas en architecture.md
según package.json.
Prueba: verificación manual del recorrido completo contra la API levantada.
Estado: pendiente

### T24 — Sitio público del producto
Publicar el sitio estático que presenta Event Furniture.
Respaldo: sección 11 de architecture.md, informe 4 del acta.
Subcarpeta: page
Verificación: el sitio presenta qué es el producto, qué problema resuelve,
las cinco categorías y las funcionalidades principales. No describe la prueba
técnica ni el plan de mejoramiento. No consume la API ni requiere JavaScript
para mostrar contenido. Incluye enlace de acceso a la aplicación.
Evidencia: captura de tool/evidence/t24-page.png mostrando el sitio levantado
con la API detenida, para confirmar independencia.
Prueba: verificación manual con la API detenida.
Estado: pendiente

---

## Fase J — Herramientas y cierre de pruebas

### T25 — Sembrador por API y ejecución de la suite
Cargar datos consumiendo el contrato y consolidar la verificación automatizada.
Respaldo: RNF04, requisito de sembrador del acta, secciones 13 y 14 de architecture.md.
Subcarpeta: tool y api
Verificación: tool/seed-api.sh autentica un asesor, crea artículos en las cinco
categorías, crea organizadores y registra alquileres y devoluciones, todo por HTTP.
tool/run-tests.sh ejecuta la suite desde la raíz. Existen al menos quince archivos
de prueba y todos pasan. Los nombres coinciden con el inventario de este documento.
No se incluyen herramientas de medición de rendimiento ni verificadores
automáticos de idioma: están fuera de alcance.
Prueba: la suite completa es la prueba de esta tarea.
Estado: pendiente

---

## Inventario de archivos de prueba

La tabla de trazabilidad de plan.md asocia cada regla y soporte con su prueba
principal. Esta lista es el inventario completo de archivos, incluidos los de
las historias que no tienen regla de negocio propia.

Los nombres son previstos. Al crear cada archivo se confirma que coincide;
si un nombre cambia, se actualiza este inventario y la tabla de plan.md
en el mismo commit.

### Feature — tests/Feature

| Archivo | Cubre | Tarea |
|:---|:---|:---|
| AuthenticationTest | SOP01, 401 sin token | T09 |
| CategoryListTest | SOP02, solo lectura | T10 |
| OrganizerSearchTest | SOP03, búsqueda por documento | T11 |
| ArticleDetailTest | SOP04, detalle por id | T12 |
| ArticleCreateTest | HU01, 409 duplicado | T13 |
| ArticleCatalogTest | HU02, paginación y filtros | T14 |
| ArticleUpdateTest | HU03, edición de catálogo | T15 |
| SoftDeleteTest | RN06, baja lógica | T15 |
| OrganizerCreateTest | HU04, 409 duplicado | T16 |
| OrganizerStatusTest | HU05, estado expuesto | T17 |
| OrganizerBlockTest | RN03, bloqueo por vencidos | T17, T18 |
| RentalFormValidationTest | validación de forma de POST /rentals | T18 |
| RentalLimitTest | RN01, límite de cinco | T18 |
| RentalDueDateTest | RN02, plazo de tres días | T18 |
| InventoryBoundsTest | RN04, inventario acotado | T19, T21 |
| FrozenSnapshotTest | RN05, datos congelados | T19, T20 |
| ConcurrentRentalTest | RNF01, última unidad y deadlock evitado | T19 |
| RentalListTest | HU07, filtros por estado | T20 |
| ReturnCreateTest | HU09, devolución parcial, total y casos de error | T21 |
| MostRequestedReportTest | HU10, orden por unidades y rango de fechas | T22 |

### Unit — tests/Unit

| Archivo | Cubre | Tarea |
|:---|:---|:---|
| DueDateCalculationTest | RN02, cálculo en UTC | T18 |
| RentalStatusTest | estado active, overdue, returned | T08, T20 |
| PendingUnitsTest | unidades pendientes por organizador | T21 |

Total previsto: veintitrés archivos. El mínimo exigido es quince.

---

## Matriz de cobertura

### Historias de usuario

| Historia | Tarea |
|:---|:---|
| HU01 | T13 |
| HU02 | T14 |
| HU03 | T15 |
| HU04 | T11, T16 |
| HU05 | T17 |
| HU06 | T18, T19 |
| HU07 | T20 |
| HU08 | T20 |
| HU09 | T21 |
| HU10 | T22 |

### Reglas de negocio

| Regla | Tarea | Prueba principal |
|:---|:---|:---|
| RN01 | T18 | RentalLimitTest |
| RN02 | T18 | RentalDueDateTest |
| RN03 | T17, T18, T21 | OrganizerBlockTest |
| RN04 | T07, T19, T21 | InventoryBoundsTest |
| RN05 | T19, T20, T22 | FrozenSnapshotTest |
| RN06 | T08, T15, T21 | SoftDeleteTest |

### Requisitos no funcionales

| Requisito | Tareas que lo sostienen | Verificación |
|:---|:---|:---|
| RNF01 concurrencia | T19 | ConcurrentRentalTest con dos peticiones simultáneas |
| RNF02 idioma y tiempo | T06 a T24 | revisión de código y respuestas; tildes en mensajes y docs |
| RNF03 entorno reproducible | T03, T04 | docker compose up en máquina limpia |
| RNF04 cobertura de pruebas | T25 | veintitrés archivos que pasan |
| RNF05 higiene del repositorio | T05 | git ls-files sin secretos ni vendor |

### Operaciones de soporte

| Soporte | Tarea | Prueba |
|:---|:---|:---|
| SOP01 | T09 | AuthenticationTest |
| SOP02 | T10 | CategoryListTest |
| SOP03 | T11 | OrganizerSearchTest |
| SOP04 | T12 | ArticleDetailTest |

### Subcarpetas de entrega

| Subcarpeta | Tareas |
|:---|:---|
| docs | T01, T02 |
| api | T06 a T22, T25 |
| app | T23 |
| page | T24 |
| infra | T03, T04, T05 |
| tool | T25 |

Las seis subcarpetas reciben trabajo. La matriz de commits de plan.md
garantiza al menos cuatro commits en cada una.

---

## Reglas de mantenimiento de este documento

1. Una tarea pasa a hecha solo cuando su criterio se cumple y su prueba pasa.
2. Si cambia un nombre de archivo de prueba, se actualiza el inventario
   y la tabla de plan.md en el mismo commit.
3. No se agregan tareas fuera del alcance de spec.md. Si aparece una necesidad
   nueva, se declara primero en la especificación o se descarta.
4. El estado se revisa al cierre de cada día de trabajo del cronograma.
5. T03, T04, T24 requieren evidencia en tool/evidence/ antes de pasar a hecha.
