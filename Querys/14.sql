-- Listar el/los proveedor/es que abastecen a los tres hospitales con más casos confirmados y listar cuanto paga el hospital a cada proveedor
WITH HospMasCasos AS
(SELECT Hospital_ID, CasosConfirmados FROM Hospital
 ORDER BY CasosConfirmados DESC
 LIMIT 3
)
SELECT Hospital_ID, CasosConfirmados, CUIT, Nombre, Mail, SUM(Precio) 'PagoTotal($)'  
FROM HospMasCasos AS H JOIN
		(SELECT  Hospital_ID, CUIT, Nombre, Mail, Insumo_ID, Precio 
         FROM Provee JOIN Proveedor 
		 USING(CUIT)
		) AS a
USING (Hospital_ID)
GROUP BY Hospital_ID, CUIT -- Agrupo para sumar en cada hospital cuanto se le paga a cada proveedor