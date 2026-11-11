# Plan de trabajo — Event Furniture

Plan de ejecución del plan de mejoramiento. Acta No. 14 - 2026.
Vigencia del plan: 5 al 19 de noviembre de 2026.
Sustentación: 26 de noviembre de 2026.

---

## 1. Objetivo

Entregar el proyecto event-furniture totalmente terminado, con especificación
propia, producto funcional en React y Laravel, entorno en contenedores y pruebas
automatizadas, de modo que se cumplan los criterios de juicio A definidos en el acta.

---

## 2. Criterio de aprobación

El acta exige mínimo 70 sobre 100 en dos revisiones obligatorias:

| Revisión | Objeto | Criterio |
|:---|:---|:---|
| 1 | Plan de mejoramiento (event-furniture) | Acumulado de 70% sobre 700 y ningún informe por debajo de 50 |
| 2 | Proyecto formativo del equipo (Bourgelat) | Rúbrica de documentación, secciones 00 a 06 y congruencia, con 70 o más |

Aprobar solo una no cumple el plan. Ambas se trabajan en paralelo.

---

## 3. Antecedente que corrige este plan

El resultado de la prueba anterior fue insuficiente. Las causas raíz identificadas
y su corrección son:

| Informe | Causa raíz | Corrección aplicada |
|:---|:---|:---|
| 1 Commits | Trabajo concentrado en una sola noche | Commits diarios y mínimo cuatro por subcarpeta |
| 2 Cambios en docs | Sin commits de trabajo en docs | Un commit por documento, más correcciones de congruencia |
| 3 Congruencia del spec | Spec incompleto y desconectado del código | Criterios verificables y tabla de trazabilidad |
| 4 Calidad del sitio page | Sitio no cumplió el veredicto | Sitio estático propio que presenta el producto |
| 5 Completitud de tareas | Tareas sin implementar | 23 tareas con prueba que las respalda |
| 6 Extras fuera del spec | Funciones no especificadas | Principio P7 y lista explícita de fuera de alcance |
| 7 Código en español | Cumplía | Se mantiene y se refuerza la acentuación correcta |

Los valores numéricos del resultado individual no se reproducen aquí:
el repositorio es público y ese dato no aporta al plan de trabajo.

---

## 4. Estado de avance

Trabajo ya registrado en el repositorio: estructura de entrega, README,
constitution, spec, plan y architecture, con sus correcciones de congruencia.

El conteo de días con commits se verifica al cierre con:

    git log --date=short --pretty=format:%ad | sort -u

No se afirma un número fijo en este documento: se comprueba contra el historial.

---

## 5. Fases

Las fases son bloques de trabajo, no rangos cerrados. El cronograma de la
sección 6 es la referencia operativa y prevalece sobre esta descripción.

### Fase A — Cierre de especificación
Completar data-model, api-contract, tasks y los tres ADR.
Verificar congruencia entre los diez documentos.

### Fase B — Backend
Esqueleto Laravel, migraciones, modelos, servicios con las seis reglas,
controladores, validación, recursos y suite de pruebas.
Es la fase de mayor peso y mayor riesgo: recibe cinco días.

### Fase C — Frontend
Aplicación React que consume la API, compilada y servida por Nginx.

### Fase D — Sitio público y herramientas
Sitio estático de presentación del producto y scripts de apoyo declarados.
Peso bajo: se ubica al final.

### Fase E — Cierre y entrega
Verificación de congruencia, PDF anonimizado del acta, README actualizado
y entrega antes de las 6:00 p. m. del 19 de noviembre.

### Fase F — Preparación de sustentación
Repaso de decisiones, ensayo de ejecución en limpio y práctica de cambio en vivo.
Del 20 al 25 de noviembre.

---

## 6. Cronograma

