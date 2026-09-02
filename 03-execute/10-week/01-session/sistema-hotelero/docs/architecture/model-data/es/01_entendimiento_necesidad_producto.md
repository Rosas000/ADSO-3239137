# Sistema de hotelería — Entendimiento de la necesidad del producto

## 1. Visión general

El sistema de hotelería busca centralizar la operación de un hotel o cadena de sedes hoteleras, integrando la gestión de habitaciones, reservas, estadías, ventas internas, facturación, inventario, notificaciones, seguridad y mantenimiento.

Desde la perspectiva del negocio, la necesidad principal es contar con una plataforma que permita controlar el ciclo completo del servicio hotelero: desde la consulta de disponibilidad de una habitación, la creación de una reserva, el ingreso del cliente, el consumo de productos o servicios durante la estadía, hasta el cierre mediante check out y facturación.

El producto debe ayudar a reducir procesos manuales, mejorar la trazabilidad de pagos, controlar el estado real de cada habitación, administrar precios dinámicos y facilitar la toma de decisiones mediante información operativa confiable.

## 2. Necesidad del cliente

El cliente requiere un sistema que le permita operar el negocio hotelero de forma ordenada, con información centralizada y disponible para los diferentes roles de la organización.

Las principales necesidades identificadas son:

- Controlar la información base del hotel, cliente, empleado, método de pago, tipo de día, precio dinámico e información legal.
- Administrar la distribución física del negocio: sede, habitación, tipo de habitación y estado de habitación.
- Gestionar el proceso principal del negocio: reserva, disponibilidad, check in, check out y secuencia de estadía.
- Registrar consumos adicionales realizados durante la estadía, como producto y servicio.
- Llevar el control de pre facturación, pagos parciales, factura y detalle de compra.
- Administrar inventario, proveedor, disponibilidad y seguimiento de producto o servicio.
- Enviar notificación asociada a promoción, alerta, términos y condición, y fidelización de cliente.
- Controlar acceso al sistema mediante usuario, persona, rol, permiso, módulo y vista.
- Gestionar mantenimiento de habitación por uso, remodelación o indisponibilidad operacional.

## 3. Módulo de parametrización

El módulo de parametrización representa la base administrativa del sistema. Permite configurar los datos que soportan la operación diaria del hotel.

En este módulo se administra la información del cliente, empleado, empresa hotelera, información legal, método de pago, tipo de día y precio. Esta configuración es necesaria para que los demás módulos funcionen correctamente.

Uno de los elementos más relevantes es el manejo de precio dinámico, ya que el valor de una habitación o servicio puede cambiar dependiendo de la temporada, feriado, día entre semana, evento especial o regla comercial definida por el negocio.

## 4. Módulo de distribución

El módulo de distribución permite representar la estructura física y comercial del hotel.

Aquí se administran las sede, habitación, tipo de habitación y estado de habitación. Esta información es clave para consultar disponibilidad, asignar reservas, bloquear habitaciones por mantenimiento y ofrecer un catálogo claro al cliente.

El estado de habitación debe reflejar si una habitación está disponible, ocupada, reservada, en limpieza, bloqueada o en mantenimiento, según las reglas que defina el negocio.

## 5. Módulo de prestación de servicio

Este módulo corresponde al core del negocio. Centraliza la reserva de habitación, la cancelación, la disponibilidad, el catálogo de habitación, el check in, el check out y la secuencia de estadía.

La secuencia de estadía permite registrar lo que ocurre durante el tiempo en que el cliente ocupa una habitación. Dentro de esta secuencia se pueden asociar ventas de producto y ventas de servicio, las cuales posteriormente impactan la pre facturación y la factura.

Este módulo debe permitir conocer en todo momento qué cliente está hospedado, en qué habitación, desde cuándo, hasta cuándo, qué consumos ha realizado y cuál es el estado actual de la estadía.

## 6. Módulo de facturación

El módulo de facturación permite consolidar los valores generados por reserva, estadía, producto y servicio.

Debe soportar pre facturación, seguimiento de pago parcial, factura y detalle de compra de producto o servicio. Esto permite que el negocio pueda manejar reservas con abonos, pagos parciales, saldos pendientes y liquidación final al momento del check out.

La pre factura sirve como vista anticipada de los valores acumulados antes de emitir la factura definitiva.

## 7. Módulo de inventario

El módulo de inventario permite controlar producto y servicio ofrecido por el hotel, así como proveedor, seguimiento y disponibilidad.

Este módulo es necesario para evitar ventas de productos no disponibles, controlar existencias, registrar movimientos y facilitar el abastecimiento.

También puede apoyar la venta de servicios internos del hotel, aunque algunos servicios no tengan existencia física como ocurre con los productos.

## 8. Módulo de notificación

El módulo de notificación permite comunicar información relevante al cliente.

Puede utilizarse para promoción, alerta, términos y condición antes de comprar producto o servicio, y fidelización de cliente.

Este módulo ayuda a mejorar la experiencia del cliente, comunicar reglas comerciales, prevenir conflictos por condiciones de compra y fortalecer la relación posterior a la estadía.

## 9. Módulo de seguridad

El módulo de seguridad permite controlar el acceso al sistema.

Debe administrar persona, usuario, rol, permiso, módulo y vista. Su propósito es garantizar que cada usuario acceda únicamente a las funcionalidades que correspondan con su responsabilidad dentro del hotel.

Por ejemplo, un empleado de recepción podría gestionar reserva y check in, mientras que un administrador podría acceder a parametrización, facturación, inventario y mantenimiento.

## 10. Módulo de mantenimiento

El módulo de mantenimiento permite controlar la disponibilidad operativa de las habitaciones.

Debe registrar mantenimiento por uso, mantenimiento por remodelación y seguimiento del estado de cada habitación. También debe alimentar un dashboard de disponibilidad, mantenimiento y seguimiento.

Este módulo es crítico porque una habitación con mantenimiento activo no debe ofrecerse como disponible para reserva o check in.

## 11. Core del negocio

El core del sistema se concentra en la prestación del servicio hotelero.

El flujo principal puede entenderse así:

1. El cliente consulta catálogo y disponibilidad de habitación.
2. El sistema calcula precio según tipo de habitación, tipo de día y regla dinámica de precio.
3. El cliente realiza reserva.
4. El sistema permite registrar pago parcial si aplica.
5. Al llegar al hotel, se realiza check in.
6. Durante la estadía, se registran consumo de producto y servicio.
7. Al finalizar, se realiza check out.
8. El sistema genera pre factura y factura definitiva.
9. La habitación cambia de estado para limpieza, disponibilidad o mantenimiento.

## 12. Resultado esperado del producto

El producto debe permitir que el hotel opere de manera trazable, controlada y escalable.

El valor principal para el cliente está en tener una plataforma que conecte la disponibilidad real de habitaciones con reservas, pagos, facturación, inventario y mantenimiento. Esto reduce errores operativos y mejora la experiencia del cliente final.

## 13. Pendiente por confirmar

Pendiente:

- Reglas exactas para cálculo de precio dinámico.
- Estados oficiales de reserva, habitación, factura y pago.
- Flujo real de cancelación de reserva.
- Política de devolución o penalidad por cancelación.
- Tipos de servicio que venderá el hotel.
- Canales de notificación requeridos.
- Roles reales del sistema.
