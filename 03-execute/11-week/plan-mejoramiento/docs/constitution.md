# Constitution — Event Furniture

Principios no negociables del proyecto. Toda decision tecnica que contradiga
este documento debe quedar registrada en un ADR.

---

## 1. Proposito

Construir un sistema web para gestionar el alquiler de mobiliario para eventos,
donde el inventario disponible sea siempre confiable, las operaciones sean
auditables y las reglas de negocio se apliquen en el backend, nunca solo en la interfaz.

---

## 2. Principios

### P1 — El backend es la unica fuente de verdad
Toda regla de negocio se valida en la API. El frontend puede anticipar errores
para mejorar la experiencia, pero nunca decide si una operacion es valida.

### P2 — El inventario nunca miente
Las unidades disponibles de un articulo estan siempre entre 0 y su total.
Ninguna ruta de codigo puede dejar el inventario en un estado imposible.

### P3 — La historia no se reescribe
Los alquileres y sus devoluciones son registros permanentes.
No se borran ni se editan despues de creados. El catalogo solo admite baja logica.

### P4 — Lo congelado permanece congelado
Al crear una linea de alquiler se guarda una copia de los datos del articulo
en ese momento. Si el catalogo cambia despues, la linea historica no cambia.

### P5 — La concurrencia se resuelve, no se ignora
Dos asesores pueden intentar tomar la ultima unidad al mismo tiempo.
El sistema garantiza que uno gana y el otro recibe 409 Conflict. Nunca se sobrevende.

### P6 — Un solo comando levanta el entorno
Cualquier persona con Docker debe poder clonar el repositorio y ejecutar
un unico comando para tener base de datos, API y frontend funcionando.

### P7 — Sin alcance inventado
No se implementa ninguna funcion que no este en spec.md.
Las funciones fuera de alcance penalizan la evaluacion.

---

## 3. Reglas de idioma

| Elemento | Idioma |
|:---|:---|
| Clases, metodos y variables | Ingles |
| Tablas y columnas de base de datos | Ingles |
| Rutas y parametros de la API | Ingles |
| Mensajes de exito y error al usuario | Espanol |
| Textos de la interfaz | Espanol |
| Documentacion tecnica | Espanol |

Las fechas se almacenan y transmiten en UTC (ISO 8601).
La conversion a hora local es responsabilidad exclusiva del cliente.

---

## 4. Alcance

### Incluido
- Catalogo de articulos en cinco categorias sembradas
- Registro y consulta de organizadores
- Creacion de alquileres con validacion de las seis reglas de negocio
- Registro de devoluciones
- Reporte de articulos mas solicitados
- Sitio publico estatico de presentacion del producto
- Pruebas automatizadas del backend

### Excluido
- Facturacion, pagos o calculo de tarifas
- Notificaciones por correo o SMS
- Gestion de bodegas o sucursales multiples
- Aplicacion movil
- Reportes distintos al de articulos mas solicitados

---

## 5. Definicion de terminado

Una tarea se considera terminada cuando:

1. El codigo esta en ingles y los mensajes al usuario en espanol.
2. La regla de negocio correspondiente se valida en el backend.
3. Existe al menos una prueba automatizada que la cubre.
4. El endpoint esta descrito en api-contract.md.
5. El cambio esta registrado en un commit pequeno y descriptivo.
6. No introduce funciones fuera de spec.md.
