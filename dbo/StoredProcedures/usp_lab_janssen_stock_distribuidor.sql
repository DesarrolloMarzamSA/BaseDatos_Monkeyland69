USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE --	CREATE	--	DROP
PROCEDURE [dbo].[usp_lab_janssen_stock_distribuidor] (@fecha VARCHAR(10))
WITH ENCRYPTION
AS	
--	23 - OCT - 2009
--	27 OCT 2009					AGREGAR	LETRA A PUNTOS DE VENTA
--	2010-05-05	SE QUITO PIEZAS = 0
declare @sucursal INT, @ejecucion VARCHAR(23)
SET @ejecucion = GETDATE()

/*
EXECUTE	usp_lab_janssen_stock_distribuidor '2011-07-10'
SELECT * FROM lab_janssen_stock_distribuidor
SELECT * FROM lab_janssen_control_stock_distribucion
*/
		
--	STOCK DISTRIBUIDOR CORRECTO
SELECT codigo,cod_barras,descripcion,p_costo 
INTO #lab_msd_productos 
FROM maestro_productos mpb 
WHERE mpb.lab_corto IN 
(SELECT lab_corto FROM lab_fusiones WHERE id_lab = 'JANSSEN')

ALTER TABLE #lab_msd_productos ADD PRIMARY KEY (codigo)

IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES 
    WHERE TABLE_TYPE='BASE TABLE' AND TABLE_NAME='lab_janssen_stock_distribuidor') 
	TRUNCATE TABLE lab_janssen_stock_distribuidor
ELSE
		CREATE TABLE lab_janssen_stock_distribuidor (
			ClaveDist					VARCHAR(20)	NOT NULL,
			ClaveSucDist			VARCHAR(20)	NOT NULL,
			FechaImg					VARCHAR(20)	NOT NULL,
			HoraImg						VARCHAR(20)	NOT NULL,
			CodigoMat					VARCHAR(20)	NOT NULL,
			CodigoEAN					VARCHAR(20)	NOT NULL,
			StatusInventario	VARCHAR(20),
			MotivoBloqueo			VARCHAR(20),
			Cantidad					int					NOT NULL,
			UnidadMedida			VARCHAR(20),
			NumeroLote				VARCHAR(20),
			Texto1						VARCHAR(20),
			Texto2						VARCHAR(20),
			Texto3						VARCHAR(20)
		
		PRIMARY KEY (ClaveDist, ClaveSucDist, FechaImg, HoraImg, CodigoMat, CodigoEAN, Cantidad)	--	FechaImg, HoraImg, 
	)

IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES 
    WHERE TABLE_TYPE='BASE TABLE' AND TABLE_NAME='lab_janssen_control_stock_distribucion') 
	TRUNCATE TABLE lab_janssen_control_stock_distribucion

ELSE
	CREATE TABLE lab_janssen_control_stock_distribucion (
		TotalRegistros			int						,
		SumaEAN							bigint				,
		SumaCantidad				decimal(12,2)		
		PRIMARY KEY (TotalRegistros, SumaEAN, SumaCantidad)
		)

DECLARE cursor_sucursales CURSOR forward_only FOR 
	SELECT sucursal FROM SUCURSALES 
	WHERE fisica = 1 --AND sucursal NOT IN ( 8, 9, 11, 19, 23)	---				<-----	30 AGO 2010

OPEN cursor_sucursales
FETCH FROM cursor_sucursales INTO @sucursal

DECLARE @hora varchar(10)
set @hora = convert(varchar(10),current_timestamp,108)

WHILE @@fetch_status = 0
BEGIN
	SELECT --	TOP 25
		'MARZAM'																								ClaveDist,	--	ib.sucursal
		RIGHT(REPLICATE('0',2)+CONVERT(varchar,ib.Sucursal),2)	ClaveSucDist,	--	ib.sucursal		--	z.AZM
