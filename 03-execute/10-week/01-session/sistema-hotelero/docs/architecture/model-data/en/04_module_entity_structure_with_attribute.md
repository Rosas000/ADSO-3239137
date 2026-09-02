# Hotel system — Module, entity, and attribute structure

> Note: `id` and audit fields are not included because they are explained in `05_id_and_audit.md`.

## 1. Parameterization

### customer
{document_type, document_number, first_name, last_name, phone, email, address}

### price
{room_type_id, day_type_id, amount, start_date, end_date, condition}

### company
{name, tax_number, legal_name, phone, email, address, website}

### legal_information
{company_id, legal_document_type, legal_document_number, description, issue_date, expiration_date}

### employee
{person_id, position, hire_date, work_phone, work_email}

### day_type
{name, description, date, applies_season, applies_holiday, applies_special}

### payment_method
{name, description, requires_reference, allows_partial_payment}

## 2. Distribution

### branch
{company_id, name, address, city, phone, email}

### room
{branch_id, room_type_id, room_status_id, number, floor, capacity, description}

### room_type
{name, description, base_capacity, maximum_capacity}

### room_status
{name, description, allows_booking, allows_check_in}

## 3. Service delivery

### room_booking
{customer_id, room_id, start_date, end_date, guest_quantity, booking_status, estimated_amount}

### room_cancellation
{room_booking_id, reason, cancellation_date, applies_penalty, penalty_amount}

### room_availability
{room_id, start_date, end_date, available, unavailable_reason}

### room_catalog
{room_id, title, description, base_price, visible}

### check_in
{room_booking_id, employee_id, check_in_datetime, observation}

### check_out
{stay_id, employee_id, check_out_datetime, observation, total_amount}

### stay
{room_booking_id, customer_id, room_id, start_date, end_date, stay_status}

### product_sale
{stay_id, product_id, quantity, unit_price, total_amount}

### service_sale
{stay_id, service_id, quantity, unit_price, total_amount}

## 4. Billing

### pre_invoice
{stay_id, room_booking_id, customer_id, subtotal, tax, discount, total}

### partial_payment
{room_booking_id, invoice_id, payment_method_id, amount, payment_date, payment_reference}

### invoice
{customer_id, stay_id, invoice_number, issue_date, subtotal, tax, discount, total, invoice_status}

### purchase_detail
{invoice_id, product_id, service_id, description, quantity, unit_price, total_amount}

## 5. Inventory

### product
{supplier_id, name, description, sale_price, current_stock, minimum_stock}

### service
{name, description, sale_price, available}

### supplier
{name, tax_number, phone, email, address}

### product_tracking
{product_id, movement_type, quantity, movement_date, observation}

### inventory_availability
{product_id, service_id, available_quantity, available, observation}

## 6. Notification

### promotion
{title, description, start_date, end_date, channel, active}

### alert
{customer_id, room_booking_id, title, message, channel, sent_date}

### term_condition
{title, content, version, effective_date, required}

### customer_loyalty
{customer_id, level, points, last_interaction_date, observation}

## 7. Security

### person
{document_type, document_number, first_name, last_name, phone, email}

### user
{person_id, username, password_hash, last_access, blocked}

### role
{name, description}

### permission
{name, description, action}

### module
{name, description, base_route}

### view
{module_id, name, description, route}

### user_role
{user_id, role_id}

### role_permission
{role_id, permission_id}

### module_view
{module_id, view_id}

## 8. Maintenance

### room_maintenance
{room_id, employee_id, maintenance_type, start_date, end_date, maintenance_status, observation}

### use_maintenance
{room_maintenance_id, use_reason, activity_detail}

### remodeling_maintenance
{room_maintenance_id, remodeling_description, estimated_budget}

### maintenance_dashboard
{branch_id, total_room, available_room, occupied_room, maintenance_room, cutoff_date}
