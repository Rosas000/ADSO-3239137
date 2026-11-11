# Especificacion funcional — Event Furniture

Dominio: alquiler de mobiliario para eventos.
Identificador: event-furniture.
Referencia de adaptacion: Manager Library.

---

## 1. Equivalencias con Manager Library

| Manager Library | Event Furniture | Identificador en codigo |
|:---|:---|:---|
| Libro | Articulo (identificado por referencia) | Article |
| Ejemplares | Unidades | units |
| Socio | Organizador | Organizer |
| Bibliotecario | Asesor | Advisor |
| Prestamo | Alquiler | Rental |
| Categoria | Cinco categorias sembradas | Category |

Categorias sembradas: sillas, mesas, carpas, tarimas, decoracion.

---

## 2. Actores

| Actor | Descripcion | Permisos |
|:---|:---|:---|
| Asesor (Advisor) | Operador autenticado del sistema | Gestiona catalogo, organizadores, alquileres y devoluciones. Consulta reportes. |
| Visitante | Usuario no autenticado del sitio publico | Solo lectura del sitio estatico de presentacion |

El organizador es una entidad del dominio, no un usuario del sistema.
No inicia sesion: es registrado y atendido por un asesor.

---

## 3. Entidades del dominio

| Entidad | Responsabilidad |
|:---|:---|
| Category | Agrupa articulos. Cinco registros sembrados, no editables. |
| Article | Articulo del catalogo con referencia unica, total de unidades y disponibles. |
| Organizer | Cliente que recibe mobiliario en alquiler. |
| Advisor | Operador autenticado que registra las operaciones. |
| Rental | Operacion de alquiler. Cabecera con organizador, fechas y estado. |
| RentalLine | Detalle del alquiler: articulo, cantidad y datos congelados del catalogo. |
| Return | Registro de devolucion asociado a un alquiler. |
| ReturnLine | Detalle de que articulos y cuantas unidades se devolvieron. |

El detalle de campos y relaciones esta en data-model.md.

---

## 4. Reglas de negocio

### RN01 — Limite de articulos sin devolver
Un organizador no puede tener mas de 5 articulos sin devolver.

- Se cuentan unidades pendientes: suma de (quantity - returned_quantity)
  de todas las lineas de alquiler activas o vencidas del organizador.
- Si la suma actual mas la cantidad solicitada supera 5, se rechaza.
- Respuesta: 422 Unprocessable Entity.
- Mensaje: "El organizador no puede tener mas de 5 articulos sin devolver."

### RN02 — Plazo de alquiler
Todo alquiler tiene un plazo de 3 dias.

- due_at = rented_at + 3 dias, calculado en UTC por el backend.
- El cliente no puede enviar ni modificar due_at.
- Un alquiler esta vencido cuando la fecha actual UTC supera due_at
  y quedan unidades sin devolver.

### RN03 — Bloqueo por vencimiento
Un organizador con alquileres vencidos no recibe mas articulos hasta devolverlos.

- Se evalua antes que RN01.
- Respuesta: 422 Unprocessable Entity.
- Mensaje: "El organizador tiene alquileres vencidos. Debe devolverlos antes de recibir mas articulos."

### RN04 — Inventario acotado
Las unidades disponibles estan siempre entre 0 y el total.

- available_units nunca es negativo ni mayor que total_units.
- Al crear un alquiler: available_units disminuye en quantity.
- Al registrar devolucion: available_units aumenta en returned_quantity.
- Si la cantidad solicitada supera available_units, se rechaza con 409 Conflict.
- Mensaje: "No hay unidades suficientes del articulo solicitado."
- La restriccion se aplica tambien en base de datos mediante CHECK.

### RN05 — Datos congelados en la linea
Lo congelado en la linea de la operacion no sigue al catalogo.

- Al crear una RentalLine se copian reference y name del articulo
  en los campos article_reference y article_name de la linea.
- Si el articulo se renombra, cambia de categoria o se da de baja,
  la linea historica conserva los valores originales.
- El detalle de alquiler lee los datos congelados, no el catalogo.

### RN06 — Sin borrado fisico
Las operaciones y devoluciones no se borran; el catalogo solo tiene baja logica.

- Rental, RentalLine, Return y ReturnLine no tienen endpoint DELETE.
- Article solo admite baja logica mediante deleted_at.
- Un articulo dado de baja no aparece en el catalogo ni puede alquilarse,
  pero sus lineas historicas siguen siendo consultables.
- No se puede dar de baja un articulo con unidades pendientes de devolucion.
- Mensaje: "No se puede dar de baja un articulo con unidades sin devolver."

---

## 5. Reglas transversales

| Regla | Aplicacion |
|:---|:---|
| Fechas en UTC | Almacenadas y expuestas en ISO 8601 con sufijo Z |
| Mensajes en espanol | Toda respuesta visible al usuario |
| Identificadores en ingles | Codigo, tablas, columnas y rutas |
| Validacion en backend | Ninguna regla depende del frontend |

---

## 6. Concurrencia

Escenario: dos asesores intentan alquilar la ultima unidad disponible
del mismo articulo en el mismo instante.

Comportamiento exigido:
1. Ambas peticiones llegan a la API.
2. La primera transaccion que obtiene el bloqueo decrementa available_units a 0 y confirma.
3. La segunda detecta que ya no hay unidades y aborta.
4. La primera recibe 201 Created. La segunda recibe 409 Conflict.
5. available_units queda en 0. Nunca en -1.

Mensaje para la peticion rechazada:
"No hay unidades suficientes del articulo solicitado."

Estrategia: bloqueo pesimista de fila dentro de una transaccion. Ver ADR-002.