--		convert(varchar(10),current_timestamp,104)						FechaImg,
		CONVERT(VARCHAR(10),CONVERT(DATETIME,@fecha,121),104)		FechaImg,
		@hora																										HoraImg,
		CONVERT(VARCHAR,CONVERT(INT,ib.codigo))									CodigoMat,
		mpb.cod_barras																					CodigoEAN,
		'ATP'																										StatusInventario,
		'NA'																										MotivoBloqueo,
		ib.piezas																								Cantidad,
		'PZA'																										UnidadMedidad,
		'NA'																										NumeroLote,
		'NA'																										Texto1,
		'NA'																										Texto2,
		'NA'																										Texto3
	INTO #tmp_stock_distrib
	from inventario_baan ib
	INNER JOIN #lab_msd_productos mpb on ib.codigo = mpb.codigo AND mpb.cod_barras IS NOT NULL
	WHERE ib.sucursal = @SUCURSAL	--	13
--	and ib.piezas > 0

	INSERT INTO lab_janssen_stock_distribuidor
		SELECT * FROM #tmp_stock_distrib

	DROP TABLE #tmp_stock_distrib
	FETCH NEXT FROM cursor_sucursales INTO @sucursal
END

CLOSE cursor_sucursales
DEALLOCATE cursor_sucursales

DECLARE @total_registros INT
DECLARE @sum_ean bigint
DECLARE @sum_cantidad int

-----------	20	OCT	2009
/*
UPDATE lab_janssen_stock_distribuidor 
SET ClaveSucDist = RIGHT(REPLICATE('0',2) + CONVERT(VARCHAR,suc.almacen) ,2)
FROM lab_janssen_stock_distribuidor stock
INNER JOIN sucursales suc ON CONVERT(INT,stock.ClaveSucDist) = suc.sucursal
*/


-----------	30 AGO 2010
/*DELETE FROM lab_janssen_stock_distribuidor
WHERE ClaveSucDist IN ( 8, 9, 11, 19, 23)*/

/*
UPDATE lab_janssen_stock_distribuidor 
SET cantidad = 0
WHERE ClaveSucDist IN ( 8, 9, 11, 19, 23)
*/


SET @total_registros	= (SELECT COUNT(*) FROM lab_janssen_stock_distribuidor)
SET @sum_ean					= (SELECT ISNULL(Sum(convert(bigint,CodigoEAN)),0) FROM lab_janssen_stock_distribuidor)-- GROUP BY ean
SET @sum_cantidad			= (SELECT ISNULL(Sum(Cantidad),0) FROM lab_janssen_stock_distribuidor)-- GROUP BY Cantidad

INSERT INTO lab_janssen_control_stock_distribucion
SELECT
	 @total_registros	TotalRegistros,
	 @sum_ean					SumaEAN,
	 @sum_cantidad		SumaCantidad

UPDATE lab_janssen_stock_distribuidor SET NumeroLote = '', Texto1 = '', Texto2 = '', Texto3 = ''	,MotivoBloqueo = ''

EXECUTE usp_estadisticas_samayoa 'usp_lab_janssen_stock_distribuidor', @total_registros, @ejecucion

SELECT 
	 LEFT(ClaveDist					+ REPLICATE(' ', 6)					, 6)	ClaveDist				,
	 LEFT(ClaveSucDist			+ REPLICATE(' ', 2)					, 2)	ClaveSucDist		,
	 LEFT(FechaImg					+ REPLICATE(' ',10)					,10)	FechaImg				,
	 LEFT(HoraImg						+ REPLICATE(' ',10)					,10)	HoraImg					,
	RIGHT(REPLICATE(' ', 7)	+ CodigoMat									, 7)	CodigoMat				,
	RIGHT(REPLICATE(' ',13)	+ CodigoEAN									,13)	CodigoEAN				,
	 LEFT(StatusInventario	+ REPLICATE(' ', 3)					, 3)	StatusInventario,
	 LEFT(MotivoBloqueo			+ REPLICATE(' ', 3)					, 3)	MotivoBloqueo		,
	RIGHT(REPLICATE(' ', 6)	+ CONVERT(VARCHAR,Cantidad)	, 6)	Cantidad				,
	 LEFT(UnidadMedida			+ REPLICATE(' ', 3)					, 3)	UnidadMedida		,
	RIGHT(REPLICATE(' ',10)	+ NumeroLote								,10)	NumeroLote			,
	 LEFT(Texto1						+ REPLICATE(' ',10)					,10)	Texto1					,
	 LEFT(Texto2						+ REPLICATE(' ',10)					,10)	Texto2					,
	 LEFT(Texto3						+ REPLICATE(' ',10)					,10)	Texto3					
FROM lab_janssen_stock_distribuidor
GO
