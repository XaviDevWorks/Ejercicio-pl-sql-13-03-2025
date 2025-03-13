/*Base de datos*/
CREATE DATABASE lscloud;
USE lscloud;

CREATE TABLE IF NOT EXISTS `usuario` (
  `id_usuario` int(11) NOT NULL AUTO_INCREMENT,
  `nick` varchar(20) NOT NULL,
  `mail` varchar(50) NOT NULL,
  `pais` varchar(20),
  `factura` boolean,
  PRIMARY KEY (`id_usuario`)
);

CREATE TABLE IF NOT EXISTS `servidor` (
  `id_servidor` int(11) NOT NULL AUTO_INCREMENT,
  `servername` varchar(50) NOT NULL,
  `hdd` int(11),
  `ram` int(11),
  `localizacion` varchar(50),
  `id_usuario` int(11),
  PRIMARY KEY (`id_servidor`)
);

CREATE TABLE IF NOT EXISTS `servidorstatus` (
  `id_servidor` int(11),
  `is_broken` boolean,
  `ram_upgrade` boolean,
  `ram_downgrade` boolean,
  PRIMARY KEY (`id_servidor`)
);

CREATE TABLE IF NOT EXISTS `alertas` (
  `id_alerta` int(11) NOT NULL AUTO_INCREMENT,
  `tipo_alerta` varchar(50) NOT NULL,
  `descripcion` varchar(50) NOT NULL,
  `motivo` varchar(50),
  `fecha_aleta` datetime NOT NULL,
  PRIMARY KEY (`id_alerta`)
);

ALTER TABLE servidor ADD FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE servidorstatus ADD FOREIGN KEY (id_servidor) REFERENCES servidor(id_servidor) ON UPDATE CASCADE ON DELETE CASCADE;

/*
Ejercicio 06
Crea un procedimiento llamado lsCloudLocation donde dada una localización a través de un
parámetro de entrada, nos guarde en un archivo el servername y Nick del usuario al que pertenece (1
por línea).
El nombre del fichero tiene que ser: location_NOMBRE-LOCALIZACION_FECHA-ACTUAL.txt (por ej.
Irlanda_YYYY-MM-DD.txt).
A parte, se tiene que guardar en un parámetro de salida el número de servidores que hay en esa
localización.
En el caso que no exista ningún servidor en la localización designada, hay que escribir en el fichero el
texto: ‘Localización noválida!’ 
*/

DELIMITER $$

CREATE PROCEDURE lsCloudLocation (
    IN p_localizacion VARCHAR(50),
    OUT p_total_servidores INT
)
BEGIN
    SELECT COUNT(*) INTO p_total_servidores 
    FROM servidor 
    WHERE localizacion = p_localizacion;

    IF p_total_servidores > 0 THEN
        SELECT s.servername, u.nick 
        INTO OUTFILE CONCAT('/var/lib/mysql-files/location_', p_localizacion, '_', CURDATE(), '.txt')
        FIELDS TERMINATED BY ' | '
        LINES TERMINATED BY '\n'
        FROM servidor s
        JOIN usuario u ON s.id_usuario = u.id_usuario
        WHERE s.localizacion = p_localizacion;
    END IF;
END $$

DELIMITER ;

/*Como usarlo*/