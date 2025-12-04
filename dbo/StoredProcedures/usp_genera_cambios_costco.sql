CREATE PROCEDURE [dbo].[usp_genera_cambios_costco]
AS
DECLARE @descuento FLOAT

SELECT	@descuento = descuento
FROM	clientes_baan 
WHERE	sucursal = 21 AND 
		cliente = '33070'
		
SELECT	LEFT(CONVERT(VARCHAR(13), CONVERT(BIGINT, t2.cod_barras)) + REPLICATE(' ', 13), 13) COL1, 
		LEFT(CONVERT(VARCHAR(30), t2.descripcion) + REPLICATE(' ', 30), 30) COL2,
		CASE t2.grupo_est 
			WHEN 'PC01A' THEN RIGHT(REPLICATE('0', 14) + CONVERT(VARCHAR(14), ROUND(t2.prec_pub, 2, 2) + (ROUND(t2.prec_pub, 2, 2) * 0.5)), 14) + '0'
			ELSE RIGHT(REPLICATE('0', 14) + CONVERT(VARCHAR(14), ROUND(t2.prec_pub, 2, 2)), 14) + '0'
		END COL3,
		CASE
			WHEN clas_fis = 'N' THEN RIGHT(REPLICATE('0', 15) + CONVERT(VARCHAR(15), CONVERT(DECIMAL(15, 3), ROUND(t2.prec_farm, 3 ,1))), 15)
			WHEN clas_fis = 'NA' THEN RIGHT(REPLICATE('0', 15) + CONVERT(VARCHAR(15), CONVERT(DECIMAL(15, 3), ROUND(t2.prec_farm, 3 ,1))), 15)
			WHEN clas_fis = 'B' THEN RIGHT(REPLICATE('0', 15) + CONVERT(VARCHAR(15), CONVERT(DECIMAL(15, 3), ROUND(t2.prec_farm * (1 - (@descuento * 0.01)), 3, 1))), 15)
			WHEN clas_fis = 'BA' THEN RIGHT(REPLICATE('0', 15) + CONVERT(VARCHAR(15), CONVERT(DECIMAL(15, 3), ROUND(t2.prec_farm * (1 - (@descuento * 0.01)), 3, 1))), 15)
			WHEN clas_fis = 'H' THEN RIGHT(REPLICATE('0', 15) + CONVERT(VARCHAR(15), CONVERT(DECIMAL(15, 3), ROUND(t2.prec_farm * (1 - (t2.descto_prod * 0.01)), 3, 1))), 15)
			WHEN clas_fis = 'HA' THEN RIGHT(REPLICATE('0', 15) + CONVERT(VARCHAR(15), CONVERT(DECIMAL(15, 3), ROUND(t2.prec_farm * (1 - (t2.descto_prod * 0.01)), 3, 1))), 15)
		END COL4,
		CASE t2.grupo_est 
			WHEN 'PC01A' THEN RIGHT(REPLICATE('0', 14) + CONVERT(VARCHAR(14), ROUND(t2.prec_farm, 2, 2) + (ROUND(t2.prec_farm, 2, 2) * 0.5)), 14) + '0'
			ELSE RIGHT(REPLICATE('0', 14) + CONVERT(VARCHAR(14), ROUND(t2.prec_farm, 2, 2)), 14) + '0'
		END COL5,
		t2.codigo INTO #tbl_temporal
FROM	cambios_precio_baan t1 INNER JOIN maestro_productos_baan t2 ON 
		t1.t_item = t2.codigo INNER JOIN catalogo_autoservicios t3 ON
		t1.t_item  = t3.codigo
WHERE	DATEDIFF(DD, t1.fecha_hora, CURRENT_TIMESTAMP) <= 1 AND
--WHERE	t1.fecha_hora >= convert(datetime, '2011-11-01', 121) AND
		ISNUMERIC(t2.cod_barras) = 1 AND
		--CONVERT(INT, t2.codigo) < 7899999 AND
		SUBSTRING(t2.status, 1, 1) <> 'B' AND
		t3.segto = 'E1' AND 
		t3.ctepadre = '681' AND 
		t3.status = 'A' AND 
		--t3.sucursal = 4
		t3.sucursal = 21

SELECT	DISTINCT * 
FROM	#tbl_temporal
ORDER BY COL2

GO

