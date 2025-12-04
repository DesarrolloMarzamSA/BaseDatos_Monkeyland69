SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_astra_zeneca_movimientos_inventarios_xml] (@fecha VARCHAR(10))
AS 


/*
usp_astra_zeneca_movimientos_inventarios_xml '2011-03-25'
*/

--	MOVIMIENTOS INVENTARIOS
--	27 OCT 2009					AGREGAR	LETRA A PUNTOS DE VENTA
--	25	MAR	2011					SE RETRASA EL ENVIO 1 DIA 


--SET @fecha = CONVERT(VARCHAR(10),DATEADD(DD ,-1, CONVERT(DATETIME,@fecha,121) ),121)

IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES 
    WHERE TABLE_TYPE='BASE TABLE' AND TABLE_NAME='tmp_az_movimientos_inventarios_xml') 
	TRUNCATE TABLE tmp_az_movimientos_inventarios_xml
ELSE
	CREATE TABLE tmp_az_movimientos_inventarios_xml (
		ClaveDist						VARCHAR(20)	NOT NULL,
		ClaveSucDist				VARCHAR(20)	NOT NULL,
		FechaMovimiento			VARCHAR(20)	NOT NULL,
		HoraMovimiento			VARCHAR(20)	NOT NULL,
		CodigoMat						VARCHAR(20)	NOT NULL,
		CodigoEAN						VARCHAR(20)	NOT NULL,
		ClaseMovimiento			VARCHAR(20)	NOT NULL,
		MotivoMovimiento		VARCHAR(20)	NOT NULL,
		OrigenMovimiento		VARCHAR(20) NOT NULL,
		StatusInventario		VARCHAR(20),
		Cantidad						int					NOT NULL,
		UnidadMedida				VARCHAR(20),
		NumeroLote					VARCHAR(20),
		Texto1							VARCHAR(20),
		Texto2							VARCHAR(20),
		Texto3							VARCHAR(20)		
	PRIMARY KEY (	ClaveDist, ClaveSucDist, FechaMovimiento, HoraMovimiento, CodigoMat, CodigoEAN, ClaseMovimiento, MotivoMovimiento, OrigenMovimiento, Cantidad)
		)

DECLARE @HORA VARCHAR(10)
SET @HORA = convert(varchar(10),current_timestamp,108)

--	VENTAS
INSERT INTO tmp_az_movimientos_inventarios_xml (
	ClaveDist, ClaveSucDist, FechaMovimiento, HoraMovimiento, CodigoMat, CodigoEAN, 
	ClaseMovimiento, MotivoMovimiento, OrigenMovimiento, StatusInventario, 
	Cantidad, UnidadMedida,	NumeroLote, Texto1, Texto2, Texto3)
	SELECT 
		ClaveDist,
		ClaveSucDist,
		FechaDoc,
		@HORA HoraMovimiento,
		convert(varchar,convert(int,CodigoMat)) CodigoMat,
		EAN CodigoEAN,
		CASE WHEN ClaseFacturacion = 'FC' THEN 'OT' ELSE 'NA' END ClaseMovimiento,
		CASE WHEN ClaseFacturacion = 'FC' THEN 'SL' ELSE 'NA' END MotivoMovimiento,
		'CUS' OrigenMovimiento,
		'ATP' StatusInventario,
		SUM(CantFacturada) Cantidad,
		UnidadMedida,
		Lote NumeroLote,
		' ' Texto1, 
		' ' Texto2, 
		' ' Texto3
	FROM tmp_az_factura_xml faz
	--	WHERE convert(datetime,FechaDoc,104) = convert(datetime,@fecha,121)
	GROUP BY ClaveDist, ClaveSucDist, FechaDoc, CodigoMat, EAN, ClaseFacturacion, UnidadMedida, Lote


----------------------------------------------------------------------
--	TRANSFERENCIAS SUCURSALES

INSERT INTO tmp_az_movimientos_inventarios_xml (
	ClaveDist, ClaveSucDist, FechaMovimiento, HoraMovimiento, CodigoMat, CodigoEAN, 
	ClaseMovimiento, MotivoMovimiento, OrigenMovimiento, StatusInventario, 
	Cantidad, UnidadMedida,	NumeroLote, Texto1, Texto2, Texto3)

SELECT 
	ClaveDist,
	ClaveSucursalOrig ClaveSucDist,
	FechaImg FechaMovimiento,
	HoraImg HoraMovimiento,
	CodigoMat,
	CodigoEAN,
	CASE WHEN TipoMovimiento = 'ATP' THEN 'OT' ELSE 'OT' END ClaseMovimiento,
	CASE WHEN TipoMovimiento = 'ATP' THEN 'TR' ELSE 'TR' END MotivoMovimiento,
	'SUC' OrigenMovimiento,
	'ATP' StatusInventario,
	Cantidad,
	UnidadMedida,
	NumeroLote,
		' ' Texto1, 
		' ' Texto2, 
		' ' Texto3
FROM tmp_az_transfer_sucursal_xml

--------------------------------------------------------------------------
--	COMPRAS

