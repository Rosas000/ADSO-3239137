# Sistema de hotelería — Identificador y campos de auditoría comunes

## 1. Identificador común

Todas las entidades del sistema deberían contar con un campo `id` como identificador único de registro.

### Campo común

```text
id
```

### Propósito

El campo `id` permite identificar de forma única cada registro dentro de una tabla. También facilita la creación de relaciones entre entidades mediante llaves foráneas.

### Recomendación para MySQL

Para MySQL, una implementación común puede ser:

```sql
id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY
```

También puede usarse `CHAR(36)` o `BINARY(16)` para UUID, pero esa decisión depende de los requerimientos de escalabilidad, integración y trazabilidad del producto.

## 2. Campos de auditoría comunes

Los campos de auditoría permiten conocer quién creó, actualizó o eliminó lógicamente un registro, y en qué momento ocurrió cada acción.

### Campos recomendados

```text
created_by
created_at
updated_by
updated_at
deleted_by
deleted_at
status
```

## 3. Descripción de campos

| Campo | Propósito |
|---|---|
| `created_by` | Identifica el usuario que creó el registro. |
| `created_at` | Guarda la fecha y hora de creación del registro. |
| `updated_by` | Identifica el último usuario que modificó el registro. |
| `updated_at` | Guarda la fecha y hora de la última modificación. |
| `deleted_by` | Identifica el usuario que realizó eliminación lógica. |
| `deleted_at` | Guarda la fecha y hora de eliminación lógica. |
| `status` | Indica el estado funcional del registro, por ejemplo activo o inactivo. |

## 4. Uso esperado

Estos campos deberían estar presentes en todas las entidades del sistema para garantizar trazabilidad, control operativo y auditoría básica.

La eliminación lógica mediante `deleted_at` y `deleted_by` permite conservar historial sin borrar físicamente la información. Esto es importante para módulos como reserva, factura, pago, mantenimiento, inventario y seguridad.

## 5. Recomendación base para MySQL

```sql
id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
created_by BIGINT UNSIGNED NULL,
created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
updated_by BIGINT UNSIGNED NULL,
updated_at DATETIME NULL ON UPDATE CURRENT_TIMESTAMP,
deleted_by BIGINT UNSIGNED NULL,
deleted_at DATETIME NULL,
status VARCHAR(30) NOT NULL DEFAULT 'ACTIVE'
```

## 6. Pendiente por confirmar

Pendiente:

- Tipo definitivo de `id`: `BIGINT`, `UUID`, `CHAR(36)` o `BINARY(16)`.
- Valores oficiales de `status`.
- Si `created_by`, `updated_by` y `deleted_by` apuntarán a `usuario.id`.
- Política de eliminación física o eliminación lógica.
