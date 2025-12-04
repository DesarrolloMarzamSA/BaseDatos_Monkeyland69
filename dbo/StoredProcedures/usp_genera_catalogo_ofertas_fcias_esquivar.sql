
CREATE PROCEDURE [dbo].[usp_genera_catalogo_ofertas_fcias_esquivar] 
	@sucursal tinyint,
	@primer_bolsa varchar(5)
AS

declare @descuento varchar(6)
declare @segunda_bolsa  varchar(5)
declare @tercer_bolsa  varchar(5)
--set @primer_bolsa = 'XXPAD'
set @segunda_bolsa = 'LIBRE'
set @tercer_bolsa = 'ZFHYB'

--declare @sucursal as tinyint
--declare @descuento varchar(6)
--declare @primer_bolsa  varchar(5)
--declare @segunda_bolsa  varchar(5)
--declare @tercer_bolsa  varchar(5)
--set @sucursal = 5
--set @primer_bolsa = 'XXPAD'
--set @segunda_bolsa = 'LIBRE'
--set @tercer_bolsa = 'ZFHYB'

SELECT @descuento =		RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR(6), descuento), 6) 
						FROM clientes_baan WHERE sucursal = 5 and cliente = '99142'

SELECT	RIGHT('00' + CONVERT(VARCHAR, @sucursal), 2) +
		REPLICATE(' ', 10) +
		LEFT(CONVERT(VARCHAR(13), CONVERT(BIGINT, t1.cod_barras)) + REPLICATE(' ', 13), 13) + 
		LEFT(t1.descripcion + REPLICATE(' ', 30), 30) + 
		CASE t1.grupo_est 
			WHEN 'PC01A' THEN RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR(9), ROUND(t1.prec_farm, 2, 2) + (ROUND(t1.prec_farm, 2, 2) * 0.5)), 9)
			ELSE RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR(9), ROUND(t1.prec_farm, 2, 2)), 9) 
		END +
		RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR(6), CONVERT(MONEY, t3.porcentaje * 100)), 6) +
		'      0' +
		'      0' +
		'      0' +
		CASE 
			WHEN t1.clas_fis = 'B' THEN @descuento
			WHEN t1.clas_fis = 'BA' THEN @descuento
			WHEN t1.clas_fis = 'N' THEN '  0.00' 
			WHEN t1.clas_fis = 'NA' THEN '  0.00' 
			WHEN t1.clas_fis = 'H' THEN RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR(6), t1.descto_prod), 6) 
			WHEN t1.clas_fis = 'HA' THEN RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR(6), t1.descto_prod), 6) 
		END +
		CASE 
			WHEN t2.piezas = 0 THEN ' 0'
			WHEN t2.piezas BETWEEN 1 AND 49 THEN ' 1'
			WHEN t2.piezas BETWEEN 50 AND 99 THEN ' 2'
			WHEN t2.piezas BETWEEN 100 AND 149 THEN ' 3'
			WHEN t2.piezas >= 150 THEN ' 4'
			ELSE ' 0'
		END
FROM	maestro_productos_baan t1 INNER JOIN inventario_baan t2 ON 
		t1.codigo = t2.codigo AND 
		t2.sucursal = @sucursal INNER JOIN dboferta t3 ON 
		t2.codigo = t3.codigo AND
		t2.sucursal = t3.sucursal AND 
		t3.bolsa = @primer_bolsa 
WHERE	CONVERT(INT, t1.codigo) < dbo.gobierno() AND
		ISNUMERIC(t1.cod_barras) = 1 AND
		SUBSTRING(t1.status, 1,1) <> 'B' 