SELECT 
	ClaveDist, 
	right(replicate('0',2)+ltrim(rtrim(ClaveSucDist)),2) ClaveSucDist, 
	FechaMovimiento, 
	HoraMovimiento, 
	convert(varchar,convert(int,CodigoMat)) CodigoMat, 
	CodigoEAN, 
	ClaseMovimiento, 
	MotivoMovimiento, 
	OrigenMovimiento, 
	StatusInventario, 
	Cantidad,	
	UnidadMedida, 
	NumeroLote, 
	Texto1, 
	Texto2, 
	Texto3
INTO #tmp_az_compras
FROM astra_compras_ingresadas
WHERE --convert(datetime,FechaMovimiento,104) = convert(datetime,current_timestamp)
convert(datetime,FechaMovimiento,104) = convert(datetime,@fecha,121)


/*
UPDATE #tmp_az_compras
SET ClaveSucDist = AZM.AZM
FROM #tmp_az_compras compras	--WHERE
INNER JOIN sucursales_azm AZM on AZM.SUCURSAL = CONVERT(int,compras.ClaveSucDist)
*/
UPDATE #tmp_az_compras
SET NumeroLote = ''
FROM #tmp_az_compras compras	--WHERE

INSERT INTO tmp_az_movimientos_inventarios_xml (
	ClaveDist, ClaveSucDist, FechaMovimiento, HoraMovimiento, CodigoMat, CodigoEAN, 
	ClaseMovimiento, MotivoMovimiento, OrigenMovimiento, StatusInventario, 
	Cantidad, UnidadMedida,	NumeroLote, Texto1, Texto2, Texto3)

SELECT 
	ClaveDist, 
	ClaveSucDist, 
	FechaMovimiento, 
	HoraMovimiento, 
	CodigoMat, 
	CodigoEAN, 
	ClaseMovimiento, 
	MotivoMovimiento, 
	OrigenMovimiento, 
	StatusInventario, 
	Cantidad,	
	UnidadMedida, 
	NumeroLote, 
	Texto1, 
	Texto2, 
	Texto3
 FROM #tmp_az_compras
--  WHERE

DROP TABLE #tmp_az_compras

DELETE FROM tmp_az_movimientos_inventarios_xml WHERE rtrim(ltrim(ClaveDist)) = ''

UPDATE tmp_az_movimientos_inventarios_xml SET Texto1 = '', Texto2 = '', Texto3 = ''
/*
UPDATE tmp_az_movimientos_inventarios_xml SET ClaveSucDist = '17' WHERE ClaveSucDist = '50'
UPDATE tmp_az_movimientos_inventarios_xml SET ClaveSucDist = '18' WHERE ClaveSucDist = '51'
UPDATE tmp_az_movimientos_inventarios_xml SET ClaveSucDist = '19' WHERE ClaveSucDist = '52'
*/

-------	20	-	oct	-	2009
UPDATE tmp_az_movimientos_inventarios_xml 
SET ClaveSucDist = RIGHT(REPLICATE('0',2) + CONVERT(VARCHAR,suc.almacen) ,2)
FROM tmp_az_movimientos_inventarios_xml mov_inv
INNER JOIN sucursales suc ON CONVERT(INT,mov_inv.ClaveSucDist) = suc.sucursal

DECLARE @total_registros INT
DECLARE @sum_ean bigint
DECLARE @sum_cantidad int

IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES 
		WHERE TABLE_TYPE='BASE TABLE' AND TABLE_NAME='tmp_az_control_movimientos_inventarios_xml') 
	TRUNCATE TABLE tmp_az_control_movimientos_inventarios_xml

ELSE
	CREATE TABLE tmp_az_control_movimientos_inventarios_xml (
		Id_Movimiento			VARCHAR(30)		NOT NULL,
		TotalRegistros		int 					NOT NULL,
		SumaEAN						bigint				NOT NULL,
		SumaCantidad			decimal(12,2)	NOT NULL
		PRIMARY KEY (Id_Movimiento)
		)

declare @sucursal varchar(5)
declare @FechaMovimiento Varchar(10)

DECLARE cursor_sucursales CURSOR forward_only FOR 
	SELECT ClaveSucDist,FechaMovimiento 
	FROM tmp_az_movimientos_inventarios_xml
	GROUP BY ClaveSucDist,FechaMovimiento 
	ORDER BY ClaveSucDist,FechaMovimiento 
	

OPEN cursor_sucursales
FETCH FROM cursor_sucursales INTO @sucursal,@FechaMovimiento

WHILE @@fetch_status = 0
BEGIN
	SELECT * INTO #tmp_az_mi FROM tmp_az_movimientos_inventarios_xml
		where ClaveSucDist = @sucursal and FechaMovimiento = @FechaMovimiento

	SET @total_registros = (SELECT COUNT(*) FROM #tmp_az_mi)
	SET @sum_ean = (SELECT Sum(convert(bigint,CodigoEAN)) FROM #tmp_az_mi)
	SET @sum_cantidad = (SELECT Sum(Cantidad) FROM #tmp_az_mi)

	INSERT INTO tmp_az_control_movimientos_inventarios_xml
	SELECT
		@sucursal + @FechaMovimiento Id_Movimiento,
		@total_registros	TotalRegistros,
		@sum_ean					SumaEAN,
		@sum_cantidad			SumaCantidad

	DROP TABLE #tmp_az_mi

	FETCH NEXT FROM cursor_sucursales INTO @sucursal,@FechaMovimiento
end


CLOSE cursor_sucursales
DEALLOCATE cursor_sucursales



GO
