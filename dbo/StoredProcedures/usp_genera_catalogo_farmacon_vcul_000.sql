
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

--	usp_genera_catalogo_farmacon_vcul_000 3
CREATE PROCEDURE [dbo].[usp_genera_catalogo_farmacon_vcul_000]
	@sucursal TINYINT

AS

--DECLARE @sucursal TINYINT
--SET @sucursal = 3

SELECT 	RIGHT(REPLICATE('0', 7) + CONVERT(VARCHAR(7), t1.codigo), 7) +
		' ' +
		LEFT(CONVERT(VARCHAR(13), CONVERT(BIGINT, t1.cod_barras)) + REPLICATE(' ', 13), 13) +
		LEFT (CONVERT(VARCHAR(50), descripcion) + REPLICATE(' ', 50), 50) +
		CASE t1.grupo_est 
			WHEN 'PC01A' THEN RIGHT(REPLICATE('0', 7) + CONVERT(VARCHAR(7), CONVERT(INT, t1.prec_pub * 100 + (t1.prec_pub * 100 * 0.5))), 7)
			ELSE RIGHT(REPLICATE('0', 7) + CONVERT(VARCHAR(7), CONVERT(INT, t1.prec_pub * 100)), 7)
		END +
		CASE t1.grupo_est 
			WHEN 'PC01A' THEN RIGHT(REPLICATE('0', 7) + CONVERT(VARCHAR(7), CONVERT(INT, t1.prec_farm * 100 + (t1.prec_farm * 100 * 0.5))), 7)
			ELSE RIGHT(REPLICATE('0', 7) + CONVERT(VARCHAR(7), CONVERT(INT, t1.prec_farm * 100)), 7)
		END +
		CASE
			WHEN clas_fis = 'N' THEN '0000'
			WHEN clas_fis = 'NA' THEN '0000'
			WHEN clas_fis = 'B' THEN '9999'
			WHEN clas_fis = 'BA' THEN '9999'
			WHEN clas_fis = 'H' THEN RIGHT( '0000' + CONVERT(VARCHAR(4), CAST(t1.descto_prod*100 AS INT)), 4)
			WHEN clas_fis = 'HA' THEN RIGHT( '0000' + CONVERT(VARCHAR(4), CAST(t1.descto_prod*100 AS INT)), 4)
		END +
		CASE 
			WHEN clas_fis = 'NA' OR clas_fis = 'BA' THEN '1'
			ELSE '2'
		END +
		CASE
			WHEN clas_ssa BETWEEN 1 AND 6 THEN clas_ssa
			ELSE '0'
		END +
		
		CASE
			WHEN grupo_est = 'EZ01A' THEN 'S'
			ELSE 'N'
		END +
		CONVERT(VARCHAR(8), GETDATE(), 112)
FROM	maestro_productos_baan t1 INNER JOIN inventario_baan t2 ON
		t1.codigo = t2.codigo
WHERE 	t2.sucursal = @sucursal AND
		ISNUMERIC(t1.cod_barras) = 1 AND
		CONVERT(INT, t1.codigo) < dbo.gobierno() AND
		SUBSTRING(t1.status, 1,1) <> 'B' /*AND
		t2.piezas > 10*/
ORDER BY descripcion		



GO
