/* Brindar toda la informacion que se tenga de kis empleados que tengan títulos relacionados a corazón o -tomías para 
enviárlos a otro sector totalmente aislado para cubrir los casos de infartos/cardiopatías que siguen llegando. */
SELECT DISTINCT Persona.DNI, Nombre, Apellido, Telefono, FechaNacimiento, Curso_ID, Titulos, Cursos 
FROM Persona JOIN(
    SELECT * FROM Emp_Trab
	JOIN (
		SELECT * FROM Cursó JOIN Titulos_Cursos
		USING (Curso_ID)) AS a
	USING (DNI)
	WHERE (Cursos LIKE '%heart%' OR Titulos LIKE '%tomy%')) AS b
USING(DNI)