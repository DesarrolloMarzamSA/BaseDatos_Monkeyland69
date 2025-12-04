CREATE 
	--	CREATE	--	DROP
PROCEDURE usp_lab_msd_pedidos (@fecha VARCHAR(10)) 
AS


/*
usp_lab_msd_pedidos '2011-01-25'
SELECT * FROM lab_msd_pedidos
SELECT * FROM lab_msd_control_pedidos
*/

--	pedidos
--	27 OCT 2009					AGREGAR	LETRA A PUNTOS DE VENTA
--	2010-03-03			SE AGREGO NUM SUCURSAL AL DOCUMENTO REF.
--	06	SEP	2010					CORRECION EN FORMULA DE IMPORTE

declare @sucursal INT, @ejecucion VARCHAR(23)
SET @ejecucion = CONVERT(VARCHAR(23),GETDATE(),121)

IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES 
    WHERE TABLE_TYPE='BASE TABLE' AND TABLE_NAME='lab_msd_pedidos') 
	TRUNCATE TABLE lab_msd_pedidos
ELSE
		CREATE --	DROP
		TABLE lab_msd_pedidos (
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
			PRIMARY KEY (ClaveSucDist, ClaveCliente, Numero, CodigoMat, CodigoEAN, CantSolic, MotFaltante)	--	
)

DECLARE cursor_sucursales CURSOR FORWARD_ONLY FOR 
	SELECT sucursal FROM SUCURSALES

OPEN cursor_sucursales
FETCH FROM cursor_sucursales INTO @sucursal

SELECT *
INTO #productos_msd
FROM maestro_productos mpb
where mpb.lab_corto IN (SELECT lab_corto FROM lab_fusiones WHERE id_lab = 'MSD')
	--AND mpb.cod_barras IS NOT NULL											AND

ALTER TABLE #productos_msd ADD PRIMARY KEY (codigo)

WHILE @@fetch_status = 0
BEGIN
/*
	IF(@sucursal <> 9)
	BEGIN
		FETCH NEXT FROM cursor_sucursales INTO @sucursal
		CONTINUE
	END
*/
	SELECT	--	TOP 25
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
	
	CASE	WHEN det.dest_det = 'FEA' THEN 'AG'									--	FALTANTE ALMACEN
				WHEN det.dest_det = 'FEP' THEN 'FA'									--	FALTANTE PROVEEDOR
				WHEN det.dest_det = 'AAA' THEN 'NA'									--	SURTIDO
				ELSE 'ND'									END												MotFaltante
	INTO #tmp_lab_msd_pedidos
	FROM	encabezado enc 
	INNER JOIN detalle det on enc.sucursal = det.sucursal AND enc.factura = det.factura
	INNER JOIN #productos_msd mpb ON	'00' + mpb.codigo = det.codigos
--	INNER JOIN sucursales_azm Z on Z.SUCURSAL = enc.sucursal

	WHERE 
	enc.sucursal =  @sucursal												AND
	enc.fechaprog = CONVERT(SMALLDATETIME, @fecha, 121)	AND	--	'2009-05-27'
--	enc.fechaprog = convert(datetime, convert(varchar(10),current_timestamp,121), 121) and	--	'2009-05-27'
	det.dest_det in ('AAA', 'FEA', 'FEP')

	PRINT @sucursal
	
	
--	SELECT * FROM #tmp_lab_msd_pedidos ORDER BY ClaveSucDist, ClaveCliente, Numero, CodigoMat, CantSolic, MotFaltante
	

	INSERT INTO lab_msd_pedidos 
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
		FROM #tmp_lab_msd_pedidos

	DROP TABLE #tmp_lab_msd_pedidos
	FETCH NEXT FROM cursor_sucursales INTO @sucursal
END

CLOSE cursor_sucursales
DEALLOCATE cursor_sucursales

--	CONSOLIDA SUCURSALES
UPDATE lab_msd_pedidos SET 
	ClaveSucDist = RIGHT(REPLICATE('0',2) + CONVERT(VARCHAR,suc.almacen) ,2)
FROM lab_msd_pedidos pedidos
INNER JOIN sucursales suc ON CONVERT(INT,pedidos.ClaveSucDist) = suc.sucursal


--	AGREGA UNA LETRA A PUNTOS DE VENTA
UPDATE lab_msd_pedidos SET 
	ClaveCliente = CONVERT(VARCHAR,suc.ibs_letra) + RIGHT(REPLICATE('0',5)+ ClaveCliente  ,5)
FROM lab_msd_pedidos pedidos
INNER JOIN sucursales suc ON CONVERT(INT,pedidos.ClaveSucDist) = suc.sucursal

DECLARE @total_registros		INT
DECLARE @sum_ean						BIGINT
DECLARE @sum_cantidad				INT
DECLARE @sum_precio					DECIMAL(12,2)
DECLARE @sum_valor					DECIMAL(12,2)
DECLARE @sum_cant_faltante	INT

SET @total_registros		= (SELECT ISNULL(COUNT(*)												,0)	FROM lab_msd_pedidos)
SET @sum_ean						= (SELECT ISNULL(SUM(CONVERT(BIGINT,CodigoEAN))	,0)	FROM lab_msd_pedidos)-- GROUP BY ean
SET @sum_cantidad				= (SELECT ISNULL(SUM(CantSolic)									,0)	FROM lab_msd_pedidos)-- GROUP BY valor
SET @sum_precio					= (SELECT ISNULL(SUM(PrecioUnit)								,0)	FROM lab_msd_pedidos)-- GROUP BY precio
SET @sum_valor					= (SELECT ISNULL(SUM(Valor)											,0)	FROM lab_msd_pedidos)-- GROUP BY valor
SET @sum_cant_faltante	= (SELECT ISNULL(SUM(CantFaltante)							,0)	FROM lab_msd_pedidos)-- GROUP BY valor

/*
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES 
    WHERE TABLE_TYPE='BASE TABLE' AND TABLE_NAME='lab_msd_pedidos_control') 
	TRUNCATE TABLE lab_msd_control_pedidos
ELSE
	CREATE --	DROP
	TABLE lab_msd_pedidos_control	(
		TotalRegistros		INT						NOT NULL,
		SumaEAN						BIGINT				NOT NULL,
		SumaCantidad			INT						NOT NULL,
		SumaPrecio				MONEY					NOT NULL,
		SumaValor					MONEY					NOT NULL,
		SumaCantFaltante	INT						NOT NULL	
		PRIMARY KEY (TotalRegistros, SumaEAN,SumaCantidad, SumaPrecio, SumaValor, SumaCantFaltante)			
		)

INSERT INTO lab_msd_pedidos_control
SELECT
	 @total_registros			TotalRegistros,
	 @sum_ean							SumaEAN,
	 @sum_cantidad				SumaCantidad,
	 @sum_precio					SumaPrecio,
	 @sum_valor						SumaValor,
	 @sum_cant_faltante		SumaCantFaltante
*/

DECLARE @estor VARCHAR(50)
SET @estor = 'usp_lab_msd_pedidos '+@fecha
EXECUTE usp_estadisticas_samayoa @estor, @total_registros, @ejecucion

SELECT  
	ClaveDist					,
	ClaveSucDist			,
	FechaDoc					,
	Numero						,
	ClaveCliente			,
	ClaveSubd					,
	MotCancel					,
	CodigoMat					,
	CodigoEAN					,
	CantSolic					,
	UnidadMedida			,
	PrecioUnit				,
	Valor							,
	CantFaltante			,
	MotFaltante					

FROM lab_msd_pedidos

GO

