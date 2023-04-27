DROP DATABASE IF EXISTS proyecto2;
CREATE DATABASE proyecto2;
USE proyecto2;


CREATE TABLE municipios(
	id_municipio INT NOT NULL AUTO_INCREMENT,
	name VARCHAR(100) NOT NULL,
	PRIMARY KEY(id_municipio)
);

CREATE TABLE restaurantes (
  id_restaurante VARCHAR(100) NOT NULL,
  direccion VARCHAR(100) NOT NULL,
  municipio_id INT NOT NULL,
  telefono BIGINT UNSIGNED NOT NULL,
  zona INT NOT NULL,
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
  id_empleado CHAR(8) NOT NULL,
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



-- Establecer el contador de autoincremento en 1 y definir el formato de ceros a la izquierda
-- ALTER TABLE empleados AUTO_INCREMENT=1;
-- ALTER TABLE empleados CHANGE id_empleado id_empleado CHAR(8) NOT NULL DEFAULT '00000001' AUTO_INCREMENT;


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
  canal_pedido CHAR(1) NOT NULL,
  fecha_inicio DATETIME NOT NULL,
  fecha_entrega DATETIME,
  estado VARCHAR(20) NOT NULL DEFAULT 'INICIADA',
  PRIMARY KEY (id_orden),
  FOREIGN KEY (dpi_cliente) REFERENCES clientes(dpi),
  FOREIGN KEY (direccion_id) REFERENCES direcciones(id_direccion)
) AUTO_INCREMENT=1;

CREATE TABLE producto(
	id_char CHAR(1) NOT NULL,
  	id_int INT UNSIGNED NOT NULL,
	nombre VARCHAR(50) NOT NULL,
	tipo_producto CHAR(1) NOT NULL,
	precio DECIMAL(10,2) NOT NULL,
	PRIMARY KEY (id_char, id_int)
);

-- Crear tabla de Detalle de Ordenes
CREATE TABLE detalle_ordenes (
  id_detalle INT NOT NULL AUTO_INCREMENT,
  orden_id INT NOT NULL,
  producto_char CHAR(1) NOT NULL,
  producto_int INT UNSIGNED NOT NULL,
  cantidad INT NOT NULL,
  observacion VARCHAR(150),
  PRIMARY KEY (id_detalle),
  FOREIGN KEY (orden_id) REFERENCES ordenes(id_orden),
  FOREIGN KEY (producto_char, producto_int) REFERENCES producto(id_char, id_int)
) AUTO_INCREMENT=1;



