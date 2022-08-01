/* De lo obtenido en el punto anterior, listar los que dieron positivo junto con su grupo
de convivientes (a fin ser alertados y puestos en cuarentena). También listar los
profesionales que trabajan en el mismo departamento para testearlos y decidir si
ponerlos en cuarentena. */
WITH MedEnf AS -- Selecciono los médicos/as y enfermeros/as junto con el hopital donde trabajan
(SELECT DNI, Hospital_ID, Cargo, Sector
 FROM Trabaja JOIN Empleado 
 USING (DNI)
 WHERE (Cargo = 'Medicina' OR Cargo = 'Enfermeria')
 ORDER BY DNI
),
MedEnfPos AS -- Selecciono los médicos/as y enfermeros/as que dieron positivo
(SELECT DNI, Cargo, Sector, Resultado, Hospital_ID
 FROM Triage JOIN 
		(SELECT * FROM MedEnf JOIN Realiza
		 USING(DNI)) AS a
USING(Triage_ID) 
WHERE (Resultado = 'P')
),
MedEnfConv AS -- Selecciono los médicos/as y enfermeros/as que dieron positivo y sus convivientes
(SELECT MedEnfPos.DNI, Sector, Hospital_ID, Conv_Nombre, Conv_Apellido, Conv_DNI, Parentesco
FROM MedEnfPos JOIN (SELECT DNI, Conv_DNI, Parentesco, Conv_Nombre, Conv_Apellido 
				   FROM Convive JOIN Convivientes
                   USING(Conv_DNI)) AS Conv
ON Conv.DNI = MedEnfPos.DNI
)
-- Finalmente junto los positivos con los empleados de su mismo sector y hospital.
SELECT MedEnfConv.DNI AS MedEnfPos, MedEnfConv.Sector, e.Hospital_ID, Conv_Nombre, Conv_Apellido, Conv_DNI, Parentesco, e.DNI AS MismoSector
FROM MedEnfConv JOIN (
	SELECT DNI, Hospital_ID, Sector
	FROM Trabaja JOIN Empleado 
	USING (DNI)) AS e
ON (e.Sector = MedEnfConv.Sector AND e.Hospital_ID = MedEnfConv.Hospital_ID)

