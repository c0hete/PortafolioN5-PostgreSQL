
------------------------------------------PORTAFOLIO---------------------------------------------------------------------------

--Se crea tabla clientes
CREATE TABLE clientes (
  id SERIAL PRIMARY KEY,
  nombre VARCHAR(255) NOT NULL,
  apellidos VARCHAR(255) NOT NULL,
  correo_electronico VARCHAR(255) NOT NULL,
  contraseña VARCHAR(255) NOT NULL,
  rut VARCHAR(12) NOT NULL
);

--Agrego unicidad al campo rut
ALTER TABLE clientes ADD UNIQUE (rut);
//Datos para tabla clientes:
INSERT INTO clientes (nombre, apellidos, correo_electronico, contraseña, rut)
VALUES ('Juan', 'Pérez', 'juan@example.com', 'contraseña123', '12345678-9'),
       ('Ana', 'García', 'ana@example.com', 'contraseña456', '98765432-1'),
       ('Pedro', 'Rodríguez', 'pedro@example.com', 'contraseña789', '56789123-4'),
       ('Sofía', 'González', 'sofia@example.com', 'contraseña159', '12312345-6'),
       ('Pablo', 'Santos', 'pablo@example.com', 'contraseña753', '45678912-3');

--Se crea tabla productos
CREATE TABLE productos (
  id SERIAL PRIMARY KEY,
  nombre VARCHAR(255) NOT NULL,
  descripcion VARCHAR(255) NOT NULL,
  precio DECIMAL(10,2) NOT NULL,
  stock INTEGER NOT NULL
);
--Datos para tabla productos:
INSERT INTO productos (nombre, descripcion, precio, stock)
VALUES ('Producto 1', 'Descripción del producto 1', 100, 10),
       ('Producto 2', 'Descripción del producto 2', 50, 20),
       ('Producto 3', 'Descripción del producto 3', 25, 30),
       ('Producto 4', 'Descripción del producto 4', 150, 40),
       ('Producto 5', 'Descripción del producto 5', 75, 50),
	   ('GOD OF WAR RAGNAROK', 'Descripción del producto 6', 75, 5),
	   ('HORIZON ZERO DAWN 2', 'Descripción del producto 7', 75, 3),
	   ('GHOST OF TSUSHIMA', 'Descripción del producto 8', 75, 1);

--Se crea tabla compras
CREATE TABLE compras (
  id SERIAL PRIMARY KEY,
  id_cliente INTEGER NOT NULL,
  id_producto INTEGER NOT NULL,
  precio DECIMAL(10,2) NOT NULL,
  cantidad INTEGER NOT NULL,
  fecha_compra DATE NOT NULL,
  FOREIGN KEY (id_cliente) REFERENCES clientes (id),
  FOREIGN KEY (id_producto) REFERENCES productos (id)
);
--Datos para tabla compras:
INSERT INTO compras (id_cliente, id_producto, precio, cantidad, fecha_compra)
VALUES (1, 1, 100, 2, '2022-01-01'),
       (2, 2, 50, 3, '2022-02-01'),
       (3, 3, 25, 4, '2022-03-01'),
       (4, 4, 150, 5, '2022-04-01'),
       (5, 11, 75, 2, '2022-05-01'),
	   (5, 13, 75, 1 '2022-12-01')
	   (5, 10, 75, 1, '2022-12-01');

--Se crea tabla facturas
CREATE TABLE facturas (
  id_factura SERIAL PRIMARY KEY,
  id_compra INTEGER NOT NULL,
  subtotal DECIMAL(10,2) NOT NULL,
  iva DECIMAL(10,2) NOT NULL,
  rut_cliente VARCHAR(12) NOT NULL,
  FOREIGN KEY (id_compra) REFERENCES compras (id),
  FOREIGN KEY (rut_cliente) REFERENCES clientes (rut)
);
--Datos para tabla facturas:
INSERT INTO facturas (id_compra, subtotal, iva, rut_cliente)
VALUES (1, 200, 36, '12345678-9'),
       (2, 225, 40.5, '98765432-1'),
       (3, 125, 22.5, '56789123-4'),
       (4, 750, 135, '12312345-6'),
       (5, 150,30,'45678912-3'),
	   (5, 75, 14.25,'45678912-3'),
	   (5, 75,14.25,'45678912-3');


SELECT * FROM clientes;
SELECT * FROM productos;
SELECT * FROM compras;
SELECT * FROM facturas;


--CONSULTAS SOLICITADAS--------------------------------------------------------------------------------------------------------

/*1.- ACTUALIZAR EL PRECIO DE TODOS LOS PRODUCTOS, -20% POR CONCEPTO DE OFERTA DE VERANO.------------------------------------*/
BEGIN;

ALTER TABLE productos ADD COLUMN oferta_de_verano BOOLEAN DEFAULT TRUE;

UPDATE productos
SET precio = precio * 0.8
WHERE oferta_de_verano = TRUE;

COMMIT;

/*2.- LISTAR LOS PRODUCTOS CON STOCK CRITICO (MENOR O IGUAL A 5 UNIDADES)----------------------------------------------------*/
SELECT *, stock as "Stock Critico" FROM productos WHERE stock <= 5;

/*3.- SIMULAR LA COMPRA DE AL MENOS 3 PRODUCTOS, CALCULAR SUBTOTAL, AGREGAR EL IVA y MOSTRAR EL TOTAL DE LA COMPRA.----------*/
SELECT
  p1.nombre AS "Producto 1",
  p1.precio AS "Precio 1",
  p2.nombre AS "Producto 2",
  p2.precio AS "Precio 2",
  p3.nombre AS "Producto 3",
  p3.precio AS "Precio 3",
  (p1.precio + p2.precio + p3.precio) AS "Subtotal",
  ((p1.precio + p2.precio + p3.precio) * 0.19) AS "IVA",
  ((p1.precio + p2.precio + p3.precio) * 1.19) AS "Total"
FROM productos p1, productos p2, productos p3
WHERE p1.id = 1 AND p2.id = 2 AND p3.id = 3;

/*4.-MOSTRAR TOTAL DE VENTAS DE MES DE DICIEMBRE DEL 2022---------------------------------------------------------------------*/
SELECT SUM(precio * cantidad) as total_ventas
FROM compras
WHERE fecha_compra BETWEEN '2022-12-01' AND '2022-12-31';


/*5.-LISTAR EL COMPORTAMIENTO DE COMPRA DEL USUARIO QUE MAS COMPRAS REALIZO EL 2022-------------------------------------------*/
SELECT c.nombre AS "Nombre del cliente", c.apellidos AS "Apellidos", COUNT(*) AS "Total de compras"
FROM clientes c
INNER JOIN compras co ON c.id = co.id_cliente
WHERE co.fecha_compra BETWEEN '2022-01-01' AND '2022-12-31'
GROUP BY c.nombre, c.apellidos
ORDER BY COUNT(*) DESC
LIMIT 1;