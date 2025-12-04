CREATE 
	--	CREATE
PROCEDURE [dbo].[usp_astra_zeneca_pedidos_xml] (@fecha VARCHAR(10)) 
AS


/*
usp_astra_zeneca_pedidos_xml '2012-10-15'
*/

--	pedidos
--	27 OCT 2009					AGREGAR	LETRA A PUNTOS DE VENTA
--	2010-03-03			SE AGREGO NUM SUCURSAL AL DOCUMENTO REF.
--	06	SEP	2010					CORRECION EN FORMULA DE IMPORTE
--	25	MAR	2011					SE RETRASA EL ENVIO 1 DIA 
--	03	OCT	2011					SE CAMBIA TABLA DE MAESTRO DE PRODUCTOS
--	20	FEB	2012					SE AGREGO FILTRO DE CUENTRAS TRANSFER

--SET @fecha = CONVERT(VARCHAR(10),DATEADD(DD ,-1, CONVERT(DATETIME,@fecha,121) ),121)

--	DROP TABLE tmp_az_pedidos_xml

DECLARE @sucursal INT

IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES 
    WHERE TABLE_TYPE='BASE TABLE' AND TABLE_NAME='tmp_az_pedidos_xml') 
	TRUNCATE TABLE tmp_az_pedidos_xml
ELSE
	BEGIN
		CREATE --	DROP
			TABLE tmp_az_pedidos_xml (
			ClaveDist					VARCHAR(20),
			ClaveSucDist			VARCHAR(20),
			FechaDoc					VARCHAR(20),
			Numero						VARCHAR(20),
			ClaveCliente			VARCHAR(20),
			ClaveSubd					VARCHAR(20),
			MotCancel					VARCHAR(20),
			CodigoMat					VARCHAR(20),
			CodigoEAN					VARCHAR(20),
			CantSolic					INT,
			UnidadMedida			VARCHAR(20),
			PrecioUnit				MONEY,
			Valor							MONEY,
			CantFaltante			INT,
			MotFaltante				VARCHAR(20)	
			)
			--PRIMARY KEY (ClaveSucDist,ClaveCliente,Numero,CodigoMat, CantSolic)	--	CantSolic
			CREATE INDEX idx_az_pedidos ON tmp_az_pedidos_xml (ClaveSucDist,ClaveCliente,Numero,CodigoMat, CantSolic)
	END


SELECT codigo,cod_barras,descripcion,p_costo INTO #az_productos 
FROM maestro_productos mpb  WITH (NOLOCK)
WHERE (
mpb.lab_corto = 'ASTRAZ' AND ISNUMERIC(cod_barras) = 1 AND CONVERT(BIGINT, cod_barras) > 0
)
OR
cod_barras IN (
'7501091440612',
'7501091440629',
'7501091440643'
) 

CREATE INDEX tmp_az_mpb ON #az_productos	(codigo)

DECLARE cursor_sucursales CURSOR FORWARD_ONLY FOR 
	SELECT sucursal FROM SUCURSALES

OPEN cursor_sucursales
FETCH FROM cursor_sucursales INTO @sucursal

WHILE @@fetch_status = 0
BEGIN

	select 
	'MARZAM'																					ClaveDist,	--	enc.sucursal
	RIGHT(REPLICATE('0',2)+CONVERT(varchar,enc.Sucursal),2)		ClaveSucDist,	--	z.AZM
	convert(varchar(12),convert(datetime,@fecha,121),104)			FechaDoc,	--	
--	convert(varchar,convert(int,enc.factura))									Numero,
	RIGHT(REPLICATE('0',2)+CONVERT(varchar,enc.Sucursal),2)	+
	enc.factura																								Numero,
	enc.cliente																								ClaveCliente,
	'NA'																											ClaveSubd,
	'NA'																											MotCancel,
	CONVERT(VARCHAR,CONVERT(INT,mpb.codigo))									CodigoMat,
	mpb.cod_barras																						CodigoEAN,
	det.cant_ped																							CantSolic,
	'PZA'																											UnidadMedida,
