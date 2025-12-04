USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

/*
usp_genera_facturacion_electronica_benavides_control '2010-06-22'
usp_fbenavides_fe_cf '2011-01-18'
*/



CREATE 
	--	CREATE
PROCEDURE [dbo].[usp_fbenavides_fe_cf] 
(@fecha varchar(10)) 
WITH ENCRYPTION
as

--  declare @fecha varchar(10)
--  set @fecha = '2008-12-24'
DECLARE @sucursal	INT
DECLARE @segto		VARCHAR(2)
DECLARE @ctepadre	VARCHAR(3)
DECLARE @factura	VARCHAR(8)
DECLARE @sep			VARCHAR(1)
DECLARE @factor		INT
DECLARE @orden		INT

SET @segto = 'C1'
SET @ctepadre = '319'
SET @factor = 100

DECLARE @dias INT

SET @dias = CASE WHEN DATEPART(DW,CONVERT(DATETIME,@fecha,121)) = 1 THEN -2 ELSE -1 END

SET @dias = CASE WHEN DATEPART(DW,CONVERT(DATETIME,@fecha,121)) = 1 THEN -2 ELSE -2 END


SELECT 
	* , 
	0 as orden2 
INTO #facturas_benavides 
FROM facturacion_electronica_estandar f
WHERE --fecha_factura --= CONVERT(datetime,@fecha,121) 
	fecha_tandem --= CONVERT(DATETIME,@fecha,121)
	BETWEEN DATEADD(DD,@dias, CONVERT(datetime,@fecha,121) ) AND CONVERT(DATETIME,@fecha,121) 
AND ctepadre = @ctepadre 
AND segto = @segto
ORDER BY sucursal,serie,factura

SET @sep = ''

--CREATE TABLE #resultados	(
--	tipo					VARCHAR(2),	
--	col1					VARCHAR(500),	
--	orden					INT, 
--	codigo				VARCHAR(7), 
--	cliente				VARCHAR(5), 
--	folio_fiscal	VARCHAR(20)
--	) 

DECLARE  cur_encabezados CURSOR FORWARD_ONLY FOR 
	SELECT sucursal
	FROM #facturas_benavides
	WHERE fecha_factura = CONVERT(DATETIME,@fecha,121) 
		AND ctepadre = @ctepadre 
		AND segto = @segto
	group by sucursal
	order by sucursal

--	@@CURSOR_ROWS

DECLARE @no_fact_encabezado	INT
DECLARE @no_reg_detalle			INT
DECLARE @importe_neto				DECIMAL(14,2)
DECLARE @iva								DECIMAL(14,2)
DECLARE @importe_bruto			DECIMAL(14,2)
DECLARE @descto_comercial		DECIMAL(14,2)

CREATE TABLE #fbenavides_cf	(
	proveedor												VARCHAR( 2),
	fecha														VARCHAR( 8),
	numero_facturas_enc							VARCHAR( 5),
	numero_detalles_enc							VARCHAR( 6),
	importe_enc											VARCHAR(13),
	iva_enc													VARCHAR(13),
	venta_bruta_enc									VARCHAR(13),
	descuentos_enc									VARCHAR(13),
	numero_facturas_det							VARCHAR( 5),
	numero_detalles_det							VARCHAR( 6),
	importe_det											VARCHAR(13),
	iva_det													VARCHAR(13),
	venta_bruta_det									VARCHAR(13),
	descuentos_det									VARCHAR(13),
	tipo														VARCHAR( 1),
	clave														VARCHAR( 1),
	cve_cto_dist										VARCHAR( 2)	
	)

OPEN cur_encabezados
FETCH FROM cur_encabezados INTO @sucursal 