UNION
SELECT	RIGHT('00' + CONVERT(VARCHAR, @sucursal), 2) +
		REPLICATE(' ', 10) +
		LEFT(CONVERT(VARCHAR(13), CONVERT(BIGINT, t1.cod_barras)) + REPLICATE(' ', 13), 13) + 
		LEFT(t1.descripcion + REPLICATE(' ', 30), 30) + 
		CASE t1.grupo_est 
			WHEN 'PC01A' THEN RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR(9), ROUND(t1.prec_farm, 2, 2) + (ROUND(t1.prec_farm, 2, 2) * 0.5)), 9)
			ELSE RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR(9), ROUND(t1.prec_farm, 2, 2)), 9) 
		END +
		RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR(6), CONVERT(MONEY, t3.porcentaje * 100)), 6) +
		'      0' +
		'      0' +
		'      0' +
		CASE 
			WHEN t1.clas_fis = 'B' THEN @descuento
			WHEN t1.clas_fis = 'BA' THEN @descuento
			WHEN t1.clas_fis = 'N' THEN '  0.00' 
			WHEN t1.clas_fis = 'NA' THEN '  0.00' 
			WHEN t1.clas_fis = 'H' THEN RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR(6), t1.descto_prod), 6) 
			WHEN t1.clas_fis = 'HA' THEN RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR(6), t1.descto_prod), 6) 
		END +
		CASE 
			WHEN t2.piezas = 0 THEN ' 0'
			WHEN t2.piezas BETWEEN 1 AND 49 THEN ' 1'
			WHEN t2.piezas BETWEEN 50 AND 99 THEN ' 2'
			WHEN t2.piezas BETWEEN 100 AND 149 THEN ' 3'
			WHEN t2.piezas >= 150 THEN ' 4'
			ELSE ' 0'
		END
FROM	maestro_productos_baan t1 INNER JOIN inventario_baan t2 ON 
		t1.codigo = t2.codigo AND 
		t2.sucursal = @sucursal INNER JOIN dboferta t3 ON 
		t2.codigo = t3.codigo AND
		t2.sucursal = t3.sucursal AND 
		t3.bolsa = @segunda_bolsa 
WHERE	CONVERT(INT, t1.codigo) < dbo.gobierno() AND
		ISNUMERIC(t1.cod_barras) = 1 AND
		SUBSTRING(t1.status, 1,1) <> 'B' AND
		t3.codigo NOT IN	(	
								SELECT	codigo 
								FROM	dboferta 
								WHERE	sucursal = @sucursal AND 
										bolsa = @primer_bolsa
							)
UNION
SELECT	RIGHT('00' + CONVERT(VARCHAR, @sucursal), 2) +
		REPLICATE(' ', 10) +
		LEFT(CONVERT(VARCHAR(13), CONVERT(BIGINT, t1.cod_barras)) + REPLICATE(' ', 13), 13) + 
		LEFT(t1.descripcion + REPLICATE(' ', 30), 30) + 
		CASE t1.grupo_est 
			WHEN 'PC01A' THEN RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR(9), ROUND(t1.prec_farm, 2, 2) + (ROUND(t1.prec_farm, 2, 2) * 0.5)), 9)
			ELSE RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR(9), ROUND(t1.prec_farm, 2, 2)), 9) 
		END +
		RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR(6), CONVERT(MONEY, t3.porcentaje * 100)), 6) +
		'      0' +
		'      0' +
		'      0' +
		CASE 
			WHEN t1.clas_fis = 'B' THEN @descuento
			WHEN t1.clas_fis = 'BA' THEN @descuento
			WHEN t1.clas_fis = 'N' THEN '  0.00' 
			WHEN t1.clas_fis = 'NA' THEN '  0.00' 
			WHEN t1.clas_fis = 'H' THEN RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR(6), t1.descto_prod), 6) 
			WHEN t1.clas_fis = 'HA' THEN RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR(6), t1.descto_prod), 6) 
		END +
		CASE 
			WHEN t2.piezas = 0 THEN ' 0'
			WHEN t2.piezas BETWEEN 1 AND 49 THEN ' 1'
			WHEN t2.piezas BETWEEN 50 AND 99 THEN ' 2'
			WHEN t2.piezas BETWEEN 100 AND 149 THEN ' 3'
			WHEN t2.piezas >= 150 THEN ' 4'
			ELSE ' 0'
		END
FROM	maestro_productos_baan t1 INNER JOIN inventario_baan t2 ON 
		t1.codigo = t2.codigo AND 
		t2.sucursal = @sucursal INNER JOIN dboferta t3 ON 
		t2.codigo = t3.codigo AND
		t2.sucursal = t3.sucursal AND 
		t3.bolsa = @tercer_bolsa 
WHERE	CONVERT(INT, t1.codigo) < dbo.gobierno() AND
		ISNUMERIC(t1.cod_barras) = 1 AND
		SUBSTRING(t1.status, 1,1) <> 'B' AND
		t3.codigo NOT IN	(	
								SELECT	distinct codigo 
								FROM	dboferta 
								WHERE	sucursal = @sucursal AND 
										bolsa in (@primer_bolsa, @segunda_bolsa)
		 					)

GO

