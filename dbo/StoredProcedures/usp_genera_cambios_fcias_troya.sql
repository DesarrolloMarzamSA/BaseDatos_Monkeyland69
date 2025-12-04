
CREATE PROCEDURE [dbo].[usp_genera_cambios_fcias_troya]
AS
SELECT	LEFT(t2.descripcion + REPLICATE(' ', 30), 30) + 
		LEFT(CONVERT(VARCHAR(13), CONVERT(BIGINT, t2.cod_barras)) + REPLICATE(' ', 13), 13) +
		CASE t2.grupo_est 
			WHEN 'PC01A' THEN RIGHT(REPLICATE(' ', 11) + CONVERT(VARCHAR(11), ROUND(t2.prec_farm, 2, 2) + (ROUND(t2.prec_farm, 2, 2) * 0.5)), 11)
			ELSE RIGHT(REPLICATE(' ', 11) + CONVERT(VARCHAR(11), ROUND(t2.prec_farm, 2, 2)), 11) 
		END +
		CASE t2.grupo_est 
			WHEN 'PC01A' THEN RIGHT(REPLICATE(' ', 11) + CONVERT(VARCHAR(11), ROUND(t2.prec_pub, 2, 2) + (ROUND(t2.prec_pub, 2, 2) * 0.5)), 11)
			ELSE RIGHT(REPLICATE(' ', 11) + CONVERT(VARCHAR(11), ROUND(t2.prec_pub, 2, 2)), 11) 
		END
FROM	cambios_precio_baan t1 INNER JOIN maestro_productos_baan t2 ON 
		t1.t_item = t2.codigo
WHERE	DATEDIFF(DD, t1.fecha_hora, CURRENT_TIMESTAMP) <= 5 AND
		ISNUMERIC(t2.cod_barras) = 1 AND
		CONVERT(INT, t2.codigo) < dbo.gobierno() AND
		SUBSTRING(t2.status, 1, 1) <> 'B'
ORDER BY t2.descripcion

GO

