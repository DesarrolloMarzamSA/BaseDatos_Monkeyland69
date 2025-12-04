CREATE PROCEDURE [dbo].[usp_genera_catalogo_ofertas_fcias_lux_cul]
	@sucursal TINYINT,
	@primer_bolsa VARCHAR(5),
	@segunda_bolsa VARCHAR(5)
AS

--DECLARE @primer_bolsa  AS VARCHAR(5)
--DECLARE @segunda_bolsa AS VARCHAR(5)
--DECLARE @sucursal AS TINYINT
--SET @primer_bolsa = 'C2800'
--SET @segunda_bolsa = 'LIBRE'
--SET @sucursal = 17

SELECT	' ' +
		--RIGHT(REPLICATE(' ', 7) + CONVERT(VARCHAR(7), t3.cant_base), 7) +
		'      0' +
		LEFT(CONVERT(VARCHAR(30), t1.descripcion) + REPLICATE(' ', 30), 30) +
		' ' +
		CASE
			WHEN clas_fis = 'N' THEN '  0.00'
			WHEN clas_fis = 'NA' THEN '  0.00'
			WHEN clas_fis = 'B' THEN '100.00'
			WHEN clas_fis = 'BA' THEN '100.00'
			WHEN clas_fis = 'H' THEN RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR(6), CONVERT(MONEY, t1.descto_prod )), 6)
			WHEN clas_fis = 'HA' THEN RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR(6), CONVERT(MONEY, t1.descto_prod )), 6)
		END +
		' ' +
		CASE
			WHEN cant_base = 0 AND cant_oferta = 0 THEN RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR(6), CONVERT(MONEY, porcentaje * 100)), 6)
			WHEN cant_base > 0 AND cant_oferta > 0 THEN RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR(6), (CONVERT(MONEY, cant_oferta) / (CONVERT(MONEY, cant_base) + CONVERT(MONEY, cant_oferta))) * 100), 6)
			ELSE RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR(6), CONVERT(MONEY, porcentaje * 100)), 6)
		END +
		LEFT(CONVERT(VARCHAR(13), CONVERT(BIGINT, t1.cod_barras)) + REPLICATE(' ', 13), 13) +
		' ' +
		'      0' +
		'  ' + 
		CASE t1.grupo_est 
			WHEN 'PC01A' THEN RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR(9), CONVERT(MONEY, ROUND(t1.prec_farm, 2, 2) + (ROUND(t1.prec_farm, 2, 2) * 0.5))), 9)
			ELSE RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR(9), CONVERT(MONEY, ROUND(t1.prec_farm, 2, 2))), 9)
		END +
		' ' +
		--RIGHT(REPLICATE(' ', 7) + CONVERT(VARCHAR(7), t3.cant_oferta), 7) +
		'      0' +
		LEFT(CONVERT(VARCHAR(12), @sucursal) + REPLICATE(' ', 12), 12) 
FROM	maestro_productos_baan t1 INNER JOIN inventario_baan t2 ON 
		t1.codigo = t2.codigo AND 
		t2.sucursal = @sucursal INNER JOIN dboferta t3 ON 
		t2.codigo = t3.codigo AND 
		t2.sucursal = t3.sucursal AND 
		t3.bolsa = @primer_bolsa 
WHERE	CONVERT(INT, t1.codigo) < dbo.gobierno() AND
		ISNUMERIC(t1.cod_barras) = 1 AND
		SUBSTRING(t1.status, 1,1) <> 'B' AND
		t2.piezas > 0
UNION
SELECT	' ' +
		--RIGHT(REPLICATE(' ', 7) + CONVERT(VARCHAR(7), t3.cant_base), 7) +
		'      0' +
		LEFT(CONVERT(VARCHAR(30), t1.descripcion) + REPLICATE(' ', 30), 30) +
		' ' +
		CASE
			WHEN clas_fis = 'N' THEN '  0.00'
			WHEN clas_fis = 'NA' THEN '  0.00'
			WHEN clas_fis = 'B' THEN '100.00'
			WHEN clas_fis = 'BA' THEN '100.00'
			WHEN clas_fis = 'H' THEN RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR(6), CONVERT(MONEY, t1.descto_prod )), 6)
			WHEN clas_fis = 'HA' THEN RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR(6), CONVERT(MONEY, t1.descto_prod )), 6)
		END +
		' ' +
		CASE
			WHEN cant_base = 0 AND cant_oferta = 0 THEN RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR(6), CONVERT(MONEY, porcentaje * 100)), 6)
			WHEN cant_base > 0 AND cant_oferta > 0 THEN RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR(6), (CONVERT(MONEY, cant_oferta) / (CONVERT(MONEY, cant_base) + CONVERT(MONEY, cant_oferta))) * 100), 6)
			ELSE RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR(6), CONVERT(MONEY, porcentaje * 100)), 6)
		END +
		LEFT(CONVERT(VARCHAR(13), CONVERT(BIGINT, t1.cod_barras)) + REPLICATE(' ', 13), 13) +
		' ' +
		'      0' +
		'  ' + 
		CASE t1.grupo_est 
			WHEN 'PC01A' THEN RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR(9), CONVERT(MONEY, ROUND(t1.prec_farm, 2, 2) + (ROUND(t1.prec_farm, 2, 2) * 0.5))), 9)
			ELSE RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR(9), CONVERT(MONEY, ROUND(t1.prec_farm, 2, 2))), 9)
		END +
		' ' +
		--RIGHT(REPLICATE(' ', 7) + CONVERT(VARCHAR(7), t3.cant_oferta), 7) +
		'      0' +
		LEFT(CONVERT(VARCHAR(12), @sucursal) + REPLICATE(' ', 12), 12) 
FROM	maestro_productos_baan t1 INNER JOIN inventario_baan t2 on 
		t1.codigo = t2.codigo AND 
		t2.sucursal = @sucursal INNER JOIN dboferta t3 on 
		t2.codigo = t3.codigo AND 
		t2.sucursal = t3.sucursal AND 
		t3.bolsa = @segunda_bolsa 
WHERE	CONVERT(INT, t1.codigo) < dbo.gobierno() AND
		ISNUMERIC(t1.cod_barras) = 1 AND
		SUBSTRING(t1.status, 1,1) <> 'B' AND
		CONVERT(INT, t1.codigo) < dbo.gobierno() AND 
		t3.disponible > 10 and 
		t2.piezas > 0 and
		t3.codigo NOT IN	(	
								SELECT	codigo 
								FROM	dboferta 
								WHERE	sucursal = @sucursal AND 
										bolsa = @primer_bolsa
							)

GO

