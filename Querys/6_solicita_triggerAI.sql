CREATE DEFINER=`root`@`localhost` TRIGGER `solicita_AFTER_INSERT` AFTER INSERT ON `solicita` FOR EACH ROW BEGIN
	UPDATE Deposito 
    SET Stock = Deposito.Stock - NEW.Cant_Sol
    WHERE (Deposito.Insumo_ID = NEW.Insumo_ID AND Deposito.Hospital_ID = NEW.Hospital_ID);
END