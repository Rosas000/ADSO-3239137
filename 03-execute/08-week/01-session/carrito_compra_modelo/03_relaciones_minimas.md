## 3) Relaciones mínimas recomendadas

### Security

```text
person 1 --- 1 user_account
user_account N --- M role           => user_role
role N --- M module                 => role_module
module N --- M app_view             => module_view
```

### Location

```text
continent 1 --- N country
country 1 --- N department
department 1 --- N city
city 1 --- N address
```

### Parameter

```text
type_document 1 --- N person
payment_method 1 --- N payment
order_status 1 --- N order
payment_status 1 --- N payment
shipment_status 1 --- N shipment
file 1 --- N product_image
```

### Customer

```text
person 1 --- 1 customer
customer 1 --- N customer_address
address 1 --- N customer_address
```

### Supplier

```text
person 1 --- 1 supplier
supplier 1 --- N supplier_address
address 1 --- N supplier_address
supplier N --- M product            => supplier_product
```

### Inventory

```text
category 1 --- N product
brand 1 --- N product
product 1 --- N product_image
product 1 --- 1 stock
product 1 --- N inventory_movement
```

### Billing

```text
customer 1 --- N cart
cart 1 --- N cart_item
product 1 --- N cart_item

customer 1 --- N order
order 1 --- N order_item
product 1 --- N order_item

order 1 --- N payment
order 1 --- 0..1 invoice
order 1 --- 0..N shipment
payment_method 1 --- N payment
order_status 1 --- N order
payment_status 1 --- N payment
shipment_status 1 --- N shipment
```
