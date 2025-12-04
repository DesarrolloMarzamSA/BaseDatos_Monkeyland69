

CREATE	--	CREATE	--	DROP
PROCEDURE usp_lab_msd_facturas (@fecha VARCHAR(10))
--	PROCEDURE usp_lab_lab_msd_facturas (@fecha VARCHAR(10))
/*
usp_lab_msd_facturas	'2011-02-28'
SELECT * FROM lab_msd_factura
SELECT * FROM lab_msd_control_facturas
*/
AS
--	FACTURAS	 MSD (MERCK SHARP & DOHME + SCHERING PLOUGH )

--	2011-07-30	CREACION EN PRODUCCION

DECLARE @sucursal INT, @ejecucion VARCHAR(23)
SET @ejecucion = CONVERT(VARCHAR(23),GETDATE(),121)

IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES 
    WHERE TABLE_TYPE='BASE TABLE' AND TABLE_NAME='lab_msd_factura') 
	TRUNCATE TABLE lab_msd_factura
ELSE
	CREATE TABLE lab_msd_factura (
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
		PRIMARY KEY (ClaveSucDist,ClaveCliente,Numero,CodigoMat)
	)

/*
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES 
    WHERE TABLE_TYPE='BASE TABLE' AND TABLE_NAME='lab_msd_facturas_control') 
	TRUNCATE TABLE lab_msd_control_facturas
ELSE
	CREATE --	DROP
	TABLE lab_msd_facturas_control	(
		TotalRegistros	INT								NOT NULL,
		SumaEAN					DOUBLE PRECISION 	NOT NULL,	--	BIGINT,
		SumaCantidad		MONEY							NOT NULL,
		SumaPrecio			MONEY							NOT NULL,
		SumaValor				MONEY							NOT NULL
	PRIMARY KEY (TotalRegistros, SumaEAN,SumaCantidad, SumaPrecio, SumaValor)	
		)
*/
SELECT * INTO #lab_msd_factura FROM lab_msd_factura WHERE 1=0

SELECT codigo,cod_barras,descripcion,p_costo INTO #lab_msd_productos 
FROM maestro_productos mpb WHERE mpb.lab_corto IN (SELECT lab_corto FROM lab_fusiones WHERE id_lab = 'MSD')

ALTER TABLE #lab_msd_productos ADD PRIMARY KEY (codigo)

DECLARE cursor_sucursales CURSOR forward_only FOR 
	SELECT sucursal FROM SUCURSALES

--IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES 
--    WHERE TABLE_TYPE='BASE TABLE' AND TABLE_NAME='lab_msd_control_facturas') 
--	DROP TABLE lab_msd_control_facturas

OPEN cursor_sucursales
FETCH FROM cursor_sucursales INTO @sucursal

WHILE @@fetch_status = 0
BEGIN
	PRINT @sucursal
	SELECT --	TOP 25
		'MARZAM'																									ClaveDist,	
		RIGHT(REPLICATE('0',2)+CONVERT(VARCHAR,enc.Sucursal),2) 	ClaveSucDist,	--	Sucursal
		CONVERT(VARCHAR(10),fechaprog,104)												FechaDoc,
		'FC'																											ClaseFacturacion,
		CONVERT(VARCHAR,CONVERT(INT,enc.factura))									Numero,
		CONVERT(VARCHAR,CONVERT(INT,enc.cliente))									ClaveCliente,
		'NA'																											ClaveSubd,
		CASE WHEN rtrim(ltrim(enc.orden)) = '' THEN 'NA' 
					ELSE rtrim(ltrim(enc.orden)) END										Pedido,
		'NA'																											MotivoCancelacion,
		CONVERT(VARCHAR,CONVERT(INT,f.codigo))										CodigoMat,
		mpb.cod_barras																						CodigoEAN,
		f.piezas_surtidas_con_cargo																CantFacturada,
		'PZA'																											UnidadMedida,
		--	f.precio_farm_sin_imp PrecioUnitario,
		mpb.p_costo																								PrecioUnitario,				--	CORRECCION
		--	f.piezas_surtidas_con_cargo * f.precio_farm_sin_imp Valor,
		CONVERT(MONEY,f.piezas_surtidas_con_cargo * mpb.p_costo)	Valor,								--	CORRECCION
		'NA'																											Lote
	INTO #lab_msd_facturas
	FROM encabezado enc
	INNER JOIN facturacion_electronica_estandar f ON enc.sucursal = f.sucursal 
		AND enc.factura = f.factura
