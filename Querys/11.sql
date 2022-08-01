/*Contar la cantidad de empleados en cada hospital que sean mayores de 65 años 
y diferenciando según su cargo y si son directores o no con el fin de 
calcular cuantos entrarán en licencia durante este período*/

WITH Mayores65 AS 
(SELECT Trabaja.DNI, Nombre, Apellido, Cargo, Director, Hospital_ID
 FROM Trabaja JOIN (SELECT p.DNI, Nombre, Apellido, Cargo, Director FROM Empleado JOIN 
		(SELECT Persona.DNI, Nombre, Apellido, FechaNacimiento FROM Persona
		 WHERE (DATE_SUB(NOW(),INTERVAL 65 YEAR) > FechaNacimiento)) as p
		 ON Empleado.DNI = p.DNI) as b
	ON Trabaja.DNI = b.DNI
)
SELECT Cargo, Director, Hospital_ID, COUNT(DNI) AS Cantidad
FROM Mayores65 
GROUP BY Hospital_ID, Cargo, Director
ORDER BY Hospital_ID

