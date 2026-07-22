DROP DATABASE IF EXISTS hotel_system;
CREATE DATABASE hotel_system CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE hotel_system;
SET FOREIGN_KEY_CHECKS = 0;
 
 
-- ============================================================
--  MÓDULO 1 · SEGURIDAD
-- ============================================================
 
CREATE TABLE person (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    document_type   VARCHAR(20)  NOT NULL,
    document_number VARCHAR(30)  NOT NULL,
    first_name      VARCHAR(80)  NOT NULL,
    last_name       VARCHAR(80)  NOT NULL,
    phone           VARCHAR(20),
    email           VARCHAR(120),
    created_at      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME     ON UPDATE CURRENT_TIMESTAMP,
    status          VARCHAR(20)  NOT NULL DEFAULT 'ACTIVE',
    UNIQUE KEY uq_person (document_type, document_number)
) ENGINE = InnoDB;
 
CREATE TABLE role (
    id          BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(60)  NOT NULL UNIQUE,
    description TEXT,
    created_at  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status      VARCHAR(20)  NOT NULL DEFAULT 'ACTIVE'
) ENGINE = InnoDB;
 
CREATE TABLE user_account (
    id            BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    person_id     BIGINT UNSIGNED NOT NULL,
    username      VARCHAR(60)  NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    last_access   DATETIME,
    blocked       TINYINT(1)   NOT NULL DEFAULT 0,
    created_at    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at    DATETIME     ON UPDATE CURRENT_TIMESTAMP,
    status        VARCHAR(20)  NOT NULL DEFAULT 'ACTIVE',
    CONSTRAINT fk_user_person FOREIGN KEY (person_id) REFERENCES person (id) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE = InnoDB;
 
CREATE TABLE permission (
    id          BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(80)  NOT NULL UNIQUE,
    action      VARCHAR(30)  NOT NULL,
    description TEXT,
    status      VARCHAR(20)  NOT NULL DEFAULT 'ACTIVE'
) ENGINE = InnoDB;
 
CREATE TABLE module (
    id          BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(80)  NOT NULL UNIQUE,
    base_route  VARCHAR(120) NOT NULL,
    description TEXT,
    status      VARCHAR(20)  NOT NULL DEFAULT 'ACTIVE'
) ENGINE = InnoDB;
 
CREATE TABLE app_view (
    id        BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    module_id BIGINT UNSIGNED NOT NULL,
    name      VARCHAR(80)  NOT NULL,
    route     VARCHAR(120) NOT NULL,
    status    VARCHAR(20)  NOT NULL DEFAULT 'ACTIVE',
    CONSTRAINT fk_view_module FOREIGN KEY (module_id) REFERENCES module (id) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE = InnoDB;
 
CREATE TABLE user_role (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_account_id BIGINT UNSIGNED NOT NULL,
    role_id         BIGINT UNSIGNED NOT NULL,
    created_at      DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status          VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    UNIQUE KEY uq_user_role (user_account_id, role_id),
    CONSTRAINT fk_ur_account FOREIGN KEY (user_account_id) REFERENCES user_account (id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_ur_role    FOREIGN KEY (role_id)         REFERENCES role          (id) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE = InnoDB;
 
CREATE TABLE role_permission (
    id            BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    role_id       BIGINT UNSIGNED NOT NULL,
    permission_id BIGINT UNSIGNED NOT NULL,
    status        VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    UNIQUE KEY uq_role_perm (role_id, permission_id),
    CONSTRAINT fk_rp_role FOREIGN KEY (role_id)       REFERENCES role       (id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_rp_perm FOREIGN KEY (permission_id) REFERENCES permission (id) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE = InnoDB;
 
CREATE TABLE module_view (
    id          BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    module_id   BIGINT UNSIGNED NOT NULL,
    app_view_id BIGINT UNSIGNED NOT NULL,
    status      VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    UNIQUE KEY uq_module_view (module_id, app_view_id),
    CONSTRAINT fk_mv_module   FOREIGN KEY (module_id)   REFERENCES module   (id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_mv_app_view FOREIGN KEY (app_view_id) REFERENCES app_view (id) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE = InnoDB;
 
 
-- ============================================================
--  MÓDULO 2 · PARAMETRIZACIÓN
-- ============================================================
 
CREATE TABLE company (
    id         BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name       VARCHAR(120) NOT NULL,
    tax_number VARCHAR(30)  NOT NULL UNIQUE,
    legal_name VARCHAR(150) NOT NULL,
    phone      VARCHAR(20),
    email      VARCHAR(120),
    address    VARCHAR(200),
    website    VARCHAR(120),
    status     VARCHAR(20)  NOT NULL DEFAULT 'ACTIVE'
) ENGINE = InnoDB;
 
CREATE TABLE legal_information (
    id                    BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    company_id            BIGINT UNSIGNED NOT NULL,
    legal_document_type   VARCHAR(60) NOT NULL,
    legal_document_number VARCHAR(60) NOT NULL,
    description           TEXT,
    issue_date            DATE,
    expiration_date       DATE,
    status                VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    CONSTRAINT fk_legal_company FOREIGN KEY (company_id) REFERENCES company (id) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE = InnoDB;
 
CREATE TABLE customer (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    document_type   VARCHAR(20)  NOT NULL,
    document_number VARCHAR(30)  NOT NULL,
    first_name      VARCHAR(80)  NOT NULL,
    last_name       VARCHAR(80)  NOT NULL,
    phone           VARCHAR(20),
    email           VARCHAR(120),
    address         VARCHAR(200),
    created_at      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME     ON UPDATE CURRENT_TIMESTAMP,
    status          VARCHAR(20)  NOT NULL DEFAULT 'ACTIVE',
    UNIQUE KEY uq_customer (document_type, document_number)
) ENGINE = InnoDB;
 
CREATE TABLE employee (
    id         BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    person_id  BIGINT UNSIGNED NOT NULL,
    position   VARCHAR(80)  NOT NULL,
    hire_date  DATE         NOT NULL,
    work_phone VARCHAR(20),
    work_email VARCHAR(120),
    status     VARCHAR(20)  NOT NULL DEFAULT 'ACTIVE',
    CONSTRAINT fk_employee_person FOREIGN KEY (person_id) REFERENCES person (id) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE = InnoDB;
 
CREATE TABLE day_type (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name            VARCHAR(60) NOT NULL UNIQUE,
    description     TEXT,
    applies_season  TINYINT(1)  NOT NULL DEFAULT 0,
    applies_holiday TINYINT(1)  NOT NULL DEFAULT 0,
    applies_special TINYINT(1)  NOT NULL DEFAULT 0,
    status          VARCHAR(20) NOT NULL DEFAULT 'ACTIVE'
) ENGINE = InnoDB;
 
CREATE TABLE payment_method (
    id                     BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name                   VARCHAR(60) NOT NULL UNIQUE,
    description            TEXT,
    requires_reference     TINYINT(1)  NOT NULL DEFAULT 0,
    allows_partial_payment TINYINT(1)  NOT NULL DEFAULT 0,
    status                 VARCHAR(20) NOT NULL DEFAULT 'ACTIVE'
) ENGINE = InnoDB;
 
 
-- ============================================================
--  MÓDULO 3 · DISTRIBUCIÓN
-- ============================================================
 
CREATE TABLE room_type (
    id               BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name             VARCHAR(80) NOT NULL UNIQUE,
    description      TEXT,
    base_capacity    INT UNSIGNED NOT NULL DEFAULT 1,
    maximum_capacity INT UNSIGNED NOT NULL DEFAULT 2,
    status           VARCHAR(20) NOT NULL DEFAULT 'ACTIVE'
) ENGINE = InnoDB;
 
CREATE TABLE room_status (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name            VARCHAR(60) NOT NULL UNIQUE,
    description     TEXT,
    allows_booking  TINYINT(1)  NOT NULL DEFAULT 0,
    allows_check_in TINYINT(1)  NOT NULL DEFAULT 0,
    status          VARCHAR(20) NOT NULL DEFAULT 'ACTIVE'
) ENGINE = InnoDB;
 
CREATE TABLE branch (
    id         BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    company_id BIGINT UNSIGNED NOT NULL,
    name       VARCHAR(120) NOT NULL,
    address    VARCHAR(200) NOT NULL,
    city       VARCHAR(80)  NOT NULL,
    phone      VARCHAR(20),
    email      VARCHAR(120),
    status     VARCHAR(20)  NOT NULL DEFAULT 'ACTIVE',
    CONSTRAINT fk_branch_company FOREIGN KEY (company_id) REFERENCES company (id) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE = InnoDB;
 
CREATE TABLE room (
    id             BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    branch_id      BIGINT UNSIGNED NOT NULL,
    room_type_id   BIGINT UNSIGNED NOT NULL,
    room_status_id BIGINT UNSIGNED NOT NULL,
    number         VARCHAR(10)  NOT NULL,
    floor          SMALLINT     NOT NULL DEFAULT 1,
    capacity       SMALLINT     NOT NULL DEFAULT 1,
    description    TEXT,
    status         VARCHAR(20)  NOT NULL DEFAULT 'ACTIVE',
    UNIQUE KEY uq_room (branch_id, number),
    CONSTRAINT fk_room_branch  FOREIGN KEY (branch_id)      REFERENCES branch      (id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_room_type    FOREIGN KEY (room_type_id)   REFERENCES room_type   (id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_room_status  FOREIGN KEY (room_status_id) REFERENCES room_status (id) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE = InnoDB;
 
CREATE TABLE price (
    id             BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    room_type_id   BIGINT UNSIGNED NOT NULL,
    day_type_id    BIGINT UNSIGNED NOT NULL,
    amount         DECIMAL(12, 2) NOT NULL,
    start_date     DATE           NOT NULL,
    end_date       DATE           NOT NULL,
    condition_note VARCHAR(200),
    status         VARCHAR(20)    NOT NULL DEFAULT 'ACTIVE',
    CONSTRAINT fk_price_room_type FOREIGN KEY (room_type_id) REFERENCES room_type (id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_price_day_type  FOREIGN KEY (day_type_id)  REFERENCES day_type  (id) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE = InnoDB;
 
 
-- ============================================================
--  MÓDULO 4 · INVENTARIO
-- ============================================================
 
CREATE TABLE supplier (
    id         BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name       VARCHAR(120) NOT NULL,
    tax_number VARCHAR(30)  UNIQUE,
    phone      VARCHAR(20),
    email      VARCHAR(120),
    address    VARCHAR(200),
    status     VARCHAR(20)  NOT NULL DEFAULT 'ACTIVE'
) ENGINE = InnoDB;
 
CREATE TABLE product (
    id            BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    supplier_id   BIGINT UNSIGNED NOT NULL,
    name          VARCHAR(150)   NOT NULL,
    description   TEXT,
    sale_price    DECIMAL(12, 2) NOT NULL,
    current_stock INT UNSIGNED   NOT NULL DEFAULT 0,
    minimum_stock INT UNSIGNED   NOT NULL DEFAULT 0,
    status        VARCHAR(20)    NOT NULL DEFAULT 'ACTIVE',
    CONSTRAINT fk_product_supplier FOREIGN KEY (supplier_id) REFERENCES supplier (id) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE = InnoDB;
 
CREATE TABLE service (
    id          BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(150)   NOT NULL,
    description TEXT,
    sale_price  DECIMAL(12, 2) NOT NULL,
    available   TINYINT(1)     NOT NULL DEFAULT 1,
    status      VARCHAR(20)    NOT NULL DEFAULT 'ACTIVE'
) ENGINE = InnoDB;
 
CREATE TABLE product_tracking (
    id            BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    product_id    BIGINT UNSIGNED NOT NULL,
    movement_type VARCHAR(20)    NOT NULL,
    quantity      INT            NOT NULL,
    movement_date DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    observation   TEXT,
    CONSTRAINT fk_tracking_product FOREIGN KEY (product_id) REFERENCES product (id) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE = InnoDB;
 
 
-- ============================================================
--  MÓDULO 5 · PRESTACIÓN DE SERVICIO
-- ============================================================
 
CREATE TABLE room_availability (
    id         BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    room_id    BIGINT UNSIGNED NOT NULL,
    start_date DATE           NOT NULL,
    end_date   DATE           NOT NULL,
    status     VARCHAR(20)    NOT NULL DEFAULT 'ACTIVE',
    CONSTRAINT fk_avail_room FOREIGN KEY (room_id) REFERENCES room (id) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE = InnoDB;
 
CREATE TABLE room_booking (
    id               BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    customer_id      BIGINT UNSIGNED NOT NULL,
    room_id          BIGINT UNSIGNED NOT NULL,
    start_date       DATE           NOT NULL,
    end_date         DATE           NOT NULL,
    guest_quantity   SMALLINT       NOT NULL DEFAULT 1,
    booking_status   VARCHAR(30)    NOT NULL DEFAULT 'PENDING',
    estimated_amount DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    created_at       DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at       DATETIME       ON UPDATE CURRENT_TIMESTAMP,
    status           VARCHAR(20)    NOT NULL DEFAULT 'ACTIVE',
    CONSTRAINT fk_booking_customer FOREIGN KEY (customer_id) REFERENCES customer (id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_booking_room     FOREIGN KEY (room_id)     REFERENCES room     (id) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE = InnoDB;
 
CREATE TABLE room_cancellation (
    id                BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    room_booking_id   BIGINT UNSIGNED NOT NULL UNIQUE,
    reason            TEXT           NOT NULL,
    cancellation_date DATE           NOT NULL,
    applies_penalty   TINYINT(1)     NOT NULL DEFAULT 0,
    penalty_amount    DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    status            VARCHAR(20)    NOT NULL DEFAULT 'ACTIVE',
    CONSTRAINT fk_cancel_booking FOREIGN KEY (room_booking_id) REFERENCES room_booking (id) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE = InnoDB;
 
CREATE TABLE check_in (
    id                BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    room_booking_id   BIGINT UNSIGNED NOT NULL UNIQUE,
    employee_id       BIGINT UNSIGNED NOT NULL,
    check_in_datetime DATETIME        NOT NULL,
    observation       TEXT,
    status            VARCHAR(20)     NOT NULL DEFAULT 'ACTIVE',
    CONSTRAINT fk_checkin_booking  FOREIGN KEY (room_booking_id) REFERENCES room_booking (id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_checkin_employee FOREIGN KEY (employee_id)     REFERENCES employee     (id) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE = InnoDB;
 
CREATE TABLE stay (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    room_booking_id BIGINT UNSIGNED NOT NULL UNIQUE,
    customer_id     BIGINT UNSIGNED NOT NULL,
    room_id         BIGINT UNSIGNED NOT NULL,
    start_date      DATE            NOT NULL,
    end_date        DATE            NOT NULL,
    stay_status     VARCHAR(20)     NOT NULL DEFAULT 'ACTIVE',
    status          VARCHAR(20)     NOT NULL DEFAULT 'ACTIVE',
    CONSTRAINT fk_stay_booking  FOREIGN KEY (room_booking_id) REFERENCES room_booking (id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_stay_customer FOREIGN KEY (customer_id)     REFERENCES customer     (id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_stay_room     FOREIGN KEY (room_id)         REFERENCES room         (id) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE = InnoDB;
 
CREATE TABLE product_sale (
    id           BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    stay_id      BIGINT UNSIGNED NOT NULL,
    product_id   BIGINT UNSIGNED NOT NULL,
    quantity     INT UNSIGNED    NOT NULL DEFAULT 1,
    unit_price   DECIMAL(12, 2)  NOT NULL,
    total_amount DECIMAL(12, 2)  NOT NULL,
    created_at   DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status       VARCHAR(20)     NOT NULL DEFAULT 'ACTIVE',
    CONSTRAINT fk_ps_stay    FOREIGN KEY (stay_id)    REFERENCES stay    (id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_ps_product FOREIGN KEY (product_id) REFERENCES product (id) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE = InnoDB;
 
CREATE TABLE service_sale (
    id           BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    stay_id      BIGINT UNSIGNED NOT NULL,
    service_id   BIGINT UNSIGNED NOT NULL,
    quantity     INT UNSIGNED    NOT NULL DEFAULT 1,
    unit_price   DECIMAL(12, 2)  NOT NULL,
    total_amount DECIMAL(12, 2)  NOT NULL,
    created_at   DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status       VARCHAR(20)     NOT NULL DEFAULT 'ACTIVE',
    CONSTRAINT fk_ss_stay    FOREIGN KEY (stay_id)    REFERENCES stay    (id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_ss_service FOREIGN KEY (service_id) REFERENCES service (id) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE = InnoDB;
 
CREATE TABLE check_out (
    id                 BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    stay_id            BIGINT UNSIGNED NOT NULL UNIQUE,
    employee_id        BIGINT UNSIGNED NOT NULL,
    check_out_datetime DATETIME        NOT NULL,
    observation        TEXT,
    total_amount       DECIMAL(12, 2)  NOT NULL DEFAULT 0.00,
    status             VARCHAR(20)     NOT NULL DEFAULT 'ACTIVE',
    CONSTRAINT fk_checkout_stay     FOREIGN KEY (stay_id)     REFERENCES stay     (id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_checkout_employee FOREIGN KEY (employee_id) REFERENCES employee (id) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE = InnoDB;
 
 
-- ============================================================
--  MÓDULO 6 · FACTURACIÓN
-- ============================================================
 
CREATE TABLE pre_invoice (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    stay_id         BIGINT UNSIGNED NOT NULL,
    room_booking_id BIGINT UNSIGNED NOT NULL,
    customer_id     BIGINT UNSIGNED NOT NULL,
    subtotal        DECIMAL(12, 2)  NOT NULL DEFAULT 0.00,
    tax             DECIMAL(12, 2)  NOT NULL DEFAULT 0.00,
    discount        DECIMAL(12, 2)  NOT NULL DEFAULT 0.00,
    total           DECIMAL(12, 2)  NOT NULL DEFAULT 0.00,
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status          VARCHAR(20)     NOT NULL DEFAULT 'ACTIVE',
    CONSTRAINT fk_preinv_stay     FOREIGN KEY (stay_id)         REFERENCES stay         (id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_preinv_booking  FOREIGN KEY (room_booking_id) REFERENCES room_booking (id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_preinv_customer FOREIGN KEY (customer_id)     REFERENCES customer     (id) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE = InnoDB;
 
CREATE TABLE invoice (
    id             BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    customer_id    BIGINT UNSIGNED NOT NULL,
    stay_id        BIGINT UNSIGNED NOT NULL,
    invoice_number VARCHAR(30)     NOT NULL UNIQUE,
    issue_date     DATE            NOT NULL,
    subtotal       DECIMAL(12, 2)  NOT NULL DEFAULT 0.00,
    tax            DECIMAL(12, 2)  NOT NULL DEFAULT 0.00,
    discount       DECIMAL(12, 2)  NOT NULL DEFAULT 0.00,
    total          DECIMAL(12, 2)  NOT NULL DEFAULT 0.00,
    invoice_status VARCHAR(20)     NOT NULL DEFAULT 'DRAFT',
    status         VARCHAR(20)     NOT NULL DEFAULT 'ACTIVE',
    CONSTRAINT fk_invoice_customer FOREIGN KEY (customer_id) REFERENCES customer (id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_invoice_stay     FOREIGN KEY (stay_id)     REFERENCES stay     (id) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE = InnoDB;
 
CREATE TABLE partial_payment (
    id                BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    room_booking_id   BIGINT UNSIGNED NOT NULL,
    invoice_id        BIGINT UNSIGNED,
    payment_method_id BIGINT UNSIGNED NOT NULL,
    amount            DECIMAL(12, 2)  NOT NULL,
    payment_date      DATE            NOT NULL,
    payment_reference VARCHAR(100),
    status            VARCHAR(20)     NOT NULL DEFAULT 'ACTIVE',
    CONSTRAINT fk_pp_booking    FOREIGN KEY (room_booking_id)   REFERENCES room_booking   (id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_pp_invoice    FOREIGN KEY (invoice_id)        REFERENCES invoice        (id) ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT fk_pp_pay_method FOREIGN KEY (payment_method_id) REFERENCES payment_method (id) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE = InnoDB;
 
CREATE TABLE purchase_detail (
    id           BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    invoice_id   BIGINT UNSIGNED NOT NULL,
    product_id   BIGINT UNSIGNED,
    service_id   BIGINT UNSIGNED,
    description  VARCHAR(200)    NOT NULL,
    quantity     INT UNSIGNED    NOT NULL DEFAULT 1,
    unit_price   DECIMAL(12, 2)  NOT NULL,
    total_amount DECIMAL(12, 2)  NOT NULL,
    status       VARCHAR(20)     NOT NULL DEFAULT 'ACTIVE',
    CONSTRAINT fk_pd_invoice FOREIGN KEY (invoice_id) REFERENCES invoice (id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_pd_product FOREIGN KEY (product_id) REFERENCES product (id) ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT fk_pd_service FOREIGN KEY (service_id) REFERENCES service (id) ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE = InnoDB;
 
 
-- ============================================================
--  MÓDULO 7 · NOTIFICACIÓN
-- ============================================================
 
CREATE TABLE promotion (
    id          BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    title       VARCHAR(120) NOT NULL,
    description TEXT,
    start_date  DATE         NOT NULL,
    end_date    DATE         NOT NULL,
    channel     VARCHAR(40)  NOT NULL,
    active      TINYINT(1)   NOT NULL DEFAULT 1,
    status      VARCHAR(20)  NOT NULL DEFAULT 'ACTIVE'
) ENGINE = InnoDB;
 
CREATE TABLE alert (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    customer_id     BIGINT UNSIGNED NOT NULL,
    room_booking_id BIGINT UNSIGNED,
    title           VARCHAR(120) NOT NULL,
    message         TEXT         NOT NULL,
    channel         VARCHAR(40)  NOT NULL,
    sent_date       DATETIME,
    status          VARCHAR(20)  NOT NULL DEFAULT 'ACTIVE',
    CONSTRAINT fk_alert_customer FOREIGN KEY (customer_id)     REFERENCES customer     (id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_alert_booking  FOREIGN KEY (room_booking_id) REFERENCES room_booking (id) ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE = InnoDB;
 
CREATE TABLE term_condition (
    id             BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    title          VARCHAR(120) NOT NULL,
    content        TEXT         NOT NULL,
    version        VARCHAR(10)  NOT NULL,
    effective_date DATE         NOT NULL,
    required       TINYINT(1)   NOT NULL DEFAULT 1,
    status         VARCHAR(20)  NOT NULL DEFAULT 'ACTIVE'
) ENGINE = InnoDB;
 
CREATE TABLE customer_loyalty (
    id                    BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    customer_id           BIGINT UNSIGNED NOT NULL UNIQUE,
    level                 VARCHAR(20)  NOT NULL DEFAULT 'STANDARD',
    points                INT UNSIGNED NOT NULL DEFAULT 0,
    last_interaction_date DATE,
    observation           TEXT,
    status                VARCHAR(20)  NOT NULL DEFAULT 'ACTIVE',
    CONSTRAINT fk_loyalty_customer FOREIGN KEY (customer_id) REFERENCES customer (id) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE = InnoDB;
 
 
-- ============================================================
--  MÓDULO 8 · MANTENIMIENTO
-- ============================================================
 
CREATE TABLE room_maintenance (
    id                 BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    room_id            BIGINT UNSIGNED NOT NULL,
    employee_id        BIGINT UNSIGNED NOT NULL,
    maintenance_type   VARCHAR(20)  NOT NULL,
    start_date         DATE         NOT NULL,
    end_date           DATE,
    maintenance_status VARCHAR(20)  NOT NULL DEFAULT 'PENDING',
    observation        TEXT,
    status             VARCHAR(20)  NOT NULL DEFAULT 'ACTIVE',
    CONSTRAINT fk_maint_room     FOREIGN KEY (room_id)     REFERENCES room     (id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_maint_employee FOREIGN KEY (employee_id) REFERENCES employee (id) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE = InnoDB;
 
CREATE TABLE use_maintenance (
    id                  BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    room_maintenance_id BIGINT UNSIGNED NOT NULL UNIQUE,
    use_reason          VARCHAR(200) NOT NULL,
    activity_detail     TEXT,
    status              VARCHAR(20)  NOT NULL DEFAULT 'ACTIVE',
    CONSTRAINT fk_use_maint FOREIGN KEY (room_maintenance_id) REFERENCES room_maintenance (id) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE = InnoDB;
 
CREATE TABLE remodeling_maintenance (
    id                     BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    room_maintenance_id    BIGINT UNSIGNED NOT NULL UNIQUE,
    remodeling_description TEXT           NOT NULL,
    estimated_budget       DECIMAL(14, 2),
    status                 VARCHAR(20)    NOT NULL DEFAULT 'ACTIVE',
    CONSTRAINT fk_remodel_maint FOREIGN KEY (room_maintenance_id) REFERENCES room_maintenance (id) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE = InnoDB;
 
 
-- ============================================================
--  VISTAS
-- ============================================================
 
CREATE OR REPLACE VIEW room_catalog AS
    SELECT
        r.id               AS room_id,
        b.name             AS branch,
        b.city,
        rt.name            AS room_type,
        r.number,
        r.floor,
        r.capacity,
        rs.name            AS room_status,
        rs.allows_booking,
        rs.allows_check_in
    FROM room        r
    JOIN branch      b  ON b.id  = r.branch_id
    JOIN room_type   rt ON rt.id = r.room_type_id
    JOIN room_status rs ON rs.id = r.room_status_id
    WHERE r.status = 'ACTIVE';
 
CREATE OR REPLACE VIEW maintenance_dashboard AS
    SELECT
        b.id                         AS branch_id,
        b.name                       AS branch,
        COUNT(r.id)                  AS total_rooms,
        SUM(rs.name = 'AVAILABLE')   AS available_rooms,
        SUM(rs.name = 'OCCUPIED')    AS occupied_rooms,
        SUM(rs.name = 'MAINTENANCE') AS maintenance_rooms,
        SUM(rs.name = 'CLEANING')    AS cleaning_rooms,
        CURRENT_DATE                 AS cutoff_date
    FROM branch      b
    JOIN room        r  ON r.branch_id = b.id
    JOIN room_status rs ON rs.id       = r.room_status_id
    WHERE r.status = 'ACTIVE'
    GROUP BY b.id, b.name;
 
 
SET FOREIGN_KEY_CHECKS = 1;