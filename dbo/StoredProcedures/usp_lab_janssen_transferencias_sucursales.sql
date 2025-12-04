CREATE --	CREATE	--	DROP
PROCEDURE usp_lab_janssen_transferencias_sucursales (@fecha VARCHAR(10))

AS 

/*
EXECUTE usp_lab_janssen_transferencias_sucursales '2011-11-04'
SELECT * FROM lab_janssen_transfer_sucursal
SELECT * FROM lab_janssen_control_transfer_sucursal
*/

DECLARE @ejecucion VARCHAR(23)
SET @ejecucion = GETDATE()

SELECT *
INTO #productos_janssen
FROM maestro_productos mpb
where mpb.lab_corto IN (SELECT lab_corto FROM lab_fusiones WHERE id_lab = 'JANSSEN')
	--AND mpb.cod_barras IS NOT NULL											AND

ALTER TABLE #productos_janssen ADD PRIMARY KEY (codigo)


--	TRANSFEReIAS SUCURSALES
--	27 OCT 2009					AGREGAR	LETRA A PUNTOS DE VENTA

IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES 
    WHERE TABLE_TYPE='BASE TABLE' AND TABLE_NAME='lab_janssen_transfer_sucursal') 
	TRUNCATE TABLE lab_janssen_transfer_sucursal
ELSE
		CREATE TABLE lab_janssen_transfer_sucursal (
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

IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES 
    WHERE TABLE_TYPE='BASE TABLE' AND TABLE_NAME='lab_janssen_control_transfer_sucursal') 
	TRUNCATE TABLE lab_janssen_control_transfer_sucursal

ELSE
	CREATE TABLE lab_janssen_control_transfer_sucursal (
		TotalRegistros				INT							NOT NULL,
		SumaEAN								BIGINT					NOT NULL,
		SumaCantidad					DECIMAL(12,2)		NOT NULL
		PRIMARY KEY (TotalRegistros, SumaEAN, SumaCantidad)
		)

INSERT INTO lab_janssen_transfer_sucursal
	SELECT --		TOP 25
	--  e.farmacia, --está de sobra pero es informativa pues nos  dice cristianamente a dónde va la mercancía
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
		d.cant_ped																									Cantidad,
		'PZA'																												UnidadMedida,
		'NA'																												NumeroLote,
		'NA'																												Texto1,
		'NA'																												Texto2,
		'NA'																												Texto2
	FROM encabezado e WITH (NOLOCK)
	INNER JOIN detalle d WITH (NOLOCK) ON e.sucursal = d.sucursal AND e.factura = d.factura
	INNER JOIN #productos_janssen mpb WITH (NOLOCK) ON '00' + mpb.codigo = d.codigos
	LEFT OUTER JOIN cuentas_transfer xfer (NOLOCK) ON e.sucursal = xfer.sucursal AND e.cliente = xfer.cliente
	WHERE e.fechaprog 	= CONVERT(DATETIME, @fecha, 121) 
	AND d.dest_det = 'AAA' 
	AND
	(   
		 (e.sucursal = 1 AND e.cliente in ('37270','37280','37300'))
	OR (e.sucursal =  3 AND e.cliente = '00834')
	OR (e.sucursal =  4 AND e.cliente in ('82552','82554'))
	OR (e.sucursal =  6 AND e.cliente in ('01412','01413','01414'))
	OR (e.sucursal =  7 AND e.cliente in ('06441','07840','07844'))
	OR (e.sucursal = 16 AND e.cliente in ('40981','40982','42222'))
	OR (e.sucursal = 17 AND e.cliente in ('10871','12084','12104','12105','12385','12508'))
	OR (e.sucursal = 18 AND e.cliente in ('30312','30314','32034','32056','32058','32128','32165','32284','50298','50351'))
	OR (e.sucursal = 24 AND e.cliente in ('50298','50351'))
	OR (e.sucursal = 25 AND e.cliente in ('20946','20948','23308','23311','23416','23538'))
	)

--------------------------------------------------------------------------------
declare @cuenta int
set @cuenta = (select count(*) FROM lab_janssen_transfer_sucursal)
if @cuenta = 0
	INSERT INTO lab_janssen_transfer_sucursal
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

SET @total_registros = (SELECT COUNT(*) FROM lab_janssen_transfer_sucursal)
SET @sum_ean = (SELECT Sum(CONVERT(bigint,CodigoEAN)) FROM lab_janssen_transfer_sucursal)
SET @sum_cantidad = (SELECT Sum(Cantidad) FROM lab_janssen_transfer_sucursal)

