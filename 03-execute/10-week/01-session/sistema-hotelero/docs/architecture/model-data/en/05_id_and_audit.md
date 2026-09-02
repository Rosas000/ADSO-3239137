# Hotel system — Common identifier and audit fields

## 1. Common identifier

Every system entity should include an `id` field as the unique record identifier.

### Common field

```text
id
```

### Purpose

The `id` field uniquely identifies each record inside a table. It also supports relationships between entities through foreign keys.

### Recommendation for MySQL

For MySQL, a common implementation can be:

```sql
id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY
```

`CHAR(36)` or `BINARY(16)` can also be used for UUID, but that decision depends on scalability, integration, and traceability requirements.

## 2. Common audit fields

Audit fields allow the system to know who created, updated, or logically deleted a record, and when each action happened.

### Recommended fields

```text
created_by
created_at
updated_by
updated_at
deleted_by
deleted_at
status
```

## 3. Field description

| Field | Purpose |
|---|---|
| `created_by` | Identifies the user who created the record. |
| `created_at` | Stores the creation date and time of the record. |
| `updated_by` | Identifies the last user who modified the record. |
| `updated_at` | Stores the date and time of the last modification. |
| `deleted_by` | Identifies the user who performed logical deletion. |
| `deleted_at` | Stores the date and time of logical deletion. |
| `status` | Indicates the functional status of the record, such as active or inactive. |

## 4. Expected use

These fields should be present in all system entities to guarantee traceability, operational control, and basic auditability.

Logical deletion through `deleted_at` and `deleted_by` allows the system to keep history without physically removing information. This is important for modules such as booking, invoice, payment, maintenance, inventory, and security.

## 5. Base recommendation for MySQL

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

## 6. Pending confirmation

Pending:

- Final `id` type: `BIGINT`, `UUID`, `CHAR(36)`, or `BINARY(16)`.
- Official `status` values.
- Whether `created_by`, `updated_by`, and `deleted_by` will point to `user.id`.
- Physical deletion or logical deletion policy.
