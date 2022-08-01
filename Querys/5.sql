/* Encontrar si hay suministros específicos que se pagaron más caros en un hospital que
en otro. Mostrar DNI, nombre y apellido del médico que los solicitó y todos los datos
del proveedor. */
WITH InsCaros AS 
(SELECT DISTINCT P.Insumo_ID, P.Hospital_ID, P.Precio, P.CUIT
FROM Provee AS P JOIN Provee AS A
ON (P.Hospital_ID <> A.Hospital_ID AND P.Insumo_ID = A.Insumo_ID)
WHERE (P.Precio > A.Precio)
ORDER BY Insumo_ID)

SELECT i.Insumo_ID, i.Hospital_ID, i.Precio, i.CUIT, d.DNI, d.Nombre, d.Apellido
FROM InsCaros AS i JOIN(
	SELECT r.DNI, Nombre, Apellido, Insumo_ID, Hospital_ID
    FROM  Solicita JOIN Persona AS r
    USING(DNI)) AS d
ON i.Insumo_ID = d.Insumo_ID AND i.Hospital_ID = d.Hospital_ID
ORDER BY Insumo_ID, Hospital_ID



