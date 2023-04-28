/****************************Municipios******************************************/
-- INSERT trigger
DELIMITER $$
CREATE TRIGGER municipios_after_insert
AFTER INSERT
ON municipios FOR EACH ROW
BEGIN
  INSERT INTO events_log (event_datetime, table_name, event_type)
  VALUES (NOW(), 'municipios', 'INSERT');
END $$
DELIMITER ;

-- UPDATE trigger
DELIMITER $$
CREATE TRIGGER municipios_after_update
AFTER UPDATE
ON municipios FOR EACH ROW
BEGIN
  INSERT INTO events_log (event_datetime, table_name, event_type)
  VALUES (NOW(), 'municipios', 'UPDATE');
END $$
DELIMITER ;

-- DELETE trigger
DELIMITER $$
CREATE TRIGGER municipios_after_delete
AFTER DELETE
ON municipios FOR EACH ROW
BEGIN
  INSERT INTO events_log (event_datetime, table_name, event_type)
  VALUES (NOW(), 'municipios', 'DELETE');
END $$
DELIMITER ;

/************************************RESTAURANTES*********************************/
-- INSERT trigger
DELIMITER $$
CREATE TRIGGER restaurantes_after_insert
AFTER INSERT
ON restaurantes FOR EACH ROW
BEGIN
  INSERT INTO events_log (event_datetime, table_name, event_type)
  VALUES (NOW(), 'restaurantes', 'INSERT');
END $$
DELIMITER ;

-- UPDATE trigger
DELIMITER $$
CREATE TRIGGER restaurantes_after_update
AFTER UPDATE
ON restaurantes FOR EACH ROW
BEGIN
  INSERT INTO events_log (event_datetime, table_name, event_type)
  VALUES (NOW(), 'restaurantes', 'UPDATE');
END $$
DELIMITER ;

-- DELETE trigger
DELIMITER $$
CREATE TRIGGER restaurantes_after_delete
AFTER DELETE
ON restaurantes FOR EACH ROW
BEGIN
  INSERT INTO events_log (event_datetime, table_name, event_type)
  VALUES (NOW(), 'restaurantes', 'DELETE');
END $$
DELIMITER ;

/********************************Puestos**************************************/
-- INSERT trigger
DELIMITER $$
CREATE TRIGGER puestos_after_insert
AFTER INSERT
ON puestos FOR EACH ROW
BEGIN
  INSERT INTO events_log (event_datetime, table_name, event_type)
  VALUES (NOW(), 'puestos', 'INSERT');
END $$
DELIMITER ;

-- UPDATE trigger
DELIMITER $$
CREATE TRIGGER puestos_after_update
AFTER UPDATE
ON puestos FOR EACH ROW
BEGIN
  INSERT INTO events_log (event_datetime, table_name, event_type)
  VALUES (NOW(), 'puestos', 'UPDATE');
END $$
DELIMITER ;

-- DELETE trigger
DELIMITER $$
CREATE TRIGGER puestos_after_delete
AFTER DELETE
ON puestos FOR EACH ROW
BEGIN
  INSERT INTO events_log (event_datetime, table_name, event_type)
  VALUES (NOW(), 'puestos', 'DELETE');
END $$
DELIMITER ;


/****************************EMPLEADOS****************************************/
-- INSERT trigger
DELIMITER $$
CREATE TRIGGER empleados_after_insert
AFTER INSERT
ON empleados FOR EACH ROW
BEGIN
  INSERT INTO events_log (event_datetime, table_name, event_type)
  VALUES (NOW(), 'empleados', 'INSERT');
END $$
DELIMITER ;

-- UPDATE trigger
DELIMITER $$
CREATE TRIGGER empleados_after_update
AFTER UPDATE
ON empleados FOR EACH ROW
BEGIN
  INSERT INTO events_log (event_datetime, table_name, event_type)
  VALUES (NOW(), 'empleados', 'UPDATE');
END $$
DELIMITER ;

-- DELETE trigger
DELIMITER $$
CREATE TRIGGER empleados_after_delete
AFTER DELETE
ON empleados FOR EACH ROW
BEGIN
  INSERT INTO events_log (event_datetime, table_name, event_type)
  VALUES (NOW(), 'empleados', 'DELETE');
END $$
DELIMITER ;


/****************************Clientes***************************************/
-- INSERT trigger
DELIMITER $$
CREATE TRIGGER clientes_after_insert
AFTER INSERT
ON clientes FOR EACH ROW
BEGIN
  INSERT INTO events_log (event_datetime, table_name, event_type)
  VALUES (NOW(), 'clientes', 'INSERT');
END $$
DELIMITER ;

-- UPDATE trigger
DELIMITER $$
CREATE TRIGGER clientes_after_update
AFTER UPDATE
ON clientes FOR EACH ROW
BEGIN
  INSERT INTO events_log (event_datetime, table_name, event_type)
  VALUES (NOW(), 'clientes', 'UPDATE');
END $$
DELIMITER ;

-- DELETE trigger
DELIMITER $$
CREATE TRIGGER clientes_after_delete
AFTER DELETE
ON clientes FOR EACH ROW
BEGIN
  INSERT INTO events_log (event_datetime, table_name, event_type)
  VALUES (NOW(), 'clientes', 'DELETE');
