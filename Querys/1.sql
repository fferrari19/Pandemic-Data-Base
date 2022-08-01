/* Mostrar el total de infectados, activos, recuperados y muertos en CABA, desde que
 comenzó a registrarse los datos de la pandemia, en marzo de 2020, mes a mes. */
WITH CantRecuperados AS
( SELECT MONTH(FechaAlta) AS Mes, COUNT(DNI) as Recuperados
	FROM Recuperados
    GROUP BY Mes
    ORDER BY Mes
), 
CantBajas AS 
( SELECT MONTH(DATE(Fecha)) AS Mes, COUNT(DNI) as Muertos
	FROM Registra JOIN Salidas
    ON Registra.Registro_ID = Salidas.Registro_ID
    WHERE Salidas.Tipo = 'B' -- B: Baja
    GROUP BY Mes
    ORDER BY Mes
),
CantActivos AS 
( SELECT MONTH(Actualizacion) AS Mes, COUNT(DNI) as Activos
	FROM Registra JOIN Estado
    ON Registra.Registro_ID = Estado.Registro_ID
    WHERE Estado.Estado = 'ACT' -- A: Activo
    GROUP BY Mes
    ORDER BY Mes	
),
t1 AS 
(SELECT CantRecuperados.Mes, Recuperados, Activos, Muertos 
FROM CantRecuperados LEFT JOIN
    (SELECT CantActivos.Mes, Activos, Muertos FROM 
	 CantActivos LEFT JOIN CantBajas 
	 ON CantActivos.Mes = CantBajas.Mes
     ) AS a
ON CantRecuperados.Mes= a.Mes
),
t2 AS
(SELECT  CB.Mes, Recuperados, Activos, t1.Muertos FROM
  t1 RIGHT JOIN CantBajas AS CB
 ON CB.Mes = t1.Mes
)

SELECT * FROM t1 
UNION
SELECT * FROM t2
GROUP BY Mes
ORDER BY Mes

-- Prueba de que con el INNER JOIN se pierden datos del mes 7.
/*
SELECT * FROM CantRecuperados JOIN(
	 SELECT * FROM CantBajas JOIN CantActivos
	 USING (Mes)) AS a
USING(Mes)
*/

-- SET SQL_SAFE_UPDATES=0;






 