if @cuenta = 0
	BEGIN
		SET @total_registros = 0
		SET @sum_ean = 0
		SET @sum_cantidad = 0
	END

---------------	20	OCT	2009	-------------------------
UPDATE lab_janssen_transfer_sucursal SET 
	ClaveSucursalOrig = RIGHT(REPLICATE('0',2) + CONVERT(VARCHAR,suc.almacen) ,2)
FROM lab_janssen_transfer_sucursal transfer
INNER JOIN sucursales suc ON CONVERT(INT,transfer.ClaveSucursalOrig) = suc.sucursal

/*
UPDATE lab_janssen_transfer_sucursal SET 
	ClaveSucursalDest = RIGHT(REPLICATE('0',2) + CONVERT(VARCHAR,suc.almacen) ,2)
FROM lab_janssen_transfer_sucursal transfer
INNER JOIN sucursales suc ON CONVERT(INT,transfer.ClaveSucursalDest) = suc.sucursal
*/
------------------------------------------------------------------------------------------------


INSERT INTO lab_janssen_control_transfer_sucursal
SELECT
	 @total_registros	TotalRegistros,
	 @sum_ean					SumaEAN,
	 @sum_cantidad		SumaCantidad

UPDATE lab_janssen_transfer_sucursal SET NumeroLote = '', Texto1 = '', Texto2 = '', Texto3 = '' 

EXECUTE usp_estadisticas_samayoa 'usp_lab_janssen_transfereias_sucursales', @total_registros, @ejecucion

/*
UPDATE lab_janssen_transfer_sucursal SET ClaveSucursalOrig = '17' WHERE ClaveSucursalOrig = '50'
UPDATE lab_janssen_transfer_sucursal SET ClaveSucursalOrig = '18' WHERE ClaveSucursalOrig = '51'
UPDATE lab_janssen_transfer_sucursal SET ClaveSucursalOrig = '19' WHERE ClaveSucursalOrig = '52'

UPDATE lab_janssen_transfer_sucursal SET ClaveSucursalDest = '17' WHERE ClaveSucursalDest = '50'
UPDATE lab_janssen_transfer_sucursal SET ClaveSucursalDest = '18' WHERE ClaveSucursalDest = '51'
UPDATE lab_janssen_transfer_sucursal SET ClaveSucursalDest = '19' WHERE ClaveSucursalDest = '52'
*/

SELECT 
	 LEFT(ClaveDist							+ REPLICATE(' ', 6)							, 6)	ClaveDist						,
	 LEFT(ClaveSucursalOrig			+ REPLICATE(' ', 2)							, 2)	ClaveSucursalOrig		,
	 LEFT(FechaImg							+ REPLICATE(' ',10)							,10)	FechaImg						,
	 LEFT(HoraImg								+ REPLICATE(' ',10)							,10)	HoraImg							,
	 LEFT(ClaveSucursalDest			+ REPLICATE(' ', 7)							, 7)	ClaveSucursalDest		,
	 LEFT(CodigoMat							+ REPLICATE(' ',13)							,13)	CodigoMat						,
	 LEFT(CodigoEAN							+ REPLICATE(' ', 3)							, 3)	CodigoEAN						,
	 LEFT(StatusInventario			+ REPLICATE(' ', 3)							, 3)	StatusInventario		,
	 LEFT(TipoMovimiento				+ REPLICATE(' ', 3)							, 3)	TipoMovimiento			,
	 LEFT(RazonMovimiento				+ REPLICATE(' ', 3)							, 3)	RazonMovimiento			,
	RIGHT(REPLICATE(' ', 6)			+ CONVERT(VARCHAR,Cantidad)			, 6)	Cantidad						,
	 LEFT(UnidadMedida					+ REPLICATE(' ', 3)							, 3)	UnidadMedida				,
	 LEFT(NumeroLote						+ REPLICATE(' ',10)							,10)	NumeroLote					,
	 LEFT(Texto1								+ REPLICATE(' ',10)							,10)	Texto1							,
	 LEFT(Texto2								+ REPLICATE(' ',10)							,10)	Texto2							,
	 LEFT(Texto3								+ REPLICATE(' ',10)							,10)	Texto3								

FROM lab_janssen_transfer_sucursal

GO

