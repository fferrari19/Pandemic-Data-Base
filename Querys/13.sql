/*Contar cuántos menores de 18 años dieron positivo, cuántos 
tienen enfermedades previas y cuántos fallecieron*/

-- Selecciono los pacientes menores de edad y que además dieron positivo
WITH MenoresEdadPos AS 
(SELECT * FROM Pacientes JOIN Persona USING(DNI)
WHERE (DATE_SUB(NOW(),INTERVAL 18 YEAR) < FechaNacimiento AND Test = 'P')),
-- Selecciono los menores de 18 que fallecieron
MenoresBaja AS 
(SELECT COUNT(DNI) AS Fallecidos 
FROM Registro_Paciente JOIN MenoresEdadPos 
USING(DNI)
WHERE(TipoSalida = 'B')
),
-- Cuento cuántos menores de edad dieron positivo y cuántos tienen enf_previas
EnfPrevMenores AS 
(SELECT COUNT(DNI) AS MenoresPositivos, COUNT(Enfermedad) AS ConEnfPrev 
	FROM MenoresEdadPos LEFT JOIN Enf_Pac USING(DNI)) /*Left join con la vista Enf_Pac para obtener tanto 
														los que tienen enf previas como los que no */
-- CROSS JOIN para agrupar todos con todo.
SELECT * FROM 
EnfPrevMenores
CROSS JOIN
MenoresBaja											  