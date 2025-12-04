CREATE PROCEDURE [dbo].[usp_astra_zeneca_stock_distribuidor_xml] (@fecha VARCHAR(10))
AS	
/*

*/
--	23 - OCT - 2009
--	27 OCT 2009					AGREGAR	LETRA A PUNTOS DE VENTA
--	2010-05-05	SE QUITO PIEZAS = 0
--	2010-08-30	SE FILTRAN LAS SIG. SUC ( 8, 9, 11, 19, 23)
--	2011-05-27	SE APLICA LA COLUMNA "fisica" DE SUCURSALES

SET @fecha = CONVERT(VARCHAR(10), GETDATE(), 121)

declare @sucursal INT

--	astra
--	STOCK DISTRIBUIDOR CORRECTO

IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES 
    WHERE TABLE_TYPE='BASE TABLE' AND TABLE_NAME='tmp_az_stock_distribuidor_xml') 
	TRUNCATE TABLE tmp_az_stock_distribuidor_xml
ELSE
		CREATE TABLE tmp_az_stock_distribuidor_xml (
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
	WHERE fisica = 1														---				<-----	27 MAY 2011
	--WHERE sucursal NOT IN ( 8, 9, 11, 19, 23, 24, 25)	---				<-----	30 AGO 2010

OPEN cursor_sucursales
FETCH FROM cursor_sucursales INTO @sucursal

DECLARE @hora varchar(10)
set @hora = convert(varchar(10),current_timestamp,108)

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

WHILE @@fetch_status = 0
BEGIN
	select --	top 10
		'MARZAM'																								ClaveDist,	--	ib.sucursal
		RIGHT(REPLICATE('0',2)+CONVERT(varchar,ib.Sucursal),2)	ClaveSucDist,	--	ib.sucursal		--	z.AZM
--		convert(varchar(10),current_timestamp,104)						FechaImg,
		convert(varchar(10),convert(datetime,@fecha,121),104)		FechaImg,
		@hora																										HoraImg,
		convert(varchar,convert(int,ib.codigo))									CodigoMat,
		mpb.cod_barras																					CodigoEAN,
		'ATP'																										StatusInventario,
		''																										MotivoBloqueo,
		ib.piezas																								Cantidad,
		'PZA'																										UnidadMedidad,
		'NA'																										NumeroLote,
		'NA'																										Texto1,
		'NA'																										Texto2,
		'NA'																										Texto3
	INTO #tmp_stock_distrib
	from inventario_baan ib
	inner join #az_productos mpb on ib.codigo = mpb.codigo 
	where --mpb.lab_corto = 'ASTRAZ' AND
		ISNUMERIC(cod_barras) = 1 AND CONVERT(BIGINT, cod_barras) > 0
		AND ib.sucursal = @SUCURSAL	--	13

	INSERT INTO tmp_az_stock_distribuidor_xml
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
UPDATE tmp_az_stock_distribuidor_xml 
SET ClaveSucDist = RIGHT(REPLICATE('0',2) + CONVERT(VARCHAR,suc.almacen) ,2)
FROM tmp_az_stock_distribuidor_xml stock
INNER JOIN sucursales suc ON CONVERT(INT,stock.ClaveSucDist) = suc.sucursal
*/


-----------	30 AGO 2010
/*DELETE FROM tmp_az_stock_distribuidor_xml
WHERE ClaveSucDist IN ( 8, 9, 11, 19, 23)*/

/*
UPDATE tmp_az_stock_distribuidor_xml 
SET cantidad = 0
WHERE ClaveSucDist IN ( 8, 9, 11, 19, 23)
*/


SET @total_registros	= (SELECT COUNT(*) FROM tmp_az_stock_distribuidor_xml)
SET @sum_ean					= (SELECT ISNULL(Sum(convert(bigint,CodigoEAN)),0) FROM tmp_az_stock_distribuidor_xml)-- GROUP BY ean
SET @sum_cantidad			= (SELECT ISNULL(Sum(Cantidad),0) FROM tmp_az_stock_distribuidor_xml)-- GROUP BY Cantidad

IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES 
    WHERE TABLE_TYPE='BASE TABLE' AND TABLE_NAME='tmp_az_control_stock_distribucion') 
	TRUNCATE TABLE tmp_az_control_stock_distribucion

ELSE
	CREATE TABLE tmp_az_control_stock_distribucion (
		TotalRegistros			int						,
		SumaEAN							bigint				,
		SumaCantidad				decimal(12,2)		
		PRIMARY KEY (TotalRegistros, SumaEAN, SumaCantidad)
		)

INSERT INTO tmp_az_control_stock_distribucion
SELECT
	 @total_registros	TotalRegistros,
	 @sum_ean					SumaEAN,
	 @sum_cantidad		SumaCantidad

UPDATE tmp_az_stock_distribuidor_xml SET NumeroLote = '', Texto1 = '', Texto2 = '', Texto3 = ''	,MotivoBloqueo = ''

GO

