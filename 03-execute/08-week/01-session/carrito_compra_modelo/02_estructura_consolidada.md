## 2) Estructura consolidada recomendada

```text
Base de datos para carrito de compra
---------
Domain:

    Security
        person
        role
        user_account
        module
        app_view
        user_role
        role_module
        module_view

    Location
        continent
        country
        department
        city
        address

    Parameter
        type_document
        file
        status
        payment_method
        order_status
        payment_status
        shipment_status

    Billing
        cart
        cart_item
        order
        order_item
        invoice
        payment
        shipment

    Inventory
        category
        product
        product_image
        brand
        stock
        inventory_movement

    Customer
        customer
        customer_address

    Supplier
        supplier
        supplier_address
        supplier_product
```
