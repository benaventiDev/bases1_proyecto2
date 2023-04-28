/************************************#1 ***************************************/
DELIMITER $$
DROP PROCEDURE IF EXISTS ListarRestaurantes $$
CREATE PROCEDURE ListarRestaurantes()
BEGIN
  SELECT 
    id_restaurante,
    direccion,
    municipio_id,
    zona,
    telefono,
    cantidad_personal,
    IF(parqueo_propio, 'SI', 'NO') AS parqueo_propio
  FROM
    restaurantes;
END $$
DELIMITER ;
/************************************#2 ***************************************/
DELIMITER $$
DROP PROCEDURE IF EXISTS ConsultarEmpleado $$
CREATE PROCEDURE ConsultarEmpleado(IN id_empleado_in INT(8) ZEROFILL)
BEGIN
  SELECT 
    e.id_empleado,
    CONCAT(e.nombre, ' ', e.apellido) AS nombre_completo,
    e.fecha_nacimiento,
    e.correo,
    e.telefono,
    e.direccion,
    e.dpi,
    p.nombre AS puesto,
    e.fecha_inicio_labores,
    p.salario
  FROM
    empleados e
  JOIN
    puestos p ON e.puesto_id = p.id_puesto
  WHERE
    e.id_empleado = id_empleado_in;
END $$
DELIMITER ;

/************************************#3 ***************************************/
DELIMITER $$
DROP PROCEDURE IF EXISTS ConsultarPedidosCliente $$
CREATE PROCEDURE ConsultarPedidosCliente(IN order_id_in INT)
BEGIN
  SELECT 
    pr.nombre AS producto,
    CASE pr.producto_tipo
      WHEN 'C' THEN 'Combo'
      WHEN 'E' THEN 'Extra'
      WHEN 'B' THEN 'Bebida'
      WHEN 'P' THEN 'Postre'
      ELSE 'Desconocido'
    END AS tipo,
    pr.precio,
    do.cantidad,
    do.observacion
  FROM
    detalle_ordenes do
  JOIN
    productos pr ON do.producto_tipo = pr.producto_tipo AND do.id_producto = pr.id_producto
  WHERE
    do.orden_id = order_id_in;
END $$
DELIMITER ;


/************************************#4 ***************************************/
DELIMITER $$
DROP PROCEDURE IF EXISTS ConsultarHistorialOrdenes $$
CREATE PROCEDURE ConsultarHistorialOrdenes(IN client_dpi_in BIGINT UNSIGNED)
BEGIN
  SELECT 
    o.id_orden,
    o.fecha_inicio,
    SUM(do.cantidad * pr.precio) AS Monto,
    o.restaurante_id,
    CONCAT(e.nombre, ' ', e.apellido) AS repartidor,
    d.direccion,
    CASE o.canal_pedido
      WHEN 'L' THEN 'Llamada'
      WHEN 'A' THEN 'Aplicacion'
      ELSE 'Desconocido'
    END AS canal_pedido
  FROM
    ordenes o
  JOIN
    detalle_ordenes do ON o.id_orden = do.orden_id
  JOIN
    productos pr ON do.producto_tipo = pr.producto_tipo AND do.id_producto = pr.id_producto
  JOIN
    empleados e ON o.id_repartidor = e.id_empleado
  JOIN
    direcciones d ON o.direccion_id = d.id_direccion
  WHERE
    o.dpi_cliente = client_dpi_in
  GROUP BY
    o.id_orden;
END $$
DELIMITER ;


/************************************#5 ***************************************/
DELIMITER $$
DROP PROCEDURE IF EXISTS ConsultarDirecciones $$
CREATE PROCEDURE ConsultarDirecciones(IN cliente_dpi BIGINT)
BEGIN
  SELECT 
    d.direccion,
    m.name_municipio,
    d.zona
  FROM
    direcciones d
  JOIN
    municipios m ON d.municipio_id = m.id_municipio
  WHERE
    d.dpi_cliente = cliente_dpi;
END $$
DELIMITER ;


/************************************#6 ***************************************/
DELIMITER $$
DROP PROCEDURE IF EXISTS MostrarOrdenes $$
CREATE PROCEDURE MostrarOrdenes(IN state_code INT)
BEGIN
  DECLARE state_name VARCHAR(20);

  CASE state_code
    WHEN 1 THEN SET state_name = 'INICIADA';
    WHEN 2 THEN SET state_name = 'AGREGADO';
    WHEN 3 THEN SET state_name = 'EN CAMINO';
    WHEN 4 THEN SET state_name = 'ENTREGADA';
    WHEN -1 THEN SET state_name = 'SIN COBERTURA';
  END CASE;

  SELECT 
    o.id_orden,
    o.estado,
    o.fecha_inicio,
    o.dpi_cliente,
    d.direccion,
    o.restaurante_id,
    CASE 
      WHEN o.canal_pedido = 'L' THEN 'Llamada'
      WHEN o.canal_pedido = 'A' THEN 'Aplicacion'
      ELSE o.canal_pedido
    END AS canal_pedido
  FROM
    ordenes o
  JOIN
    direcciones d ON o.direccion_id = d.id_direccion
  WHERE
    o.estado = state_name;
END $$
DELIMITER ;


/************************************#7 ***************************************/
DELIMITER $$
DROP PROCEDURE IF EXISTS ConsultarFacturas $$
CREATE PROCEDURE ConsultarFacturas(IN dia INT, IN mes INT, IN anio INT)
BEGIN
  SELECT 
    f.serial_number,
    f.monto_total,
    m.name_municipio,
    f.confirmacion_datetime,
    f.orden_id,
    IFNULL(CAST(f.nit AS CHAR(15)), 'C/F') AS nit,
    CASE
      WHEN f.forma_pago = 'E' THEN 'Efectivo'
      WHEN f.forma_pago = 'T' THEN 'Tarjeta'
      ELSE f.forma_pago
    END AS forma_pago
  FROM
    facturas f
  JOIN municipios m ON m.id_municipio = f.lugar
  WHERE
    DAY(confirmacion_datetime) = dia AND
    MONTH(confirmacion_datetime) = mes AND
    YEAR(confirmacion_datetime) = anio;
END $$
DELIMITER ;


/************************************#8 ***************************************/
DELIMITER $$
DROP PROCEDURE IF EXISTS ConsultarTiempos $$
CREATE PROCEDURE ConsultarTiempos(IN tiempoEsperaMinutos INT)
BEGIN
  SELECT 
    o.id_orden,
    d.direccion,
    o.fecha_inicio,
    TIMESTAMPDIFF(MINUTE, o.fecha_inicio, o.fecha_entrega) AS wait_time,
    CONCAT(e.nombre, ' ', e.apellido) AS nombre_repartidor
  FROM
    ordenes o
  JOIN
    direcciones d ON o.direccion_id = d.id_direccion
  JOIN
    empleados e ON o.id_repartidor = e.id_empleado
  WHERE
    TIMESTAMPDIFF(MINUTE, o.fecha_inicio, o.fecha_entrega) >= tiempoEsperaMinutos;
END $$
DELIMITER ;















