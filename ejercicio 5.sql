/*
Crea una base de datos llamada ex_plsql y crea la tabla de persona (id (PK), nombre, apellido,
apellido2, correo, i DNI) e inserta datos para tres personas. 
*/
CREATE DATABASE ex_plsql;
USE ex_plsql;

CREATE TABLE persona (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido1 VARCHAR(50) NOT NULL,
    apellido2 VARCHAR(50),
    correo VARCHAR(100) NOT NULL UNIQUE,
    dni VARCHAR(9) NOT NULL UNIQUE
);

INSERT INTO persona (nombre, apellido1, apellido2, correo, dni) VALUES
('Carlos', 'Fernández', 'Gómez', 'carlos.fernandez@example.com', '12345678A'),
('Lucía', 'Martínez', 'Pérez', 'lucia.martinez@example.com', '87654321B'),
('Javier', 'López', 'Díaz', 'javier.lopez@example.com', '11223344C');

/*
Ejercicio 05 Tarea #2
Dado un DNI como parámetro de entrada, comprueba si existe el usuario con ese DNI. Devuelve por
un parámetro de salida el correo de esa persona. 
*/
DELIMITER $$

CREATE PROCEDURE ObtenercorreoPorDNI (
    IN p_dni VARCHAR(9), 
    OUT p_correo VARCHAR(100)
)
BEGIN
    SELECT correo INTO p_correo 
    FROM persona 
    WHERE dni = p_dni 
    LIMIT 1;
    
    IF p_correo IS NULL THEN
        SET p_correo = 'No encontrado';
    END IF;
END $$

DELIMITER ;

--Como usarlo
CALL ObtenercorreoPorDNI('12345678A', @correo);
SELECT @correo;

/*
Ejercicio 05 Tarea #3
Dado una id concreta como parámetro de entrada asegúrate que:
 El nombre y apellidos empiezan por una letra mayúscula y el resto son minúsculas.
 El correo está en letra minúscula.
 El DNI tiene 8 números y una letra al final. Si falta la letra, añadiremos la letra A por defecto.
Si faltan números añadiremos 0’s por la izquierda hasta que sea necesario.
Actualiza la fila correspondiente a la id de entrada con los parámetros editados. 
*/
DELIMITER $$

CREATE PROCEDURE FormatearDatosPersona (
    IN p_id INT
)
BEGIN
    UPDATE persona
    SET nombre = CONCAT(UPPER(LEFT(nombre, 1)), LOWER(SUBSTRING(nombre, 2))),
        apellido = CONCAT(UPPER(LEFT(apellido1, 1)), LOWER(SUBSTRING(apellido1, 2))),
        apellido2 = CONCAT(UPPER(LEFT(apellido2, 1)), LOWER(SUBSTRING(apellido2, 2))),
        correo = LOWER(correo),
        dni = CONCAT(
            LPAD(SUBSTRING(dni, 1, LENGTH(dni) - 1), 8, '0'), 
            IF(RIGHT(dni, 1) REGEXP '[A-Z]', RIGHT(dni, 1), 'A')
        )
    WHERE id = p_id;
END $$

DELIMITER ;
