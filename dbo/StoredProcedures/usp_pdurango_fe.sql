
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE	--	CREATE
PROCEDURE [dbo].[usp_pdurango_fe] @fecha VARCHAR(10),	@bloque VARCHAR(2)
WITH ENCRYPTION
AS

/*
EXECUTE usp_pdurango_fe '2011-04-04','P1'
EXECUTE usp_pdurango_fe '2011-04-04','P2'
EXECUTE usp_pdurango_fe '2011-04-04','P3'
EXECUTE usp_pdurango_fe '2011-04-04','P4'
EXECUTE usp_pdurango_fe '2011-04-04','P5'
*/

/*
DECLARE @bloque VARCHAR(2)
SET @bloque = 'P3'

DECLARE @fecha VARCHAR(10)
SET @fecha = '2011-01-06'
*/

CREATE TABLE #fe_pdurango	(
	fecha										VARCHAR( 6)		,
	cliente									VARCHAR( 5)		,
	folio_fiscal						VARCHAR( 7)		,
	cod_barras							VARCHAR(14)		,
	codigo									VARCHAR( 7)		,
	descripcion							VARCHAR(30)		,
	cant_surtida						VARCHAR( 6)		,
	cant_oferta							VARCHAR( 6)		,
	prec_farm_m_desc				VARCHAR(10)		,
	campo1									VARCHAR(10)		,
	descto_comer						VARCHAR(10)		,
	iva											VARCHAR(10)		,
	campo2									VARCHAR(10)		,
	prec_pub								VARCHAR(10)		
	PRIMARY KEY	(cliente, folio_fiscal, codigo, cant_surtida)
	)
	
INSERT INTO #fe_pdurango
SELECT
	CONVERT(VARCHAR( 6),f.fecha_factura, 12)																																				fecha				,
	f.cliente																																																				cliente			,
	RIGHT(REPLICATE('0', 7) + CONVERT(VARCHAR,CONVERT(INT,f.folio_fiscal)), 7)																			folio_fiscal,
	LEFT (f.cod_barras + REPLICATE(' ',14)																,14)																			cod_barras	,
	f.codigo																																																				codigo			,
	LEFT(f.descripcion + REPLICATE(' ',30)																,30)																			descripcion	,
	RIGHT(REPLICATE('0', 6) + CONVERT(VARCHAR,f.piezas_surtidas_con_cargo), 6)																			cant_surt		,
	RIGHT(REPLICATE('0', 6) + CONVERT(VARCHAR,f.piezas_surtidas_sin_cargo), 6)																			cant_ofer		,
	RIGHT(REPLICATE('0',10) + CONVERT(VARCHAR,f.precio_farm_sin_imp	* (1-(f.porcentaje_descto_comercial/100)) )	,10)	prec_farm_m_desc	,
	RIGHT(REPLICATE('0', 5) + CONVERT(VARCHAR,CONVERT(MONEY,0)					)	, 5)																			campo1							,
	RIGHT(REPLICATE('0', 5) + CONVERT(VARCHAR,f.descto_comercial				)	, 5)																			descto_comercial		,
	RIGHT(REPLICATE('0',10) + CONVERT(VARCHAR,f.iva											)	,10)																			iva									,
	RIGHT(REPLICATE('0',10) + CONVERT(VARCHAR,CONVERT(MONEY,0)					)	,10)																			campo2							,
	RIGHT(REPLICATE('0',10) + CONVERT(VARCHAR,f.precio_pub_sin_imp			)	,10)																			precio_pub_sin_imp
--	s.serie_cfd																																																		serie_cfd		,
FROM facturacion_electronica_estandar f		WITH (NOLOCK)
INNER JOIN sucursales s										WITH (NOLOCK)	ON	s.sucursal = f.sucursal
WHERE f.fecha_tandem = CONVERT(DATETIME,@fecha,121)
	AND f.sucursal = 7
	AND	f.segto = 'G3'	AND f.ctepadre = '176'
	AND (
	(@bloque = 'P1'	AND f.cliente IN ('02499','20172')	)	OR
	(@bloque = 'P2'	AND f.cliente IN ('02500','20173')	)	OR
	(@bloque = 'P3'	AND f.cliente IN ('02501','20174')	)	OR
	(@bloque = 'P3'	AND f.cliente IN ('02511','20175')	)	OR
	(@bloque = 'P5'	AND f.cliente IN ('08072')					)	)
	

--02499
--20172
--
	
SELECT --* 
	fecha										,
	cliente									,
	folio_fiscal						,
	cod_barras							,
	codigo									,
	descripcion							,
	cant_surtida						,
	cant_oferta							,
	prec_farm_m_desc				,
	campo1									,
	descto_comer						,
	iva											,
	campo2									,
	prec_pub								
FROM #fe_pdurango	

DROP TABLE #fe_pdurango
--SELECT * FROM clientes_baan f where sucursal = 7 --and farmacia like '%PENSIONES%'
--	AND	f.segto = 'G3'	AND f.ctepadre = '176'
GO
