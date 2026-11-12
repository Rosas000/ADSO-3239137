# Arquitectura — Event Furniture

Documento técnico de referencia. Define stack, capas, flujo de peticiones
y el lugar donde se implementa cada regla de negocio.

---

## 1. Vista general

Cuatro servicios en contenedores, orquestados con Docker Compose:

| Servicio | Carpeta de código | Tecnología | Puerto |
|:---|:---|:---|:---|
| page | page/ | Nginx sirviendo HTML estático | 8080 |
| app | app/ | Nginx sirviendo el build de React | 8081 |
| api | api/ | Nginx con PHP-FPM 8.3 y Laravel 11 | 8000 |
| db | — | PostgreSQL 16 | 5432, solo interno |

Topología:

    visitante --> page (8080)   sitio estático de presentación
    asesor    --> app  (8081)   build estático de React
                    |
                    | HTTP/JSON
                    v
                  api  (8000)   Laravel, reglas de negocio
                    |
                    | SQL
                    v
                  db   (5432)   PostgreSQL, restricciones de integridad

El único punto que escribe en la base de datos es api.
page no consume la API: es contenido estático.

---

## 2. Versiones

Fijadas por decisión de proyecto:

| Componente | Versión | Razón |
|:---|:---|:---|
| PHP | 8.3 | Soporte activo y compatibilidad con Laravel 11 |
| Laravel | 11 | Estructura de arranque simplificada y soporte vigente |
| PostgreSQL | 16 | Bloqueo de fila y restricciones CHECK confiables |
| React | 18 | API estable, sin dependencia de características experimentales |

Determinadas por el gestor de paquetes:

| Componente | Versión |
|:---|:---|
| Vite | La que instale el esqueleto de React. Se registra en este documento al crear app/package.json |
| PHPUnit | La que instale Laravel 11. Se registra en este documento al crear api/composer.json |
| Sanctum | La compatible con Laravel 11 según composer.json |

No se fijan de antemano versiones que el gestor resuelve por dependencia,
para evitar que el documento quede incongruente con los archivos de bloqueo.
Cambiar una versión mayor fijada requiere un ADR.

---

## 3. Capas del backend

    HTTP Request
        |
        v
    Controller        recibe la petición y delega. Sin lógica de negocio.
        |
        v
    FormRequest       valida forma: tipos, obligatorios, longitudes, formatos.
        |
        v
    Service           aplica las reglas de negocio RN01 a RN06.
        |             Abre transacción y bloquea filas cuando corresponde.
        v
    Model / DB        persiste. Restricciones CHECK como última defensa.
        |
        v
    ApiResource       serializa la respuesta. Fechas en UTC ISO 8601.
        |
        v
    HTTP Response

Responsabilidad de cada capa:

| Capa | Hace | No hace |
|:---|:---|:---|
| Controller | Orquestar entrada y salida | Consultar inventario, calcular fechas |
| FormRequest | Validar forma del payload | Validar reglas de negocio |
| Service | Aplicar reglas, transacciones, bloqueos | Conocer el formato HTTP |
| Model | Relaciones, casts, soft deletes | Reglas que dependen de otras entidades |
| ApiResource | Dar forma al JSON | Consultar datos adicionales |

Separación clave: FormRequest responde 422 por datos mal formados.
Service responde 422 por regla violada y 409 por conflicto de estado.

---

