
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE --	CREATE	--	DROP
PROCEDURE [dbo].[usp_lab_sanofi2_movimientos_inventarios] (@fecha VARCHAR(10))
WITH ENCRYPTION
AS 

/*
EXECUTE usp_lab_sanofi2_movimientos_inventarios '2012-03-18'
SELECT * FROM lab_sanofi2_movimientos_inventarios
SELECT * FROM lab_sanofi2_control_movimientos_inventarios
*/

--	MOVIMIENTOS INVENTARIOS
--	27 OCT 2009					AGREGAR	LETRA A PUNTOS DE VENTA

IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES 
    WHERE TABLE_TYPE='BASE TABLE' AND TABLE_NAME='lab_sanofi2_movimientos_inventarios') 
	TRUNCATE TABLE lab_sanofi2_movimientos_inventarios
ELSE
	CREATE TABLE lab_sanofi2_movimientos_inventarios (
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

IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES 
		WHERE TABLE_TYPE='BASE TABLE' AND TABLE_NAME='lab_sanofi2_control_movimientos_inventarios') 
	TRUNCATE TABLE lab_sanofi2_control_movimientos_inventarios

ELSE
	CREATE TABLE lab_sanofi2_control_movimientos_inventarios (
		Id_Movimiento			VARCHAR(30)		NOT NULL,
		TotalRegistros		int 					NOT NULL,
		SumaEAN						bigint				NOT NULL,
		SumaCantidad			decimal(12,2)	NOT NULL
		PRIMARY KEY (Id_Movimiento)
		)


DECLARE @HORA VARCHAR(10)
SET @HORA = CONVERT(VARCHAR(10),CURRENT_TIMESTAMP,108)

--	VENTAS
INSERT INTO lab_sanofi2_movimientos_inventarios (
	ClaveDist, ClaveSucDist, FechaMovimiento, HoraMovimiento, CodigoMat, CodigoEAN, 
	ClaseMovimiento, MotivoMovimiento, OrigenMovimiento, StatusInventario, 
	Cantidad, UnidadMedida,	NumeroLote, Texto1, Texto2, Texto3)
	SELECT --	--  TOP 25
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
	FROM lab_sanofi2_factura faz
	WHERE --convert(datetime,FechaDoc,104) = convert(datetime,@fecha,121)
		EAN	IS NOT NULL
	GROUP BY ClaveDist, ClaveSucDist, FechaDoc, CodigoMat, EAN, ClaseFacturacion, UnidadMedida, Lote


----------------------------------------------------------------------
--	TRANSFERENCIAS SUCURSALES

INSERT INTO lab_sanofi2_movimientos_inventarios (
	ClaveDist, ClaveSucDist, FechaMovimiento, HoraMovimiento, CodigoMat, CodigoEAN, 
	ClaseMovimiento, MotivoMovimiento, OrigenMovimiento, StatusInventario, 
	Cantidad, UnidadMedida,	NumeroLote, Texto1, Texto2, Texto3)

SELECT	--  TOP 25
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
FROM lab_sanofi2_transfer_sucursal

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
INTO #tmp_lab_sanofi2_compras
FROM lab_sanofi2_compras_ingresadas
WHERE --convert(datetime,FechaMovimiento,104) = convert(datetime,current_timestamp)
CONVERT(SMALLDATETIME,FechaMovimiento,104) = CONVERT(SMALLDATETIME,@fecha,121)


UPDATE #tmp_lab_sanofi2_compras
SET NumeroLote = ''
FROM #tmp_lab_sanofi2_compras compras	--WHERE

INSERT INTO lab_sanofi2_movimientos_inventarios (
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
 FROM #tmp_lab_sanofi2_compras
--  WHERE

DROP TABLE #tmp_lab_sanofi2_compras

DELETE FROM lab_sanofi2_movimientos_inventarios WHERE RTRIM(LTRIM(ClaveDist)) = ''

UPDATE lab_sanofi2_movimientos_inventarios SET Texto1 = '', Texto2 = '', Texto3 = ''
/*
UPDATE lab_sanofi2_movimientos_inventarios SET ClaveSucDist = '17' WHERE ClaveSucDist = '50'
UPDATE lab_sanofi2_movimientos_inventarios SET ClaveSucDist = '18' WHERE ClaveSucDist = '51'
UPDATE lab_sanofi2_movimientos_inventarios SET ClaveSucDist = '19' WHERE ClaveSucDist = '52'
*/

-------	20	-	oct	-	2009
UPDATE lab_sanofi2_movimientos_inventarios 
SET ClaveSucDist = RIGHT(REPLICATE('0',2) + CONVERT(VARCHAR,suc.almacen) ,2)
FROM lab_sanofi2_movimientos_inventarios mov_inv
INNER JOIN sucursales suc ON CONVERT(INT,mov_inv.ClaveSucDist) = suc.sucursal

DECLARE @total_registros INT
DECLARE @sum_ean bigint
DECLARE @sum_cantidad int


declare @sucursal varchar(5)
declare @FechaMovimiento Varchar(10)

DECLARE cursor_sucursales CURSOR forward_only FOR 
	SELECT ClaveSucDist,FechaMovimiento 
	FROM lab_sanofi2_movimientos_inventarios
	GROUP BY ClaveSucDist,FechaMovimiento 
	ORDER BY ClaveSucDist,FechaMovimiento 
	

OPEN cursor_sucursales
FETCH FROM cursor_sucursales INTO @sucursal,@FechaMovimiento

WHILE @@fetch_status = 0
BEGIN
	SELECT * INTO #tmp_lab_sanofi2_mi FROM lab_sanofi2_movimientos_inventarios
		where ClaveSucDist = @sucursal and FechaMovimiento = @FechaMovimiento

	SET @total_registros = (SELECT COUNT(*) FROM #tmp_lab_sanofi2_mi)
	SET @sum_ean = (SELECT Sum(convert(bigint,CodigoEAN)) FROM #tmp_lab_sanofi2_mi)
	SET @sum_cantidad = (SELECT Sum(Cantidad) FROM #tmp_lab_sanofi2_mi)

	INSERT INTO lab_sanofi2_control_movimientos_inventarios
	SELECT
		@sucursal + @FechaMovimiento Id_Movimiento,
		@total_registros	TotalRegistros,
		@sum_ean					SumaEAN,
		@sum_cantidad			SumaCantidad

	DROP TABLE #tmp_lab_sanofi2_mi

	FETCH NEXT FROM cursor_sucursales INTO @sucursal,@FechaMovimiento
end


CLOSE cursor_sucursales
DEALLOCATE cursor_sucursales
--GO


SELECT * FROM lab_sanofi2_movimientos_inventarios
GO
