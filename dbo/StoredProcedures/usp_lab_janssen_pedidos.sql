

CREATE	--	CREATE	--	DROP
PROCEDURE [dbo].[usp_lab_janssen_pedidos] (@fecha VARCHAR(10)) 
AS


/*
EXECUTE usp_lab_janssen_pedidos '2011-11-08'
SELECT * FROM lab_janssen_pedidos
SELECT * FROM lab_janssen_control_pedidos
*/

--	pedidos
--	27 OCT 2009					AGREGAR	LETRA A PUNTOS DE VENTA
--	2010-03-03			SE AGREGO NUM SUCURSAL AL DOCUMENTO REF.
--	06	SEP	2010					CORRECION EN FORMULA DE IMPORTE

declare @sucursal INT, @ejecucion VARCHAR(23)
SET @ejecucion = GETDATE()

IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES 
    WHERE TABLE_TYPE='BASE TABLE' AND TABLE_NAME='lab_janssen_pedidos') 
	TRUNCATE TABLE lab_janssen_pedidos
ELSE
		CREATE --	DROP
		TABLE lab_janssen_pedidos (
			ClaveDist					VARCHAR(20)	,
			ClaveSucDist			VARCHAR(20)	,
			FechaDoc					VARCHAR(20)	,
			Numero						VARCHAR(20)	,
			ClaveCliente			VARCHAR(20)	,
			ClaveSubd					VARCHAR(20)	,
			MotCancel					VARCHAR(20)	,
			CodigoMat					VARCHAR(20)	,
			CodigoEAN					VARCHAR(20)	,
			CantSolic					INT					,
			UnidadMedida			VARCHAR(20)	,
			PrecioUnit				MONEY				,
			Valor							MONEY				,
			CantFaltante			INT					,
			MotFaltante				VARCHAR(20)	
			PRIMARY KEY (ClaveSucDist, ClaveCliente, FechaDoc, Numero, CodigoMat, CodigoEAN, CantSolic)	--	CantSolic
)

DECLARE cursor_sucursales CURSOR FORWARD_ONLY FOR 
	SELECT sucursal FROM SUCURSALES

OPEN cursor_sucursales
FETCH FROM cursor_sucursales INTO @sucursal

SELECT *
INTO #productos_janssen
FROM maestro_productos mpb
where mpb.lab_corto IN (SELECT lab_corto FROM lab_fusiones WHERE id_lab = 'JANSSEN')
	--AND mpb.cod_barras IS NOT NULL											AND

ALTER TABLE #productos_janssen ADD PRIMARY KEY (codigo)

WHILE @@fetch_status = 0
BEGIN

	SELECT --	TOP 25
	'MARZAM'																					ClaveDist,	--	enc.sucursal
	RIGHT(REPLICATE('0',2)+CONVERT(VARCHAR,enc.Sucursal),2)		ClaveSucDist,	--	z.AZM
	convert(VARCHAR(12),convert(SMALLDATETIME,fechaprog,121),104)			FechaDoc,	--	
--	convert(varchar,convert(int,enc.factura))									Numero,
--	RIGHT(REPLICATE('0',2)+CONVERT(VARCHAR,enc.Sucursal),2)	+
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
	INTO #tmp_lab_janssen_pedidos
	FROM	encabezado enc  WITH (NOLOCK)
	INNER JOIN detalle det WITH (NOLOCK) on enc.sucursal = det.sucursal AND enc.factura = det.factura 
	--AND		DATEADD(DD, -1, CONVERT(SMALLDATETIME,@fecha,121))  >= det.timestamp
	INNER JOIN #productos_janssen mpb WITH (NOLOCK) ON	'00' + mpb.codigo = det.codigos
--	INNER JOIN sucursales_azm Z on Z.SUCURSAL = enc.sucursal

	WHERE 
	enc.sucursal =  @sucursal												AND
	enc.fechaprog = DATEADD(DD, -1, CONVERT(SMALLDATETIME, @fecha, 121))	AND	--	'2009-05-27'
--	enc.fechaprog = convert(datetime, convert(varchar(10),current_timestamp,121), 121) and	--	'2009-05-27'
	det.dest_det in ('AAA', 'FEA', 'FEP')


--ALTER TABLE #tmp_lab_janssen_pedidos 
--	ADD PRIMARY KEY (ClaveSucDist, ClaveCliente, FechaDoc, Numero, CodigoMat, CodigoEAN, CantSolic)

	INSERT INTO lab_janssen_pedidos 
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
		FROM #tmp_lab_janssen_pedidos	;

	DROP TABLE #tmp_lab_janssen_pedidos
	FETCH NEXT FROM cursor_sucursales INTO @sucursal
END

CLOSE cursor_sucursales
DEALLOCATE cursor_sucursales

UPDATE lab_janssen_pedidos 
SET ClaveSucDist = RIGHT(REPLICATE('0',2) + CONVERT(VARCHAR,suc.almacen) ,2)
FROM lab_janssen_pedidos pedidos
INNER JOIN sucursales suc ON CONVERT(INT,pedidos.ClaveSucDist) = suc.sucursal