END $$
DELIMITER ;
/************************Direcciones *********************************/
-- INSERT trigger
DELIMITER $$
CREATE TRIGGER direcciones_after_insert
AFTER INSERT
ON direcciones FOR EACH ROW
BEGIN
  INSERT INTO events_log (event_datetime, table_name, event_type)
  VALUES (NOW(), 'direcciones', 'INSERT');
END $$
DELIMITER ;

-- UPDATE trigger
DELIMITER $$
CREATE TRIGGER direcciones_after_update
AFTER UPDATE
ON direcciones FOR EACH ROW
BEGIN
  INSERT INTO events_log (event_datetime, table_name, event_type)
  VALUES (NOW(), 'direcciones', 'UPDATE');
END $$
DELIMITER ;

-- DELETE trigger
DELIMITER $$
CREATE TRIGGER direcciones_after_delete
AFTER DELETE
ON direcciones FOR EACH ROW
BEGIN
  INSERT INTO events_log (event_datetime, table_name, event_type)
  VALUES (NOW(), 'direcciones', 'DELETE');
END $$
DELIMITER ;


/**********************Ordenes**********************************/
-- INSERT trigger
DELIMITER $$
CREATE TRIGGER ordenes_after_insert
AFTER INSERT
ON ordenes FOR EACH ROW
BEGIN
  INSERT INTO events_log (event_datetime, table_name, event_type)
  VALUES (NOW(), 'ordenes', 'INSERT');
END $$
DELIMITER ;

-- UPDATE trigger
DELIMITER $$
CREATE TRIGGER ordenes_after_update
AFTER UPDATE
ON ordenes FOR EACH ROW
BEGIN
  INSERT INTO events_log (event_datetime, table_name, event_type)
  VALUES (NOW(), 'ordenes', 'UPDATE');
END $$
DELIMITER ;

-- DELETE trigger
DELIMITER $$
CREATE TRIGGER ordenes_after_delete
AFTER DELETE
ON ordenes FOR EACH ROW
BEGIN
  INSERT INTO events_log (event_datetime, table_name, event_type)
  VALUES (NOW(), 'ordenes', 'DELETE');
END $$
DELIMITER ;

/***************************Productos**********************/
-- INSERT trigger
DELIMITER $$
CREATE TRIGGER productos_after_insert
AFTER INSERT
ON productos FOR EACH ROW
BEGIN
  INSERT INTO events_log (event_datetime, table_name, event_type)
  VALUES (NOW(), 'productos', 'INSERT');
END $$
DELIMITER ;

-- UPDATE trigger
DELIMITER $$
CREATE TRIGGER productos_after_update
AFTER UPDATE
ON productos FOR EACH ROW
BEGIN
  INSERT INTO events_log (event_datetime, table_name, event_type)
  VALUES (NOW(), 'productos', 'UPDATE');
END $$
DELIMITER ;

-- DELETE trigger
DELIMITER $$
CREATE TRIGGER productos_after_delete
AFTER DELETE
ON productos FOR EACH ROW
BEGIN
  INSERT INTO events_log (event_datetime, table_name, event_type)
  VALUES (NOW(), 'productos', 'DELETE');
END $$
DELIMITER ;

/********************detalle_Orden****************************/
-- INSERT trigger
DELIMITER $$
CREATE TRIGGER detalle_ordenes_after_insert
AFTER INSERT
ON detalle_ordenes FOR EACH ROW
BEGIN
  INSERT INTO events_log (event_datetime, table_name, event_type)
  VALUES (NOW(), 'detalle_ordenes', 'INSERT');
END $$
DELIMITER ;

-- UPDATE trigger
DELIMITER $$
CREATE TRIGGER detalle_ordenes_after_update
AFTER UPDATE
ON detalle_ordenes FOR EACH ROW
BEGIN
  INSERT INTO events_log (event_datetime, table_name, event_type)
  VALUES (NOW(), 'detalle_ordenes', 'UPDATE');
END $$
DELIMITER ;

-- DELETE trigger
DELIMITER $$
CREATE TRIGGER detalle_ordenes_after_delete
AFTER DELETE
ON detalle_ordenes FOR EACH ROW
BEGIN
  INSERT INTO events_log (event_datetime, table_name, event_type)
  VALUES (NOW(), 'detalle_ordenes', 'DELETE');
END $$
DELIMITER ;

/*******************Facturas**********************************/
-- INSERT trigger
DELIMITER $$
CREATE TRIGGER facturas_after_insert
AFTER INSERT
ON facturas FOR EACH ROW
BEGIN
  INSERT INTO events_log (event_datetime, table_name, event_type)
  VALUES (NOW(), 'facturas', 'INSERT');
END $$
DELIMITER ;

-- UPDATE trigger
DELIMITER $$
CREATE TRIGGER facturas_after_update
AFTER UPDATE
ON facturas FOR EACH ROW
BEGIN
  INSERT INTO events_log (event_datetime, table_name, event_type)
  VALUES (NOW(), 'facturas', 'UPDATE');
END $$
DELIMITER ;

-- DELETE trigger
DELIMITER $$
CREATE TRIGGER facturas_after_delete
AFTER DELETE
ON facturas FOR EACH ROW
BEGIN
  INSERT INTO events_log (event_datetime, table_name, event_type)
  VALUES (NOW(), 'facturas', 'DELETE');
END $$
DELIMITER ;