## 4. Estructura de api/

    api/
    |-- app/
    |   |-- Enums/                  RentalStatus
    |   |-- Exceptions/             excepciones de dominio
    |   |-- Http/
    |   |   |-- Controllers/Api/V1/ ArticleController, OrganizerController,
    |   |   |                       RentalController, RentalReturnController,
    |   |   |                       ReportController, CategoryController,
    |   |   |                       AuthController
    |   |   |-- Requests/           StoreArticleRequest, StoreRentalRequest, ...
    |   |   `-- Resources/          ArticleResource, RentalResource, ...
    |   |-- Models/                 Category, Article, Organizer, Advisor,
    |   |                           Rental, RentalLine, RentalReturn, RentalReturnLine
    |   `-- Services/               RentalService, RentalReturnService, ReportService
    |-- bootstrap/                  app.php, registro de manejo de excepciones
    |-- config/
    |-- database/
    |   |-- factories/
    |   |-- migrations/
    |   `-- seeders/                CategorySeeder, AdvisorSeeder
    |-- routes/                     api.php
    |-- tests/
    |   |-- Feature/                pruebas de endpoint y reglas
    |   `-- Unit/                   pruebas de cálculo y estado
    `-- composer.json

---

## 5. Dónde vive cada regla de negocio

| Regla | Implementación | Mecanismo |
|:---|:---|:---|
| RN01 límite de 5 | RentalService | Suma de unidades pendientes del organizador antes de crear |
| RN02 plazo de 3 días | RentalService | due_at calculado en UTC, nunca aceptado del cliente |
| RN03 bloqueo por vencidos | RentalService | Consulta de alquileres vencidos, primera validación |
| RN04 inventario acotado | RentalService, RentalReturnService, DB | Bloqueo de fila más CHECK en PostgreSQL |
| RN05 datos congelados | RentalService | Copia de reference y name al crear la línea |
| RN06 sin borrado físico | Rutas y modelos | Sin DELETE en operaciones, SoftDeletes en Article |

Orden de validación en RentalService: RN03, luego RN01, luego RN04.
RN03 es una prohibición absoluta y debe evaluarse antes que cualquier restricción
cuantitativa, para no autorizar a un organizador bloqueado.

---

## 6. Concurrencia

Estrategia: bloqueo pesimista de fila dentro de una transacción.

    DB::transaction(function () use ($articleId, $quantity) {
        $article = Article::where('id', $articleId)->lockForUpdate()->first();

        if ($article->available_units < $quantity) {
            throw new InsufficientUnitsException();
        }

        $article->decrement('available_units', $quantity);
        // crear rental y sus líneas con datos congelados
    });

Comportamiento esperado ante dos peticiones simultáneas por la última unidad:

1. La primera transacción adquiere el bloqueo de la fila.
2. La segunda queda en espera hasta que la primera confirme o aborte.
3. La primera decrementa a cero y confirma: responde 201.
4. La segunda lee available_units en cero y aborta: responde 409.
5. El inventario nunca queda negativo.

Defensa adicional en base de datos:

    ALTER TABLE articles
      ADD CONSTRAINT articles_available_units_range
      CHECK (available_units >= 0 AND available_units <= total_units);

Si un defecto de código intentara escribir un valor imposible, PostgreSQL lo rechaza.
La aplicación valida y la base de datos también. Ver ADR-002.

---

## 7. Manejo de errores

Excepciones de dominio y su código HTTP:

| Excepción | HTTP | Mensaje al usuario |
|:---|:---|:---|
| InsufficientUnitsException | 409 | No hay unidades suficientes del artículo solicitado. |
| DuplicateReferenceException | 409 | Ya existe un artículo con esa referencia. |
| DuplicateDocumentException | 409 | Ya existe un organizador con ese documento. |
| OrganizerBlockedException | 422 | El organizador tiene alquileres vencidos. Debe devolverlos antes de recibir más artículos. |
| RentalLimitExceededException | 422 | El organizador no puede tener más de 5 artículos sin devolver. |
| ArticleUnavailableException | 422 | El artículo no está disponible para alquiler. |
| InvalidReturnQuantityException | 422 | La cantidad a devolver supera las unidades pendientes. |
| ModelNotFoundException | 404 | Recurso no encontrado. |
| AuthenticationException | 401 | No autenticado. |

Registro centralizado en bootstrap/app.php mediante withExceptions.
Ningún controlador captura excepciones de dominio: se resuelven en un solo lugar.

Formato uniforme de error:

    {
      "message": "No hay unidades suficientes del artículo solicitado.",
      "errors": {}
    }

Los mensajes van en español. Las claves del JSON en inglés.

No se contempla 403 Forbidden: existe un único rol operativo y todo asesor
autenticado está autorizado para todas las operaciones. No hay caso que lo produzca.

---

## 8. Autenticación

Laravel Sanctum con tokens de acceso. Implementa SOP01 de la especificación.

- Solo Advisor se autentica. Organizer es una entidad del dominio, no un usuario.
- El asesor se identifica con correo y contraseña: POST /api/v1/auth/login.
- El token se envía en el encabezado Authorization.
- Todas las rutas de escritura, el reporte y la consulta de categorías requieren token.
- Sin token o token inválido: 401 Unauthorized.
- El asesor inicial se siembra con AdvisorSeeder. No hay registro público.

El advisor_id de cada operación se toma del token, nunca del cuerpo de la petición.
Esto garantiza la trazabilidad de quién registró cada movimiento.

---

## 9. Tiempo y zona horaria

- config/app.php fija timezone en UTC.
- Las columnas de fecha son timestamp con zona.
- Las respuestas serializan en ISO 8601 con sufijo Z.
- El cálculo de vencimiento compara siempre contra la hora UTC actual.
- La conversión a hora local ocurre solo en el cliente, para mostrar.

La lógica de negocio nunca usa hora local. Ver ADR-003.

---

## 10. Frontend

    app/
    |-- src/
    |   |-- api/            cliente HTTP y funciones por recurso
    |   |-- components/     piezas reutilizables de interfaz
    |   |-- pages/          Catalog, Organizers, RentalCreate,
    |   |                   RentalDetail, ReturnCreate, Report, Login
    |   |-- hooks/          estado de peticiones
    |   `-- main.jsx
    |-- package.json
    `-- vite.config.js

Reglas del frontend:

- No implementa reglas de negocio: solo muestra lo que la API decide.
- Puede anticipar errores de forma para mejorar la experiencia, pero la API
  es la que valida en definitiva.
- Los mensajes de error se muestran tal como los entrega la API, en español.
- Las fechas se convierten a hora local únicamente al renderizar.
- El estado de bloqueo del organizador se consulta antes de habilitar el formulario.

### Servido en el entorno Docker

El contenedor de app compila el proyecto con vite build y Nginx sirve
el directorio dist resultante en el puerto 8081. No se usa el servidor
de desarrollo de Vite en el entorno entregado.

Razón: el servidor de desarrollo de Vite no está diseñado para exposición
pública. Incluye recarga en caliente, mapas de fuente y endpoints internos
que no deben estar disponibles en un entorno desplegado. Servir el build
estático elimina esa superficie y reduce el consumo del contenedor.

El servidor de desarrollo en el puerto 5173 queda disponible únicamente
para trabajo local fuera de Docker, de forma opcional. No forma parte
del entorno que levanta docker compose up.

---

## 11. Sitio público

page/ es HTML y CSS estáticos servidos por Nginx en el puerto 8080.

- Presenta el producto: qué es Event Furniture, qué problema resuelve,
  categorías del catálogo y funcionalidades principales.
- No describe la prueba técnica ni el plan de mejoramiento.
- No consume la API ni requiere JavaScript para mostrar contenido.
- Incluye enlace de acceso a la aplicación.

---

## 12. Infraestructura

Los archivos de construcción viven en infra/, con nombres que no se
confunden con las carpetas de código api/ y app/ de la raíz:

    infra/
    |-- docker-compose.yml
    |-- docker/
    |   |-- api.Dockerfile
    |   |-- app.Dockerfile
    |   `-- page.Dockerfile
    |-- nginx/
    |   |-- api.conf
    |   |-- app.conf
    |   `-- page.conf
    `-- .env.example

