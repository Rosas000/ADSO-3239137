## Parametrizar clientes  
Definir y registrar la información básica y complementaria de los clientes para su correcta identificación y gestión dentro del sistema.

- Nombre completo  
- Tipo de documento  
- Documento  
- Teléfono  
- Tipo de sangre  
- Otros campos esenciales (no obligatorios, pero recomendados para trazabilidad y contacto)

---

## Parametrizar atractivos  
Corresponde a la configuración de los lugares turísticos ofrecidos por la empresa.

- Nombre  
- Precio  
- Descripción  
- Lugar  
- Nivel de dificultad  
- Precondiciones (edad mínima, condiciones físicas, restricciones, etc.)  
- Fotos  

---

## Parametrizar alimentación  
Corresponde a los restaurantes o lugares de comida disponibles.

- Solo se ofrece el menú del día.
- Se deben parametrizar los platos disponibles por restaurante.
- Si el cliente solicita un plato diferente al ofertado en el plan, se le devuelve el valor correspondiente al menú incluido, y el cliente asume el pago adicional directamente en el establecimiento.

- Restaurante  
  - Parametrizar los platos de cada restaurante:
    - Nombre  
    - Precio  

---

## Parametrizar transportes por atractivos  
- Para cualquier atractivo, el valor del trayecto es de $15.000.  
- La cantidad de trayectos será calculada manualmente por el recepcionista, ya que actualmente no existe dependencia directa entre transporte y atractivo.  

---

# Paso 1: Configuración de reserva  

Para realizar una reserva es obligatorio contar con atractivos, alimentación y transporte previamente parametrizados.

La reserva corresponde a la proyección de servicios, no a la materialización inmediata de los mismos. Esta permite tramitar información hacia logística, donde se llevará el control de los servicios adquiridos por uno o varios clientes.

- Puede existir relación:
  - 1 Cliente – N servicios  
  - 1 Servicio – N Clientes  

No todos los servicios proyectados necesariamente serán ejecutados. Por tanto, el valor total proyectado no siempre será el valor facturable final.

### Causísticas del sistema
- Limitaciones de tiempo.  
- Condiciones de salud del cliente.  
- Otras novedades operativas.  

El sistema deberá:
- Contabilizar únicamente los servicios efectivamente prestados.
- Permitir seguimiento en dashboard de los servicios pendientes.

### Descuentos
- El recepcionista puede aplicar descuentos manuales:
  - Por porcentaje.
  - Por valor fijo.
- El sistema debe persistir:
  - Valor proyectado.
  - Valor final con descuento.
- Los descuentos deben asociarse al tipo de producto:
  - Atractivo.
  - Transporte.
  - Alimentación.
- Cada descuento debe incluir una descripción del concepto aplicado (ejemplo: promoción temporada baja, cortesía comercial, ajuste operativo).

Todos los cálculos deben provenir obligatoriamente de los datos previamente parametrizados.

### Datos de reporte de la reserva
- N° de reserva  
- Nombre del turista  
- Cantidad de personas  
- Fecha  
- Atractivo  
- Alimentación  
- Hospedaje  
- Transporte  
- Total  

La reserva, una vez confirmada, no debe permitir modificaciones. Debe conservar los valores tal como fueron proyectados.

---

# Paso 2: Control de ejecución de servicios  

Este módulo toma los datos del Paso 1 y gestiona la ejecución real de los servicios proyectados.

Su responsabilidad es:
- Marcar qué servicios han sido prestados.
- Llevar control de cumplimiento frente a la reserva original.

### Causísticas
Este módulo permite:
- Agregar, modificar o eliminar servicios únicamente cuando:
  - Al menos un servicio ya haya sido ejecutado.
- También se habilita modificación cuando:
  - El cliente no ha tomado ningún servicio, pero realiza una primera transacción (anticipo o pago parcial).

---

# Paso 3: Control de ejecución operativa  

Este módulo está intrínsecamente asociado al Paso 2.  
Solo puede activarse cuando ya exista un control de ejecución de servicios iniciado.

### Causísticas
- Depende estrictamente de los módulos parametrizados.
- Se activa únicamente cuando inicia la prestación de servicios.

Cada atractivo genera un costo operacional independiente.  
Este costo:
- No corresponde al precio de venta del atractivo.
- No está relacionado con alimentación o transporte.
- Representa un gasto interno de la empresa.

---

# Paso 4: Facturación y flujo de caja  

Este módulo gestiona la relación entre ingresos y egresos operacionales.

- No corresponde a facturación electrónica ni integración con DIAN.
- Su objetivo es controlar:
  - Flujo de caja entrante (Pasos 1 y 2).
  - Flujo de caja saliente (Paso 3).

Permite visualizar la trazabilidad financiera completa entre reservas, ejecución de servicios y costos operativos.