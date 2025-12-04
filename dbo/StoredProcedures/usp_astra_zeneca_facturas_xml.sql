CREATE 
	--	CREATE
PROCEDURE [dbo].[usp_astra_zeneca_facturas_xml] (@fecha VARCHAR(10))
--	PROCEDURE usp_lab_az_facturas_xml (@fecha VARCHAR(10))
/*
EXECUTE usp_astra_zeneca_facturas_xml	'2012-09-03'
*/
AS
--	FACTURAS
--	12	JUN	2009
--	27	OCT	2009					AGREGAR	LETRA A PUNTOS DE VENTA
--	01	MAR	2010					CAMBIO DE NOMBRE DE USP
--	06	SEP	2010					CORRECION EN FORMULA DE IMPORTE
--	25	MAR	2011					SE RETRASA EL ENVIO 1 DIA 
--	03	OCT	2011					SE CAMBIA TABLA DE MAESTRO DE PRODUCTOS
--	20	FEB	2012					SE AGREGO FILTRO DE CUENTRAS TRANSFER

--SET @fecha = CONVERT(VARCHAR(10),DATEADD(DD ,-1, CONVERT(DATETIME,@fecha,121) ),121)

DECLARE @sucursal INT

--	DROP TABLE tmp_az_factura_xml

IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES 
    WHERE TABLE_TYPE='BASE TABLE' AND TABLE_NAME='tmp_az_factura_xml') 
	TRUNCATE TABLE tmp_az_factura_xml
ELSE
	CREATE TABLE tmp_az_factura_xml (
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
		PRIMARY KEY (ClaveSucDist, ClaveCliente, Numero, CodigoMat, CantFacturada)
	)

SELECT * INTO #tmp_az_factura_xml FROM tmp_az_factura_xml WHERE 1=0

SELECT codigo,cod_barras,descripcion,p_costo INTO #az_productos 
FROM maestro_productos mpb  WITH (NOLOCK)
WHERE 
(mpb.lab_corto = 'ASTRAZ' AND ISNUMERIC(cod_barras) = 1 AND CONVERT(BIGINT, cod_barras) > 0) OR
(
cod_barras IN (
'7501091440612',
'7501091440629',
'7501091440643'
) 
)

CREATE INDEX tmp_az_mpb ON #az_productos	(codigo)

DECLARE cursor_sucursales CURSOR forward_only FOR 
	SELECT sucursal FROM SUCURSALES

--IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES 
--    WHERE TABLE_TYPE='BASE TABLE' AND TABLE_NAME='tmp_az_control_facturas') 
--	DROP TABLE tmp_az_control_facturas

OPEN cursor_sucursales
FETCH FROM cursor_sucursales INTO @sucursal

WHILE @@fetch_status = 0
BEGIN
	PRINT @sucursal
	SELECT --	top 10
		'MARZAM'																									ClaveDist,	
		RIGHT(REPLICATE('0',2)+CONVERT(VARCHAR,f.Sucursal),2) 		ClaveSucDist,	--	Sucursal
		CONVERT(VARCHAR(10),f.fecha_factura,104)									FechaDoc,
		'FC'																											ClaseFacturacion,
		CONVERT(VARCHAR,CONVERT(INT,f.factura))										Numero,
		CONVERT(VARCHAR,CONVERT(INT,f.cliente))										ClaveCliente,
		'NA'																											ClaveSubd,
		CASE WHEN rtrim(ltrim(f.orden)) = '' THEN 'NA' 
					ELSE rtrim(ltrim(f.orden)) END											Pedido,
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
	INTO #tmp_az_facturas

	FROM facturacion_electronica_estandar f  WITH (NOLOCK)--ON enc.sucursal = f.sucursal AND enc.factura = f.factura
	--FROM encabezado enc
	--INNER JOIN facturacion_electronica_estandar f ON enc.sucursal = f.sucursal 
	--	AND enc.factura = f.factura
	INNER JOIN #az_productos mpb on mpb.codigo = f.codigo --	and mpb.lab_corto = 'ASTRAZ'
	--	WHERE enc.sucursal = @sucursal AND 
	WHERE f.sucursal = @sucursal AND 
	--enc.fechaprog = CONVERT(DATETIME,@fecha,121)	--	CONVERT(VARCHAR(10),current_timestamp,121)
	f.fecha_factura = CONVERT(DATETIME,@fecha,121)	--	CONVERT(VARCHAR(10),current_timestamp,121)
	--	enc.fecha_tandem = CONVERT(datetime,@fecha,121)	--	CONVERT(VARCHAR(10),current_timestamp,121)
	AND f.sucursal = @sucursal 
	--	AND f.fecha_tandem = CONVERT(datetime,@fecha,121)	--	CONVERT(VARCHAR(10),current_timestamp,121)
	AND f.fecha_factura = CONVERT(DATETIME,@fecha,121)	--	CONVERT(VARCHAR(10),current_timestamp,121)


