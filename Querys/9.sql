/* Mostrar para cada hospital, cuántos médicos y enfermeros fueron testeados por
COVID-19 por cada semana, y mostrar también el resultado obtenido del test. */
WITH MedEnf AS
(SELECT DNI, Hospital_ID, Cargo
 FROM Trabaja JOIN Empleado 
 USING (DNI)
 WHERE (Cargo = 'Medicina' OR Cargo = 'Enfermeria')
 ORDER BY Hospital_ID
)
SELECT Hospital_ID, Cargo AS Sector, Resultado, WEEK(Fecha) AS SemanaNro, COUNT(Triage_ID) AS CantTest
FROM Triage JOIN 
		(SELECT * FROM MedEnf JOIN Realiza
		USING(DNI)) AS a
USING(Triage_ID)
GROUP BY  Hospital_ID, Cargo, Resultado, SemanaNro
ORDER BY Hospital_ID, SemanaNro