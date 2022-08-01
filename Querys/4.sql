/* Encontrar la fecha en la que hubo mayor cantidad de muertos y mostrar los nombres
de enfermeros y enfermeras que trabajaron ese día.*/
WITH MasMuertes AS
(SELECT COUNT(DNI) AS CantidadBajas, Actualizacion AS Fecha
FROM (SELECT Pacientes.DNI, Estado, Actualizacion FROM Pacientes 
		JOIN ( SELECT DNI, Estado, Actualizacion FROM
				Registra JOIN Estado
				ON Registra.Registro_ID = Estado.Registro_ID
			 )AS Reg_Est
		ON Reg_Est.DNI = Pacientes.DNI
	 ) AS a
WHERE (Estado = 'B') -- B: Baja/Muerto
GROUP BY Actualizacion 
ORDER BY CantidadBajas DESC
LIMIT 2 -- Me quedo con los 2 días con mayores muertes por si 2 días poseen la misma cantidad de bajas
)
SELECT Persona.DNI, Apellido, Nombre, Fecha AS DiaConMasMuertes, CantidadBajas 
FROM Persona JOIN (
	SELECT DNI, Fecha,CantidadBajas FROM 
    Ing_Eg JOIN MasMuertes  
    ON DATE(Ing_Eg.Ingreso) = MasMuertes.Fecha -- Me quedo los DNI de los Empleados que ingresaron ese día
) as t1
ON t1.DNI = Persona.DNI
ORDER BY CantidadBajas DESC

