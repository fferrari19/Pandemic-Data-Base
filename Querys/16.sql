-- Listar la cantidad de pacientes infectados (activos) por obra social
WITH PacOb AS
(SELECT * FROM Obra_Social JOIN Asegura USING (NumAfiliado)), 
Muertes AS
(SELECT DNI FROM Registro_Paciente JOIN Estado USING(Registro_ID)
WHERE (Estado = 'ACT')-- ACT: Activo
)

SELECT Empresa, COUNT(NumAfiliado) AS Cantidad 
FROM PacOb JOIN Muertes USING(DNI)
GROUP BY Empresa
ORDER BY Cantidad

