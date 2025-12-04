CREATE PROCEDURE [dbo].[usp_genera_catalogo_ofertas_fox_fcias_esquivar]
	@sucursal TINYINT,
	@primer_bolsa VARCHAR(5)
AS

DECLARE @segunda_bolsa  VARCHAR(5)
DECLARE @tercer_bolsa  VARCHAR(5)
--SET @primer_bolsa = 'XXPAD'
SET @segunda_bolsa = 'LIBRE'
SET @tercer_bolsa = 'ZFHYB'

--DECLARE @sucursal AS TINYINT
--DECLARE @primer_bolsa  VARCHAR(5)
--DECLARE @segunda_bolsa  VARCHAR(5)
--DECLARE @tercer_bolsa  VARCHAR(5)
--SET @sucursal = 5
--SET @primer_bolsa = 'XXPAD'
--SET @segunda_bolsa = 'LIBRE'
--SET @tercer_bolsa = 'ZFHYB'

SELECT	t1.codigo +
		' ' +
		LEFT(SUBSTRING(t1.descripcion, 1, 16) + REPLICATE(' ', 16), 16) + 
		' ' +
		LEFT(SUBSTRING(t1.descripcion, 17, 16) + REPLICATE(' ', 15), 15) + 
		CASE t1.grupo_est
			WHEN 'PC01A' THEN RIGHT(REPLICATE('0', 8) + CONVERT(VARCHAR(8), CONVERT(INT, (t1.prec_farm * 100) + (t1.prec_farm * 0.5))), 8)
			ELSE RIGHT(REPLICATE('0', 8) + CONVERT(VARCHAR(8), CONVERT(INT, t1.prec_farm * 100)), 8) 
		END +
		' ' + 
		CASE t1.grupo_est
			WHEN 'PC01A' THEN RIGHT(REPLICATE('0', 8) + CONVERT(VARCHAR(8), CONVERT(INT, (t1.prec_pub * 100) + (t1.prec_pub * 0.5))), 8)
			ELSE RIGHT(REPLICATE('0', 8) + CONVERT(VARCHAR(8), CONVERT(INT, t1.prec_pub * 100)), 8) 
		END +		' ' +
		'001 ' +
		'000 ' +
		RIGHT(REPLICATE('0', 2) + CONVERT(VARCHAR(2), CONVERT(INT, t3.porcentaje * 100)), 2) +
		' ' +
		LEFT(t1.clas_fis + REPLICATE(' ', 2), 2)
FROM	maestro_productos_baan t1 INNER JOIN inventario_baan t2 ON 
		t1.codigo = t2.codigo AND 
		t2.sucursal = @sucursal INNER JOIN dboferta t3 ON 
		t2.codigo = t3.codigo AND
		t2.sucursal = t3.sucursal AND 
		t3.bolsa = @primer_bolsa 
WHERE	CONVERT(INT, t1.codigo) < dbo.gobierno() AND
		ISNUMERIC(t1.cod_barras) = 1 AND
		SUBSTRING(t1.status, 1,1) <> 'B' --NOT LIKE 'B%'
UNION
SELECT	t1.codigo +
		' ' +
		LEFT(SUBSTRING(t1.descripcion, 1, 16) + REPLICATE(' ', 16), 16) + 
		' ' +
		LEFT(SUBSTRING(t1.descripcion, 17, 16) + REPLICATE(' ', 15), 15) + 
		CASE t1.grupo_est
			WHEN 'PC01A' THEN RIGHT(REPLICATE('0', 8) + CONVERT(VARCHAR(8), CONVERT(INT, (t1.prec_farm * 100) + (t1.prec_farm * 0.5))), 8)
			ELSE RIGHT(REPLICATE('0', 8) + CONVERT(VARCHAR(8), CONVERT(INT, t1.prec_farm * 100)), 8) 
		END +
		' ' + 
		CASE t1.grupo_est
			WHEN 'PC01A' THEN RIGHT(REPLICATE('0', 8) + CONVERT(VARCHAR(8), CONVERT(INT, (t1.prec_pub * 100) + (t1.prec_pub * 0.5))), 8)
			ELSE RIGHT(REPLICATE('0', 8) + CONVERT(VARCHAR(8), CONVERT(INT, t1.prec_pub * 100)), 8) 
		END +		' ' +
		'001 ' +
		'000 ' +
		RIGHT(REPLICATE('0', 2) + CONVERT(VARCHAR(2), CONVERT(INT, t3.porcentaje * 100)), 2) +
		' ' +
		LEFT(t1.clas_fis + REPLICATE(' ', 2), 2)
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
SELECT	t1.codigo +
		' ' +
		LEFT(SUBSTRING(t1.descripcion, 1, 16) + REPLICATE(' ', 16), 16) + 
		' ' +
		LEFT(SUBSTRING(t1.descripcion, 17, 16) + REPLICATE(' ', 15), 15) + 
		CASE t1.grupo_est
			WHEN 'PC01A' THEN RIGHT(REPLICATE('0', 8) + CONVERT(VARCHAR(8), CONVERT(INT, (t1.prec_farm * 100) + (t1.prec_farm * 0.5))), 8)
			ELSE RIGHT(REPLICATE('0', 8) + CONVERT(VARCHAR(8), CONVERT(INT, t1.prec_farm * 100)), 8) 
		END +
		' ' + 
		CASE t1.grupo_est
			WHEN 'PC01A' THEN RIGHT(REPLICATE('0', 8) + CONVERT(VARCHAR(8), CONVERT(INT, (t1.prec_pub * 100) + (t1.prec_pub * 0.5))), 8)
			ELSE RIGHT(REPLICATE('0', 8) + CONVERT(VARCHAR(8), CONVERT(INT, t1.prec_pub * 100)), 8) 
		END +		' ' +
		'001 ' +
		'000 ' +
		RIGHT(REPLICATE('0', 2) + CONVERT(VARCHAR(2), CONVERT(INT, t3.porcentaje * 100)), 2) +
		' ' +
		LEFT(t1.clas_fis + REPLICATE(' ', 2), 2)
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

