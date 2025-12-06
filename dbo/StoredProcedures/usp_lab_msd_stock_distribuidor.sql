
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE --	CREATE	--	DROP
PROCEDURE [dbo].[usp_lab_msd_stock_distribuidor] (@fecha VARCHAR(10))
WITH ENCRYPTION
AS	
--	23 - OCT - 2009
--	27 OCT 2009					AGREGAR	LETRA A PUNTOS DE VENTA
--	2010-05-05	SE QUITO PIEZAS = 0
declare @sucursal INT, @ejecucion VARCHAR(23)
SET @ejecucion = CONVERT(VARCHAR(23),GETDATE(),121)

/*
EXECUTE	usp_lab_msd_stock_distribuidor '2011-01-25'
SELECT * FROM lab_msd_stock_distribuidor
SELECT * FROM lab_msd_control_stock_distribucion
*/
		
--	STOCK DISTRIBUIDOR CORRECTO

IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES 
    WHERE TABLE_TYPE='BASE TABLE' AND TABLE_NAME='lab_msd_stock_distribuidor') 
	TRUNCATE TABLE lab_msd_stock_distribuidor
ELSE
		CREATE TABLE lab_msd_stock_distribuidor (
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

DECLARE cursor_sucursales CURSOR forward_only FOR 
	SELECT sucursal FROM SUCURSALES 
	WHERE fisica = 1

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
		convert(varchar(10),convert(datetime,@fecha,121),104)		FechaImg,
		@hora																										HoraImg,
		convert(varchar,convert(int,ib.codigo))									CodigoMat,
		mpb.cod_barras																					CodigoEAN,
		'ATP'																										StatusInventario,
		'NA'																										MotivoBloqueo,
		ib.piezas																								Cantidad,
		'PZA'																										UnidadMedidad,
		'NA'																										NumeroLote,
		mpb.lab_corto																						Texto1,	--	'NA'
		'NA'																										Texto2,
		'NA'																										Texto3
	INTO #tmp_stock_distrib
	from inventario_baan ib
	inner join maestro_productos mpb on ib.codigo = mpb.codigo 
--	INNER JOIN sucursales_azm Z on Z.SUCURSAL = ib.sucursal
	where mpb.lab_corto IN (SELECT lab_corto FROM lab_fusiones WHERE id_lab = 'MSD')
	AND mpb.cod_barras IS NOT NULL
	AND ib.sucursal = @SUCURSAL	--	13
--	and ib.piezas > 0

	INSERT INTO lab_msd_stock_distribuidor
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
UPDATE lab_msd_stock_distribuidor 
SET ClaveSucDist = RIGHT(REPLICATE('0',2) + CONVERT(VARCHAR,suc.almacen) ,2)
FROM lab_msd_stock_distribuidor stock
INNER JOIN sucursales suc ON CONVERT(INT,stock.ClaveSucDist) = suc.sucursal
*/


-----------	30 AGO 2010
/*DELETE FROM lab_msd_stock_distribuidor
WHERE ClaveSucDist IN ( 8, 9, 11, 19, 23)*/

/*
UPDATE lab_msd_stock_distribuidor 
SET cantidad = 0
WHERE ClaveSucDist IN ( 8, 9, 11, 19, 23)
*/


SET @total_registros	= (SELECT COUNT(*) FROM lab_msd_stock_distribuidor)
SET @sum_ean					= (SELECT ISNULL(Sum(convert(bigint,CodigoEAN)),0) FROM lab_msd_stock_distribuidor)-- GROUP BY ean
SET @sum_cantidad			= (SELECT ISNULL(Sum(Cantidad),0) FROM lab_msd_stock_distribuidor)-- GROUP BY Cantidad

/*
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES 
    WHERE TABLE_TYPE='BASE TABLE' AND TABLE_NAME='lab_msd_stock_distribucion_control') 
	TRUNCATE TABLE lab_msd_control_stock_distribucion

ELSE
	CREATE --	DROP
	TABLE lab_msd_control_distribucion_stock (
		TotalRegistros			int						,
		SumaEAN							bigint				,
		SumaCantidad				decimal(12,2)		
		PRIMARY KEY (TotalRegistros, SumaEAN, SumaCantidad)
		)

INSERT INTO lab_msd_stock_distribucion_control
SELECT
	 @total_registros	TotalRegistros,
	 @sum_ean					SumaEAN,
	 @sum_cantidad		SumaCantidad
*/

--	NO QUITAR, LOS XML DEBEN NO PUEDEN TENER VALORES NULL
UPDATE lab_msd_stock_distribuidor SET 
	NumeroLote = '', 
	Texto1 = '', 
	Texto2 = '', 
	Texto3 = ''	,
	MotivoBloqueo = ''
--	NO QUITAR


DECLARE @estor VARCHAR(50)
SET @estor = 'usp_lab_msd_stock_distribuidor '+@fecha
EXECUTE usp_estadisticas_samayoa @estor, @total_registros, @ejecucion

SELECT * FROM lab_msd_stock_distribuidor
GO
