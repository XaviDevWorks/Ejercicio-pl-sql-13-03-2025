/*
Aneu a Northwind.
Creeu un procediment que mostri les dades de shippers per pantalla.
*/
DELIMITER //
CREATE PROCEDURE showShippers()
BEGIN
    SELECT * FROM shippers;
END //
DELIMITER ;

/*
Aneu a la BD Northwind.
Mireu la taula customers.
Feu un procediment que comprovi si un CustomerID existeix. En cas de que exiteixi, que retorni el seu ContactName.
Si no existeix que mostri un missatge d'error.

Aquest procediment ha de tenir dos paràmetres (1 d'entrada i un de sortida).
*/
DELIMITER //
CREATE PROCEDURE checkCustomerID(
    IN vCustomerID VARCHAR(10), 
    OUT vContactName VARCHAR(50)
)
BEGIN
    DECLARE vExists INT;
    
    -- Comprovar si el CustomerID existeix
    SELECT COUNT(*) INTO vExists FROM customers WHERE CustomerID = vCustomerID;

    IF vExists > 0 THEN
        -- Si existeix, retornar el ContactName
        SELECT ContactName INTO vContactName FROM customers WHERE CustomerID = vCustomerID;
    ELSE
        -- Si no existeix, retornar un missatge d'error
        SET vContactName = 'ERROR: CustomerID no existeix';
    END IF;
END //
DELIMITER ;

/*
Aneu a la BD Northwind.
Mireu la taula orders.
Creeu una taula nova que es digui orders_bck i que tingui la mateixa estructura que la taula orders més una columna que es digui bck_date de tipus DATETIME.

Feu un procediment que usi un cursor per recòrrer tota la taula orders i que insereixi les files dins de la taula orders_bck afegint la data actual a l'última columna.
*/

CREATE PROCEDURE backUpOrders() ...

