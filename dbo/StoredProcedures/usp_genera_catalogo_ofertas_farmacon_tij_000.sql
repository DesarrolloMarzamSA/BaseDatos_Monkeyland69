CREATE PROCEDURE [dbo].[usp_genera_catalogo_ofertas_farmacon_tij_000]
	@sucursal TINYINT,
	@primer_bolsa VARCHAR(5),
	@segunda_bolsa VARCHAR(5)
AS

--usp_genera_catalogo_ofertas_farmacon_tij_000 6, 'C2599', 'LIBRE'
--DECLARE @primer_bolsa  AS VARCHAR(5)
--DECLARE @segunda_bolsa AS VARCHAR(5)
--DECLARE @sucursal AS TINYINT
--SET @primer_bolsa = 'C2599'
--SET @segunda_bolsa = 'LIBRE'
--SET @sucursal = 6

SELECT 	RIGHT(REPLICATE('0', 7) + CONVERT(VARCHAR(7), t1.codigo), 7) +
		LEFT (CONVERT(VARCHAR(31), descripcion) + REPLICATE(' ', 31), 31) +
		CASE t1.grupo_est 
			WHEN 'PC01A' THEN RIGHT(REPLICATE('0', 7) + CONVERT(VARCHAR(7), CONVERT(MONEY, ROUND(t1.prec_farm, 2, 2) + (ROUND(t1.prec_farm, 2, 2) * 0.5))), 7)
			ELSE RIGHT(REPLICATE('0', 7) + CONVERT(VARCHAR(7), CONVERT(MONEY, ROUND(t1.prec_farm, 2, 2))), 7)
		END +
		'0000' +
		'0000' +
		CASE
			WHEN cant_base = 0 AND cant_oferta = 0 THEN RIGHT(REPLICATE('0', 7) + CONVERT(VARCHAR(7), CONVERT(MONEY, porcentaje * 100)), 7)
			WHEN cant_base > 0 AND cant_oferta > 0 THEN RIGHT(REPLICATE('0', 7) + CONVERT(VARCHAR(7), (CONVERT(MONEY, cant_oferta) / (CONVERT(MONEY, cant_base) + CONVERT(MONEY, cant_oferta))) * 100), 7)
			ELSE RIGHT(REPLICATE('0', 7) + CONVERT(VARCHAR(7), CONVERT(MONEY, porcentaje * 100)), 7)
		END +
		CASE clas_abc
			WHEN 'A' THEN '3'
			WHEN 'B' THEN '2'
			WHEN 'C' THEN 'A'
			WHEN 'D' THEN 'B'
			WHEN 'E' THEN 'C'
			ELSE ' ' 
		END +
		' ' +
		LEFT(CONVERT(VARCHAR(13), CONVERT(BIGINT, t1.cod_barras)) + REPLICATE(' ', 13), 13) +
		'   '
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
SELECT 	RIGHT(REPLICATE('0', 7) + CONVERT(VARCHAR(7), t1.codigo), 7) +
		LEFT (CONVERT(VARCHAR(31), descripcion) + REPLICATE(' ', 31), 31) +
		CASE t1.grupo_est 
			WHEN 'PC01A' THEN RIGHT(REPLICATE('0', 7) + CONVERT(VARCHAR(7), CONVERT(MONEY, ROUND(t1.prec_farm, 2, 2) + (ROUND(t1.prec_farm, 2, 2) * 0.5))), 7)
			ELSE RIGHT(REPLICATE('0', 7) + CONVERT(VARCHAR(7), CONVERT(MONEY, ROUND(t1.prec_farm, 2, 2))), 7)
		END +
		'0000' +
		'0000' +
		CASE
			WHEN cant_base = 0 AND cant_oferta = 0 THEN RIGHT(REPLICATE('0', 7) + CONVERT(VARCHAR(7), CONVERT(MONEY, porcentaje * 100)), 7)
			WHEN cant_base > 0 AND cant_oferta > 0 THEN RIGHT(REPLICATE('0', 7) + CONVERT(VARCHAR(7), (CONVERT(MONEY, cant_oferta) / (CONVERT(MONEY, cant_base) + CONVERT(MONEY, cant_oferta))) * 100), 7)
			ELSE RIGHT(REPLICATE('0', 7) + CONVERT(VARCHAR(7), CONVERT(MONEY, porcentaje * 100)), 7)
		END +
		CASE clas_abc
			WHEN 'A' THEN '3'
			WHEN 'B' THEN '2'
			WHEN 'C' THEN 'A'
			WHEN 'D' THEN 'B'
			WHEN 'E' THEN 'C'
			ELSE ' ' 
		END +
		' ' +
		LEFT(CONVERT(VARCHAR(13), CONVERT(BIGINT, t1.cod_barras)) + REPLICATE(' ', 13), 13) +
		'   '
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
		t3.disponible > 10 AND
		t3.codigo NOT IN	(	
								SELECT	codigo 
								FROM	dboferta 
								WHERE	sucursal = @sucursal AND 
										bolsa = @primer_bolsa
							)

GO