--	INNER 
	LEFT OUTER JOIN #lab_msd_productos mpb on mpb.codigo = f.codigo --	and mpb.lab_corto = 'msd'
--	INNER JOIN sucursales_lab_msdm Z on Z.SUCURSAL = enc.sucursal
	WHERE enc.sucursal = @sucursal AND 
--	enc.fechaprog = CONVERT(datetime,CONVERT(VARCHAR(10),current_timestamp,121),121)
	enc.fechaprog = CONVERT(datetime,@fecha,121)	AND		--	CONVERT(VARCHAR(10),current_timestamp,121)
	f.sucursal = @sucursal AND 
	F.fecha_factura = CONVERT(datetime,@fecha,121)	AND	--	CONVERT(VARCHAR(10),current_timestamp,121)
	mpb.cod_barras IS NOT NULL

	INSERT INTO #lab_msd_factura 
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
		FROM #lab_msd_facturas

	DROP TABLE #lab_msd_facturas
	FETCH NEXT FROM cursor_sucursales INTO @sucursal
END

CLOSE cursor_sucursales
DEALLOCATE cursor_sucursales
/*
UPDATE lab_msd_factura SET lote = ''
UPDATE lab_msd_factura SET ClaveSucDist = '17' WHERE ClaveSucDist = '50'
UPDATE lab_msd_factura SET ClaveSucDist = '18' WHERE ClaveSucDist = '51'
UPDATE lab_msd_factura SET ClaveSucDist = '19' WHERE ClaveSucDist = '52'
*/

INSERT INTO lab_msd_factura 
	SELECT * FROM #lab_msd_factura

---------------	20 / OCTUBRE / 2009	-----------------	
UPDATE lab_msd_factura SET 
	ClaveSucDist = RIGHT(REPLICATE('0',2) + CONVERT(VARCHAR,suc.almacen) ,2)
FROM lab_msd_factura facturas
INNER JOIN sucursales suc ON CONVERT(INT,facturas.ClaveSucDist) = suc.sucursal

UPDATE lab_msd_factura SET 
	ClaveCliente = CONVERT(VARCHAR,suc.ibs_letra) + RIGHT(REPLICATE('0',5)+ ClaveCliente  ,5)
FROM lab_msd_factura facturas
INNER JOIN sucursales suc ON CONVERT(INT,facturas.ClaveSucDist) = suc.sucursal


--UPDATE lab_msd_factura SET pedido = '' where pedido = 'N/A'
-- CONVERT(VARCHAR(10),current_timestamp-1,121)

DECLARE @total_registros INT
DECLARE @sum_ean DOUBLE	PRECISION--	bigINT
DECLARE @sum_cantidad INT
DECLARE @sum_precio NUMERIC(12,2)
DECLARE @sum_valor NUMERIC(12,2)

SET @total_registros	=	(SELECT ISNULL(COUNT(*)														,0)	FROM lab_msd_factura)
SET @sum_ean					=	(SELECT ISNULL(SUM(CONVERT(DOUBLE PRECISION,EAN))	,0)	FROM lab_msd_factura)	--	BIGINT
SET @sum_cantidad			=	(SELECT ISNULL(SUM(CantFacturada)									,0)	FROM lab_msd_factura)
SET @sum_precio				=	(SELECT ISNULL(SUM(PrecioUnitario)								,0)	FROM lab_msd_factura)
SET @sum_valor				=	(SELECT ISNULL(SUM(valor)													,0)	FROM lab_msd_factura)

/*
INSERT INTO lab_msd_facturas_control
SELECT
	 @total_registros	TotalRegistros,
	 @sum_ean					SumaEAN,
	 @sum_cantidad		SumaCantidad,
	 @sum_precio			SumaPrecio,
	 @sum_valor				SumaValor

--SELECT * FROM #lab_msd_productos
*/

DECLARE @estor VARCHAR(50)
SET @estor = 'usp_lab_msd_facturas '+@fecha
EXECUTE usp_estadisticas_samayoa @estor, @total_registros, @ejecucion

SELECT * FROM lab_msd_factura

GO

