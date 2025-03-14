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
    DECLARE v_filename VARCHAR(100);
    DECLARE v_content VARCHAR(255);
    DECLARE v_servername VARCHAR(50);
    DECLARE v_nick VARCHAR(20);
    DECLARE done INT DEFAULT 0;
    DECLARE cur CURSOR FOR 
        SELECT s.servername, u.nick 
        FROM servidor s
        JOIN usuario u ON s.id_usuario = u.id_usuario
        WHERE s.localizacion = p_localizacion;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    SELECT COUNT(*) INTO p_total_servidores 
    FROM servidor 
    WHERE localizacion = p_localizacion;

    SET v_filename = CONCAT('location_', p_localizacion, '_', DATE_FORMAT(NOW(), '%Y-%m-%d'), '.txt');

    IF p_total_servidores > 0 THEN
        OPEN cur;
        read_loop: LOOP
            FETCH cur INTO v_servername, v_nick;
            IF done THEN
                LEAVE read_loop;
            END IF;
            SET v_content = CONCAT(v_servername, ' ', v_nick);
            SELECT v_content INTO OUTFILE v_filename
            FIELDS TERMINATED BY '\n';
        END LOOP;
        CLOSE cur;
    ELSE
        SET v_content = 'Localización noválida!';
        SELECT v_content INTO OUTFILE v_filename
        FIELDS TERMINATED BY '\n';
    END IF;
END $$

DELIMITER ;
