DROP DATABASE IF EXISTS apartment_rental;
CREATE DATABASE apartment_rental;
USE apartment_rental;

-- ===============================
-- PERSON
-- ===============================
CREATE TABLE person (
    id INT AUTO_INCREMENT PRIMARY KEY,
    type_document ENUM('CC','DNI','TI','CE','P') NOT NULL,
    document VARCHAR(20) NOT NULL UNIQUE,
    name VARCHAR(50) NOT NULL,
    address VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20)
);

-- ===============================
-- USERS (mejor nombre)
-- ===============================
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    person_id INT,
    FOREIGN KEY (person_id) REFERENCES person(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- ===============================
-- GATED COMMUNITY
-- ===============================
CREATE TABLE gated_community (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    address VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20),
    city VARCHAR(50)
);

-- ===============================
-- TOWER
-- ===============================
CREATE TABLE tower (
    id INT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(20) NOT NULL,
    name VARCHAR(50),
    apartment_count INT,
    gated_community_id INT,
    FOREIGN KEY (gated_community_id) REFERENCES gated_community(id)
        ON DELETE CASCADE
);

-- ===============================
-- LEVEL APARTMENT
-- ===============================
CREATE TABLE level_apartment (
    id INT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(20),
    number INT,
    tower_id INT,
    FOREIGN KEY (tower_id) REFERENCES tower(id)
        ON DELETE CASCADE
);

-- ===============================
-- APARTMENT
-- ===============================
CREATE TABLE apartment (
    id INT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(20),
    address VARCHAR(100),
    person_owner_id INT,
    level_apartment_id INT,
    FOREIGN KEY (person_owner_id) REFERENCES person(id)
        ON DELETE SET NULL,
    FOREIGN KEY (level_apartment_id) REFERENCES level_apartment(id)
        ON DELETE CASCADE
);

-- ===============================
-- RENT
-- ===============================
CREATE TABLE rent (
    id INT AUTO_INCREMENT PRIMARY KEY,
    date_start_contract DATE,
    date_end_contract DATE,
    price DECIMAL(12,2),
    total_deposit DECIMAL(12,2),
    description VARCHAR(255),
    person_tenant_id INT,
    apartment_id INT,
    FOREIGN KEY (person_tenant_id) REFERENCES person(id)
        ON DELETE CASCADE,
    FOREIGN KEY (apartment_id) REFERENCES apartment(id)
        ON DELETE CASCADE
);

-- ===============================
-- INSERTS PERSON
-- ===============================
INSERT INTO person (type_document, document, name, address, email, phone) VALUES
('CC','31231232','Pedro','Calle 20','pedro@gmail.com','321312312'),
('DNI','84567213','Laura','Carrera 15','laura@gmail.com','300123456'),
('TI','10293847','Andres','Avenida 30','andres@gmail.com','311987654'),
('CE','55667788','Maria','Calle 45','maria@gmail.com','320456789'),
('P','99887766','Carlos','Carrera 50','carlos@gmail.com','315654321');

-- ===============================
-- INSERT USERS
-- ===============================
INSERT INTO users (username, password, person_id) VALUES
('pedro.g', SHA2('Pedro123!',256),1),
('laura.m', SHA2('Laura456!',256),2),
('andres.c',SHA2('Andres789!',256),3),
('maria.v', SHA2('Maria012!',256),4),
('carlos.r',SHA2('Carlos345!',256),5);

-- ===============================
-- CONSULTA FINAL (corregida)
-- ===============================
SELECT 
    p.name, 
    u.username
FROM person p
INNER JOIN users u ON p.id = u.person_id;