AND NOT
(   
   (f.sucursal =  1 AND f.cliente in ('37270','37280','37300'))
OR (f.sucursal =  3 AND f.cliente = '00834')
OR (f.sucursal =  4 AND f.cliente in ('82552','82554'))
OR (f.sucursal =  6 AND f.cliente in ('01412','01413','01414'))
OR (f.sucursal =  7 AND f.cliente in ('06441','07840','07844'))
OR (f.sucursal = 16 AND f.cliente in ('40981','40982','42222'))
OR (f.sucursal = 17 AND f.cliente in ('10871','12084','12104','12105','12385','12508'))
OR (f.sucursal = 18 AND f.cliente in ('30312','30314','32034','32056','32058','32128','32165','32284','50298','50351'))
OR (f.sucursal = 24 AND f.cliente in ('50298','50351'))
OR (f.sucursal = 25 AND f.cliente in ('20946','20948','23308','23311','23416','23538'))
)
	INSERT INTO #tmp_az_factura_xml 
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
		FROM #tmp_az_facturas

	DROP TABLE #tmp_az_facturas
	FETCH NEXT FROM cursor_sucursales INTO @sucursal
END

CLOSE cursor_sucursales
DEALLOCATE cursor_sucursales
/*
UPDATE tmp_az_factura_xml SET lote = ''
UPDATE tmp_az_factura_xml SET ClaveSucDist = '17' WHERE ClaveSucDist = '50'
UPDATE tmp_az_factura_xml SET ClaveSucDist = '18' WHERE ClaveSucDist = '51'
UPDATE tmp_az_factura_xml SET ClaveSucDist = '19' WHERE ClaveSucDist = '52'
*/

INSERT INTO tmp_az_factura_xml 
	SELECT * FROM #tmp_az_factura_xml

---------------	20 / OCTUBRE / 2009	-----------------	
UPDATE tmp_az_factura_xml SET 
	ClaveSucDist = RIGHT(REPLICATE('0',2) + CONVERT(VARCHAR,suc.almacen) ,2)
FROM tmp_az_factura_xml facturas
INNER JOIN sucursales suc ON CONVERT(INT,facturas.ClaveSucDist) = suc.sucursal

UPDATE tmp_az_factura_xml SET 
	ClaveCliente = CONVERT(VARCHAR,suc.ibs_letra) + RIGHT(REPLICATE('0',5)+ ClaveCliente  ,5)
FROM tmp_az_factura_xml facturas
INNER JOIN sucursales suc ON CONVERT(INT,facturas.ClaveSucDist) = suc.sucursal


--UPDATE tmp_az_factura_xml SET pedido = '' where pedido = 'N/A'
-- CONVERT(VARCHAR(10),current_timestamp-1,121)

DECLARE @total_registros INT
DECLARE @sum_ean DOUBLE	PRECISION--	bigINT
DECLARE @sum_cantidad INT
DECLARE @sum_precio NUMERIC(12,2)
DECLARE @sum_valor NUMERIC(12,2)

SET @total_registros	=	(SELECT ISNULL(COUNT(*)														,0)	FROM tmp_az_factura_xml)
SET @sum_ean					=	(SELECT ISNULL(SUM(CONVERT(DOUBLE PRECISION,EAN))	,0)	FROM tmp_az_factura_xml)	--	BIGINT
SET @sum_cantidad			=	(SELECT ISNULL(SUM(CantFacturada)									,0)	FROM tmp_az_factura_xml)
SET @sum_precio				=	(SELECT ISNULL(SUM(PrecioUnitario)								,0)	FROM tmp_az_factura_xml)
SET @sum_valor				=	(SELECT ISNULL(SUM(valor)													,0)	FROM tmp_az_factura_xml)

IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES 
    WHERE TABLE_TYPE='BASE TABLE' AND TABLE_NAME='tmp_az_control_facturas') 
	TRUNCATE TABLE tmp_az_control_facturas
ELSE
	CREATE TABLE tmp_az_control_facturas	(
		TotalRegistros	INT								NOT NULL,
		SumaEAN					DOUBLE PRECISION 	NOT NULL,	--	BIGINT,
		SumaCantidad		MONEY							NOT NULL,
		SumaPrecio			MONEY							NOT NULL,
		SumaValor				MONEY							NOT NULL
	PRIMARY KEY (TotalRegistros, SumaEAN,SumaCantidad, SumaPrecio, SumaValor)	
		)

INSERT INTO tmp_az_control_facturas
SELECT
	 @total_registros	TotalRegistros,
	 @sum_ean					SumaEAN,
	 @sum_cantidad		SumaCantidad,
	 @sum_precio			SumaPrecio,
	 @sum_valor				SumaValor

--SELECT * FROM #az_productos

GO

