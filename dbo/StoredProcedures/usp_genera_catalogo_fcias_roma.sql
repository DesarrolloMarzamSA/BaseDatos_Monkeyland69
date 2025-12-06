
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_genera_catalogo_fcias_roma]
	@sucursal TINYINT

AS
	
--DECLARE @sucursal TINYINT
--SET @sucursal = 25
					
SELECT	RIGHT(REPLICATE('0', 8) + CONVERT(VARCHAR(8), t1.codigo), 8) +
		' ' + 
		LEFT(CONVERT(VARCHAR(30), t1.descripcion) + REPLICATE(' ', 30), 30) +
		'00000' + 
		CASE t1.grupo_est 
			WHEN 'PC01A' THEN RIGHT(REPLICATE('0', 9) + CONVERT(VARCHAR(9), CONVERT(INT, t1.prec_pub * 100 + (t1.prec_pub * 100 * 0.5))), 9)
			ELSE RIGHT(REPLICATE('0', 9) + CONVERT(VARCHAR(9), CONVERT(INT, t1.prec_pub * 100)), 9)
		END +
		CASE t1.grupo_est 
			WHEN 'PC01A' THEN RIGHT(REPLICATE('0', 9) + CONVERT(VARCHAR(9), CONVERT(INT, t1.prec_farm * 100 + (t1.prec_farm * 100 * 0.5))), 9)
			ELSE RIGHT(REPLICATE('0', 9) + CONVERT(VARCHAR(9), CONVERT(INT, t1.prec_farm * 100)), 9)
		END +		
		'03' +
		LEFT(CONVERT(VARCHAR(13), CONVERT(BIGINT, t1.cod_barras)) + REPLICATE(' ', 13), 13) +
		' ' +
		REPLICATE('0', 21) + 
		'1' +
		CASE
			WHEN t1.refrigerado = 'R' THEN '1'
			ELSE '0'
		END +
		CASE
			WHEN t1.clas_ssa BETWEEN 1 AND 3 THEN '1'
			ELSE '0'
		END +
		SUBSTRING(t1.lab_corto, 1, 3)
FROM	maestro_productos_baan t1 INNER JOIN inventario_baan t2 ON 
		t1.codigo = t2.codigo AND 
		t2.sucursal = @sucursal
WHERE	CONVERT(INT, t1.codigo) < dbo.gobierno() AND
		ISNUMERIC(t1.cod_barras) = 1 AND
		SUBSTRING(t1.status, 1,1) <> 'B' AND
		t2.piezas > 0
ORDER BY t1.descripcion

GO
