CREATE PROCEDURE [dbo].[usp_astra_zeneca_transferencias_sucursales_xml] (@fecha VARCHAR(10))

AS 

/*
usp_astra_zeneca_transferencias_sucursales_xml '2011-03-25'
*/

--	TRANSFERENCIAS SUCURSALES
--	27 OCT 2009					AGREGAR	LETRA A PUNTOS DE VENTA
--	25	MAR	2011					SE RETRASA EL ENVIO 1 DIA 


--SET @fecha = CONVERT(VARCHAR(10),DATEADD(DD ,-1, CONVERT(DATETIME,@fecha,121) ),121)

IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES 
    WHERE TABLE_TYPE='BASE TABLE' AND TABLE_NAME='tmp_az_transfer_sucursal_xml') 
	TRUNCATE TABLE tmp_az_transfer_sucursal_xml
ELSE
		CREATE TABLE tmp_az_transfer_sucursal_xml (
			ClaveDist						VARCHAR(20),
			ClaveSucursalOrig		VARCHAR(20),
			FechaImg						VARCHAR(20),
			HoraImg							VARCHAR(20),
			ClaveSucursalDest		VARCHAR(20),
			CodigoMat						VARCHAR(20),
			CodigoEAN						VARCHAR(20),
			StatusInventario		VARCHAR(20),
			TipoMovimiento			VARCHAR(20),
			RazonMovimiento			VARCHAR(20),
			Cantidad						int,
			UnidadMedida				VARCHAR(20),
			NumeroLote					VARCHAR(20),
			Texto1							VARCHAR(20),
			Texto2							VARCHAR(20),
			Texto3							VARCHAR(20)		
			PRIMARY KEY (ClaveSucursalOrig, FechaImg, HoraImg, ClaveSucursalDest, CodigoMat, TipoMovimiento)

)
SELECT codigo,cod_barras,descripcion,p_costo INTO #az_productos 
FROM maestro_productos mpb  WITH (NOLOCK)
WHERE mpb.lab_corto = 'ASTRAZ'  OR
cod_barras IN (
'7501091440612',
'7501091440629',
'7501091440643'
) AND
ISNUMERIC(cod_barras) = 1 AND CONVERT(BIGINT, cod_barras) > 0

CREATE INDEX tmp_az_mpb ON #az_productos	(codigo)

INSERT INTO tmp_az_transfer_sucursal_xml
SELECT 
--  enc.farmacia, --está de sobra pero es informativa pues nos  dice cristianamente a dónde va la mercancía
  'MARZAM'																										ClaveDist,	--		
  RIGHT(REPLICATE('0',2)+CONVERT(VARCHAR,xfer.sucursal),2)		ClaveSucursalOrig,	--	AZM.AZM
--  CONVERT(varchar(10),current_timestamp,104)									FechaImg,
--  CONVERT(varchar(10),convert(datetime,@fecha,121),104)				FechaImg,
  CONVERT(varchar(10),fechaprog,104)				FechaImg,
  CONVERT(varchar(10),current_timestamp,108)									HomaImg,
  RIGHT(REPLICATE('0',2)+CONVERT(VARCHAR,xfer.suc_destino),2) ClaveSucursalDest,	--	
  CONVERT(varchar,CONVERT(int,mpb.codigo))										CodigoMat,
  mpb.cod_barras																							CodigoEAN,
  'ATP'																												StatusInventario,
  'ATP'																												TipoMovimiento,
  'S'																													RazonMovimiento,
  det.cant_ped																								Cantidad,
  'PZA'																												UnidadMedida,
  'NA'																												NumeroLote,
  'NA'																												Texto1,
  'NA'																												Texto2,
  'NA'																												Texto2