El contexto de construcción de los tres servicios es la raíz de
plan-mejoramiento, declarado como context: .. en el compose. Cada imagen
se referencia con dockerfile: infra/docker/nombre.Dockerfile.

Arranque con un solo comando:

    docker compose --env-file infra/.env -f infra/docker-compose.yml up --build

Orden de dependencia: db primero, api espera a que db responda mediante
healthcheck, app y page arrancan en paralelo. Esto evita que api intente
conectar antes de que PostgreSQL acepte conexiones.

Variables de entorno por archivo .env.example versionado.
El archivo .env real nunca se sube al repositorio (RNF05).

---

## 13. Sembrador de datos

Requisito del acta: sembrador que carga datos por la API, no por SQL directo.

Ubicación: tool/seed-api.sh

Secuencia:
1. Autentica un asesor mediante SOP01 y obtiene token.
2. Crea artículos en las cinco categorías mediante POST /api/v1/articles.
3. Crea organizadores mediante POST /api/v1/organizers.
4. Registra algunos alquileres y devoluciones para que el reporte tenga datos.

Razón: si el sembrador pasara por encima de la API, no ejercitaría las reglas
de negocio ni demostraría que el contrato funciona. Sembrar por API valida
el sistema de extremo a extremo.

Las cinco categorías y el asesor inicial se siembran con seeders de Laravel,
porque son datos de estructura previos a cualquier operación autenticada.

---

## 14. Estrategia de pruebas

Mínimo 15 archivos, en dos niveles:

| Nivel | Ubicación | Qué cubre |
|:---|:---|:---|
| Unit | tests/Unit | Cálculo de vencimiento, estado del alquiler, unidades pendientes |
| Feature | tests/Feature | Endpoints, reglas de negocio, códigos HTTP, concurrencia, reporte |

Cada regla RN01 a RN06 tiene al menos una prueba dedicada.
La concurrencia se prueba con peticiones simultáneas sobre una única unidad.
SOP01 y SOP02 se cubren con pruebas de autenticación y de consulta de categorías.

Ejecución con un solo comando:

    docker compose --env-file infra/.env -f infra/docker-compose.yml exec api php artisan test

El script tool/run-tests.sh envuelve ese comando para cumplir RNF04
desde la raíz del proyecto. No añade funcionalidad: solo lo invoca.

Base de datos de pruebas aislada, recreada en cada ejecución.

No se implementan pruebas de carga ni medición de rendimiento:
están declaradas fuera de alcance en la especificación.

---

## 15. Convención de nombres de la devolución

