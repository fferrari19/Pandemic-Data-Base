/*Mostrar para cada hospital, cuánto es el promedio semanal de recuperados y de
muertos en personas mayores de 70 años, separando por sexo y por lugar de
residencia (Ciudad Autónoma de Buenos Aires, Gran Buenos Aires, otros)*/
WITH Mas70 AS 
(SELECT Persona.DNI, Sexo, Residencia FROM Persona JOIN Pacientes 
ON Persona.DNI = Pacientes.DNI  
WHERE (DATE_SUB(NOW(),INTERVAL 70 YEAR) > FechaNacimiento)
),
Mas70Rec AS  -- Mayores de 70 recuperados
(SELECT Sexo, Residencia, MONTH(FechaAlta) AS Mes, Hospital_ID, COUNT(Recuperados.DNI) AS Cant
FROM Recuperados JOIN (  -- Se obtienen los Recuperados mayores de 70
	SELECT Internado.DNI, Sexo, Residencia, Hospital_ID
    FROM Mas70 JOIN Internado -- Se seleccionan los internados mayores de 70 y el hospital donde están internados
	ON Mas70.DNI = Internado.DNI) AS i
ON i.DNI = Recuperados.DNI 
GROUP BY  Mes, Hospital_ID, Sexo, Residencia -- Criterios para el conteo
ORDER BY Mes, Hospital_ID
),
Mas70Baja AS  -- Mayores de 70 fallecidos
(SELECT Sexo, Residencia, MONTH(FechaSalida) AS Mes, Hospital_ID, COUNT(RP.DNI) AS Cant
FROM Registro_Paciente AS RP JOIN (   -- Utilizo la Vista Registro_Pacientes
	SELECT Mas70.DNI, Sexo, Residencia, Hospital_ID  -- Se seleccionan los internados mayores de 70 y el hospital donde están internados
    FROM Mas70 JOIN Internado 
	ON  Internado.DNI = Mas70.DNI) AS d
ON d.DNI = RP.DNI 
WHERE (RP.TipoSalida = 'B') -- Se seleccionan los fallecidos (B)
GROUP BY Mes, Hospital_ID, Sexo, Residencia -- Criterios para el conteo
ORDER BY Mes, Hospital_ID
), 
/*
Ahora con t1 y t2 se emula un FULL JOIN haciendo left y right para tener los datos de todos los meses por 
si existen meses que no registraron bajas pero si recuperados o viceversa (puede ocurrir en fechas de comienzo de mes)
*/
t1 AS 
(SELECT MR.Mes, MR.Hospital_ID, MR.Cant AS CantRec , MB.Cant AS CantBaja, MR.Sexo, MR.Residencia
FROM Mas70Rec AS MR LEFT JOIN Mas70Baja AS MB
ON MR.Mes = MB.Mes
),
t2 AS 
(SELECT MB.Mes, MB.Hospital_ID, MR.Cant AS CantRec , MB.Cant AS CantBaja, MB.Sexo, MB.Residencia  
FROM Mas70Rec AS MR  RIGHT JOIN Mas70Baja AS MB
ON MR.Mes = MB.Mes 
)
/* 
Se calculan los promedios semanales teniendo la cantidad mensual para cada criterio (Hospital, Sexo y Residencia)
y a dichas cantidades se las divide por la cantidad de semanas del mes (4)
*/

SELECT Mes, Hospital_ID, Sexo, Residencia, CantRec/4 AS PromSemRec, CantBaja/4 AS PromSemBaja FROM t1
UNION 
SELECT Mes, Hospital_ID, Sexo, Residencia, CantRec/4 AS PromSemRec, CantBaja/4 AS PromSemBaja FROM t2
ORDER BY Mes, Hospital_ID 

-- Querys para probar cada tabla individualmente
-- SELECT * FROM Mas70Rec
-- SELECT * FROM Mas70Baja
-- SELECT * FROM t1 
-- SELECT * FROM t2 