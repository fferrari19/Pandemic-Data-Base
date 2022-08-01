-- Listar la cantidad de camas ocupadas y disponibles que posee cada hospital tanto en terapia intensiva como en sala común 
WITH CamasHosp AS
(SELECT Hospital_ID, Cama_ID, Estado, Area
 FROM Hospital JOIN
	(SELECT Hospital_ID, Cama_ID, Estado, Area
     FROM Contiene JOIN Camas
	 USING(Cama_ID)	
    ) AS a
 USING(Hospital_ID)
)
SELECT Hospital_ID, Estado, Area, COUNT(Cama_ID) AS Cantidad
FROM CamasHosp 
GROUP BY Hospital_ID, Estado, Area