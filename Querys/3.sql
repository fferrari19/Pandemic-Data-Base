SELECT Medicamento, COUNT(Medicamento) as Cantidad
FROM Recuperados JOIN Medicacion
		ON Medicacion.DNI = Recuperados.DNI
GROUP BY Medicamento
ORDER BY Cantidad desc
limit 1