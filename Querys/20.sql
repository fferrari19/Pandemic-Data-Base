/*Contar cuantas personas, tienen la oxigenacion debajo de la media y fiebre por encima de la media
diferenciando si pertenecen o no a algún grupo de riesgo y por el resultado del test */

WITH FiebOx AS
(
SELECT a.DNI, Nombre, Apellido, Telefono, FechaNacimiento, Residencia, Grupo_Riesgo, Resultado
FROM Triage as t JOIN (
	 SELECT * FROM Realiza JOIN Persona 
	 USING(DNI)) AS a
USING(Triage_ID)
WHERE(t.Fiebre > (SELECT AVG(t2.Fiebre) FROM Triage AS t2) 
AND t.Oxigenacion < (SELECT AVG(t1.Oxigenacion) FROM Triage AS t1))
)
SELECT Grupo_Riesgo, Resultado, COUNT(DNI) AS Cantidad FROM FiebOx
GROUP BY Grupo_Riesgo, Resultado