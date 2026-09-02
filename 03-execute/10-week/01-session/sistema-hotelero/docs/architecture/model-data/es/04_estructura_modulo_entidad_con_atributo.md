# Sistema de hotelería — Estructura por módulo, entidad y atributo

> Nota: no se incluyen `id` ni campos de auditoría, porque se explican en el archivo `05_id_y_auditoria.md`.

## 1. Parametrización

### cliente
{tipo_documento, numero_documento, nombre, apellido, telefono, correo, direccion}

### precio
{tipo_habitacion_id, tipo_dia_id, valor, fecha_inicio, fecha_fin, condicion}

### empresa
{nombre, nit, razon_social, telefono, correo, direccion, sitio_web}

### informacion_legal
{empresa_id, tipo_documento_legal, numero_documento_legal, descripcion, fecha_expedicion, fecha_vencimiento}

### empleado
{persona_id, cargo, fecha_ingreso, telefono_laboral, correo_laboral}

### tipo_dia
{nombre, descripcion, fecha, aplica_temporada, aplica_feriado, aplica_especial}

### metodo_pago
{nombre, descripcion, requiere_referencia, permite_pago_parcial}

## 2. Distribución

### sede
{empresa_id, nombre, direccion, ciudad, telefono, correo}

### habitacion
{sede_id, tipo_habitacion_id, estado_habitacion_id, numero, piso, capacidad, descripcion}

### tipo_habitacion
{nombre, descripcion, capacidad_base, capacidad_maxima}

### estado_habitacion
{nombre, descripcion, permite_reserva, permite_check_in}

## 3. Prestación de servicio

### reserva_habitacion
{cliente_id, habitacion_id, fecha_inicio, fecha_fin, cantidad_persona, estado_reserva, valor_estimado}

### cancelacion_habitacion
{reserva_habitacion_id, motivo, fecha_cancelacion, aplica_penalidad, valor_penalidad}

### disponibilidad_habitacion
{habitacion_id, fecha_inicio, fecha_fin, disponible, motivo_no_disponible}

### catalogo_habitacion
{habitacion_id, titulo, descripcion, precio_base, visible}

### check_in
{reserva_habitacion_id, empleado_id, fecha_hora_ingreso, observacion}

### check_out
{estadia_id, empleado_id, fecha_hora_salida, observacion, valor_total}

### estadia
{reserva_habitacion_id, cliente_id, habitacion_id, fecha_inicio, fecha_fin, estado_estadia}

### venta_producto
{estadia_id, producto_id, cantidad, valor_unitario, valor_total}

### venta_servicio
{estadia_id, servicio_id, cantidad, valor_unitario, valor_total}

## 4. Facturación

### pre_factura
{estadia_id, reserva_habitacion_id, cliente_id, subtotal, impuesto, descuento, total}

### pago_parcial
{reserva_habitacion_id, factura_id, metodo_pago_id, valor, fecha_pago, referencia_pago}

### factura
{cliente_id, estadia_id, numero_factura, fecha_emision, subtotal, impuesto, descuento, total, estado_factura}

### detalle_compra
{factura_id, producto_id, servicio_id, descripcion, cantidad, valor_unitario, valor_total}

## 5. Inventario

### producto
{proveedor_id, nombre, descripcion, valor_venta, stock_actual, stock_minimo}

### servicio
{nombre, descripcion, valor_venta, disponible}

### proveedor
{nombre, nit, telefono, correo, direccion}

### seguimiento_producto
{producto_id, tipo_movimiento, cantidad, fecha_movimiento, observacion}

### disponibilidad_inventario
{producto_id, servicio_id, cantidad_disponible, disponible, observacion}

## 6. Notificación

### promocion
{titulo, descripcion, fecha_inicio, fecha_fin, canal, activa}

### alerta
{cliente_id, reserva_habitacion_id, titulo, mensaje, canal, fecha_envio}

### termino_condicion
{titulo, contenido, version, fecha_vigencia, obligatorio}

### fidelizacion_cliente
{cliente_id, nivel, puntos, fecha_ultima_interaccion, observacion}

## 7. Seguridad

### persona
{tipo_documento, numero_documento, nombre, apellido, telefono, correo}

### usuario
{persona_id, username, password_hash, ultimo_acceso, bloqueado}

### rol
{nombre, descripcion}

### permiso
{nombre, descripcion, accion}

### modulo
{nombre, descripcion, ruta_base}

### vista
{modulo_id, nombre, descripcion, ruta}

### usuario_rol
{usuario_id, rol_id}

### rol_permiso
{rol_id, permiso_id}

### modulo_vista
{modulo_id, vista_id}

## 8. Mantenimiento

### mantenimiento_habitacion
{habitacion_id, empleado_id, tipo_mantenimiento, fecha_inicio, fecha_fin, estado_mantenimiento, observacion}

### mantenimiento_uso
{mantenimiento_habitacion_id, motivo_uso, detalle_actividad}

### mantenimiento_remodelacion
{mantenimiento_habitacion_id, descripcion_remodelacion, presupuesto_estimado}

### dashboard_mantenimiento
{sede_id, total_habitacion, habitacion_disponible, habitacion_ocupada, habitacion_mantenimiento, fecha_corte}