---

## 7. Historias de usuario

### HU01 — Registrar articulo
Como asesor quiero registrar un articulo en el catalogo para poder alquilarlo.

Criterios de aceptacion:
- Referencia unica, nombre, categoria y total de unidades obligatorios.
- Al crear, available_units igual a total_units.
- Referencia duplicada responde 409 Conflict.
- Categoria inexistente responde 422.
- Exito: 201 Created.

### HU02 — Consultar catalogo
Como asesor quiero listar y filtrar articulos por categoria y referencia
para encontrar rapidamente lo que necesita el organizador.

Criterios de aceptacion:
- Lista paginada. Excluye articulos con baja logica.
- Filtro por categoria y busqueda parcial por referencia o nombre.
- Cada registro expone total_units y available_units.
- Exito: 200 OK.

### HU03 — Editar y dar de baja un articulo
Como asesor quiero corregir los datos de un articulo o darlo de baja
para mantener el catalogo actualizado.

Criterios de aceptacion:
- Permite editar nombre, categoria y total de unidades.
- Reducir total_units por debajo de las unidades alquiladas responde 422.
- Cambiar el catalogo no altera lineas de alquiler existentes (RN05).
- Baja logica con unidades pendientes responde 422 (RN06).
- Exito: 200 OK.

### HU04 — Registrar organizador
Como asesor quiero registrar un organizador para poder entregarle mobiliario.

Criterios de aceptacion:
- Documento de identidad unico, nombre y telefono obligatorios.
- Documento duplicado responde 409 Conflict.
- Exito: 201 Created.

### HU05 — Consultar estado del organizador
Como asesor quiero ver el estado de un organizador antes de atenderlo
para saber si puede recibir articulos.

Criterios de aceptacion:
- Expone unidades pendientes, alquileres activos y alquileres vencidos.
- Expone indicador booleano de bloqueo por vencimiento (RN03).
- Organizador inexistente responde 404.
- Exito: 200 OK.

### HU06 — Crear alquiler
Como asesor quiero registrar un alquiler con uno o varios articulos
para entregar mobiliario al organizador.

Criterios de aceptacion:
- Valida RN03, luego RN01, luego RN04, en ese orden.
- Calcula due_at en el backend (RN02).
- Congela referencia y nombre en cada linea (RN05).
- Descuenta available_units de forma atomica.
- Articulo con baja logica responde 422.
- Exito: 201 Created con el detalle del alquiler.

### HU07 — Consultar alquileres
Como asesor quiero listar los alquileres por estado y por organizador
para hacer seguimiento a las entregas.

Criterios de aceptacion:
- Filtros por estado (active, overdue, returned) y por organizador.
- Lista paginada.
- El estado vencido se calcula en UTC al momento de la consulta.
- Exito: 200 OK.

### HU08 — Consultar detalle de alquiler
Como asesor quiero ver el detalle de un alquiler con los datos originales
para resolver reclamos sobre lo que se entrego.

Criterios de aceptacion:
- Lee article_reference y article_name congelados (RN05).
- Expone quantity, returned_quantity y pendientes por linea.
- Alquiler inexistente responde 404.
- Exito: 200 OK.

### HU09 — Registrar devolucion
Como asesor quiero registrar la devolucion de articulos
para liberar unidades y desbloquear al organizador.

Criterios de aceptacion:
- Permite devolucion parcial o total por linea.
- Devolver mas de lo pendiente responde 422.
- Incrementa available_units sin exceder total_units (RN04).
- Crea Return y ReturnLine; no borra ni edita el alquiler (RN06).
- Cuando no quedan unidades pendientes, el alquiler pasa a estado returned.
- Una devolucion libera el bloqueo por vencimiento (RN03).
- Exito: 201 Created.

### HU10 — Reporte de articulos mas solicitados
Como asesor quiero consultar el reporte de articulos mas solicitados
para decidir compras de inventario.

Criterios de aceptacion:
- Ordena por total de unidades alquiladas, descendente.
- Suma las cantidades de las lineas, no el numero de operaciones.
- Incluye articulos dados de baja que tuvieron movimientos.
- Lee los datos congelados de las lineas (RN05).
- Acepta rango de fechas opcional en UTC.
- Exito: 200 OK.

---

## 8. Requisitos no funcionales

### RNF01 — Seguridad de concurrencia
Bajo peticiones simultaneas sobre la ultima unidad, el sistema nunca
produce inventario negativo. Una peticion tiene exito y las demas reciben 409.
Verificable con prueba automatizada de concurrencia.

### RNF02 — Consistencia de idioma y tiempo
Fechas en UTC ISO 8601. Mensajes al usuario en espanol.
Identificadores de codigo en ingles. Verificable por revision estatica.

### RNF03 — Entorno reproducible
El entorno completo levanta con un unico comando docker compose up.
Incluye base de datos, API y frontend. Los datos iniciales se cargan
con un sembrador que consume la API. Verificable en maquina limpia.

### RNF04 — Cobertura de pruebas
Minimo 15 archivos de prueba automatizada en el backend.
Cada regla RN01 a RN06 tiene al menos una prueba que la cubre.
Ejecutables con un unico comando.

### RNF05 — Tiempo de respuesta
Las consultas de catalogo y de estado del organizador responden
en menos de 500 ms en el percentil 95 con 1000 articulos sembrados.
Verificable con prueba de carga sobre el entorno Docker.

---

## 9. Fuera de alcance

No se implementa: facturacion, pagos, tarifas, notificaciones, multiples bodegas,
aplicacion movil, ni reportes distintos al de articulos mas solicitados.

Cualquier funcion no listada en este documento se considera fuera de alcance.
