USE proyecto2;

/************************************Triggers**************************************************/


/************************************FUNCIONES*************************************************/
DELIMITER $$
DROP FUNCTION IF EXISTS ExisteRestaurante $$
CREATE FUNCTION ExisteRestaurante(id_restaurante VARCHAR(100))
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
	DECLARE existe BOOLEAN;
	SELECT EXISTS (SELECT 1 FROM restaurantes r WHERE r.id_restaurante  = id_restaurante) INTO existe;
-- returns the boolean
	RETURN (existe);
END $$
DELIMITER ;

DELIMITER $$
DROP FUNCTION IF EXISTS GetMunicipio $$
CREATE FUNCTION GetMunicipio(municipio_id VARCHAR(100))
RETURNS INT
DETERMINISTIC
BEGIN
DECLARE existe INT;
SELECT id_municipio INTO existe FROM municipios m WHERE m.name_municipio = municipio_id;
IF existe IS NULL THEN
  INSERT INTO municipios (name_municipio) VALUES (municipio_id);
  SET existe = LAST_INSERT_ID();
END IF;
RETURN existe;
END $$
DELIMITER;






/**************************#1 Registrar Restaurante*********************************/
DELIMITER $$
DROP PROCEDURE IF EXISTS RegistrarRestaurante $$
CREATE PROCEDURE RegistrarRestaurante(
    IN id_restaurante_in VARCHAR(100),
    IN direccion_in VARCHAR(100),
    IN municipio_id_in VARCHAR(100),
    IN zona_in INT,
    IN telefono_in BIGINT UNSIGNED,
    IN cantidad_personal_in INT,
    IN parqueo_propio_in BOOLEAN
)
registrarRestaurante:BEGIN
    DECLARE is_exists INT;
    DECLARE municipio INT;
   	DECLARE parqueo INT;

    SET is_exists = 0;

    SELECT COUNT(*) INTO is_exists
    FROM restaurantes
    WHERE id_restaurante = id_restaurante_in;

    /* YA EXISTE */
    IF (is_exists > 0) THEN
        SELECT CONCAT("EL Restaurante '", id_restaurante_in, "' ya existe.") AS ERROR;
        LEAVE registrarRestaurante;
    END IF;
    IF cantidad_personal_in <= 0 THEN 
        SELECT "La cantidad de personal debe ser mayor a 0." AS ERROR;
        LEAVE registrarRestaurante;
    END IF;
	IF zona_in <= 0 THEN 
        SELECT "Zona invalida." AS ERROR;
        LEAVE registrarRestaurante;
    END IF;
   	IF parqueo_propio_in = 0 THEN
   		SET parqueo = FALSE;
   	ELSE IF parqueo_propio_in = 1 THEN
   		SET parqueo = TRUE;
   	ELSE
   		SELECT "Parametro de parqueo invalido." AS ERROR;
        LEAVE registrarRestaurante;
   	END IF
   	
		SET parqueo = TRUE;
	END IF;
   
   	SET municipio = GetMunicipio(municipio_id_in);
    INSERT INTO restaurantes(id_restaurante, direccion, municipio_id, zona, telefono, cantidad_personal, parqueo_propio)
    VALUES(id_restaurante_in, direccion_in, municipio, zona_in, telefono_in, cantidad_personal_in, parqueo);

    /* MENSAJE */
    SELECT CONCAT("Restaurante '", id_restaurante_in, "' registrado.") AS MENSAJE;
END $$
DELIMITER ;


/**************************#2 *********************************/

