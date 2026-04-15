-- =====================
-- INSERCIONES
-- =====================

INSERT INTO continente VALUES
(1,'América'),(2,'Europa'),(3,'Asia'),(4,'África'),(5,'Oceanía');

INSERT INTO pais VALUES
(1,'Colombia',1),(2,'México',1),(3,'Argentina',1),(4,'España',2),(5,'Perú',1);

INSERT INTO departamento VALUES
(1,'Huila',1),(2,'Cundinamarca',1),(3,'Antioquia',1),(4,'Lima',5),(5,'Madrid',4);

INSERT INTO ciudad VALUES
(1,'Neiva',1),(2,'Bogotá',2),(3,'Medellín',3),(4,'Lima',4),(5,'Madrid',5);

INSERT INTO barrio VALUES
(1,'Centro',1),(2,'Chapinero',2),(3,'El Poblado',3),(4,'Miraflores',4),(5,'Salamanca',5);

INSERT INTO persona VALUES
(1,'Juan Perez','123','300111',1),
(2,'Maria Lopez','124','300222',2),
(3,'Carlos Ruiz','125','300333',3),
(4,'Ana Torres','126','300444',4),
(5,'Luis Gomez','127','300555',5);

INSERT INTO rol VALUES
(1,'Admin'),(2,'Vendedor'),(3,'Cliente'),(4,'Supervisor'),(5,'Invitado');

INSERT INTO usuario VALUES
(1,'juan','123',1),
(2,'maria','123',2),
(3,'carlos','123',3),
(4,'ana','123',4),
(5,'luis','123',5);

INSERT INTO usuario_rol VALUES
(1,1),(2,2),(3,3),(4,4),(5,5);

INSERT INTO categoria VALUES
(1,'Tecnología'),(2,'Ropa'),(3,'Alimentos'),(4,'Hogar'),(5,'Deportes');

INSERT INTO producto VALUES
(1,'Laptop',2500,10,1),
(2,'Camisa',80,50,2),
(3,'Pan',5,100,3),
(4,'Silla',150,20,4),
(5,'Balón',60,30,5);

INSERT INTO factura VALUES
(1,'2026-01-01',3000,1),
(2,'2026-01-02',200,2),
(3,'2026-01-03',50,3),
(4,'2026-01-04',150,4),
(5,'2026-01-05',60,5);

INSERT INTO detalle_factura VALUES
(1,1,1,1,2500),
(2,2,2,2,80),
(3,3,3,5,5),
(4,4,4,1,150),
(5,5,5,1,60);

-- =====================
-- UPDATES
-- =====================

UPDATE continente SET nombre='America Latina' WHERE id_continente=1;
UPDATE continente SET nombre='Europa Oeste' WHERE id_continente=2;

UPDATE pais SET nombre='Colombia Actualizada' WHERE id_pais=1;
UPDATE pais SET nombre='México DF' WHERE id_pais=2;

UPDATE producto SET precio=2600 WHERE id_producto=1;
UPDATE producto SET stock=45 WHERE id_producto=2;

UPDATE persona SET telefono='300999' WHERE id_persona=1;
UPDATE persona SET nombre='Maria Actualizada' WHERE id_persona=2;

UPDATE factura SET total=3100 WHERE id_factura=1;
UPDATE factura SET total=220 WHERE id_factura=2;

-- =====================
-- DELETE
-- =====================

DELETE FROM detalle_factura WHERE id_detalle=5;
DELETE FROM detalle_factura WHERE id_detalle=4;

DELETE FROM factura WHERE id_factura=5;
DELETE FROM factura WHERE id_factura=4;

DELETE FROM producto WHERE id_producto=5;
DELETE FROM producto WHERE id_producto=4;

-- =====================
-- SELECT
-- =====================

-- consultas simples
SELECT * FROM continente WHERE nombre LIKE 'A%';
SELECT * FROM pais WHERE nombre LIKE 'Col%';
SELECT * FROM producto WHERE precio > 100;
SELECT * FROM persona WHERE nombre LIKE '%Maria%';

-- joins
SELECT p.nombre, c.nombre AS categoria
FROM producto p
INNER JOIN categoria c ON p.id_categoria=c.id_categoria;

SELECT pe.nombre, b.nombre AS barrio
FROM persona pe
INNER JOIN barrio b ON pe.id_barrio=b.id_barrio;

SELECT f.id_factura, u.username
FROM factura f
INNER JOIN usuario u ON f.id_usuario=u.id_usuario;

SELECT d.id_factura, p.nombre
FROM detalle_factura d
INNER JOIN producto p ON d.id_producto=p.id_producto;