| Fecha | Trabajo principal | Subcarpetas con commit |
|:---|:---|:---|
| 12 nov | data-model, api-contract, esqueleto Laravel, compose base | docs, api, infra |
| 13 nov | tasks, tres ADR, migraciones y modelos | docs, api |
| 14 nov | Servicios: RN01, RN02, RN03 y sus pruebas | api |
| 15 nov | Servicios: RN04, RN05, RN06, concurrencia y sus pruebas | api |
| 16 nov | Controladores, FormRequests, Resources, autenticación | api |
| 17 nov | Pruebas restantes del backend, esqueleto de React | api, app |
| 18 nov | Páginas de la aplicación, sitio público | app, page |
| 19 nov | Sembrador, cierre del sitio, verificación y entrega | tool, page, docs |

Ocho días de trabajo programado, adicionales a los ya registrados.
El mínimo exigido por el acta es ocho días distintos en total.

Justificación del orden: el backend concentra las seis reglas de negocio,
la concurrencia y la mayoría de las pruebas. Recibe cinco días (13 al 17).
page y tool tienen peso bajo y se ubican al final, donde un retraso
no compromete la parte que más informes sostiene.

---

## 7. Matriz de commits por subcarpeta

El informe 1 exige cuatro o más commits por subcarpeta.

| Subcarpeta | Commits planeados | Contenido |
|:---|:---|:---|
| docs | 10 o más | Un commit por documento más correcciones de congruencia |
| api | 8 o más | Esqueleto, migraciones, modelos, servicios por bloque de reglas, controladores, validación, recursos, pruebas |
| app | 5 | Esqueleto, cliente HTTP, catálogo y organizadores, operaciones, reporte |
| page | 4 | Estructura, estilos, contenido del producto, pulido y enlace a la app |
| infra | 5 | Compose base, api.Dockerfile, app.Dockerfile, page.Dockerfile, configuraciones Nginx y healthchecks |
| tool | 4 | Sembrador: autenticación, artículos, organizadores y operaciones; envoltorio de pruebas |

Regla de trabajo: ningún commit gigante al cierre. Cada cambio verificable
se registra en el momento en que se completa.

---

## 8. Contenido de tool/

Solo se incluyen las dos herramientas declaradas en la especificación
y en la arquitectura. No se añaden utilidades adicionales.

| Script | Propósito | Respaldo |
|:---|:---|:---|
| tool/seed-api.sh | Sembrador de datos que consume la API | Requisito del acta, sección 13 de architecture.md |
| tool/run-tests.sh | Envoltorio de php artisan test para ejecutar desde la raíz | RNF04, sección 14 de architecture.md |

Descartados por fuera de alcance: verificador automático de idioma y script
de pruebas de carga. La verificación de RNF02 y RNF05 es por revisión manual,
y RNF05 ya no exige medición de rendimiento.

---

## 9. Estrategia de trazabilidad

Cada regla se conecta con su historia, su endpoint y su prueba.
Esta cadena sostiene el informe 3.

Los nombres de archivo de prueba son previstos. Al crearlos se verifica
que coincidan exactamente con esta tabla; si un nombre cambia, se actualiza
la tabla en el mismo commit. Una tabla con nombres que no existen en el
código es una incongruencia.

| Regla o soporte | Historia | Endpoint principal | Prueba prevista |
|:---|:---|:---|:---|
| RN01 | HU06 | POST /api/v1/rentals | RentalLimitTest |
| RN02 | HU06 | POST /api/v1/rentals | RentalDueDateTest |
| RN03 | HU05, HU06 | POST /api/v1/rentals | OrganizerBlockTest |
| RN04 | HU06, HU09 | POST /api/v1/rentals | InventoryBoundsTest |
| RN05 | HU08 | GET /api/v1/rentals/{id} | FrozenSnapshotTest |
| RN06 | HU03, HU09 | DELETE /api/v1/articles/{id} | SoftDeleteTest |
| Concurrencia | HU06 | POST /api/v1/rentals | ConcurrentRentalTest |
| Reporte | HU10 | GET /api/v1/reports/most-requested | MostRequestedReportTest |
| SOP01 | — | POST /api/v1/auth/login | AuthenticationTest |
| SOP02 | — | GET /api/v1/categories | CategoryListTest |

---

## 10. Riesgos y mitigación

