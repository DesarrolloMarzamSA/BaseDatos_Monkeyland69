/*
usp_lab_sanofi_factura  1,'2012-02-20'
*/

CREATE
--	CREATE
PROCEDURE usp_lab_sanofi_factura 
	@almacen INT, @fecha VARCHAR(10)
AS

/*
DECLARE	@almacen INT, @fecha VARCHAR(10)
SET @fecha = '2012-02-20'
SET @almacen = 1
SELECT 
CONVERT(DATETIME,DATEADD(DD,  -1, CONVERT(DATETIME, @fecha,121) ),121 ),
CONVERT(DATETIME,DATEADD(DD,  -7, CONVERT(DATETIME, @fecha,121) ),121 )

*/

DECLARE @SEP VARCHAR(10)
SET @SEP = '|'
DECLARE @contador INT

CREATE TABLE #Invoice	(	--	ENCABEZADO
	renglon													INT						,
	sucursal												INT						,
	cliente													VARCHAR(5)		,
	factura													VARCHAR(10)		,
	Fecha_Factura										DATE	,
	Fecha_compromiso								DATE	,
	Monto_Total											MONEY					,
	Balance													MONEY					,
	Impuesto												MONEY					,
	DescuentoTotalSanofi						MONEY					,
	DescuentoTotalMayorista					MONEY					,
	Cargo_Embarques									MONEY					,
	Codigo_cliente_mayorista				VARCHAR(90)		,
	Numero_Factura									VARCHAR(60)		,
	Numero_orden_mayorista					VARCHAR(60)
	PRIMARY KEY (sucursal, cliente, factura)
)

CREATE TABLE #facturas	(
	id_recno												INT IDENTITY	,
	fecha_factura										DATE	,
	fecha_compromiso								DATE	,
	sucursal												INT						,
	cliente													VARCHAR(5)		,
	factura													VARCHAR(10)		
	PRIMARY KEY (sucursal, cliente, factura)
)

CREATE					--	DROP	--	TRUNCATE	
TABLE	#facturas_sanofi_surtido	(
	sucursal													TINYINT					NOT	NULL,				--	01
	cliente														VARCHAR(5)			NOT	NULL,				--	02
	digito_verificador								VARCHAR(1)			NULL,						--	03
	serie															VARCHAR(1)			NULL,						--	04
	factura														VARCHAR(8)			NOT	NULL,				--	05
	fecha_factura											DATETIME				NULL,						--	06
	codigo														VARCHAR(7)			NOT	NULL,				--	07
	descripcion												VARCHAR(40)			NULL,						--	08
	cod_barras												VARCHAR(13)			NULL,						--	09
	clas_fis													VARCHAR(2)			NULL,						--	10
	piezas_surtidas_con_cargo					INT							NULL,						--	11
	piezas_surtidas_sin_cargo					INT							NULL,						--	12
	precio_farm_sin_imp								MONEY						NULL,						--	13
	precio_pub_sin_imp								MONEY						NULL,						--	14
	precio_pub_con_imp								MONEY						NULL,						--	15
	importe_bruto											MONEY						NULL,						--	16
	porcentaje_descto_oferta					MONEY						NULL,						--	17
	descto_oferta											MONEY						NULL,						--	18
	porcentaje_descto_comercial				MONEY						NULL,						--	19
	descto_comercial									MONEY						NULL,						--	20
	ieps															MONEY						NULL,						--	21
	iva																MONEY						NULL,						--	22
	bonificacion_iva									MONEY						NULL,						--	23
	porcentaje_utilidad								MONEY						NULL,						--	24
	importe_neto											MONEY						NULL,						--	25
	orden															VARCHAR(10)			NULL,						--	26
	porcentaje_iva										MONEY						NULL,						--	27
	filler														VARCHAR(5)			NULL,						--	28
	no_registro												INT							NULL,						--	29
	desc_comerc_prod									MONEY						NULL,						--	30
	porcentaje_iva2										MONEY						NULL,						--	31
	iva2															MONEY						NULL,						--	32
	bonificacion_iva2									MONEY						NULL,						--	33
	porcentaje_ieps										MONEY						NULL,						--	34
	desc_comerc_ieps									MONEY						NULL,						--	35
	iva_del_iesps											MONEY						NULL,						--	36
	bonificacion_iva_del_iesps				MONEY						NULL,						--	37
	timestamp													DATETIME				NULL,						--	38
	segto															CHAR(2)					NULL,						--	39
	ctepadre													CHAR(3)					NULL,						--	40
	rfc																CHAR(13)				NULL,						--	41
	tipo_documento										VARCHAR(1)			NULL,						--	42
	folio_fiscal											VARCHAR(8)			NULL,						--	43
	fecha_tandem											SMALLDATETIME		NULL,						--	44
