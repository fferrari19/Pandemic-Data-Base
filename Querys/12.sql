-- Mostrar los viajeros que pertenecen al grupo de riesgo y dieron positivo y aislar a los convivientes
WITH Viajeros AS
(SELECT  DNI, Nombre, Apellido, Destino 
 FROM Persona JOIN 
	(SELECT * FROM Viajo JOIN Viaje
	 USING(Viaje_ID)
    ) AS a
 USING (DNI)
),
ViajerosPositivos AS
(SELECT * FROM Viajeros JOIN 
	(SELECT * FROM Realiza JOIN Triage
     USING(Triage_ID)) AS b
 USING (DNI)
 WHERE (Resultado = 'P' AND Grupo_Riesgo = 'S')
)
SELECT DNI, Nombre, Apellido, Destino, Conv_DNI, Conv_Nombre, Conv_Apellido 
FROM ViajerosPositivos JOIN
	(SELECT * FROM Convive JOIN Convivientes
     USING(Conv_DNI)) AS c
USING(DNI)