/*Contar cuántos pacientes fueron tratados con plasma convaleciente y cuántos recuperados son O- para
realizar donaciones.*/

WITH PC AS
(SELECT Tratamiento AS Categoría, COUNT(P.DNI) AS Cantidad 
FROM Pacientes AS P JOIN Registro_Paciente
USING (DNI)
WHERE (Tratamiento LIKE '%PC%' AND TipoSalida = 'A')
-- Me quedo con los dados de alta y que además son tratados con plasma convaleciente (entre otras cosas) --> LIKE
GROUP BY Tratamiento
),
CeroNeg AS 
(SELECT COUNT(DNI) AS Cantidad FROM Recuperados JOIN Pacientes
USING(DNI) 
WHERE (Fact_Sang = 'O-')
)
SELECT 'O-' AS Categoría, Cantidad FROM CeroNeg
UNION
SELECT * FROM PC
