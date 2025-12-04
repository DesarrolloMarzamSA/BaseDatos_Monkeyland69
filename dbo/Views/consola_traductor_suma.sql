

CREATE view [dbo].[consola_traductor_suma]
as

SELECT 
	t2.descripcion sucursal, 
	ISNULL(COUNT(t1.archivo), 0) transmisiones ,
	CONVERT(VARCHAR(10), MAX(fecha), 108) reciente,
	CONVERT(VARCHAR(10), MIN(fecha), 108) antiguo
FROM monitoreo_traductor t1 
RIGHT OUTER JOIN sucursales t2 
	ON t1.sucursal = t2.sucursal 
WHERE
	t2.fisica = 1 OR t2.sucursal IN (24, 25)
GROUP BY t2.descripcion

GO

