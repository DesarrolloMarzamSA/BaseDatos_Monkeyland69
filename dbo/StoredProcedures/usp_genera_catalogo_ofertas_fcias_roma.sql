
CREATE PROCEDURE [dbo].[usp_genera_catalogo_ofertas_fcias_roma]
	@sucursal TINYINT,
	@primer_bolsa VARCHAR(5),
	@segunda_bolsa VARCHAR(5)
AS

--DECLARE @primer_bolsa  AS VARCHAR(5)
--DECLARE @segunda_bolsa AS VARCHAR(5)
--DECLARE @sucursal AS TINYINT
--SET @primer_bolsa = 'C2447'
--SET @segunda_bolsa = 'LIBRE'
--SET @sucursal = 25

SELECT	'3' +
		',' +
		LEFT(CONVERT(VARCHAR(13), CONVERT(BIGINT, t1.cod_barras)) + REPLICATE(' ', 13), 13) +
		',' +
		LEFT(t1.descripcion + REPLICATE(' ', 30), 30) +
		',' +
		CASE
			WHEN cant_base = 0 AND cant_oferta = 0 THEN RIGHT(REPLICATE('0', 5) + CONVERT(VARCHAR(5), CONVERT(MONEY, porcentaje * 100)), 5)
			WHEN cant_base > 0 AND cant_oferta > 0 THEN RIGHT(REPLICATE('0', 5) + CONVERT(VARCHAR(5), (CONVERT(MONEY, cant_oferta) / (CONVERT(MONEY, cant_base) + CONVERT(MONEY, cant_oferta))) * 100), 5)
			ELSE RIGHT(REPLICATE('0', 5) + CONVERT(VARCHAR(5), CONVERT(MONEY, porcentaje * 100)), 5)
		END +
		',' +
		CONVERT(VARCHAR(8), t3.vigencia_inicial, 112) + 
		',' +
		CASE
			WHEN CONVERT(VARCHAR(8), t3.vigencia_final, 112) = '20500101' THEN '99999999'
			ELSE CONVERT(VARCHAR(8), t3.vigencia_final, 112)
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
		t2.piezas > 0
UNION
SELECT	'3' +
		',' +
		LEFT(CONVERT(VARCHAR(13), CONVERT(BIGINT, t1.cod_barras)) + REPLICATE(' ', 13), 13) +
		',' +
		LEFT(t1.descripcion + REPLICATE(' ', 30), 30) +
		',' +
		CASE
			WHEN cant_base = 0 AND cant_oferta = 0 THEN RIGHT(REPLICATE('0', 5) + CONVERT(VARCHAR(5), CONVERT(MONEY, porcentaje * 100)), 5)
			WHEN cant_base > 0 AND cant_oferta > 0 THEN RIGHT(REPLICATE('0', 5) + CONVERT(VARCHAR(5), (CONVERT(MONEY, cant_oferta) / (CONVERT(MONEY, cant_base) + CONVERT(MONEY, cant_oferta))) * 100), 5)
			ELSE RIGHT(REPLICATE('0', 5) + CONVERT(VARCHAR(5), CONVERT(MONEY, porcentaje * 100)), 5)
		END +
		',' +
		CONVERT(VARCHAR(8), t3.vigencia_inicial, 112) + 
		',' +
		CASE
			WHEN CONVERT(VARCHAR(8), t3.vigencia_final, 112) = '20500101' THEN '99999999'
			ELSE CONVERT(VARCHAR(8), t3.vigencia_final, 112)
		END
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

