
CREATE PROCEDURE [dbo].[usp_genera_catalogo_fox_fcias_esquivar]
	@sucursal TINYINT
AS

--DECLARE @sucursal TINYINT
--SET @sucursal = 5

SELECT	t1.codigo +
		LEFT(t1.descripcion + REPLICATE(' ', 31), 31) + 
		CASE t1.grupo_est 
			WHEN 'PC01A' THEN right(REPLICATE('0', 10) + CONVERT(VARCHAR(10), ROUND(t1.prec_farm, 2, 2) + (ROUND(t1.prec_farm, 2, 2) * 0.5)), 10)
			ELSE RIGHT(REPLICATE('0', 10) + CONVERT(VARCHAR(10), ROUND(t1.prec_farm, 2, 2)), 10) 
		END +
		CASE t1.grupo_est 
			WHEN 'PC01A' THEN RIGHT(REPLICATE('0', 10) + CONVERT(VARCHAR(10), ROUND(t1.prec_pub, 2, 2) + (ROUND(t1.prec_pub, 2, 2) * 0.5)), 10)
			ELSE RIGHT(REPLICATE('0', 10) + CONVERT(VARCHAR(10), ROUND(t1.prec_pub, 2, 2)), 10) 
		END +
		LEFT(CONVERT(VARCHAR(13), CONVERT(BIGINT, t1.cod_barras)) + REPLICATE(' ', 13), 13) + 
		LEFT(t1.clas_fis + REPLICATE(' ', 2), 2) +
		CASE 
			WHEN t2.piezas = 0 THEN '0'
			WHEN t2.piezas BETWEEN 1 AND 49 THEN '1'
			WHEN t2.piezas BETWEEN 50 AND 99 THEN '2'
			WHEN t2.piezas BETWEEN 100 AND 149 THEN '3'
			WHEN t2.piezas >= 150 THEN '4'
			ELSE ' 0'
		END
FROM	maestro_productos_baan t1 INNER JOIN inventario_baan t2 ON 
		t1.codigo = t2.codigo AND 
		t2.sucursal = @sucursal
WHERE	CONVERT(INT, t1.codigo) < dbo.gobierno() AND
		ISNUMERIC(t1.cod_barras) = 1 AND
		SUBSTRING(t1.status, 1,1) <> 'B' 
ORDER BY t1.descripcion

GO

