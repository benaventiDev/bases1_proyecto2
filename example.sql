DROP DATABASE IF EXISTS bases1;
CREATE DATABASE bases1;
USE bases1;

CREATE TABLE player(username VARCHAR(25), 
nombre VARCHAR(100), 
fecha_nacimiento DATE, 
nivel INTEGER, 
PRIMARY KEY(username));

CREATE TABLE stadium(
id_stadium VARCHAR(25), 
nombre VARCHAR(100),  
PRIMARY KEY(id_stadium));

CREATE TABLE bitacora(
fecha_hora DATETIME, 
tabla VARCHAR(100),
tipo VARCHAR(25)
);

/******************Triggers************************/
DELIMITER $$
CREATE TRIGGER tr_bitacora_insert
AFTER INSERT ON player
FOR EACH ROW
BEGIN
INSERT INTO bitacora VALUES (CURDATE(), 'player', 'INSERT');
END $$

CREATE TRIGGER tr_bitacora_update
AFTER INSERT ON player
FOR EACH ROW
BEGIN
INSERT INTO bitacora VALUES (CURDATE(), 'player', 'UPDATE');
END $$

/***************************Validar Letras***********************************/
DELIMITER $$
DROP FUNCTION IF EXISTS ValidarLetras $$
CREATE FUNCTION ValidarLetras(cadena VARCHAR(100))
RETURNS BOOLEAN
DETERMINISTIC
BEGIN

DECLARE valido BOOLEAN;
/* VALIDAR CON REGEXP */
IF(SELECT REGEXP_INSTR(cadena, '[^a-zA-Z ]')=0) THEN
	SELECT TRUE INTO valido;
ELSE
	SELECT FALSE INTO valido;
END IF;
-- return the boolean
RETURN(valido);
END $$




/*********************Existe Usuario**************************/
DELIMITER $$
DROP FUNCTION IF EXISTS ExisteUsuario $$
CREATE FUNCTION ExisteUsuario(username VARCHAR(25))
RETURNS BOOLEAN
DETERMINISTIC
BEGIN

DECLARE existe BOOLEAN;
SELECT EXISTS (SELECT 1 FROM player p WHERE p.username = username) INTO existe;
-- returns the boolean
RETURN (existe);
END $$


/*************************Crear Jugador***************************************/
DELIMITER $$
DROP PROCEDURE IF EXISTS AddPlayer $$ CREATE PROCEDURE AddPlayer(
	IN username_in VARCHAR(25),
    IN nombre_in VARCHAR(100),
    IN fecha_nacimiento_in DATE
)
add_player:BEGIN

/* YA EXISTE */
IF(ExisteUsuario(username_in)) THEN
	SELECT 'EL Usuario ya existe.' AS ERROR;
    LEAVE add_player;
END IF;


/*VALIDAR LETRAS*/
IF (NOT ValidarLetras(nombre_in)) THEN
	SELECT 'EL NOMBRE SOLO DEBE CONTENER LETRAS.' AS ERROR;
    LEAVE add_player;
END IF;


/*FECHA INVALIDA*/
IF (SELECT TIMESTAMPDIFF(YEAR, fecha_nacimiento_in, CURDATE()) < 18) THEN
	SELECT 'DEBE SER MAYOR DE EDAD PARA PODER REGISTRARSE.' AS ERROR;
    LEAVE add_player;
END IF;

INSERT INTO player (username, nombre, fecha_nacimiento, nivel) VALUES(username_in, nombre_in, fecha_nacimiento_in, 0);


/* MENSAJE */
SELECT CONCAT("Jugador '", username_in, "' registrado.") AS MENSAJE;
END $$

/*********************** Actualizar nivel ********************/
DELIMITER $$
DROP PROCEDURE IF EXISTS UpdateLevel $$ CREATE PROCEDURE UpdateLevel(
	IN username_in VARCHAR(25),
    IN cantidad INT
)

update_level:BEGIN

-- DEclarar una variable auxiliar al inicio
DECLARE nivel_aux INT;

/* NO EXISTE */
IF (NOT ExisteUsuario(username_in)) THEN
	SELECT 'USUARIO NO EXISTE' AS ERROR;
    LEAVE update_level;
END IF;

-- Se asigna el valor original
SELECT nivel INTO nivel_aux FROM player WHERE username = username_in;
-- Le sumo la cantidad (podria ser un numero negativo y estaria bajando de nivel)
SET nivel_aux = nivel_aux + cantidad;

UPDATE player SET nivel = nivel_aux WHERE username = username_in;

/* MENSAJE */
SELECT CONCAT (username_in, " ahora es nivel ", nivel_aux) AS MENSAJE;
END $$


DELIMITER ;
CALL AddPlayer('ben', 'Benaventi Bernal Fuentes Roldan', '2015-01-25' );
CALL UpdateLevel('ben', 1);


SELECT * FROM player;
TRUNCATE player;


SELECT ValidarLetras('1');
SELECT ExisteUsuario('benaventi');
















