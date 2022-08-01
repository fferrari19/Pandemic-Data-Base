-- Listar la cantidad de recuperados que registró cada hospital y la cant de respiradores que están siendo utilizados
WITH RecHosp AS
(SELECT Hospital_ID, COUNT(DNI) AS CantRecuperados
 FROM Recuperados JOIN(
	SELECT * FROM Internado JOIN Hospital
    USING (Hospital_ID)) AS a
USING(DNI)
GROUP BY Hospital_ID
),
RespHosp AS
(SELECT Hospital_ID, COUNT(DNI) AS CantRespiradores
FROM Pacientes JOIN Internado
USING (DNI)
WHERE (Tratamiento LIKE '%RM%')
GROUP BY Hospital_ID 
)
SELECT * FROM RespHosp JOIN RecHosp
USING(Hospital_ID)
ORDER BY Hospital_ID