La entidad de devolución se nombra RentalReturn, no Return.

Razón: return es palabra reservada de PHP. Declarar class Return produce un error
de sintaxis y el archivo no compila. El prefijo Rental elimina el conflicto y
además expresa a qué pertenece la devolución.

Nombres que cambian:

| Elemento | Nombre |
|:---|:---|
| Modelo de cabecera | RentalReturn |
| Modelo de detalle | RentalReturnLine |
| Tabla de cabecera | rental_returns |
| Tabla de detalle | rental_return_lines |
| Clave foránea en el detalle | rental_return_id |
| Controlador | RentalReturnController |
| Servicio | RentalReturnService |

Nombres que no cambian, y por qué:

| Elemento | Nombre | Razón |
|:---|:---|:---|
| Ruta | POST /api/v1/rentals/{id}/returns | en la URL es el recurso REST, no un identificador de PHP |
| Excepción | InvalidReturnQuantityException | no es la palabra reservada exacta; nombra la condición, no la entidad |
| Prueba | ReturnCreateTest | nombra el endpoint que verifica |
| Página de React | ReturnCreate | JavaScript no reserva Return; nombra la acción del usuario |

---

## 16. Restricciones de integridad

El detalle completo está en data-model.md. Las que la aplicación debe respetar
y las pruebas deben verificar:

| Restricción | Tabla | Efecto |
|:---|:---|:---|
| articles_total_units_positive | articles | total_units mayor que cero |
| articles_available_units_range | articles | available_units entre 0 y total_units |
| rentals_status_allowed | rentals | status solo active o returned |
| rentals_returned_consistent | rentals | status returned si y solo si returned_at no es nulo |
| rental_lines_quantity_positive | rental_lines | quantity mayor que cero |
| rental_lines_returned_within_quantity | rental_lines | returned_quantity entre 0 y quantity |
| rental_return_lines_quantity_positive | rental_return_lines | quantity mayor que cero |

La igualdad entre la suma de rental_return_lines.quantity y
rental_lines.returned_quantity no es una restricción de base de datos: la mantiene
RentalReturnService dentro de la misma transacción. ReturnCreateTest la verifica.

---

## 17. Operación del entorno

### Preparación y arranque

Preparación única, desde la carpeta plan-mejoramiento:

    cp infra/.env.example infra/.env

Arranque con un solo comando, desde la misma carpeta:

    docker compose --env-file infra/.env -f infra/docker-compose.yml up --build

El flag --env-file es explícito a propósito. Con -f, Compose no garantiza leer
el .env ubicado junto al archivo de composición, y las variables quedarían
vacías. Declararlo elimina la ambigüedad y cumple RNF03.

Este es el mismo comando que aparece en spec.md (RNF03), en el comentario de
docker-compose.yml y en el README. No hay dos formas de arrancar el proyecto.

### Contexto de construcción

Los tres servicios usan context: .. — la raíz de plan-mejoramiento.

Razón: cada Dockerfile necesita copiar tanto el código de su carpeta
(api/, app/, page/) como las configuraciones de infra/nginx/. Docker prohíbe
COPY fuera del contexto de construcción, así que un contexto restringido a la
carpeta de código haría imposible alcanzar infra/ y la construcción fallaría.

### Clave de la aplicación

APP_KEY puede quedar vacía en infra/.env. El entrypoint del contenedor api
la genera en el arranque si no encuentra valor, de modo que no haya un paso
manual que rompa el requisito de un solo comando.

La clave generada en runtime es efímera: se regenera al recrear el contenedor.
Los tokens de Sanctum no dependen de APP_KEY, por lo que las sesiones de los
asesores no se invalidan. Para fijar una clave estable se genera con
php artisan key:generate --show y se pega en infra/.env.

### Healthchecks

| Servicio | Verificación | Propósito |
|:---|:---|:---|
| db | pg_isready | que PostgreSQL acepte conexiones, no solo que el contenedor arranque |
| api | nc -z 127.0.0.1 80 | que Nginx esté escuchando |

api espera a db con condition: service_healthy. app espera a api con la misma
condición. page no depende de nadie.

El healthcheck de api verifica disponibilidad del puerto, no un endpoint de
salud. No se crea un endpoint /health porque no está en la especificación y
añadiría alcance no declarado.

### Puerto de la base de datos

PostgreSQL no se expone al equipo anfitrión. La API conecta por la red interna
de Docker usando el nombre de servicio db.

Razón: exponer 5432 haría fallar el arranque si el evaluador ya tiene PostgreSQL
en ese puerto, y no aporta nada al cumplimiento del acta. El bloque ports queda
comentado en docker-compose.yml para quien necesite inspeccionar la base de datos
con un cliente local, usando un puerto alternativo.
