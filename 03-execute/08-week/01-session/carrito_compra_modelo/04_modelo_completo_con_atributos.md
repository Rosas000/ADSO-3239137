## 4) Modelo completo con atributos

```text
Base de datos para carrito de compra
---------
Domain:

    Security
        person {type_document_id, document_number, first_name, middle_name, last_name, second_last_name, email, phone, birth_date}
        role {code, name, description}
        user_account {person_id, username, password_hash, last_login_at}
        module {code, name, description, route, icon, order_index}
        app_view {module_id, code, name, description, route, order_index}
        user_role {user_account_id, role_id, start_date, end_date}
        role_module {role_id, module_id}
        module_view {module_id, app_view_id}

    Location
        continent {code, name, description}
        country {continent_id, code, name, description, iso_code, phone_code}
        department {country_id, code, name, description}
        city {department_id, code, name, description, postal_code}
        address {city_id, line_1, line_2, reference, zip_code, latitude, longitude}

    Parameter
        type_document {code, name, description}
        file {code, name, description, file_name, file_path, file_extension, mime_type, size}
        status {code, name, description, domain_name}
        payment_method {code, name, description}
        order_status {code, name, description}
        payment_status {code, name, description}
        shipment_status {code, name, description}

    Billing
        cart {customer_id, opened_at, closed_at, total_amount, total_items}
        cart_item {cart_id, product_id, quantity, unit_price, subtotal}
        order {customer_id, order_status_id, billing_address_id, shipping_address_id, order_number, order_date, subtotal, tax_amount, discount_amount, shipping_amount, total_amount, note}
        order_item {order_id, product_id, quantity, unit_price, tax_amount, discount_amount, subtotal, total_amount}
        invoice {order_id, invoice_number, issue_date, subtotal, tax_amount, total_amount}
        payment {order_id, payment_method_id, payment_status_id, payment_date, reference_number, amount, authorization_code, transaction_number}
        shipment {order_id, shipment_status_id, address_id, shipment_date, delivered_date, tracking_number, carrier_name, shipping_cost}

    Inventory
        category {code, name, description, parent_category_id}
        product {category_id, brand_id, code, name, description, sku, barcode, price, cost, weight}
        product_image {product_id, file_id, url, is_main, order_index}
        brand {code, name, description}
        stock {product_id, quantity_available, quantity_reserved, reorder_level, max_stock, min_stock}
        inventory_movement {product_id, movement_type, quantity, unit_cost, reference_type, reference_id, movement_date, note}

    Customer
        customer {person_id, customer_code, loyalty_points}
        customer_address {customer_id, address_id, is_default, address_type}

    Supplier
        supplier {person_id, supplier_code, contact_name, contact_email, contact_phone}
        supplier_address {supplier_id, address_id, is_default, address_type}
        supplier_product {supplier_id, product_id, supplier_product_code, purchase_price, lead_time_days, is_primary}
```
