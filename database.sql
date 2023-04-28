DROP DATABASE IF EXISTS proyecto2;
CREATE DATABASE proyecto2;
USE proyecto2;


CREATE TABLE municipios(
	id_municipio INT NOT NULL AUTO_INCREMENT,
	name_municipio VARCHAR(100) NOT NULL,
	PRIMARY KEY(id_municipio)
);

CREATE TABLE restaurantes (
  id_restaurante VARCHAR(100) NOT NULL,
  direccion VARCHAR(100) NOT NULL,
  municipio_id INT NOT NULL,
  zona INT NOT NULL,
  telefono BIGINT UNSIGNED NOT NULL,
  cantidad_personal INT NOT NULL,
  parqueo_propio BOOLEAN NOT NULL,
  PRIMARY KEY (id_restaurante),
  FOREIGN KEY (municipio_id) REFERENCES municipios(id_municipio)
);

-- Crear tabla de Puestos
CREATE TABLE puestos (
  id_puesto INT NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(100) NOT NULL,
  descripcion VARCHAR(100) NOT NULL,
  salario DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (id_puesto)
) AUTO_INCREMENT=1;

-- LPAD()
CREATE TABLE empleados (
  id_empleado INT(8) ZEROFILL  NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(100) NOT NULL,
  apellido VARCHAR(100) NOT NULL,
  fecha_nacimiento DATE NOT NULL,
  correo VARCHAR(100) NOT NULL,
  telefono BIGINT UNSIGNED NOT NULL,
  direccion VARCHAR(100) NOT NULL,
  dpi BIGINT UNSIGNED NOT NULL,
  puesto_id INT NOT NULL,
  restaurante_id VARCHAR(100) NOT NULL,
  fecha_inicio_labores DATE NOT NULL,
  PRIMARY KEY (id_empleado),
  FOREIGN KEY (puesto_id) REFERENCES puestos(id_puesto),
  FOREIGN KEY (restaurante_id) REFERENCES restaurantes(id_restaurante)
)AUTO_INCREMENT=1;

-- Crear tabla de Clientes
CREATE TABLE clientes (
  dpi BIGINT UNSIGNED NOT NULL,
  nombre VARCHAR(50) NOT NULL,
  apellido VARCHAR(50) NOT NULL,
  telefono BIGINT UNSIGNED NOT NULL,
  fecha_nacimiento DATE NOT NULL,
  correo VARCHAR(100) NOT NULL,
  nit INT,
  PRIMARY KEY (dpi)
) AUTO_INCREMENT=1;

-- Crear tabla de Direcciones de Clientes
CREATE TABLE direcciones (
  id_direccion INT NOT NULL AUTO_INCREMENT,
  dpi_cliente BIGINT UNSIGNED NOT NULL,
  direccion VARCHAR(100) NOT NULL,
  municipio_id INT NOT NULL,
  zona INT NOT NULL,
  PRIMARY KEY (id_direccion),
  FOREIGN KEY (dpi_cliente) REFERENCES clientes(dpi),
  FOREIGN KEY (municipio_id) REFERENCES municipios(id_municipio)
) AUTO_INCREMENT=1;

-- Crear tabla de Ordenes
CREATE TABLE ordenes (
  id_orden INT NOT NULL AUTO_INCREMENT,
  dpi_cliente BIGINT UNSIGNED NOT NULL,
  direccion_id INT NOT NULL,
  restaurante_id  VARCHAR(100),
  canal_pedido CHAR(1) NOT NULL,
  fecha_inicio DATETIME NOT NULL,
  fecha_entrega DATETIME,
  estado VARCHAR(20) NOT NULL, -- DEFAULT 'INICIADA',
  id_repartidor INT(8) ZEROFILL,
  PRIMARY KEY (id_orden),
  FOREIGN KEY (dpi_cliente) REFERENCES clientes(dpi),
  FOREIGN KEY (direccion_id) REFERENCES direcciones(id_direccion),
  FOREIGN KEY (restaurante_id)REFERENCES restaurantes(id_restaurante),
  FOREIGN KEY (id_repartidor) REFERENCES  empleados(id_empleado)
) AUTO_INCREMENT=1;

CREATE TABLE productos(
	producto_tipo CHAR(1) NOT NULL,
  	id_producto INT UNSIGNED NOT NULL,
	nombre VARCHAR(50) NOT NULL,
	precio DECIMAL(10,2) NOT NULL,
	PRIMARY KEY (producto_tipo, id_producto)
);

-- Crear tabla de Detalle de Ordenes
CREATE TABLE detalle_ordenes (
  id_detalle INT NOT NULL AUTO_INCREMENT,
  orden_id INT NOT NULL,
  producto_tipo CHAR(1) NOT NULL,
  id_producto INT UNSIGNED NOT NULL,
  cantidad INT NOT NULL,
  observacion VARCHAR(150),
  PRIMARY KEY (id_detalle),
  FOREIGN KEY (orden_id) REFERENCES ordenes(id_orden),
  FOREIGN KEY (producto_tipo, id_producto) REFERENCES productos(producto_tipo, id_producto)  
) AUTO_INCREMENT=1;


-- Crear la tabla de Facturas
CREATE TABLE facturas(
	serial_number VARCHAR(15),
	monto_total DECIMAL(10, 2),
	lugar INT,
	confirmacion_datetime DATETIME,
	orden_id INT,
	nit INT,
	forma_pago CHAR(1),
	PRIMARY KEY (serial_number),
	FOREIGN KEY (lugar) REFERENCES municipios(id_municipio),
	FOREIGN KEY (orden_id) REFERENCES ordenes(id_orden)
);

CREATE TABLE events_log(
	id_events INT NOT NULL AUTO_INCREMENT,
	event_datetime DATETIME, 
	table_name VARCHAR(50), 
	event_type VARCHAR(50),
	PRIMARY KEY (id_events)
);
-- falta agregar repartidor
INSERT INTO productos(producto_tipo, id_producto, nombre, precio)
VALUES
  ('C', 1, 'Cheeseburger', 41.00),
  ('C', 2, 'Chicken Sandwich', 32.00),
  ('C', 3, 'BBQ Ribs', 54.00),
  ('C', 4, 'Pasta Alfredo',  47.00),
  ('C', 5, 'Pizza Espinator', 85.00),
  ('C', 6, 'Buffalo Wings', 36.00),
  ('E', 1, 'Papas Fritas', 15.00),
  ('E', 2, 'Aros de Cebolla', 17.00),
  ('E', 3, 'Coleslaw', 12.00),
  ('B', 1, 'Coca-Cola', 12.00),
  ('B', 2, 'Fanta',  12.00),
  ('B', 3, 'Sprite',  12.00),
  ('B', 4, 'Té Frío', 12.00),
  ('B', 5, 'Cerveza de Barril',  18.00),
  ('P', 1, 'Copa de Helado', 13.00),
  ('P', 2, 'Cheesecake', 15.00),
  ('P', 3, 'Cupcake de Chocolate', 8.00),
  ('P', 4, 'Flan', 10.00);

SELECT * FROM productos;