PRIMARY					KEY			(	sucursal	ASC,	cliente	ASC,	factura	ASC,	codigo	ASC)
)

CREATE					--	DROP	--	TRUNCATE	
TABLE	#facturas_sanofi_negado	(
	sucursal													TINYINT					NOT	NULL,					--	01
	cliente														VARCHAR(5)			NOT	NULL,					--	02
	digito_verificador								VARCHAR(1)			NULL,							--	03
	serie															VARCHAR(1)			NULL,							--	04
	factura														VARCHAR(8)			NOT	NULL,					--	05
	fecha_factura											DATETIME				NULL,							--	06
	codigo														VARCHAR(7)			NOT	NULL,					--	07
	descripcion												VARCHAR(40)			NULL,							--	08
	cod_barras												VARCHAR(13)			NULL,							--	09
	clas_fis													VARCHAR(2)			NULL,							--	10
	piezas_surtidas_con_cargo					INT							NULL,							--	11
	piezas_surtidas_sin_cargo					INT							NULL,							--	12
	precio_farm_sin_imp								MONEY						NULL,							--	13
	precio_pub_sin_imp								MONEY						NULL,							--	14
	precio_pub_con_imp								MONEY						NULL,							--	15
	importe_bruto											MONEY						NULL,							--	16
	porcentaje_descto_oferta					MONEY						NULL,							--	17
	descto_oferta											MONEY						NULL,							--	18
	porcentaje_descto_comercial				MONEY						NULL,							--	19
	descto_comercial									MONEY						NULL,							--	20
	ieps															MONEY						NULL,							--	21
	iva																MONEY						NULL,							--	22
	bonificacion_iva									MONEY						NULL,							--	23
	porcentaje_utilidad								MONEY						NULL,							--	24
	importe_neto											MONEY						NULL,							--	25
	orden															VARCHAR(10)			NULL,							--	26
	porcentaje_iva										MONEY						NULL,							--	27
	filler														VARCHAR(5)			NULL,							--	28
	no_registro												INT							NULL,							--	29
	desc_comerc_prod									MONEY						NULL,							--	30
	porcentaje_iva2										MONEY						NULL,							--	31
	iva2															MONEY						NULL,							--	32
	bonificacion_iva2									MONEY						NULL,							--	33
	porcentaje_ieps										MONEY						NULL,							--	34
	desc_comerc_ieps									MONEY						NULL,							--	35
	iva_del_iesps											MONEY						NULL,							--	36
	bonificacion_iva_del_iesps				MONEY						NULL,							--	37
	timestamp													DATETIME				NULL,							--	38
	segto															CHAR(2)					NULL,							--	39
	ctepadre													CHAR(3)					NULL,							--	40
	rfc																CHAR(13)				NULL,							--	41
	tipo_documento										VARCHAR(1)			NULL,							--	42
	folio_fiscal											VARCHAR(8)			NULL,							--	43
	fecha_tandem											SMALLDATETIME		NULL,							--	44
PRIMARY					KEY			(	sucursal	ASC,	cliente	ASC,	factura	ASC,	codigo	ASC)
)

