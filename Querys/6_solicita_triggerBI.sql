CREATE DEFINER = CURRENT_USER TRIGGER `BD_COVID-19`.`Solicita_BEFORE_INSERT` BEFORE INSERT ON `Solicita` FOR EACH ROW
BEGIN

	DECLARE Cantidad int;
	SELECT Deposito.Stock
    INTO Cantidad FROM Deposito 
    WHERE (Deposito.Insumo_ID = NEW.Insumo_ID AND Deposito.Hospital_ID = NEW.Hospital_ID);
    
    IF((Cantidad - NEW.Cant_sol) < 0)
    THEN 
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La cantidad solicitada es mayor que el stock disponible';
	END IF;




END
