
CREATE PROCEDURE [dbo].[usp_genera_cambios_farmacon_tij_000]
AS
SELECT	LEFT(t2.descripcion + REPLICATE(' ', 31), 31) + 
		RIGHT(REPLICATE('0', 7) + CONVERT(VARCHAR(7), CONVERT(BIGINT, t2.codigo)), 7) +
		CASE t2.grupo_est 
			WHEN 'PC01A' THEN RIGHT(REPLICATE('0', 7) + CONVERT(VARCHAR(7), CONVERT(MONEY, ROUND(t2.prec_pub + (t2.prec_pub * t2.iva), 2, 2) + (ROUND(t2.prec_pub + (t2.prec_pub * t2.iva), 2, 2) * 0.5))), 7)
			ELSE RIGHT(REPLICATE('0', 7) + CONVERT(VARCHAR(7), t2.prec_pub + (t2.prec_pub * t2.iva)), 7) 
		END +
		CASE t2.grupo_est 
			WHEN 'PC01A' THEN RIGHT(REPLICATE('0', 7) + CONVERT(VARCHAR(7), CONVERT(MONEY, ROUND(t2.prec_pub, 2, 2) + (ROUND(t2.prec_pub, 2, 2) * 0.5))), 7)
			ELSE RIGHT(REPLICATE('0', 7) + CONVERT(VARCHAR(7), ROUND(t2.prec_pub, 2, 2)), 7) 
		END +
		CASE t2.grupo_est 
			WHEN 'PC01A' THEN RIGHT(REPLICATE('0', 7) + CONVERT(VARCHAR(7), CONVERT(MONEY, ROUND(t2.prec_farm, 2, 2) + (ROUND(t2.prec_farm, 2, 2) * 0.5))), 7)
			ELSE RIGHT(REPLICATE('0', 7) + CONVERT(VARCHAR(7), ROUND(t2.prec_farm, 2, 2)), 7)  
		END +
		LEFT(CONVERT(VARCHAR(13), CONVERT(BIGINT, t2.cod_barras)) + REPLICATE(' ', 13), 13)
FROM	cambios_precio_baan t1 INNER JOIN maestro_productos_baan t2 ON 
		t1.t_item = t2.codigo
WHERE	DATEDIFF(DD, t1.fecha_hora, CURRENT_TIMESTAMP) <= 5 AND
		ISNUMERIC(t2.cod_barras) = 1 AND
		CONVERT(int, t2.codigo) < dbo.gobierno() AND
		SUBSTRING(t2.status, 1, 1) <> 'B' AND
		t2.prec_farm  <= 9999.99 AND
		t2.prec_pub <= 9999.99
ORDER BY t2.descripcion

GO