/*
SELECT 	--	TOP 50
	F.sucursal										,
	F.cliente											,
	F.digito_verificador					,
	F.serie												,
	F.factura											,
	F.fecha_factura								,
	F.codigo											,
	F.descripcion									,
	F.cod_barras									,
	F.clas_fis										,
	F.piezas_surtidas_con_cargo		,
	F.piezas_surtidas_sin_cargo		,
	F.precio_farm_sin_imp					,
	F.precio_pub_sin_imp					,
	F.precio_pub_con_imp					,
	F.importe_bruto								,
	F.porcentaje_descto_oferta		,
	F.descto_oferta								,
	F.porcentaje_descto_comercial	,
	F.descto_comercial						,
	F.ieps												,
	F.iva													,
	F.bonificacion_iva						,
	F.porcentaje_utilidad					,
	F.importe_neto								,
	F.orden												,
	F.porcentaje_iva							,
	F.filler											,
	F.no_registro									,
	F.desc_comerc_prod						,
	F.porcentaje_iva2							,
	F.iva2												,
	F.bonificacion_iva2						,
	F.porcentaje_ieps							,
	F.desc_comerc_ieps						,
	F.iva_del_iesps								,
	F.bonificacion_iva_del_iesps	,
	F.TIMESTAMP										,
	F.segto												,
	F.ctepadre										,
	F.rfc													,
	F.tipo_documento							,
	F.folio_fiscal								
INTO #facturas_sanofi_surtido
FROM facturacion_electronica_estandar f	WITH (NOLOCK)
INNER JOIN sucursales s									WITH (NOLOCK)	ON s.almacen = @almacen AND s.sucursal = f.sucursal
INNER JOIN maestro_productos_baan mpb		WITH (NOLOCK)	ON mpb.lab_corto = 'SANOFI' AND f.codigo = mpb.codigo
WHERE f.fecha_tandem = CONVERT(DATETIME,@fecha,121)
AND ISNUMERIC( LTRIM(RTRIM(factura) ) ) = 1
--and f.sucursal = @almacen
*/

INSERT INTO #facturas_sanofi_surtido
SELECT 	--	TOP 50
	f.sucursal										,							--	01
	f.cliente											,							--	02
	f.digito_verificador					,							--	03
	f.serie												,							--	04
	f.factura											,							--	05
	f.fecha_factura								,							--	06
	f.codigo											,							--	07
	f.descripcion									,							--	08
	f.cod_barras									,							--	09
	f.clas_fis										,							--	10
	f.piezas_surtidas_con_cargo		,							--	11
	f.piezas_surtidas_sin_cargo		,							--	12
	f.precio_farm_sin_imp					,							--	13
	f.precio_pub_sin_imp					,							--	14
	f.precio_pub_con_imp					,							--	15
	f.importe_bruto								,							--	16
	f.porcentaje_descto_oferta		,							--	17
	f.descto_oferta								,							--	18
	f.porcentaje_descto_comercial	,							--	19
	f.descto_comercial						,							--	20
	f.ieps												,							--	21
	f.iva													,							--	22
	f.bonificacion_iva						,							--	23
	f.porcentaje_utilidad					,							--	24
	f.importe_neto								,							--	25
	f.orden												,							--	26
	f.porcentaje_iva							,							--	27
	f.filler											,							--	28
	f.no_registro									,							--	29
	f.desc_comerc_prod						,							--	30
	f.porcentaje_iva2							,							--	31
	f.iva2												,							--	32
	f.bonificacion_iva2						,							--	33
	f.porcentaje_ieps							,							--	34
	f.desc_comerc_ieps						,							--	35
	f.iva_del_iesps								,							--	36
	f.bonificacion_iva_del_iesps	,							--	37
	f.TIMESTAMP										,							--	38
	f.segto												,							--	39
	f.ctepadre										,							--	40
	f.rfc													,							--	41
	f.tipo_documento							,							--	42
	f.folio_fiscal								,							--	43
	fecha_tandem									 							--	44	
--FROM lab_sanofi_fes f									WITH (NOLOCK)
FROM facturacion_electronica_estandar f									WITH (NOLOCK)
INNER JOIN sucursales s								WITH (NOLOCK)	ON s.almacen = @almacen AND s.sucursal = f.sucursal
INNER JOIN lab_sanofi_cat_productos mpb		WITH (NOLOCK)	ON f.codigo = mpb.codigo
WHERE f.fecha_factura 
BETWEEN	CONVERT(DATETIME,DATEADD(DD,  -7, CONVERT(DATETIME, @fecha,121) ),121 )
		AND CONVERT(DATETIME,DATEADD(DD,  -1, CONVERT(DATETIME, @fecha,121) ),121 )
--CONVERT(DATETIME,@fecha,121)
ORDER BY f.fecha_factura, f.sucursal, f.factura