-- TODO ver que no se agregen mas empleados de la capacidad que tiene el restaurante
DELIMITER $$
DROP PROCEDURE IF EXISTS CrearEmpleado $$ 
CREATE PROCEDURE CrearEmpleado(
    IN nombre_in VARCHAR(100),
    IN apellido_in VARCHAR(100),
    IN fecha_nacimiento_in DATE,
    IN correo_in VARCHAR(100),
    IN telefono_in BIGINT UNSIGNED,
    IN direccion_in VARCHAR(100),
    IN dpi_in BIGINT UNSIGNED,
    IN puesto_id_in INT,
    IN fecha_inicio_labores_in DATE,
    IN restaurante_id_in VARCHAR(100)
)
crearEmpleado:BEGIN
    DECLARE puesto_exists INT;
    DECLARE restaurante_exists INT;
    DECLARE dpi_exists INT;
	DECLARE empleados_count INT;
	DECLARE empleados_max INT;

    SET puesto_exists = 0;
    SET restaurante_exists = 0;
    SET dpi_exists = 0;
    SET empleados_count = 0;
	SET empleados_max = 0;

    SELECT COUNT(*) INTO puesto_exists FROM puestos WHERE id_puesto = puesto_id_in;
    IF (puesto_exists = 0) THEN
        SELECT CONCAT("ERROR: El puesto '", puesto_id_in, "' no existe.") AS ERROR;
        LEAVE crearEmpleado;
    END IF;

    SELECT COUNT(*) INTO restaurante_exists FROM restaurantes WHERE id_restaurante = restaurante_id_in;
    IF (restaurante_exists = 0) THEN
        SELECT CONCAT("ERROR: El restaurante '", restaurante_id_in, "' no existe.") AS ERROR;
        LEAVE crearEmpleado;
    END IF;
   
   	SELECT cantidad_personal INTO empleados_max FROM restaurantes WHERE id_restaurante = restaurante_id_in;
  	SELECT COUNT(*) INTO empleados_count FROM empleados  WHERE restaurante_id = restaurante_id_in;
	IF empleados_count >= empleados_max THEN
		SELECT "ERROR: Ya existe se ha llegado al numero maximo de empleados." AS ERROR;
        LEAVE crearEmpleado;
	END IF;
  
    SELECT COUNT(*) INTO dpi_exists FROM empleados WHERE dpi = dpi_in;
    IF (dpi_exists > 0) THEN
        SELECT "ERROR: Ya existe un empleado con el mismo DPI." AS ERROR;
        LEAVE crearEmpleado;
    END IF;

    IF correo_in REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$' THEN
        INSERT INTO empleados(nombre, apellido, fecha_nacimiento, correo, telefono, direccion, dpi, puesto_id, restaurante_id, fecha_inicio_labores)
        VALUES(nombre_in, apellido_in, fecha_nacimiento_in, correo_in, telefono_in, direccion_in, dpi_in, puesto_id_in, restaurante_id_in, fecha_inicio_labores_in);
        SELECT CONCAT("Empleado '", nombre_in, apellido_in, "' registrado.") AS MENSAJE;
    ELSE
        SELECT "ERROR: Correo electrónico inválido." AS ERROR;
    END IF;
END $$
DELIMITER ;


/**************************#3 *********************************/
DELIMITER $$
DROP PROCEDURE IF EXISTS RegistrarPuesto $$ 
CREATE PROCEDURE RegistrarPuesto(
	IN nombre_in VARCHAR(100),
    IN descripcion_in VARCHAR(100),
    IN salario_in DECIMAL(10,2)
)
registrarPuesto:BEGIN
	DECLARE is_exists INT;
    SET is_exists = 0;
    SELECT COUNT(*) INTO is_exists FROM puestos WHERE nombre = nombre_in;
    IF (is_exists > 0) THEN
        SELECT CONCAT("ERROR: El puesto '", nombre_in, "' ya existe.") AS ERROR;
        LEAVE registrarPuesto;
    END IF;

    IF salario_in <= 0 THEN
        SELECT "ERROR: El salario debe ser mayor a 0.0" AS ERROR;
        LEAVE registrarPuesto;
    END IF;

    INSERT INTO puestos(nombre, descripcion, salario)
    VALUES(nombre_in, descripcion_in, salario_in);

    SELECT CONCAT("Puesto '", nombre_in, "' registrado.") AS MENSAJE;
END $$
DELIMITER ;


