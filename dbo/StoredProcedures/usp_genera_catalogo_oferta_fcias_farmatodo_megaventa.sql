
CREATE PROCEDURE [dbo].[usp_genera_catalogo_oferta_fcias_farmatodo_megaventa]
	@sucursal TINYINT,
	@primer_bolsa VARCHAR(5)
AS

--DECLARE @primer_bolsa  AS VARCHAR(5)
--DECLARE @segunda_bolsa AS VARCHAR(5)
--DECLARE @sucursal AS TINYINT
--SET @primer_bolsa = 'LIBRE'
--SET @sucursal = 1

SELECT	RIGHT(REPLICATE('0', 2) + CONVERT(VARCHAR, @sucursal), 2) +
		REPLICATE('  ', 5) +
		LEFT(CONVERT(VARCHAR(13), CONVERT(BIGINT, t1.cod_barras)) + '             ', 13),
		descripcion = LEFT(t1.descripcion + REPLICATE(' ', 30), 30) +
		CASE t1.grupo_est 
			WHEN 'PC01A' THEN RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR, CONVERT(MONEY, ROUND(t1.prec_farm, 2, 2) + (ROUND(t1.prec_farm, 2, 2) * 0.5))), 9)
			ELSE RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR, CONVERT(MONEY, ROUND(t1.prec_farm, 2, 2))), 9)
		END  +
		RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR, CONVERT(MONEY, t3.porcentaje * 100)), 6) +
		'      0' +
		'      0' +
		'      0' +
		CASE 
			WHEN t1.clas_fis = 'B' THEN '100.00'
			WHEN t1.clas_fis = 'BA' THEN '100.00'
			WHEN t1.clas_fis = 'N' THEN '  0.00'
			WHEN t1.clas_fis = 'NA' THEN '  0.00' 
			WHEN t1.clas_fis = 'H' THEN RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR, CONVERT(MONEY, ROUND(t1.descto_prod, 2, 2))), 6)
			WHEN t1.clas_fis = 'HA' THEN RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR, CONVERT(MONEY, ROUND(t1.descto_prod, 2, 2))), 6)
		END
FROM	maestro_productos_baan t1 INNER JOIN inventario_baan t2 ON 
		t1.codigo = t2.codigo AND 
		t2.sucursal = @sucursal INNER JOIN dboferta t3 ON 
		t2.codigo = t3.codigo AND 
		t2.sucursal = t3.sucursal AND 
		t3.bolsa = @primer_bolsa 
WHERE	CONVERT(INT, t1.codigo) < dbo.gobierno() AND
		ISNUMERIC(t1.cod_barras) = 1 AND
		SUBSTRING(t1.status, 1,1) <> 'B' AND
		t3.disponible > 10 AND
		t2.piezas > 10

GO

