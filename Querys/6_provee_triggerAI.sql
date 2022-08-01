CREATE DEFINER=`root`@`localhost` TRIGGER `provee_AFTER_INSERT` AFTER INSERT ON `provee` FOR EACH ROW BEGIN
 DECLARE Cantidad int;
 SELECT Deposito.Stock
 INTO Cantidad FROM Deposito
 WHERE (Deposito.Insumo_ID = NEW.Insumo_ID AND Deposito.Hospital_ID = NEW.Hospital_ID);
 
 IF(Cantidad IS NULL)
    THEN -- No existe dicho insumo
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El insumo no existe para este hospital';
	ELSE
		UPDATE Deposito
		SET Stock = Deposito.Stock + NEW.Cantidad
		WHERE (Deposito.Insumo_ID = NEW.Insumo_ID AND Deposito.Hospital_ID = NEW.Hospital_ID);
	END IF;
END