/**************************#4 *********************************/
DELIMITER $$
DROP PROCEDURE IF EXISTS RegistrarCliente $$ 
CREATE PROCEDURE RegistrarCliente(
  IN dpi_in BIGINT UNSIGNED,
  IN nombre_in VARCHAR(50),
  IN apellido_in VARCHAR(50),
  IN fecha_nacimiento_in DATE,
  IN correo_in VARCHAR(100),
  IN telefono_in BIGINT UNSIGNED,
  IN nit_in INT
)
registrarClient:BEGIN
  DECLARE dpi_count INT;
  
  SELECT COUNT(*) INTO dpi_count
  FROM clientes
  WHERE dpi = dpi_in;
  
  IF (dpi_count > 0) THEN
    SELECT CONCAT("ERROR: Ya existe un cliente con DPI ", dpi_in) AS ERROR;
    LEAVE registrarClient;
  END IF;

  IF (correo_in REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$') = 0 THEN
    SELECT CONCAT("ERROR: Correo '", correo_in, "' no es válido.") AS ERROR;
    LEAVE registrarClient;
  END IF;
  
  INSERT INTO clientes(dpi, nombre, apellido, fecha_nacimiento, correo, telefono, nit)
  VALUES(dpi_in, nombre_in, apellido_in, fecha_nacimiento_in, correo_in, telefono_in, nit_in);

  SELECT CONCAT("Cliente con DPI ", dpi_in, " registrado.") AS MENSAJE;
END $$
DELIMITER ;

	
	
	
/**************************#5 *********************************/
DELIMITER $$
DROP PROCEDURE IF EXISTS RegistrarDireccion $$
CREATE PROCEDURE RegistrarDireccion(
    IN dpi_cliente_in BIGINT UNSIGNED,
    IN direccion_in VARCHAR(100),
    IN municipio_id_in VARCHAR(100),
    IN zona_in INT
)
registrarDireccion:BEGIN
    DECLARE cliente_exists INT;
    DECLARE municipio INT;
    SET cliente_exists = 0;
    SELECT COUNT(*) INTO cliente_exists FROM clientes WHERE dpi = dpi_cliente_in;
    IF (cliente_exists = 0) THEN
        SELECT CONCAT("ERROR: El cliente con DPI '", dpi_cliente_in, "' no existe.") AS ERROR;
        LEAVE registrarDireccion;
    END IF;

    IF zona_in <= 0 THEN
        SELECT "ERROR: La zona debe ser un número entero positivo." AS ERROR;
        LEAVE registrarDireccion;
    END IF;
	SET municipio = GetMunicipio(municipio_id_in);
    INSERT INTO direcciones(dpi_cliente, direccion, municipio_id, zona)
    VALUES(dpi_cliente_in, direccion_in, municipio, zona_in);
    SELECT CONCAT("Dirección '", direccion_in, "' registrada para el cliente con DPI '", dpi_cliente_in, "'.") AS MENSAJE;
END $$
DELIMITER ;

/**************************#6 *********************************/
DELIMITER $$
DROP PROCEDURE IF EXISTS CrearOrden $$
CREATE PROCEDURE CrearOrden(
    IN dpi_cliente_in BIGINT UNSIGNED,
    IN id_direccion_cliente_in INT,
    IN canal_in CHAR(1)
)
crearOrden:BEGIN
    DECLARE cliente_exists INT;
    DECLARE direccion_exists INT;
    DECLARE zona_cliente INT;
   	DECLARE municipio_cliente INT;
    DECLARE restaurante_id_found VARCHAR(100);
   	DECLARE restaurante_exists INT;

    SET cliente_exists = 0;
    SET direccion_exists = 0;
    SET restaurante_id_found = NULL;
	SET restaurante_exists = 0;

    SELECT COUNT(*) INTO cliente_exists FROM clientes WHERE dpi = dpi_cliente_in;
    IF (cliente_exists = 0) THEN
        SELECT CONCAT("ERROR: El cliente con DPI '", dpi_cliente_in, "' no existe.") AS ERROR;
        LEAVE crearOrden;
    END IF;

    SELECT COUNT(*) INTO direccion_exists FROM direcciones d WHERE d.id_direccion = id_direccion_cliente_in AND d.dpi_cliente = dpi_cliente_in;
    IF (direccion_exists = 0) THEN
        SELECT CONCAT("ERROR: La dirección con ID '", id_direccion_cliente_in, "' no existe o no le pertenece al client con dpi ", dpi_cliente_in, ".") AS ERROR;
        LEAVE crearOrden;
    END IF;

    IF (canal_in NOT IN ('L', 'A')) THEN
        SELECT "ERROR: El valor del canal debe ser 'L' o 'A'." AS ERROR;
        LEAVE crearOrden;
    END IF;

    SELECT zona INTO zona_cliente FROM direcciones WHERE id_direccion = id_direccion_cliente_in;
   	SELECT municipio_id INTO municipio_cliente FROM direcciones WHERE id_direccion = id_direccion_cliente_in;
    SELECT id_restaurante INTO restaurante_id_found FROM restaurantes WHERE zona = zona_cliente AND municipio_id = municipio_cliente LIMIT 1;
	SELECT COUNT(*) INTO restaurante_exists FROM restaurantes WHERE (zona = zona_cliente AND municipio_id = municipio_cliente);
  	IF (restaurante_exists = 0) THEN
		INSERT INTO ordenes(dpi_cliente, direccion_id, restaurante_id, canal_pedido, fecha_inicio, estado)
    	VALUES(dpi_cliente_in, id_direccion_cliente_in, restaurante_id_found, canal_in, NOW(), 'SIN COBERTURA');
    	SELECT CONCAT("WARNING: Orden '", LAST_INSERT_ID(), "' registrada, pero sin COBERTURA.") AS MENSAJE;
	ELSE
		INSERT INTO ordenes(dpi_cliente, direccion_id, restaurante_id, canal_pedido, fecha_inicio, estado)
    	VALUES(dpi_cliente_in, id_direccion_cliente_in, restaurante_id_found, canal_in, NOW(), 'INICIADA');
    	SELECT CONCAT("Orden '", LAST_INSERT_ID(), "' registrada.") AS MENSAJE;
	END IF;
    
END $$
DELIMITER ;


/**************************#7 *********************************/
DELIMITER $$
DROP PROCEDURE IF EXISTS AgregarItem $$
CREATE PROCEDURE AgregarItem(
    IN id_orden_in INT,
    IN producto_tipo_in CHAR(1),
    IN id_producto_in INT UNSIGNED,
    IN cantidad_in INT,
    IN observacion_in VARCHAR(100)
)
agregarItem:BEGIN
    DECLARE orden_exists INT;
    DECLARE producto_exists INT;
	DECLARE order_status VARCHAR(20);
    SET orden_exists = 0;
    SET producto_exists = 0;

    SELECT COUNT(*) INTO orden_exists FROM ordenes WHERE id_orden = id_orden_in;

    IF (orden_exists = 0) THEN
        SELECT CONCAT("ERROR: La orden con ID '", id_orden_in, "' no existe.") AS ERROR;
        LEAVE agregarItem;
    END IF;

    SELECT COUNT(*) INTO producto_exists FROM productos WHERE producto_tipo = UPPER(producto_tipo_in) AND id_producto = id_producto_in;
    IF (producto_exists = 0) THEN
        SELECT CONCAT("ERROR: El producto con tipo '", producto_tipo_in, "' y ID '", id_producto_in, "' no existe.") AS ERROR;
        LEAVE agregarItem;
    END IF;

    IF (cantidad_in <= 0) THEN
        SELECT "ERROR: La cantidad debe ser mayor a 0." AS ERROR;
        LEAVE agregarItem;
    END IF;
   	SELECT estado INTO order_status FROM ordenes WHERE id_orden = id_orden_in;
   	IF (order_status NOT IN ('INICIADA', 'AGREGANDO')) THEN
        SELECT CONCAT("ERROR: La orden debe tener estado 'INICIADA' o 'AGREGANDO'. Actualmente esta como: ", order_status)AS ERROR;
        LEAVE agregarItem;
    END IF;
	UPDATE ordenes SET estado = 'AGREGANDO' WHERE id_orden = id_orden_in AND estado = 'INICIADA';
    INSERT INTO detalle_ordenes(orden_id, producto_tipo, id_producto, cantidad, observacion)
    VALUES(id_orden_in, UPPER(producto_tipo_in), id_producto_in, cantidad_in, observacion_in);
    -- ON DUPLICATE KEY UPDATE
    --    cantidad = cantidad_in;
    SELECT CONCAT("Detalle de orden actualizado para orden '", id_orden_in, "', producto tipo '", producto_tipo_in, "' y ID '", id_producto_in, "'.") AS MENSAJE;
END $$
DELIMITER ;


/**************************#8 *********************************/
DELIMITER $$
DROP PROCEDURE IF EXISTS ConfirmarOrden $$
CREATE PROCEDURE ConfirmarOrden(
    IN id_orden_in INT,
    IN forma_pago_in CHAR(1),
    IN id_repartidor_in INT(8)
)
confirmarOrden:BEGIN
    DECLARE order_status VARCHAR(20);
    DECLARE repartidor_exists INT;
    DECLARE repartidor_restaurante_id VARCHAR(100);
    DECLARE orden_restaurante_id VARCHAR(100);
    DECLARE current_year CHAR(4);
    DECLARE serial_number_new VARCHAR(15);
    DECLARE monto_total_new DECIMAL(10,2);
	DECLARE cliente_municipio INT;
	DECLARE cliente_nit INT;
	DECLARE order_exists INT;

    SET order_status = '';
    SET repartidor_exists = 0;
    SET repartidor_restaurante_id = '';
    SET orden_restaurante_id = '';
	SET order_exists  = 0;

	SELECT COUNT(*) INTO order_exists  FROM ordenes WHERE id_orden = id_orden_in;
	IF (order_exists = 0) THEN
		SELECT "ERROR: La orden no existe'." AS ERROR;
        LEAVE confirmarOrden;
	END IF;
    SELECT estado, restaurante_id INTO order_status, orden_restaurante_id FROM ordenes WHERE id_orden = id_orden_in;
    IF (order_status != 'AGREGANDO') THEN
        SELECT "ERROR: La orden debe tener estado 'AGREGANDO'." AS ERROR;
        LEAVE confirmarOrden;
    END IF;

    SELECT COUNT(*) INTO repartidor_exists  FROM empleados WHERE id_empleado = id_repartidor_in;
	
    IF (repartidor_exists = 0) THEN
        SELECT CONCAT("ERROR: El repartidor con ID '", id_repartidor_in, "' no existe.") AS ERROR;
        LEAVE confirmarOrden;
    END IF;

    SELECT COUNT(*) INTO repartidor_exists  FROM empleados WHERE id_empleado = id_repartidor_in AND restaurante_id = orden_restaurante_id;
    IF (repartidor_exists = 0 ) THEN
        SELECT "ERROR: El repartidor y la orden no pertenecen al mismo restaurante." AS ERROR;
        LEAVE confirmarOrden;
    END IF;
	
   	SELECT c.nit INTO cliente_nit FROM clientes c JOIN ordenes o ON c.dpi = o.dpi_cliente WHERE o.id_orden = id_orden_in;
   	SELECT d.municipio_id INTO cliente_municipio FROM direcciones d JOIN ordenes o ON o.direccion_id = d.id_direccion WHERE o.id_orden = id_orden_in;

   
    SET forma_pago_in = UPPER(forma_pago_in);
    IF (forma_pago_in NOT IN ('E', 'T')) THEN
        SELECT "ERROR: La forma de pago debe ser 'E' o 'T'." AS ERROR;
        LEAVE confirmarOrden;
    END IF;

    UPDATE ordenes
    SET estado = 'EN CAMINO', id_repartidor = id_repartidor_in
    WHERE id_orden = id_orden_in;

    SET current_year = YEAR(NOW());
    SET serial_number_new = CONCAT(current_year, id_orden_in);

    SELECT SUM(do.cantidad * p.precio) INTO monto_total_new
    FROM detalle_ordenes do
    JOIN productos p ON do.producto_tipo = p.producto_tipo AND do.id_producto = p.id_producto
    WHERE do.orden_id = id_orden_in;
	SET monto_total_new = monto_total_new * 0.12 + monto_total_new;

    INSERT INTO facturas(serial_number, monto_total, lugar, confirmacion_datetime, orden_id, nit, forma_pago)
    VALUES(serial_number_new, monto_total_new, cliente_municipio, NOW(), id_orden_in, cliente_nit, forma_pago_in);
    SELECT CONCAT("Orden '", id_orden_in, "' confirmada.") AS MENSAJE;
END $$
DELIMITER ;

/**************************#9 *********************************/
DELIMITER $$
DROP PROCEDURE IF EXISTS FinalizarOrden $$
CREATE PROCEDURE FinalizarOrden(
    IN id_orden_in INT
)
finalizarOrden:BEGIN
    DECLARE order_status VARCHAR(20);
	DECLARE order_exists INT;

    SET order_status = '';
	SET order_exists = 0;

	SELECT COUNT(*) INTO order_exists  FROM ordenes WHERE id_orden = id_orden_in;
	IF (order_exists = 0) THEN
		SELECT "ERROR: La orden no existe'." AS ERROR;
        LEAVE finalizarOrden;
	END IF;

    SELECT estado INTO order_status
    FROM ordenes
    WHERE id_orden = id_orden_in;

    IF (order_status != 'EN CAMINO') THEN
        SELECT "ERROR: La orden debe tener estado 'EN CAMINO'." AS ERROR;
        LEAVE finalizarOrden;
    END IF;

    UPDATE ordenes
    SET estado = 'ENTREGADA', fecha_entrega = NOW()
    WHERE id_orden = id_orden_in;

    SELECT CONCAT("Orden '", id_orden_in, "' finalizada.") AS MENSAJE;
END $$
DELIMITER ;




















