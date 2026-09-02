-- Eliminar base de datos si existe. 
DROP DATABASE IF EXISTS trace_product;

-- Crear base de datos trace_product
CREATE DATABASE trace_product;

-- Usar base de datos trace_product
USE trace_product; 

-- Crear entidades de la base de datos 
CREATE TABLE continent(
	id INT PRIMARY KEY AUTO_INCREMENT,
    code VARCHAR(50) UNIQUE NOT NULL,
    name VARCHAR(50) NOT NULL,
    description VARCHAR(50)
);

CREATE TABLE country(
	id INT PRIMARY KEY AUTO_INCREMENT,
    code VARCHAR(50) UNIQUE NOT NULL,
    name VARCHAR(50) NOT NULL,
    description VARCHAR(50), 
    continent_id INT NOT NULL,
    CONSTRAINT fk_country_continent_id FOREIGN KEY (continent_id) REFERENCES continent(id) 
);

CREATE TABLE estate(
	id INT PRIMARY KEY AUTO_INCREMENT,
    code VARCHAR(50) UNIQUE NOT NULL,
    name VARCHAR(50) NOT NULL,
    description VARCHAR(50), 
    country_id INT NOT NULL,
    CONSTRAINT fk_estate_country_id FOREIGN KEY (country_id) REFERENCES country(id) 
);

CREATE TABLE city(
	id INT PRIMARY KEY AUTO_INCREMENT,
    code VARCHAR(50) UNIQUE NOT NULL,
    name VARCHAR(50) NOT NULL,
    description VARCHAR(50), 
    estate_id INT NOT NULL,
    CONSTRAINT fk_city_estate_id FOREIGN KEY (estate_id) REFERENCES estate(id) 
);

CREATE TABLE locality(
  id INT PRIMARY KEY AUTO_INCREMENT,
  code VARCHAR(50) UNIQUE NOT NULL,
  name VARCHAR(50) NOT NULL,
  description VARCHAR(50), 
  city_id INT NOT NULL,
  CONSTRAINT fk_locality_city_id FOREIGN KEY (city_id) REFERENCES city(id) 
);

CREATE TABLE neighborhood(
  id INT PRIMARY KEY AUTO_INCREMENT,
  code VARCHAR(50) UNIQUE NOT NULL,
  name VARCHAR(50) NOT NULL,
  description VARCHAR(50), 
  locality_id INT NOT NULL,
  CONSTRAINT fk_neighborhood_locality_id FOREIGN KEY (locality_id) REFERENCES locality(id) 
);

CREATE TABLE product(
  id INT PRIMARY KEY AUTO_INCREMENT,
  code VARCHAR(50) UNIQUE NOT NULL,
  name VARCHAR(50) NOT NULL,
  price DECIMAL(10,2) NOT NULL,
  description VARCHAR(50)
);

CREATE TABLE shipping_order(
  id INT PRIMARY KEY AUTO_INCREMENT,
  code VARCHAR(50) UNIQUE NOT NULL,
  name VARCHAR(50) NOT NULL,
  description VARCHAR(50), 
  neighborhood_origin_id INT NOT NULL,
  neighborhood_destination_id INT NOT NULL,
  product_id INT NOT NULL,
  CONSTRAINT fk_shipping_order_neighborhood_origin_id FOREIGN KEY (neighborhood_origin_id) REFERENCES neighborhood(id),
  CONSTRAINT fk_shipping_order_neighborhood_destination_id FOREIGN KEY (neighborhood_destination_id) REFERENCES neighborhood(id),
  CONSTRAINT fk_shipping_order_product_id FOREIGN KEY (product_id) REFERENCES product(id)
);

CREATE TABLE trace(
  id INT PRIMARY KEY AUTO_INCREMENT,
  code VARCHAR(50) UNIQUE NOT NULL,
  name VARCHAR(50) NOT NULL,
  description VARCHAR(50), 
  shipping_order_id INT NOT NULL,
  neighborhood_status_id INT NOT NULL,
  timestamp_at DATETIME NOT NULL,
  status_position enum('Lugar de envío', 'En transito', 'Lugar destino') NOT NULL,
  CONSTRAINT fk_trace_shipping_order_id FOREIGN KEY (shipping_order_id) REFERENCES shipping_order(id)
);  

