/* Contabilizar la cantidad de pacientes muertos, separándolos por grupos de
enfermedad preexistente (diabetes, cardiopatías, hipertensión arterial, insuficiencia
renal, insuficiencia respiratoria, obesidad mórbida, edad mayor a 75 años, por
ejemplo). */
WITH Mas75 AS 
(SELECT TipoSalida AS Tipo, COUNT(RP.DNI) AS Cantidad
FROM Registro_Paciente AS RP JOIN Persona -- Junto los registros con Persona para obtener tanto Fecha de Nacimiento como el tipo de salida que se registró
ON Persona.DNI = RP.DNI
WHERE (DATE_SUB(NOW(),INTERVAL 75 YEAR) > FechaNacimiento AND TipoSalida = 'B') -- Filtro a aquellos que sean menores de 75
)
SELECT 'Mas 75' AS Condicion, Cantidad FROM Mas75 
UNION 
SELECT TipoEnf AS Condicion , Cantidad FROM (
		SELECT Enf_Pac.Tipo AS TipoEnf, COUNT(RP.DNI) AS Cantidad
			FROM Enf_Pac JOIN Registro_Paciente AS RP  -- Utilizo la vista Enf_Pac
			ON RP.DNI = Enf_Pac.DNI
                    -- Filtro los tipos de enf deseadas según la Clasificación Internacional de Enfermedades (CIE) y por tipo de salida
			WHERE (Enf_Pac.Tipo = 21 OR Enf_Pac.Tipo = 9 OR Enf_Pac.Tipo = 4 OR Enf_Pac.Tipo = 10 OR Enf_Pac.Tipo = 14 AND TipoSalida = 'B')
			GROUP BY (TipoEnf) -- Agrupo para contar correctamente según tipo de enfermedad
			ORDER BY Cantidad DESC
) AS d


                
