CREATE PROCEDURE [dbo].[usp_genera_cambios_fcias_leyva_20]
AS

DECLARE @descuento VARCHAR(6)
	
SELECT	@descuento = RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR(6), descuento), 6)   
FROM	clientes_baan   
WHERE	sucursal = 1 AND   
		cliente = '08590'  

SELECT	LEFT(CONVERT(VARCHAR(15), CONVERT(BIGINT, t2.cod_barras)) + REPLICATE(' ', 15), 15) + 
		LEFT(t2.descripcion + REPLICATE(' ', 30), 30) + 
		CASE t2.grupo_est 
			WHEN 'PC01A' THEN RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR(9), CONVERT(MONEY, ROUND(t2.prec_pub, 2, 2) + (ROUND(t2.prec_pub, 2, 2) * 0.5))), 9)
			ELSE RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR(9), CONVERT(MONEY, ROUND(t2.prec_pub, 2, 2))), 9)
		END +
		CASE t2.grupo_est 
			WHEN 'PC01A' THEN RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR(9), CONVERT(MONEY, ROUND(t2.prec_farm, 2, 2) + (ROUND(t2.prec_farm, 2, 2) * 0.5))), 9)
			ELSE RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR(9), CONVERT(MONEY, ROUND(t2.prec_farm, 2, 2))), 9)
		END +
		CASE 
			WHEN t2.clas_fis = 'B' THEN RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR(9), @descuento), 6)
			WHEN t2.clas_fis = 'BA' THEN RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR(9), @descuento), 6)
			WHEN t2.clas_fis = 'N' THEN '  0.00' 
			WHEN t2.clas_fis = 'NA' THEN '  0.00' 
			WHEN t2.clas_fis = 'H' THEN RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR(9), t2.descto_prod), 6) 
			WHEN t2.clas_fis = 'HA' THEN RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR(9), t2.descto_prod), 6) 
		END +
		RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR(9), CONVERT(INT, (t2.iva * 100))), 9) 
FROM	cambios_precio_baan t1 INNER JOIN maestro_productos_baan t2 ON 
		t1.t_item = t2.codigo
WHERE	DATEDIFF(DD, t1.fecha_hora, CURRENT_TIMESTAMP) <= 5 AND
		ISNUMERIC(t2.cod_barras) = 1 AND
		CONVERT(INT, t2.codigo) < dbo.gobierno() AND
		SUBSTRING(t2.status, 1, 1) <> 'B'
ORDER BY 
		t2.descripcion

GO

