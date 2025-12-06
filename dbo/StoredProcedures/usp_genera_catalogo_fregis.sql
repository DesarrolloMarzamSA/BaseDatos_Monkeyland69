
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE --	CREATE
PROCEDURE [dbo].[usp_genera_catalogo_fregis] --	@sucursal int, @cliente VARCHAR(5)

as

/*
EXECUTE usp_genera_catalogo_fregis
*/

DECLARE @sucursal int
set @sucursal = 7
DECLARE @cliente VARCHAR(5)
SET @cliente = '07799'
--PROCEDIMIENTO PARA  CATALOGO FCIAS. MODERNA DE GDL
--DECLARE @descuento VARCHAR(6)
--SELECT @descuento = RIGHT('   ' + CONVERT(VARCHAR(6), descuento), 6) from clientes_baan where sucursal = @sucursal and cliente = @cliente

DECLARE @descuento MONEY
SELECT @descuento = descuento from clientes_baan where cliente = @cliente AND sucursal = 8	--	@sucursal 


CREATE TABLE #catalogo_fregis	(
	sucursal				INT						,
	codigo					VARCHAR( 7)		,
	descripcion			VARCHAR(30)		,
	cod_barras			VARCHAR(13)		,
	prec_farm				MONEY					,
--	prec_pub				MONEY					,
	descto					MONEY					,
	piezas					INT						,
	clas_fis				VARCHAR(10)		,
	grupo_est				VARCHAR(10)
	PRIMARY KEY (codigo)	)

INSERT INTO #catalogo_fregis
SELECT 
	ib.sucursal																									,
	mpb.codigo																									,
	mpb.descripcion																							,
	mpb.cod_barras																							,
	CASE mpb.grupo_est 
		WHEN 'PC01A' THEN mpb.prec_farm * 1.5
		ELSE mpb.prec_farm END prec_farm													,
	CASE
		WHEN mpb.clas_fis = 'B'		THEN @descuento
		WHEN mpb.clas_fis = 'BA'	THEN @descuento
		WHEN mpb.clas_fis = 'N'		THEN 0 
		WHEN mpb.clas_fis = 'NA'	THEN 0
		WHEN mpb.clas_fis = 'H'		THEN mpb.descto_prod
		WHEN mpb.clas_fis = 'HA'	THEN mpb.descto_prod
		ELSE 0 END descto																					,
	--CASE
	--	WHEN ib.piezas = 0							THEN 0
	--	WHEN ib.piezas between 1 and 50 THEN 1
	--	WHEN ib.piezas > 50							THEN 2 
	--	ELSE 0 END piezas																					,
	CASE
		WHEN ib.piezas = 0								THEN 0
		WHEN ib.piezas between 01 and 10	THEN 1
		WHEN ib.piezas between 11 and 50	THEN 2 
		WHEN ib.piezas > 50								THEN 3
		ELSE 0 END piezas																					,
	clas_fis																										,
	grupo_est
FROM maestro_productos_baan mpb 
INNER JOIN inventario_baan ib ON mpb.codigo = ib.codigo AND ib.sucursal = @sucursal --AND ib.piezas > 0
WHERE CONVERT(INT, mpb.codigo) < dbo.gobierno() 
AND ISNUMERIC(mpb.cod_barras) = 1

--SELECT * FROM #catalogo_fregis

SELECT
	RIGHT(REPLICATE('0', 2) + CONVERT(VARCHAR, sucursal), 2) +	REPLICATE(' '	,	10)						+
	LEFT(CONVERT(VARCHAR, CONVERT(BIGINT, cod_barras)) + REPLICATE(' ',13)		, 13)						+
	LEFT(descripcion + REPLICATE(' ',30), 30)																									+
	RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR,CONVERT(DECIMAL(10,2),prec_farm)), 9)						+
	RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR,descto   ), 6)																	+
	RIGHT(REPLICATE(' ', 2) + CONVERT(VARCHAR,piezas   ), 2)																	+
	codigo col1
FROM #catalogo_fregis


--SELECT
--	codigo, piezas
--FROM #catalogo_fregis
GO