INSERT INTO #facturas_sanofi_negado
SELECT 
	e.sucursal   										sucursal										,							--	01
	e.cliente	 											cliente											,							--	02
	'0'				 											digito_verificador					,							--	03
	'0'			  											serie												,							--	04
	e.factura    										factura											,							--	05
	e.fechaprog											fecha_factura								,							--	06
	mpb.codigo 											codigo											,							--	07
	mpb.descripcion									descripcion									,							--	08
	mpb.cod_barras									cod_barras									,							--	09
	mpb.clas_fis	 									clas_fis										,							--	10
	det.cant_ped										piezas_surtidas_con_cargo		,							--	11
	det.cant_ped  									piezas_surtidas_sin_cargo		,							--	12
	CONVERT(MONEY,det.prec_farm)		precio_farm_sin_imp					,							--	13
	CONVERT(MONEY,det.prec_pub )		precio_pub_sin_imp					,							--	14
	CONVERT(MONEY,0)								precio_pub_con_imp					,							--	15
	CONVERT(MONEY,0)								importe_bruto								,							--	16
	CONVERT(MONEY,0)								porcentaje_descto_oferta		,							--	17
	CONVERT(MONEY,0)								descto_oferta								,							--	18
	CONVERT(MONEY,0)								porcentaje_descto_comercial	,							--	19
	CONVERT(MONEY,0)								descto_comercial						,							--	20
	CONVERT(MONEY,0)								ieps												,							--	21
	CONVERT(MONEY,0)								iva													,							--	22
	CONVERT(MONEY,0)								bonificacion_iva						,							--	23
	CONVERT(MONEY,0)								porcentaje_utilidad					,							--	24
	CONVERT(MONEY,0)								importe_neto								,							--	25
	left(e.orden, 10)													orden												,							--	26
	CONVERT(MONEY,0)								porcentaje_iva							,							--	27
	REPLICATE(' ', 5)								filler											,							--	28
	0																no_registro									,							--	29
	CONVERT(MONEY,0)								desc_comerc_prod						,							--	30
	CONVERT(MONEY,0)								porcentaje_iva2							,							--	31
	CONVERT(MONEY,0)								iva2												,							--	32
	CONVERT(MONEY,0)								bonificacion_iva2						,							--	33
	CONVERT(MONEY,0)								porcentaje_ieps							,							--	34
	CONVERT(MONEY,0)								desc_comerc_ieps						,							--	35
	CONVERT(MONEY,0)								iva_del_iesps								,							--	36
	CONVERT(MONEY,0)								bonificacion_iva_del_iesps	,							--	37
	det.timestamp										TIMESTAMP										,							--	38
	e.segto													segto												,							--	39
	e.ctepadre											ctepadre										,							--	40
	cb.rfc													rfc													,							--	41
	'N'															tipo_documento							,							--	42
	e.folio_fiscal									folio_fiscal								,							--	43
	e.fecha_tandem									fecha_tandem															--	44	
	
FROM encabezado e	WITH (NOLOCK)
INNER JOIN sucursales s 							WITH (NOLOCK)	ON s.almacen = @almacen AND s.sucursal = e.sucursal
INNER JOIN detalle det								WITH (NOLOCK)	ON det.sucursal = e.sucursal AND det.factura = e.factura	 
--INNER JOIN lab_sanofi_detalle det								WITH (NOLOCK)	ON det.sucursal = e.sucursal AND det.factura = e.factura	 
--INNER JOIN maestro_productos_baan mpb WITH (NOLOCK)	ON mpb.lab_corto = 'SANOFI' AND SUBSTRING(det.codigos,3,7) = mpb.codigo
INNER JOIN lab_sanofi_cat_productos mpb WITH (NOLOCK)	ON SUBSTRING(det.codigos,3,7) = mpb.codigo
INNER JOIN clientes_baan cb ON cb.sucursal = e.sucursal AND cb.cliente = e.cliente
WHERE e.fechaprog --= CONVERT(SMALLDATETIME,@fecha,121) 
BETWEEN	CONVERT(DATETIME,DATEADD(DD,  -7, CONVERT(DATETIME, @fecha,121) ),121 )
		AND CONVERT(DATETIME,DATEADD(DD,  -1, CONVERT(DATETIME, @fecha,121) ),121 )

	AND det.dest_det IN ('FEP', 'FEA')
	AND ISNUMERIC( LTRIM(RTRIM(e.factura) ) ) = 1
	--AND e.sucursal = @almacen
ORDER BY e.fechaprog, e.sucursal, e.factura



SELECT * 
INTO #facturas_sanofi
FROM #facturas_sanofi_surtido
UNION ALL
SELECT * 
FROM #facturas_sanofi_negado

CREATE INDEX idx_tmp_fe_sanofi ON #facturas_sanofi (sucursal,	cliente, factura, codigo)

