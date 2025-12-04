USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE	--	CREATE	--	DROP
PROCEDURE [dbo].[usp_lab_merckmx_facturas] 
@fecha VARCHAR(10)

/*
EXECUTE usp_lab_merckmx_facturas	'2011-07-31'
SELECT * FROM lab_merckmx_factura
SELECT * FROM lab_merckmx_control_facturas
*/
WITH ENCRYPTION
AS
--	FACTURAS
--	12	JUN	2009
--	27	OCT	2009					AGREGAR	LETRA A PUNTOS DE VENTA
--	01	MAR	2010					CAMBIO DE NOMBRE DE USP
--	06	SEP	2010					CORRECION EN FORMULA DE IMPORTE

DECLARE @sucursal INT, @ejecucion VARCHAR(23)
SET @ejecucion = GETDATE()

IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES 
    WHERE TABLE_TYPE='BASE TABLE' AND TABLE_NAME='lab_merckmx_factura') 
	TRUNCATE TABLE lab_merckmx_factura
ELSE
	BEGIN
		CREATE --	DROP
		TABLE lab_merckmx_factura (
			ClaveDist					VARCHAR(20),
			ClaveSucDist			VARCHAR(20),
			FechaDoc					VARCHAR(20),
			ClaseFacturacion	VARCHAR(20),
			Numero						VARCHAR(20),
			ClaveCliente			VARCHAR(20),
			ClaveSubd					VARCHAR(20),
			Pedido						VARCHAR(20),
			MotivoCancelacion	VARCHAR(20),
			CodigoMat					VARCHAR(20),
			EAN								VARCHAR(20),
			CantFacturada			INT,
			UnidadMedida			VARCHAR(20),
			PrecioUnitario		MONEY,
			Valor							MONEY,
			Lote							VARCHAR(20)		
	--		PRIMARY KEY (ClaveSucDist,ClaveCliente,FechaDoc, Numero, Pedido, CodigoMat, EAN, CantFacturada)
		)
			CREATE INDEX idx_lmerckmx_fe ON lab_merckmx_factura (ClaveSucDist,ClaveCliente,FechaDoc, Numero, Pedido, CodigoMat, EAN, CantFacturada)
	END

IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES 
    WHERE TABLE_TYPE='BASE TABLE' AND TABLE_NAME='lab_merckmx_control_facturas') 
	TRUNCATE TABLE lab_merckmx_control_facturas
ELSE
	CREATE --	DROP
	TABLE lab_merckmx_control_facturas	(
		TotalRegistros	INT								NOT NULL,
		SumaEAN					DOUBLE PRECISION 	NOT NULL,	--	BIGINT,
		SumaCantidad		MONEY							NOT NULL,
		SumaPrecio			MONEY							NOT NULL,
		SumaValor				MONEY							NOT NULL
	PRIMARY KEY (TotalRegistros, SumaEAN,SumaCantidad, SumaPrecio, SumaValor)	
		)

SELECT * INTO #lab_merckmx_factura FROM lab_merckmx_factura WHERE 1=0

--ALTER TABLE #lab_merckmx_factura ADD PRIMARY KEY (ClaveSucDist,ClaveCliente,FechaDoc, Numero, Pedido, CodigoMat, EAN, CantFacturada)
CREATE INDEX idx_tmp ON #lab_merckmx_factura  (ClaveSucDist,ClaveCliente,FechaDoc, Numero,CodigoMat,EAN, CantFacturada)

SELECT codigo,cod_barras,descripcion,p_costo 
INTO #lab_merckmx_productos 
FROM maestro_productos_baan mpb 
WHERE mpb.lab_corto IN (SELECT lab_corto FROM lab_fusiones WHERE id_lab = 'MERCKMX')

ALTER TABLE #lab_merckmx_productos ADD PRIMARY KEY (codigo)

DECLARE cursor_sucursales CURSOR forward_only FOR 
	SELECT sucursal FROM SUCURSALES

--IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES 
--    WHERE TABLE_TYPE='BASE TABLE' AND TABLE_NAME='lab_merckmx_control_facturas') 
--	DROP TABLE lab_merckmx_control_facturas

OPEN cursor_sucursales
FETCH FROM cursor_sucursales INTO @sucursal

WHILE @@fetch_status = 0
BEGIN
	PRINT @sucursal

	SELECT 	--  TOP 25
		'MARZAM'																														ClaveDist,	
		RIGHT(REPLICATE('0',2)+CONVERT(VARCHAR,f.Sucursal),2) 							ClaveSucDist,	--	Sucursal
		CONVERT(VARCHAR(10),fecha_factura,104)															FechaDoc,
		'FC'																																ClaseFacturacion,
		CONVERT(VARCHAR,CONVERT(INT,f.factura))															Numero,
		CONVERT(VARCHAR,CONVERT(INT,f.cliente))															ClaveCliente,
		'NA'																																ClaveSubd,
		CASE WHEN rtrim(ltrim(f.orden)) = '' THEN 'NA' 
					ELSE rtrim(ltrim(f.orden)) END																Pedido,
		'NA'																																MotivoCancelacion,
		CONVERT(VARCHAR,CONVERT(INT,f.codigo))															CodigoMat,
		mpb.cod_barras																											CodigoEAN,
		f.piezas_surtidas_con_cargo																					CantFacturada,
		'PZA'																																UnidadMedida,
		--	f.precio_farm_sin_imp PrecioUnitario,
		mpb.p_costo																													PrecioUnitario,				--	CORRECCION
		CONVERT(MONEY,f.piezas_surtidas_con_cargo * f.precio_farm_sin_imp)	Valor,
		--CONVERT(MONEY,f.piezas_surtidas_con_cargo * mpb.p_costo)	Valor,								--	CORRECCION
		'NA'																																Lote
	INTO #lab_merckmx_facturas
	FROM facturacion_electronica_estandar f WITH (NOLOCK) 
	LEFT OUTER JOIN #lab_merckmx_productos mpb WITH (NOLOCK) on mpb.codigo = f.codigo
	WHERE f.sucursal = @sucursal AND 
	f.fecha_factura  = CONVERT(SMALLDATETIME,@fecha,121)
	/*BETWEEN
		DATEADD(DD, -7, CONVERT(SMALLDATETIME,@fecha,121) ) AND CONVERT(SMALLDATETIME,@fecha,121)	*/
		AND	mpb.cod_barras IS NOT NULL


	INSERT INTO #lab_merckmx_factura 
		SELECT 
			ClaveDist,
			ClaveSucDist,
			FechaDoc,
			ClaseFacturacion,
			Numero,
			ClaveCliente,
			ClaveSubd,
			Pedido,
			MotivoCancelacion,
			CodigoMat,
			CodigoEAN,
			CantFacturada,
			UnidadMedida,
			PrecioUnitario,
			Valor,
			Lote
		FROM #lab_merckmx_facturas

	DROP TABLE #lab_merckmx_facturas
	FETCH NEXT FROM cursor_sucursales INTO @sucursal
END

CLOSE cursor_sucursales
DEALLOCATE cursor_sucursales
/*
UPDATE lab_merckmx_factura SET lote = ''
UPDATE lab_merckmx_factura SET ClaveSucDist = '17' WHERE ClaveSucDist = '50'
UPDATE lab_merckmx_factura SET ClaveSucDist = '18' WHERE ClaveSucDist = '51'
UPDATE lab_merckmx_factura SET ClaveSucDist = '19' WHERE ClaveSucDist = '52'
*/

INSERT INTO lab_merckmx_factura 
	SELECT * FROM #lab_merckmx_factura

---------------	20 / OCTUBRE / 2009	-----------------	
UPDATE lab_merckmx_factura SET 
	ClaveSucDist = RIGHT(REPLICATE('0',2) + CONVERT(VARCHAR,suc.almacen) ,2)
