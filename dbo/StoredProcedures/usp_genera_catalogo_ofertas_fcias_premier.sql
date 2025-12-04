
CREATE PROCEDURE [dbo].[usp_genera_catalogo_ofertas_fcias_premier]
	@sucursal TINYINT,
	@primer_bolsa VARCHAR(5),
	@segunda_bolsa VARCHAR(5)
AS
DECLARE @descuento VARCHAR(6)

--DECLARE @descuento VARCHAR(6)
--DECLARE @primer_bolsa  AS VARCHAR(5)
--DECLARE @segunda_bolsa AS VARCHAR(5)
--DECLARE @sucursal AS TINYINT
--SET @primer_bolsa = 'LIBRE'
--SET @segunda_bolsa = 'ZZZZZ'
--SET @sucursal = 1

SELECT	@descuento = RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR(6), descuento), 6) 
FROM	clientes_baan 
WHERE	sucursal = @sucursal AND 
		cliente = '66060'

SELECT	LEFT(CONVERT(VARCHAR(12), @sucursal) + REPLICATE(' ', 12), 12) +
		LEFT(CONVERT(VARCHAR(13), CONVERT(BIGINT, t1.cod_barras)) + REPLICATE(' ', 13), 13) + 
		LEFT(t1.descripcion + REPLICATE(' ', 30), 30) + 
		CASE t1.grupo_est 
			WHEN 'PC01A' THEN RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR(9), ROUND(t1.prec_farm, 2, 2) + (ROUND(t1.prec_farm, 2, 2) * 0.5)), 9)
			ELSE RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR(9), ROUND(t1.prec_farm, 2, 2)), 9) 
		END +
		RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR(6), CONVERT(MONEY, t3.porcentaje * 100)), 6) +
		RIGHT(REPLICATE(' ', 7) + CONVERT(VARCHAR(7), t3.cant_base), 7) +
		RIGHT(REPLICATE(' ', 7) + CONVERT(VARCHAR(7), t3.cant_oferta), 7) +
		'      0' +
		CASE 
			WHEN t1.clas_fis = 'B' THEN @descuento
			WHEN t1.clas_fis = 'BA' THEN @descuento
			WHEN t1.clas_fis = 'N' THEN '  0.00' 
			WHEN t1.clas_fis = 'NA' THEN '  0.00' 
			WHEN t1.clas_fis = 'H' THEN RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR(6), t1.descto_prod), 6) 
			WHEN t1.clas_fis = 'HA' THEN RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR(6), t1.descto_prod), 6) 
		END 
FROM	maestro_productos_baan t1 INNER JOIN inventario_baan t2 ON
		t1.codigo = t2.codigo AND 
		t2.sucursal = @sucursal INNER JOIN dboferta t3 ON
		t2.codigo = t3.codigo AND
		t2.sucursal = t3.sucursal AND
		t3.bolsa = @primer_bolsa
WHERE	--t3.vigencia_final > CONVERT(DATETIME, CONVERT(VARCHAR(10), GETDATE(), 121), 121) AND
		CONVERT(INT, t1.codigo) < dbo.gobierno() AND
		ISNUMERIC(t1.cod_barras) = 1 AND
		SUBSTRING(t1.status, 1,1) <> 'B'
UNION
SELECT	LEFT(CONVERT(VARCHAR(12), @sucursal) + REPLICATE(' ', 12), 12) +
		LEFT(CONVERT(VARCHAR(13), CONVERT(BIGINT, t1.cod_barras)) + REPLICATE(' ', 13), 13) + 
		LEFT(t1.descripcion + REPLICATE(' ', 30), 30) + 
		CASE t1.grupo_est 
			WHEN 'PC01A' THEN RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR(9), ROUND(t1.prec_farm, 2, 2) + (ROUND(t1.prec_farm, 2, 2) * 0.5)), 9)
			ELSE RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR(9), ROUND(t1.prec_farm, 2, 2)), 9) 
		END +
		RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR(6), CONVERT(MONEY, t3.porcentaje * 100)), 6) +
		RIGHT(REPLICATE(' ', 7) + CONVERT(VARCHAR(7), t3.cant_base), 7) +
		RIGHT(REPLICATE(' ', 7) + CONVERT(VARCHAR(7), t3.cant_oferta), 7) +
		'      0' +
		CASE 
			WHEN t1.clas_fis = 'B' THEN @descuento
			WHEN t1.clas_fis = 'BA' THEN @descuento
			WHEN t1.clas_fis = 'N' THEN '  0.00' 
			WHEN t1.clas_fis = 'NA' THEN '  0.00' 
			WHEN t1.clas_fis = 'H' THEN RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR(6), t1.descto_prod), 6) 
			WHEN t1.clas_fis = 'HA' THEN RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR(6), t1.descto_prod), 6) 
		END 
FROM	maestro_productos_baan t1 INNER JOIN inventario_baan t2 ON
		t1.codigo = t2.codigo AND 
		t2.sucursal = @sucursal INNER JOIN dboferta t3 ON 
		t2.codigo = t3.codigo AND 
		t2.sucursal = t3.sucursal AND 
		t3.bolsa = @segunda_bolsa 
WHERE	--t3.vigencia_final > CONVERT(DATETIME, CONVERT(VARCHAR(10), GETDATE(), 121), 121) AND
		CONVERT(INT, t1.codigo) < dbo.gobierno() AND
		ISNUMERIC(t1.cod_barras) = 1 AND
		SUBSTRING(t1.status, 1,1) <> 'B' AND
		t3.codigo NOT IN	(	
								SELECT	codigo 
								FROM	dboferta 
								WHERE	sucursal = @sucursal AND 
										bolsa = @primer_bolsa
							)

GO

