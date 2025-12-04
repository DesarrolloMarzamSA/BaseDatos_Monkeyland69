
CREATE PROCEDURE [dbo].[usp_genera_cambios_fcias_roma]
AS
SELECT	RIGHT(REPLICATE('0', 8) + CONVERT(VARCHAR(8), t2.codigo), 8) +
		' ' + 
		LEFT(CONVERT(VARCHAR(30), t2.descripcion) + REPLICATE(' ', 30), 30) +
		'00000' + 
		CASE t2.grupo_est 
			WHEN 'PC01A' THEN RIGHT(REPLICATE('0', 9) + CONVERT(VARCHAR(9), CONVERT(INT, t2.prec_pub * 100 + (t2.prec_pub * 100 * 0.5))), 9)
			ELSE RIGHT(REPLICATE('0', 9) + CONVERT(VARCHAR(9), CONVERT(INT, t2.prec_pub * 100)), 9)
		END +
		CASE t2.grupo_est 
			WHEN 'PC01A' THEN RIGHT(REPLICATE('0', 9) + CONVERT(VARCHAR(9), CONVERT(INT, t2.prec_farm * 100 + (t2.prec_farm * 100 * 0.5))), 9)
			ELSE RIGHT(REPLICATE('0', 9) + CONVERT(VARCHAR(9), CONVERT(INT, t2.prec_farm * 100)), 9)
		END +		
		'03' +
		LEFT(CONVERT(VARCHAR(13), CONVERT(BIGINT, t2.cod_barras)) + REPLICATE(' ', 13), 13) +
		' ' +
		REPLICATE('0', 5) + 
		RIGHT(REPLICATE('0', 9) + CONVERT(VARCHAR(9), CONVERT(INT, t1. t_prfa * 100)), 9) +
		'000000010' +
		CASE
			WHEN t2.clas_ssa BETWEEN 1 AND 3 THEN '1'
			ELSE '0'
		END +
		SUBSTRING(t2.lab_corto, 1, 3)
FROM	cambios_precio_baan t1 INNER JOIN maestro_productos_baan t2 ON 
		t1.t_item = t2.codigo
WHERE	DATEDIFF(DD, t1.fecha_hora, CURRENT_TIMESTAMP) <= 5 AND
		ISNUMERIC(t2.cod_barras) = 1 AND
		CONVERT(int, t2.codigo) < dbo.gobierno() AND
		SUBSTRING(t2.status, 1, 1) <> 'B'
ORDER BY t2.descripcion

GO