--	POBLA LA LISTA DE FACTURAS DE LA sucursal, CLIENTE Y FACTURA
INSERT INTO #facturas	(fecha_factura, fecha_compromiso, sucursal, cliente, factura)
	SELECT DISTINCT fecha_factura, DATEADD(DD, 1, fecha_factura), sucursal, cliente, factura 
	FROM #facturas_sanofi
	--GROUP BY sucursal, cliente, factura
	ORDER BY sucursal, cliente, factura

CREATE INDEX idx_tmp_facturas_sanofi ON #facturas (sucursal,	cliente, factura)

DECLARE @row INT
SET @row = 1
DECLARE @fecha_factura			DATE
DECLARE @fecha_compromiso		DATE
DECLARE @cliente						VARCHAR(5)
DECLARE @sucursal						INT
DECLARE @factura						VARCHAR(10)
DECLARE @impuestos					MONEY
DECLARE @descuentos					MONEY
DECLARE @Monto_Total				MONEY
DECLARE @documentos					INT
DECLARE @orden							VARCHAR(10)
SET @documentos		=		( SELECT COUNT(*) FROM #facturas )


--CREATE TABLE #resultados	(
--	col1	VARCHAR(1000)
--)

WHILE @row <= @documentos
BEGIN
	SET @fecha							= ( SELECT fecha_factura		FROM #facturas WHERE id_recno = @row	)
	SET @fecha_compromiso		= ( SELECT fecha_compromiso	FROM #facturas WHERE id_recno = @row	)
	SET @cliente						= ( SELECT cliente					FROM #facturas WHERE id_recno = @row	)
	SET @factura						=	( SELECT factura					FROM #facturas WHERE id_recno = @row	)
	SET @sucursal						=	( SELECT sucursal					FROM #facturas WHERE id_recno = @row	)

	SELECT * INTO #corriente FROM #facturas_sanofi f
	WHERE f.sucursal = @sucursal AND f.cliente = @cliente AND f.factura = @factura

	SET @orden				=	( SELECT TOP 1 orden														FROM #corriente)
	SET @descuentos		= ( SELECT ISNULL(SUM(descto_oferta + descto_comercial)	,0)	FROM #corriente)
	SET @Monto_Total	= ( SELECT ISNULL(SUM(importe_bruto)										,0)		FROM #corriente)
	SET @impuestos		= ( SELECT ISNULL(SUM(iva + ieps)												,0)	FROM #corriente)

--	INSERTA 

--	INSERTA LOS ENCABEZADOS DESDE LA LISTA DE #facturas
	INSERT INTO #Invoice
	SELECT
		@row																												,
		@sucursal																										,
		@cliente																										,
		@factura																										,
		CONVERT(DATE,@fecha,121)						Fecha_Factura						,
		CONVERT(DATE,@fecha_compromiso,121)	Fecha_compromiso				,
		@Monto_Total												Monto_Total							,
		@Monto_Total												Balance									,
		@impuestos													Impuesto								,
		@descuentos													DescuentoTotalSanofi		,
		@descuentos													DescuentoTotalMayorista	,
		0																		Cargo_Embarques					,	
		@cliente														Codigo_cliente_mayorista,	
		@factura														Numero_Factura					,	
		@orden															Numero_orden_mayorista
	
	DROP TABLE #corriente
	SET @row = @row + 1
END

SELECT 
	CONVERT(VARCHAR(10),f.fecha_factura			,121) 											Fecha_Factura							,
	CONVERT(VARCHAR(10),f.fecha_compromiso	,121)												Fecha_compromiso					,
	f.Monto_Total																												Monto_Total								,
	f.Balance																														Balance										,
	f.Impuesto																													Impuesto									,
	f.DescuentoTotalSanofi																							DescuentoTotalSanofi			,
	f.DescuentoTotalMayorista																						DescuentoTotalMayorista		,
	f.Cargo_Embarques																										Cargo_Embarques						,
	f.Codigo_cliente_mayorista																					Codigo_cliente_mayorista	,
	f.Numero_Factura																										Numero_Factura						,
	f.Numero_orden_mayorista																						Numero_orden_mayorista		,
	RIGHT(REPLICATE('0', 2) + CONVERT(VARCHAR,f.sucursal), 2)	sucursal
FROM #Invoice f
ORDER BY f.Fecha_Factura, f.sucursal, f.Numero_Factura


DROP TABLE #Invoice

DROP TABLE #facturas_sanofi

DROP TABLE #facturas

GO