FROM encabezado enc 
INNER JOIN detalle det ON enc.sucursal = det.sucursal AND enc.factura = det.factura
INNER JOIN #az_productos mpb ON '00' + mpb.codigo = det.codigos
left outer JOIN cuentas_transfer xfer ON enc.sucursal = xfer.sucursal AND enc.cliente = xfer.cliente
--	INNER JOIN sucursales_azm AZM ON AZM.SUCURSAL = enc.sucursal
--	WHERE enc.fechaprog between CONVERT(datetime, CONVERT(varchar(10),current_timestamp-7,121) , 121) --	datediff(dd,7,
--	AND CONVERT(datetime, CONVERT(varchar(10),CURRENT_TIMESTAMP,121), 121) 
WHERE 
--	enc.fecha_tandem 	= CONVERT(datetime, @fecha, 121) 
	enc.fechaprog 	= CONVERT(datetime, @fecha, 121) 
AND det.dest_det = 'AAA' 
--AND mpb.lab_corto = 'ASTRAZ' 
AND
(   
   (enc.sucursal = 1 AND enc.cliente in ('37270','37280','37300'))
OR (enc.sucursal =  3 AND enc.cliente = '00834')
OR (enc.sucursal =  4 AND enc.cliente in ('82552','82554'))
OR (enc.sucursal =  6 AND enc.cliente in ('01412','01413','01414'))
OR (enc.sucursal =  7 AND enc.cliente in ('06441','07840','07844'))
OR (enc.sucursal = 16 AND enc.cliente in ('40981','40982','42222'))
OR (enc.sucursal = 17 AND enc.cliente in ('10871','12084','12104','12105','12385','12508'))
OR (enc.sucursal = 18 AND enc.cliente in ('30312','30314','32034','32056','32058','32128','32165','32284','50298','50351'))
OR (enc.sucursal = 24 AND enc.cliente in ('50298','50351'))
OR (enc.sucursal = 25 AND enc.cliente in ('20946','20948','23308','23311','23416','23538'))
)

--------------------------------------------------------------------------------
declare @cuenta int
set @cuenta = (select count(*) FROM tmp_az_transfer_sucursal_xml)
if @cuenta = 0
	INSERT INTO tmp_az_transfer_sucursal_xml
		SELECT 
			''		ClaveDist,	--		
			''		ClaveSucursalOrig,	--	AZM.AZM
			''		FechaImg,
			''		HomaImg,
			''		ClaveSucursalDest,	--	
			''		CodigoMat,
			''		CodigoEAN,
			''		StatusInventario,
			''		TipoMovimiento,
			''		RazonMovimiento,
			0 		Cantidad,
			''		UnidadMedida,
			''		NumeroLote,
			''		Texto1,
			''		Texto2,
			''		Texto2
---------------------------------------------------------------------------------

DECLARE @total_registros INT
DECLARE @sum_ean BIGINT
DECLARE @sum_cantidad INT

SET @total_registros = (SELECT COUNT(*) FROM tmp_az_transfer_sucursal_xml)
SET @sum_ean = (SELECT Sum(CONVERT(bigint,CodigoEAN)) FROM tmp_az_transfer_sucursal_xml)
SET @sum_cantidad = (SELECT Sum(Cantidad) FROM tmp_az_transfer_sucursal_xml)

if @cuenta = 0
	BEGIN
		SET @total_registros = 0
		SET @sum_ean = 0
		SET @sum_cantidad = 0
	END

---------------	20	OCT	2009	-------------------------
UPDATE tmp_az_transfer_sucursal_xml SET 
	ClaveSucursalOrig = RIGHT(REPLICATE('0',2) + CONVERT(VARCHAR,suc.almacen) ,2)
FROM tmp_az_transfer_sucursal_xml transfer
INNER JOIN sucursales suc ON CONVERT(INT,transfer.ClaveSucursalOrig) = suc.sucursal

/*
UPDATE tmp_az_transfer_sucursal_xml SET 
	ClaveSucursalDest = RIGHT(REPLICATE('0',2) + CONVERT(VARCHAR,suc.almacen) ,2)
FROM tmp_az_transfer_sucursal_xml transfer
INNER JOIN sucursales suc ON CONVERT(INT,transfer.ClaveSucursalDest) = suc.sucursal
*/
------------------------------------------------------------------------------------------------

IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES 
    WHERE TABLE_TYPE='BASE TABLE' AND TABLE_NAME='tmp_az_control_transfer_sucursal_xml') 
	TRUNCATE TABLE tmp_az_control_transfer_sucursal_xml

ELSE
	CREATE TABLE tmp_az_control_transfer_sucursal_xml (
		TotalRegistros				INT							NOT NULL,
		SumaEAN								BIGINT					NOT NULL,
		SumaCantidad					DECIMAL(12,2)		NOT NULL
		PRIMARY KEY (TotalRegistros, SumaEAN, SumaCantidad)
		)

INSERT INTO tmp_az_control_transfer_sucursal_xml
SELECT
	 @total_registros	TotalRegistros,
	 @sum_ean					SumaEAN,
	 @sum_cantidad		SumaCantidad

UPDATE tmp_az_transfer_sucursal_xml SET NumeroLote = '', Texto1 = '', Texto2 = '', Texto3 = '' 

/*
UPDATE tmp_az_transfer_sucursal_xml SET ClaveSucursalOrig = '17' WHERE ClaveSucursalOrig = '50'
UPDATE tmp_az_transfer_sucursal_xml SET ClaveSucursalOrig = '18' WHERE ClaveSucursalOrig = '51'
UPDATE tmp_az_transfer_sucursal_xml SET ClaveSucursalOrig = '19' WHERE ClaveSucursalOrig = '52'

UPDATE tmp_az_transfer_sucursal_xml SET ClaveSucursalDest = '17' WHERE ClaveSucursalDest = '50'
UPDATE tmp_az_transfer_sucursal_xml SET ClaveSucursalDest = '18' WHERE ClaveSucursalDest = '51'
UPDATE tmp_az_transfer_sucursal_xml SET ClaveSucursalDest = '19' WHERE ClaveSucursalDest = '52'
*/

GO

