## 1) Reglas y descripciones bien documentadas

### Regla 1. PK y auditoría comunes
Todas las entidades comparten implícitamente:

```text
id, status, created_by, created_at, updated_by, updated_at, deleted_by, deleted_at
```

Por tanto, en el modelo del punto 4 **no se repiten**; allí solo se muestran los atributos **core**.

### Regla 2. Convención de llaves foráneas
Toda llave foránea debe nombrarse con el patrón:

```text
entity_id
```

Ejemplos:

```text
person_id, role_id, module_id, country_id, city_id, customer_id, product_id, order_id
```

### Regla 3. Convención de nombres de atributos descriptivos
Cuando aplique, preferir atributos estándar y limpios:

```text
code, name, description
```

Evitar redundancias como:

```text
name_product, name_role, description_category
```

### Regla 4. Relaciones N:M
Toda relación muchos a muchos debe resolverse mediante entidad intermedia.

Ejemplos:

```text
user_role, role_module, module_view, supplier_product
```

### Regla 5. Separación por dominio
Las entidades se organizan por dominio funcional:

- `Security`: acceso, autenticación y autorización.
- `Location`: jerarquía geográfica y direcciones.
- `Parameter`: catálogos transversales.
- `Billing`: carrito, orden, factura, pago y envío.
- `Inventory`: catálogo comercial e inventario.
- `Customer`: información del cliente.
- `Supplier`: información del proveedor.

### Regla 6. Direcciones desacopladas
Las direcciones no deben incrustarse directamente en `customer` ni en `supplier`; deben manejarse por entidades de relación para soportar múltiples direcciones.

### Regla 7. Inventario separado del catálogo
`product` define el producto; `stock` controla existencias; `inventory_movement` registra trazabilidad operativa.

### Regla 8. Flujo mínimo de compra
El flujo funcional mínimo recomendado es:

```text
customer -> cart -> cart_item -> order -> order_item -> payment / invoice / shipment
```