UPDATE lab_janssen_pedidos 
SET ClaveCliente = CONVERT(VARCHAR,suc.ibs_letra) + RIGHT(REPLICATE('0',5)+ ClaveCliente  ,5)
FROM lab_janssen_pedidos pedidos
INNER JOIN sucursales suc ON CONVERT(INT,pedidos.ClaveSucDist) = suc.sucursal

DECLARE @total_registros		INT
DECLARE @sum_ean						BIGINT
DECLARE @sum_cantidad				INT
DECLARE @sum_precio					DECIMAL(12,2)
DECLARE @sum_valor					DECIMAL(12,2)
DECLARE @sum_cant_faltante	INT

IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES 
    WHERE TABLE_TYPE='BASE TABLE' AND TABLE_NAME='lab_janssen_control_pedidos') 
	TRUNCATE TABLE lab_janssen_control_pedidos
ELSE
	CREATE TABLE lab_janssen_control_pedidos	(
		TotalRegistros		INT						NOT NULL,
		SumaEAN						BIGINT				NOT NULL,
		SumaCantidad			INT						NOT NULL,
		SumaPrecio				MONEY					NOT NULL,
		SumaValor					MONEY					NOT NULL,
		SumaCantFaltante	INT						NOT NULL	
		PRIMARY KEY (TotalRegistros, SumaEAN,SumaCantidad, SumaPrecio, SumaValor, SumaCantFaltante)			
		)

SET @total_registros		= (SELECT ISNULL(COUNT(*)												,0)	FROM lab_janssen_pedidos)
SET @sum_ean						= (SELECT ISNULL(SUM(CONVERT(BIGINT,CodigoEAN))	,0)	FROM lab_janssen_pedidos)-- GROUP BY ean
SET @sum_cantidad				= (SELECT ISNULL(SUM(CantSolic)									,0)	FROM lab_janssen_pedidos)-- GROUP BY valor
SET @sum_precio					= (SELECT ISNULL(SUM(PrecioUnit)								,0)	FROM lab_janssen_pedidos)-- GROUP BY precio
SET @sum_valor					= (SELECT ISNULL(SUM(Valor)											,0)	FROM lab_janssen_pedidos)-- GROUP BY valor
SET @sum_cant_faltante	= (SELECT ISNULL(SUM(CantFaltante)							,0)	FROM lab_janssen_pedidos)-- GROUP BY valor


INSERT INTO lab_janssen_control_pedidos
SELECT
	 @total_registros			TotalRegistros,
	 @sum_ean							SumaEAN,
	 @sum_cantidad				SumaCantidad,
	 @sum_precio					SumaPrecio,
	 @sum_valor						SumaValor,
	 @sum_cant_faltante		SumaCantFaltante

EXECUTE usp_estadisticas_samayoa 'usp_lab_janssen_pedidos', @total_registros, @ejecucion

SELECT 
	 LEFT(ClaveDist					 													+ REPLICATE(' ',10) 						,10)	ClaveDist					,
	 LEFT(ClaveSucDist																+ REPLICATE(' ',10)  						,10)	ClaveSucDist			,
	 LEFT(FechaDoc					 													+ REPLICATE(' ',10) 						,10)	FechaDoc					,
	 LEFT(Numero						 													+ REPLICATE(' ',10) 						,10)	Numero						,
	 LEFT(ClaveCliente  															+ REPLICATE(' ',15)							,15)	ClaveCliente			,
	 LEFT(ClaveSubd			 															+ REPLICATE(' ',10)		 					,10)	ClaveSubd					,
	 LEFT(MotCancel			 															+ REPLICATE(' ', 3)		 					, 3)	MotCancel					,
	 LEFT(CodigoMat					 													+ REPLICATE(' ',18) 						,18)	CodigoMat					,
	 LEFT(CONVERT(VARCHAR,CONVERT(BIGINT,CodigoEAN)	)	+ REPLICATE(' ',18) 						,18)	CodigoEAN					,
	RIGHT(REPLICATE(' ',18) 													+ CONVERT(VARCHAR,CantSolic)		,18) 	CantSolic			,
	 LEFT(UnidadMedida																+ REPLICATE(' ', 3)							, 3)	UnidadMedida			,
	RIGHT(REPLICATE(' ',18)														+ CONVERT(VARCHAR,PrecioUnit)		,18)	PrecioUnit				,
	RIGHT(REPLICATE(' ',18)														+ CONVERT(VARCHAR,Valor)				,18)	Valor				,
	RIGHT(REPLICATE(' ',18) 													+ CONVERT(VARCHAR,CantFaltante)	,18) 	CantFaltante			,
	 LEFT(MotFaltante	+ REPLICATE(' ', 3) 																						, 3) 	MotFaltante					
FROM lab_janssen_pedidos

GO

