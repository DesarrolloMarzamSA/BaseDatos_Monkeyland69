
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_genera_catalogo_fcias_lux_cul]
	@sucursal TINYINT
WITH ENCRYPTION
AS
	
--DECLARE @sucursal TINYINT
--SET @sucursal = 17
					
SELECT	RIGHT(REPLICATE(' ', 12) + CONVERT(VARCHAR(12), @sucursal), 12) +
		LEFT(CONVERT(VARCHAR(30), t1.descripcion) + REPLICATE(' ', 30), 30) +
		' ' +
		CASE
			WHEN clas_fis = 'N' THEN '  0.00'
			WHEN clas_fis = 'NA' THEN '  0.00'
			WHEN clas_fis = 'B' THEN '100.00'
			WHEN clas_fis = 'BA' THEN '100.00'
			WHEN clas_fis = 'H' THEN RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR(6), CONVERT(MONEY, t1.descto_prod )), 6)
			WHEN clas_fis = 'HA' THEN RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR(6), CONVERT(MONEY, t1.descto_prod )), 6)
		END +
		LEFT(CONVERT(VARCHAR(13), CONVERT(BIGINT, t1.cod_barras)) + REPLICATE(' ', 13), 13) +
		'  ' +
		CASE t1.grupo_est 
			WHEN 'PC01A' THEN RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR(9), CONVERT(MONEY, ROUND(t1.prec_farm, 2, 2) + (ROUND(t1.prec_farm, 2, 2) * 0.5))), 9)
			ELSE RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR(9), CONVERT(MONEY, ROUND(t1.prec_farm, 2, 2))), 9)
		END 
FROM	maestro_productos_baan t1 INNER JOIN inventario_baan t2 ON 
		t1.codigo = t2.codigo AND 
		t2.sucursal = @sucursal
WHERE	CONVERT(INT, t1.codigo) < dbo.gobierno() AND
		ISNUMERIC(t1.cod_barras) = 1 AND
		SUBSTRING(t1.status, 1,1) <> 'B' AND
		t2.piezas > 0
ORDER BY t1.descripcion

GO