WHILE @@fetch_status = 0
BEGIN
	SET @no_fact_encabezado = (SELECT COUNT(DISTINCT factura) FROM #facturas_benavides WHERE sucursal = @sucursal)	--	
	SET @no_reg_detalle			= (SELECT COUNT(*) registros FROM #facturas_benavides WHERE sucursal = @sucursal )
	SET @importe_neto				=	(SELECT SUM(importe_neto														* @factor) suma FROM #facturas_benavides WHERE sucursal = @sucursal)
	SET @iva								=	(SELECT SUM(iva																			* @factor) suma FROM #facturas_benavides WHERE sucursal = @sucursal)
	SET @importe_bruto			=	(SELECT SUM((importe_bruto - descto_oferta)					* @factor) suma FROM #facturas_benavides WHERE sucursal = @sucursal)
	SET @descto_comercial		=	(SELECT SUM((descto_comercial + bonificacion_iva)		* @factor) suma FROM #facturas_benavides WHERE sucursal = @sucursal)		--	descto_comercial	descto_comercial

--	INSERT INTO #resultados (tipo,col1)         
	INSERT INTO #fbenavides_cf
		SELECT
--			'CF' tipo,
			'05'																																									proveedor						,	
			SUBSTRING(@fecha,1,4)	+	SUBSTRING(@fecha,6,2)	+	SUBSTRING(@fecha,9,2)									fecha								,	
			RIGHT(REPLICATE('0', 5)	+	CONVERT(VARCHAR,@no_fact_encabezado),5)											numero_facturas_enc	,	
			RIGHT(REPLICATE('0', 6)	+	CONVERT(VARCHAR,@no_reg_detalle),6)													numero_detalles_enc	,	
			RIGHT(REPLICATE('0',13)	+	CONVERT(VARCHAR,CONVERT(INT,@importe_neto					) ) ,13)  importe_enc					,	
			RIGHT(REPLICATE('0',13)	+	CONVERT(VARCHAR,CONVERT(INT,@iva									) ) ,13)  iva_enc							,	
			RIGHT(REPLICATE('0',13)	+	CONVERT(VARCHAR,CONVERT(INT,@importe_bruto				) ) ,13)  venta_bruta_enc			,	
			RIGHT(REPLICATE('0',13)	+	CONVERT(VARCHAR,CONVERT(INT,@descto_comercial			) ) ,13)  descuentos_enc			,	
			RIGHT(REPLICATE('0', 5)	+	CONVERT(VARCHAR,@no_fact_encabezado									)	, 5)	numero_facturas_det	,	
			RIGHT(REPLICATE('0', 6)	+	CONVERT(VARCHAR,@no_reg_detalle											)	, 6)	numero_detalles_det	,	
			RIGHT(REPLICATE('0',13)	+	CONVERT(VARCHAR,CONVERT(INT,@importe_neto					) ) ,13)	importe_det					,	
			RIGHT(REPLICATE('0',13)	+	CONVERT(VARCHAR,CONVERT(INT,@iva									) ) ,13)	iva_det							,	
			RIGHT(REPLICATE('0',13)	+	CONVERT(VARCHAR,CONVERT(INT,@importe_bruto				) ) ,13)  venta_bruta_det			,	
			RIGHT(REPLICATE('0',13)	+	CONVERT(VARCHAR,CONVERT(INT,@descto_comercial			) ) ,13)  descuentos_det			,	
			'F'																																										tipo								,	
			'N'																																										clave								, 
			RIGHT(						'00'	+	CONVERT(VARCHAR,@sucursal													)		, 2)	cve_cto_dist
--			COL1
--		FROM #facturas_benavides f
--		INNER JOIN cat_sucursales_benavides b ON f.sucursal = b.sucursal AND f.cliente = b.cuenta 
--		WHERE f.sucursal = @sucursal

		FETCH FROM cur_encabezados INTO @sucursal 

END

CLOSE cur_encabezados
DEALLOCATE cur_encabezados

--	SELECT * FROM #resultados
SELECT * FROM #fbenavides_cf

DROP TABLE #fbenavides_cf

--	DROP TABLE #resultados
--	DROP TABLE #facturas_benavides
GO
