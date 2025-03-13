/*
Crea una base de datos llamada ex_plsql y crea la tabla de persona (id (PK), nombre, apellido,
apellido2, email, i DNI) e inserta datos para tres personas. 
*/
CREATE DATABASE ex_plsql;
USE ex_plsql;

CREATE TABLE persona (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    apellido2 VARCHAR(50),
    email VARCHAR(100) NOT NULL UNIQUE,
    dni VARCHAR(9) NOT NULL UNIQUE
);

INSERT INTO persona (nombre, apellido, apellido2, email, dni) VALUES
('Carlos', 'Fernández', 'Gómez', 'carlos.fernandez@example.com', '12345678A'),
('Lucía', 'Martínez', 'Pérez', 'lucia.martinez@example.com', '87654321B'),
('Javier', 'López', 'Díaz', 'javier.lopez@example.com', '11223344C');

/*
Ejercicio 05 Tarea #2
Dado un DNI como parámetro de entrada, comprueba si existe el usuario con ese DNI. Devuelve por
un parámetro de salida el email de esa persona. 
*/
DELIMITER $$

CREATE PROCEDURE ObtenerEmailPorDNI (
    IN p_dni VARCHAR(9), 
    OUT p_email VARCHAR(100)
)
BEGIN
    SELECT email INTO p_email 
    FROM persona 
    WHERE dni = p_dni 
    LIMIT 1;
    
    IF p_email IS NULL THEN
        SET p_email = 'No encontrado';
    END IF;
END $$

DELIMITER ;

--Como usarlo
CALL ObtenerEmailPorDNI('12345678A', @email);
SELECT @email;

/*
Ejercicio 05 Tarea #3
Dado una id concreta como parámetro de entrada asegúrate que:
 El nombre y apellidos empiezan por una letra mayúscula y el resto son minúsculas.
 El email está en letra minúscula.
 El DNI tiene 8 números y una letra al final. Si falta la letra, añadiremos la letra A por defecto.
Si faltan números añadiremos 0’s por la izquierda hasta que sea necesario.
Actualiza la fila correspondiente a la id de entrada con los parámetros editados. 
*/