| Riesgo | Impacto | Mitigación |
|:---|:---|:---|
| Backend insuficiente en tiempo | Alto | Cinco días asignados, reglas agrupadas por bloque, pruebas junto a cada regla |
| Prueba de concurrencia difícil de reproducir | Alto | Aislarla el 15 de noviembre con bloqueo de fila y prueba dedicada |
| Incongruencia entre documentos y código | Alto | Tabla de la sección 9 como lista de chequeo en cada commit |
| Similitud con trabajo de otro aprendiz | Alto | Ver detalle abajo |
| Olvido de la revisión 2 (Bourgelat) | Alto | Bloque fijo diario en el cronograma de la sección 11 |
| Commit único al cierre | Medio | Matriz de la sección 7 revisada cada noche |
| Versiones documentadas que no coinciden con las instaladas | Medio | Registrar Vite y PHPUnit al crear los archivos de bloqueo, no antes |

### Mitigación de similitud

El acta penaliza desde 85% de parecido con la mitad de los informes 3, 4 y 5,
y desde 98% con su pérdida total. Tener un dominio distinto no basta:
la estructura y la redacción también se comparan.

Compromisos concretos:
- No consultar ni reutilizar el repositorio de otro aprendiz de la ficha.
- Redactar los documentos con voz propia, no plantillas compartidas.
- Elegir nombres de clases, métodos y archivos por criterio propio y justificarlos.
- Poder explicar cada decisión sin leer el documento.
- Si una decisión coincide con la de un compañero, que sea por la misma razón
  técnica y no por copia, y estar en capacidad de defenderla.

---

## 11. Trabajo paralelo: revisión 2 (Bourgelat)

La segunda revisión evalúa la documentación del proyecto formativo del equipo,
secciones 00 a 06 y su congruencia con el código. Sin este pilar el plan
no se cumple, aunque event-furniture quede perfecto.

Bloque reservado: una hora diaria, de 8:00 p. m. a 9:00 p. m.,
del 12 al 19 de noviembre. Total: ocho horas.

| Fecha | Bloque | Objeto |
|:---|:---|:---|
| 12 nov | 1 h | Inventario de las secciones 00 a 06: qué existe y qué falta |
| 13 nov | 1 h | Completar secciones faltantes de contexto y alcance |
| 14 nov | 1 h | Congruencia entre documentación y modelo de datos |
| 15 nov | 1 h | Congruencia entre documentación y endpoints implementados |
| 16 nov | 1 h | Evidencias de validación y manejo de errores |
| 17 nov | 1 h | Revisión de redacción y consistencia entre secciones |
| 18 nov | 1 h | Verificación contra la rúbrica, punto por punto |
| 19 nov | 1 h | Cierre y entrega de la documentación del equipo |

Este bloque no se negocia ni se pospone por retrasos en event-furniture.

---

## 12. Verificación antes de entregar

1. Ocho o más días con commits, comprobado contra el historial.
2. Cuatro o más commits en cada una de las seis subcarpetas.
3. Los diez documentos de especificación existen y son congruentes entre sí.
4. Las operaciones de soporte declaradas están implementadas y probadas.
5. Las 23 tareas de tasks.md están implementadas y marcadas.
6. Las seis reglas de negocio se validan en el backend y tienen prueba.
7. Mínimo 15 archivos de prueba, ejecutables con un comando.
8. Los nombres de archivo de prueba coinciden con la tabla de trazabilidad.
9. El entorno levanta con un solo comando en máquina limpia.
10. La aplicación se sirve como build estático, no con servidor de desarrollo.
11. El sembrador carga datos consumiendo la API.
12. El sitio page presenta el producto, no la prueba.
13. Identificadores en inglés; mensajes al usuario en español con acentuación correcta.
14. Sin archivos .env, node_modules ni vendor en el historial.
15. Versiones de Vite y PHPUnit registradas según los archivos de bloqueo.
16. PDF del acta anonimizado adjunto en la carpeta de entrega.
17. README inicia con la frase exigida por el acta.
18. Documentación de Bourgelat entregada y verificada contra la rúbrica.
