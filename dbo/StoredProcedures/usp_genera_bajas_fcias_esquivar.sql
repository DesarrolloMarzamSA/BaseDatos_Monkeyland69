USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_genera_bajas_fcias_esquivar]
WITH ENCRYPTION
AS
SELECT	LEFT(CONVERT(VARCHAR(13), CONVERT(BIGINT, t1.cod_barras)) + REPLICATE(' ', 13), 13) + 
		LEFT(t1.descripcion + REPLICATE(' ', 30), 30) + 
		CASE t1.grupo_est 
			WHEN 'PC01A' THEN RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR(9), ROUND(t1.prec_pub, 2, 2) + (ROUND(t1.prec_pub, 2, 2) * 0.5)), 9)
			ELSE RIGHT(REPLICATE(' ', 9) + CONVERT(varchar(9), ROUND(t1.prec_pub, 2, 2)), 9) 
		END +
		CASE t1.grupo_est 
					WHEN 'PC01A' THEN right(REPLICATE(' ', 9) + CONVERT(VARCHAR(9), ROUND(t1.prec_farm, 2, 2) + (ROUND(t1.prec_farm, 2, 2) * 0.5)), 9)
			ELSE RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR(9), ROUND(t1.prec_farm, 2, 2)), 9) 
		END 
FROM	maestro_productos_baan  t1 
WHERE	DATEDIFF(DD, fecha_baja, CURRENT_TIMESTAMP) <= 5 AND
		ISNUMERIC(t1.cod_barras) = 1 AND
		CONVERT(int, t1.codigo) < dbo.gobierno() 
ORDER BY t1.descripcion, fecha_baja DESC
GO