--	det.prec_farm																							PrecioUnit,
	mpb.p_costo																								PrecioUnit,
	--det.cant_ped * det.prec_farm															Valor,
	det.cant_ped * mpb.p_costo																Valor,
																							
	CASE	WHEN det.dest_det = 'FEA' THEN det.cant_ped
				WHEN det.dest_det = 'FEP' THEN det.cant_ped 
				WHEN det.dest_det = 'AAA' THEN 0 
				ELSE 0										END												CantFaltante,
	
	CASE	WHEN det.dest_det = 'FEA' THEN 'AG'
				WHEN det.dest_det = 'FEP' THEN 'FA' 
				WHEN det.dest_det = 'AAA' THEN 'NA' 
				ELSE 'ND'									END												MotFaltante
	INTO #tmp_az_pedidos
	FROM	encabezado enc 
	INNER JOIN detalle det on enc.sucursal = det.sucursal AND enc.factura = det.factura
	INNER JOIN #az_productos mpb on '00' + mpb.codigo = det.codigos

	WHERE 
	enc.sucursal =  @sucursal AND
	enc.fechaprog = CONVERT(DATETIME, @fecha, 121) AND	--	'2009-05-27'
	ISNUMERIC(cod_barras) = 1 AND CONVERT(BIGINT, cod_barras) > 0 AND	--	14-02-2011
	det.dest_det in ('AAA', 'FEA', 'FEP')
AND NOT
(   
   (enc.sucursal =  1 AND enc.cliente in ('37270','37280','37300'))
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

	INSERT INTO tmp_az_pedidos_xml 
		SELECT 
			ClaveDist,
			ClaveSucDist,
			FechaDoc,
			Numero,
			ClaveCliente,
			ClaveSubd,
			MotCancel,
			CodigoMat,
			CodigoEAN,
			CantSolic,
			UnidadMedida,
			PrecioUnit,
			Valor,
			CantFaltante,
			MotFaltante
		FROM #tmp_az_pedidos

	DROP TABLE #tmp_az_pedidos
	FETCH NEXT FROM cursor_sucursales INTO @sucursal
END

CLOSE cursor_sucursales
DEALLOCATE cursor_sucursales

UPDATE tmp_az_pedidos_xml 
SET ClaveSucDist = RIGHT(REPLICATE('0',2) + CONVERT(VARCHAR,suc.almacen) ,2)
FROM tmp_az_pedidos_xml pedidos
INNER JOIN sucursales suc ON CONVERT(INT,pedidos.ClaveSucDist) = suc.sucursal

UPDATE tmp_az_pedidos_xml 
SET ClaveCliente = CONVERT(VARCHAR,suc.ibs_letra) + RIGHT(REPLICATE('0',5)+ ClaveCliente  ,5)
FROM tmp_az_pedidos_xml pedidos
INNER JOIN sucursales suc ON CONVERT(INT,pedidos.ClaveSucDist) = suc.sucursal

DECLARE @total_registros		INT
DECLARE @sum_ean						BIGINT
DECLARE @sum_cantidad				INT
DECLARE @sum_precio					DECIMAL(12,2)
DECLARE @sum_valor					DECIMAL(12,2)
DECLARE @sum_cant_faltante	INT

IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES 
    WHERE TABLE_TYPE='BASE TABLE' AND TABLE_NAME='tmp_az_control_pedidos') 
	TRUNCATE TABLE tmp_az_control_pedidos
ELSE
	CREATE TABLE tmp_az_control_pedidos	(
		TotalRegistros		INT						NOT NULL,
		SumaEAN						BIGINT				NOT NULL,
		SumaCantidad			INT						NOT NULL,
		SumaPrecio				MONEY					NOT NULL,
		SumaValor					MONEY					NOT NULL,
		SumaCantFaltante	INT						NOT NULL	
		PRIMARY KEY (TotalRegistros, SumaEAN,SumaCantidad, SumaPrecio, SumaValor, SumaCantFaltante)			
		)

SET @total_registros		= (SELECT ISNULL(COUNT(*)												,0)	FROM tmp_az_pedidos_xml)
SET @sum_ean						= (SELECT ISNULL(SUM(CONVERT(BIGINT,CodigoEAN))	,0)	FROM tmp_az_pedidos_xml)-- GROUP BY ean
SET @sum_cantidad				= (SELECT ISNULL(SUM(CantSolic)									,0)	FROM tmp_az_pedidos_xml)-- GROUP BY valor
SET @sum_precio					= (SELECT ISNULL(SUM(PrecioUnit)								,0)	FROM tmp_az_pedidos_xml)-- GROUP BY precio
SET @sum_valor					= (SELECT ISNULL(SUM(Valor)											,0)	FROM tmp_az_pedidos_xml)-- GROUP BY valor
SET @sum_cant_faltante	= (SELECT ISNULL(SUM(CantFaltante)							,0)	FROM tmp_az_pedidos_xml)-- GROUP BY valor


INSERT INTO tmp_az_control_pedidos
SELECT
	 @total_registros			TotalRegistros,
	 @sum_ean							SumaEAN,
	 @sum_cantidad				SumaCantidad,
	 @sum_precio					SumaPrecio,
	 @sum_valor						SumaValor,
	 @sum_cant_faltante		SumaCantFaltante

GO