FROM lab_merckmx_factura facturas
INNER JOIN sucursales suc ON CONVERT(INT,facturas.ClaveSucDist) = suc.sucursal

UPDATE lab_merckmx_factura SET 
	ClaveCliente = CONVERT(VARCHAR,suc.ibs_letra) + RIGHT(REPLICATE('0',5)+ ClaveCliente  ,5)
FROM lab_merckmx_factura facturas
INNER JOIN sucursales suc ON CONVERT(INT,facturas.ClaveSucDist) = suc.sucursal


--UPDATE lab_merckmx_factura SET pedido = '' where pedido = 'N/A'
-- CONVERT(VARCHAR(10),current_timestamp-1,121)

DECLARE @total_registros INT
DECLARE @sum_ean DOUBLE	PRECISION--	bigINT
DECLARE @sum_cantidad INT
DECLARE @sum_precio NUMERIC(12,2)
DECLARE @sum_valor NUMERIC(12,2)

SET @total_registros	=	(SELECT ISNULL(COUNT(*)														,0)	FROM lab_merckmx_factura)
SET @sum_ean					=	(SELECT ISNULL(SUM(CONVERT(DOUBLE PRECISION,EAN))	,0)	FROM lab_merckmx_factura)	--	BIGINT
SET @sum_cantidad			=	(SELECT ISNULL(SUM(CantFacturada)									,0)	FROM lab_merckmx_factura)
SET @sum_precio				=	(SELECT ISNULL(SUM(PrecioUnitario)								,0)	FROM lab_merckmx_factura)
SET @sum_valor				=	(SELECT ISNULL(SUM(valor)													,0)	FROM lab_merckmx_factura)


INSERT INTO lab_merckmx_control_facturas
SELECT
	 @total_registros	TotalRegistros,
	 @sum_ean					SumaEAN,
	 @sum_cantidad		SumaCantidad,
	 @sum_precio			SumaPrecio,
	 @sum_valor				SumaValor

--SELECT * FROM #lab_merckmx_productos

EXECUTE usp_estadisticas_samayoa 'usp_lab_merckmx_facturas', @total_registros, @ejecucion

SELECT 
	 LEFT(ClaveDist					 + REPLICATE(' ',10) 										,10)				ClaveDist					,
	RIGHT(REPLICATE(' ',10)  + ClaveSucDist			 										,10)				ClaveSucDist				,
	 LEFT(FechaDoc					 + REPLICATE(' ',10) 										,10)				FechaDoc						,
	 LEFT(ClaseFacturacion	 + REPLICATE(' ',02) 										,02)				ClaseFacturacion		,
	RIGHT(REPLICATE(' ',15)  + 							Numero									,15)				Numero							,
	RIGHT(REPLICATE(' ',10)	 + ClaveCliente			 										,10)				ClaveCliente				,
	RIGHT(REPLICATE(' ',10)	 + ClaveSubd				 										,10)				ClaveSubd					,
	 LEFT(Pedido						 + REPLICATE(' ',15) 										,15)				Pedido							,
	 LEFT(MotivoCancelacion	 + REPLICATE(' ',03) 										,03)				MotivoCancelacion	,
	 LEFT(CodigoMat					 + REPLICATE(' ',18) 										,18)				CodigoMat					,
	RIGHT(REPLICATE(' ',18) + CONVERT(VARCHAR,CONVERT(BIGINT,EAN))	,18)				EAN								,
	RIGHT(REPLICATE(' ',10) + CONVERT(VARCHAR,CantFacturada)				,10)				CantFacturada			,
	 LEFT(UnidadMedida			+	REPLICATE(' ',03)											,03)				UnidadMedida				,
	RIGHT(REPLICATE(' ',18) + CONVERT(VARCHAR,PrecioUnitario)				,18) 				PrecioUnitario			,
	RIGHT(REPLICATE(' ',18) + CONVERT(VARCHAR,Valor)								,18) 				Valor							--,
--Lote							VARCHAR(20)	
FROM lab_merckmx_factura
ORDER BY ClaveSucDist
GO
