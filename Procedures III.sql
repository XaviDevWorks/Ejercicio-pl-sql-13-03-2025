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

CREATE PROCEDURE checkCustomerID(IN vCustomerID VARCHAR(??), OUT vContactName VARCHAR(??))

/*
Aneu a la BD Northwind.
Mireu la taula orders.
Creeu una taula nova que es digui orders_bck i que tingui la mateixa estructura que la taula orders més una columna que es digui bck_date de tipus DATETIME.

Feu un procediment que usi un cursor per recòrrer tota la taula orders i que insereixi les files dins de la taula orders_bck afegint la data actual a l'última columna.
*/

CREATE PROCEDURE backUpOrders() ...


-- Procediment per comprovar si un CustomerID existeix i retornar el ContactName
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

-- Crear la taula de backup orders_bck amb la mateixa estructura que orders més una columna extra
CREATE TABLE orders_bck AS
SELECT *, NOW() AS bck_date FROM orders WHERE 1=0;

-- Procediment per copiar totes les comandes a orders_bck amb la data actual
DELIMITER //
CREATE PROCEDURE backUpOrders()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE vOrderID INT;
    DECLARE vCustomerID VARCHAR(10);
    DECLARE vEmployeeID INT;
    DECLARE vOrderDate DATE;
    DECLARE vRequiredDate DATE;
    DECLARE vShippedDate DATE;
    DECLARE vShipVia INT;
    DECLARE vFreight DECIMAL(10,2);
    DECLARE vShipName VARCHAR(50);
    DECLARE vShipAddress VARCHAR(100);
    DECLARE vShipCity VARCHAR(50);
    DECLARE vShipRegion VARCHAR(50);
    DECLARE vShipPostalCode VARCHAR(20);
    DECLARE vShipCountry VARCHAR(50);
    
    -- Cursor per recórrer la taula orders
    DECLARE cur CURSOR FOR 
    SELECT OrderID, CustomerID, EmployeeID, OrderDate, RequiredDate, ShippedDate, ShipVia, Freight, ShipName, ShipAddress, ShipCity, ShipRegion, ShipPostalCode, ShipCountry 
    FROM orders;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO vOrderID, vCustomerID, vEmployeeID, vOrderDate, vRequiredDate, vShippedDate, vShipVia, vFreight, vShipName, vShipAddress, vShipCity, vShipRegion, vShipPostalCode, vShipCountry;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Inserir a la taula de backup amb la data actual
        INSERT INTO orders_bck 
        (OrderID, CustomerID, EmployeeID, OrderDate, RequiredDate, ShippedDate, ShipVia, Freight, ShipName, ShipAddress, ShipCity, ShipRegion, ShipPostalCode, ShipCountry, bck_date) 
        VALUES 
        (vOrderID, vCustomerID, vEmployeeID, vOrderDate, vRequiredDate, vShippedDate, vShipVia, vFreight, vShipName, vShipAddress, vShipCity, vShipRegion, vShipPostalCode, vShipCountry, NOW());
    END LOOP;

    CLOSE cur;
END //
DELIMITER ;
