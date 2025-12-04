CREATE 
--	CREATE 
PROCEDURE usp_lab_sanofi_address 
@almacen INT, @fecha VARCHAR(10)

--	HECHO POR MIGUEL SAMAYOA
--	2010-02-08	FECHA DE CREACION
/*
usp_lab_sanofi_address 1, '2012-02-20'
*/


AS
/*
DECLARE @fecha VARCHAR(10)
SET @fecha = '2010-03-31'
DECLARE @almacen INT
SET @almacen = 1
*/

DECLARE @SEP VARCHAR(10)
SET @SEP = '|'
DECLARE @contador INT

CREATE TABLE #Invoice	(	--	ENCABEZADO
	renglon													INT,
	sucursal												INT,
	cliente													VARCHAR(5),
	factura													VARCHAR(10),
	InvoiceDate											SMALLDATETIME,
	DueDate													SMALLDATETIME,
	TotalAmount											MONEY,
	Balance													MONEY,
	Tax															MONEY,
	SanofiOrderTotalDiscount				MONEY,
	WholesalerOrderTotalDiscount		MONEY,
	ShippingCharges									MONEY,
	WholesalerCustomerCode					VARCHAR(90),
	InvoiceNumber										VARCHAR(60),
	WholesalerOrderNumber						VARCHAR(60),
	CurrencyCode										VARCHAR(60)	
	PRIMARY KEY (sucursal, cliente, factura)
)

--	TABLA PARA POBLAR LA LISTA DE FACTURAS DEL DIA Y SUCURSAL
CREATE TABLE #facturas	(
	id_recno						INT IDENTITY,
	sucursal						INT,
	cliente							VARCHAR(5),
	factura							VARCHAR(10)	
	PRIMARY KEY (sucursal, cliente, factura)
)

--	TABLA PARA GENERAR EL DETALLE EN BASE A LA TABLA #facturas
--CREATE TABLE #items		(
--	sucursal						INT							,
--	cliente							VARCHAR(5)			,
--	factura							INT							,
--	SKU									VARCHAR(120)		,
--	Descripcion					VARCHAR(240)		,
--	Quantity						INT							,
--	UnitPrice						MONEY						,
--	InvoiceLineNumber		INT							,
--	FinalUnitPrice			MONEY						,
--	SanofiDiscount			MONEY						,
--	WholesalerDiscount	MONEY						,
--	FreeQuantity				INT
--	PRIMARY KEY (sucursal, cliente, factura, SKU, Quantity)
--)

--	TABLA PARA POBLAR LOS DOMICILIOS A PARTIR DE LA TABLA #corriente
CREATE TABLE #domicilios	(
	sucursal					INT						,
	cliente						VARCHAR(5)		,
	factura						VARCHAR(10)		,
	CompanyName				VARCHAR(120)	,
	FirstName					VARCHAR(120)	,
	LastName					VARCHAR(120)	,  
	Address1					VARCHAR(120)	,
	Address2					VARCHAR(120)	,
	Address3					VARCHAR(120)	,
	City							VARCHAR(120)	,
	Postal_Code				VARCHAR(120)	,
	State							VARCHAR(120)	,
	Country						VARCHAR(120)	
--	PRIMARY KEY (sucursal, cliente, factura)
)

CREATE INDEX idx_domicilios on #domicilios (sucursal, cliente, factura)

CREATE					--	DROP	--	TRUNCATE	
TABLE	#facturas_sanofi_surtido	(
	sucursal													TINYINT					NOT	NULL,
	cliente														VARCHAR(5)			NOT	NULL,
	digito_verificador								VARCHAR(1)			NULL,
	serie															VARCHAR(1)			NULL,
	factura														VARCHAR(8)			NOT	NULL,
	fecha_factura											DATETIME				NULL,
	codigo														VARCHAR(7)			NOT	NULL,
	descripcion												VARCHAR(40)			NULL,
	cod_barras												VARCHAR(13)			NULL,
	clas_fis													VARCHAR(2)			NULL,
	piezas_surtidas_con_cargo					INT							NULL,
	piezas_surtidas_sin_cargo					INT							NULL,
	precio_farm_sin_imp								MONEY						NULL,
	precio_pub_sin_imp								MONEY						NULL,
	precio_pub_con_imp								MONEY						NULL,
	importe_bruto											MONEY						NULL,
	porcentaje_descto_oferta					MONEY						NULL,
	descto_oferta											MONEY						NULL,
	porcentaje_descto_comercial				MONEY						NULL,
	descto_comercial									MONEY						NULL,
	ieps															MONEY						NULL,
	iva																MONEY						NULL,
	bonificacion_iva									MONEY						NULL,
	porcentaje_utilidad								MONEY						NULL,
	importe_neto											MONEY						NULL,
	orden															VARCHAR(10)			NULL,
	porcentaje_iva										MONEY						NULL,
	filler														VARCHAR(5)			NULL,
	no_registro												INT							NULL,
	desc_comerc_prod									MONEY						NULL,
	porcentaje_iva2										MONEY						NULL,
	iva2															MONEY						NULL,
	bonificacion_iva2									MONEY						NULL,
	porcentaje_ieps										MONEY						NULL,
	desc_comerc_ieps									MONEY						NULL,
	iva_del_iesps											MONEY						NULL,
	bonificacion_iva_del_iesps				MONEY						NULL,
	timestamp													DATETIME				NULL,
	segto															CHAR(2)					NULL,
	ctepadre													CHAR(3)					NULL,
	rfc																CHAR(13)				NULL,
	tipo_documento										VARCHAR(1)			NULL,
	folio_fiscal											VARCHAR(8)			NULL,
	fecha_tandem											SMALLDATETIME		NULL,
PRIMARY					KEY			(	sucursal	ASC,	cliente	ASC,	factura	ASC,	codigo	ASC)
)

CREATE					--	DROP	--	TRUNCATE	
TABLE	#facturas_sanofi_negado	(
	sucursal													TINYINT					NOT	NULL,
	cliente														VARCHAR(5)			NOT	NULL,
	digito_verificador								VARCHAR(1)			NULL,
	serie															VARCHAR(1)			NULL,
	factura														VARCHAR(8)			NOT	NULL,
	fecha_factura											DATETIME				NULL,
	codigo														VARCHAR(7)			NOT	NULL,
	descripcion												VARCHAR(40)			NULL,
	cod_barras												VARCHAR(13)			NULL,
	clas_fis													VARCHAR(2)			NULL,
	piezas_surtidas_con_cargo					INT							NULL,
	piezas_surtidas_sin_cargo					INT							NULL,
	precio_farm_sin_imp								MONEY						NULL,
	precio_pub_sin_imp								MONEY						NULL,
	precio_pub_con_imp								MONEY						NULL,
	importe_bruto											MONEY						NULL,
	porcentaje_descto_oferta					MONEY						NULL,
	descto_oferta											MONEY						NULL,
	porcentaje_descto_comercial				MONEY						NULL,
	descto_comercial									MONEY						NULL,
	ieps															MONEY						NULL,
	iva																MONEY						NULL,
	bonificacion_iva									MONEY						NULL,
	porcentaje_utilidad								MONEY						NULL,
	importe_neto											MONEY						NULL,
	orden															VARCHAR(10)			NULL,
	porcentaje_iva										MONEY						NULL,
	filler														VARCHAR(5)			NULL,
	no_registro												INT							NULL,
	desc_comerc_prod									MONEY						NULL,
	porcentaje_iva2										MONEY						NULL,
	iva2															MONEY						NULL,
	bonificacion_iva2									MONEY						NULL,
	porcentaje_ieps										MONEY						NULL,
	desc_comerc_ieps									MONEY						NULL,
	iva_del_iesps											MONEY						NULL,
	bonificacion_iva_del_iesps				MONEY						NULL,
	timestamp													DATETIME				NULL,
	segto															CHAR(2)					NULL,
	ctepadre													CHAR(3)					NULL,
	rfc																CHAR(13)				NULL,
	tipo_documento										VARCHAR(1)			NULL,
	folio_fiscal											VARCHAR(8)			NULL,
	fecha_tandem											SMALLDATETIME		NULL,
PRIMARY					KEY			(	sucursal	ASC,	cliente	ASC,	factura	ASC,	codigo	ASC)
)

INSERT INTO #facturas_sanofi_surtido
SELECT 	--	TOP 50
	F.sucursal,
	F.cliente,
	F.digito_verificador,
	F.serie,
	F.factura,
	F.fecha_factura,
	F.codigo,
	F.descripcion,
	F.cod_barras,
	F.clas_fis,
	F.piezas_surtidas_con_cargo,
	F.piezas_surtidas_sin_cargo,
	F.precio_farm_sin_imp,
	F.precio_pub_sin_imp,
	F.precio_pub_con_imp,
	F.importe_bruto,
	F.porcentaje_descto_oferta,
	F.descto_oferta,
	F.porcentaje_descto_comercial,
	F.descto_comercial,
	F.ieps,
	F.iva,
	F.bonificacion_iva,
	F.porcentaje_utilidad,
	F.importe_neto,
	F.orden,
	F.porcentaje_iva,
	F.filler,
	F.no_registro,
	F.desc_comerc_prod,
	F.porcentaje_iva2,
	F.iva2,
	F.bonificacion_iva2,
	F.porcentaje_ieps,
	F.desc_comerc_ieps,
	F.iva_del_iesps,
	F.bonificacion_iva_del_iesps,
	F.TIMESTAMP,
	F.segto,
	F.ctepadre,
	F.rfc,
	F.tipo_documento,
	F.folio_fiscal			,
	F.fecha_tandem												--	44
FROM facturacion_electronica_estandar f									WITH (NOLOCK)
--FROM lab_sanofi_fes f			WITH (NOLOCK)
INNER JOIN sucursales s											WITH (NOLOCK)	ON s.almacen = @almacen AND s.sucursal = f.sucursal
INNER JOIN lab_sanofi_cat_productos mpb					WITH (NOLOCK)	ON mpb.codigo = f.codigo
WHERE f.fecha_factura --= CONVERT(DATETIME,@fecha,121)
BETWEEN	CONVERT(DATETIME,DATEADD(DD,  -7, CONVERT(DATETIME, @fecha,121) ),121 )
		AND CONVERT(DATETIME,DATEADD(DD,  -1, CONVERT(DATETIME, @fecha,121) ),121 )
AND ISNUMERIC( LTRIM(RTRIM(factura) ) ) = 1
--and f.sucursal = @almacen

INSERT INTO #facturas_sanofi_negado
SELECT 
	e.sucursal   										sucursal										,
	e.cliente	 											cliente											,
	'0'				 											digito_verificador					,
	'0'			  											serie												,
	e.factura    										factura											,
	e.fechaprog											fecha_factura								,
	mpb.codigo 											codigo											,
	mpb.descripcion									descripcion									,
	mpb.cod_barras									cod_barras									,
	mpb.clas_fis	 									clas_fis										,
	det.cant_ped										piezas_surtidas_con_cargo		,
	det.cant_ped  									piezas_surtidas_sin_cargo		,
	CONVERT(MONEY,det.prec_farm)		precio_farm_sin_imp					,
	CONVERT(MONEY,det.prec_pub )		precio_pub_sin_imp					,
	CONVERT(MONEY,0)								precio_pub_con_imp					,
	CONVERT(MONEY,0)								importe_bruto								,
	CONVERT(MONEY,0)								porcentaje_descto_oferta		,
	CONVERT(MONEY,0)								descto_oferta								,
	CONVERT(MONEY,0)								porcentaje_descto_comercial	,
	CONVERT(MONEY,0)								descto_comercial						,
	CONVERT(MONEY,0)								ieps												,
	CONVERT(MONEY,0)								iva													,
	CONVERT(MONEY,0)								bonificacion_iva						,
	CONVERT(MONEY,0)								porcentaje_utilidad					,
	CONVERT(MONEY,0)								importe_neto								,
	left(e.orden, 10)													orden												,
	CONVERT(MONEY,0)								porcentaje_iva							,
	REPLICATE(' ', 5)								filler											,
	0																no_registro									,
	CONVERT(MONEY,0)								desc_comerc_prod						,
	CONVERT(MONEY,0)								porcentaje_iva2							,
	CONVERT(MONEY,0)								iva2												,
	CONVERT(MONEY,0)								bonificacion_iva2						,
	CONVERT(MONEY,0)								porcentaje_ieps							,
	CONVERT(MONEY,0)								desc_comerc_ieps						,
	CONVERT(MONEY,0)								iva_del_iesps								,
	CONVERT(MONEY,0)								bonificacion_iva_del_iesps	,
	det.timestamp										TIMESTAMP										,
	e.segto													segto												,
	e.ctepadre											ctepadre										,
	cb.rfc													rfc													,
	'N'															tipo_documento							,
	e.folio_fiscal									folio_fiscal								,
	e.fecha_tandem									fecha_tandem								
FROM encabezado e											WITH (NOLOCK)
INNER JOIN sucursales s 							WITH (NOLOCK)	ON s.almacen = @almacen AND s.sucursal = e.sucursal
INNER JOIN detalle det								WITH (NOLOCK)	ON det.sucursal = e.sucursal AND det.factura = e.factura	 
--INNER JOIN lab_sanofi_detalle det			WITH (NOLOCK)	ON det.sucursal = e.sucursal AND det.factura = e.factura	 
--INNER JOIN maestro_productos_baan mpb WITH (NOLOCK)	ON mpb.lab_corto = 'SANOFI' AND mpb.codigo = SUBSTRING(det.codigos,3,7)
INNER JOIN lab_sanofi_cat_productos mpb WITH (NOLOCK)	ON mpb.codigo = SUBSTRING(det.codigos,3,7)
INNER JOIN clientes_baan cb ON cb.sucursal = e.sucursal AND cb.cliente = e.cliente
WHERE e.fechaprog --= CONVERT(DATETIME,@fecha,121) 
BETWEEN	CONVERT(DATETIME,DATEADD(DD,  -7, CONVERT(DATETIME, @fecha,121) ),121 )
		AND CONVERT(DATETIME,DATEADD(DD,  -1, CONVERT(DATETIME, @fecha,121) ),121 )
	AND det.dest_det IN ('FEP', 'FEA')
	AND ISNUMERIC( LTRIM(RTRIM(e.factura) ) ) = 1
	--AND e.sucursal = @almacen


SELECT * 
INTO #facturas_sanofi
FROM #facturas_sanofi_surtido
UNION ALL
SELECT * 
FROM #facturas_sanofi_negado

CREATE INDEX idx_tmp_fe_sanofi ON #facturas_sanofi (sucursal,	cliente, factura, codigo)

--	POBLA LA LISTA DE FACTURAS DE LA SUCURSAL, CLIENTE Y FACTURA
INSERT INTO #facturas	(sucursal, cliente, factura)
	SELECT DISTINCT sucursal, cliente, factura 
	FROM #facturas_sanofi
	--GROUP BY sucursal, cliente, factura
	--ORDER BY sucursal, cliente, factura

CREATE INDEX idx_tmp_facturas_sanofi ON #facturas (sucursal,	cliente, factura)

DECLARE @row INT
SET @row = 1
DECLARE @cliente			VARCHAR(5)
DECLARE @sucursal			INT
DECLARE @factura			VARCHAR(10)
DECLARE @impuestos		MONEY
DECLARE @descuentos		MONEY
DECLARE @TotalAmount	MONEY
DECLARE @documentos		INT
DECLARE @orden				VARCHAR(10)
SET @documentos		=		( SELECT COUNT(*) FROM #facturas )

/*
CREATE TABLE #resultados	(
	sucursal					INT				,
	cliente						VARCHAR(5),
	factura						VARCHAR(8),
	col1	VARCHAR(1000)
	PRIMARY KEY (sucursal, cliente, factura)
)
*/

WHILE @row <= @documentos
BEGIN
	SET @cliente			= ( SELECT cliente	FROM #facturas WHERE id_recno = @row	)
	SET @factura			=	( SELECT factura	FROM #facturas WHERE id_recno = @row	)
	SET @sucursal			=	( SELECT sucursal	FROM #facturas WHERE id_recno = @row	)

	SELECT * INTO #corriente FROM #facturas_sanofi f
	WHERE f.sucursal = @sucursal AND f.cliente = @cliente AND f.factura = @factura

	SET @orden				=	( SELECT TOP 1 orden														FROM #corriente)
	SET @descuentos		= ( SELECT SUM(descto_oferta + descto_comercial)	FROM #corriente)
	SET @TotalAmount	= ( SELECT SUM(importe_bruto)											FROM #corriente)
	SET @impuestos		= ( SELECT SUM(iva + ieps)												FROM #corriente)

--	INSERTA 

--	INSERTA LOS ENCABEZADOS DESDE LA LISTA DE #facturas
	INSERT INTO #Invoice
	SELECT
		@row,
		@sucursal																						,	
		@cliente																						,	
		@factura																						,	
		CONVERT(DATETIME,@fecha,121)		InvoiceDate										,	
		CONVERT(DATETIME,@fecha,121)		DueDate												,	
		@TotalAmount					TotalAmount										,	
		@TotalAmount					Balance												,	
		@impuestos						Tax														,		
		@descuentos						SanofiOrderTotalDiscount			,	
		@descuentos						WholesalerOrderTotalDiscount	,	
		0 ShippingCharges																		,	
		@cliente							WholesalerCustomerCode				,	
		@factura							InvoiceNumber									,	
		@orden								WholesalerOrderNumber					,	
		'MXN' CurrencyCode					
	

--	POBLA LOS DETALLES
	--INSERT INTO #items
	--SELECT 
	--	cr.sucursal																						,
	--	cr.cliente																						,
	--	cr.factura										                        ,
	--	cr.Codigo												SKU									  ,
	--	cr.Descripcion										                    ,
	--	cr.piezas_surtidas_con_cargo		Quantity						  ,
	--	cr.precio_farm_sin_imp					UnitPrice						  ,
	--	cr.no_registro									InvoiceLineNumber		  ,
	--	cr.importe_bruto								FinalUnitPrice			  ,
	--	cr.desc_comerc_prod							SanofiDiscount			  ,
	--	cr.descto_comercial							WholesalerDiscount	  ,
	--	cr.piezas_surtidas_sin_cargo		FreeQuantity				
	--FROM #corriente cr


	DROP TABLE #corriente

	--	POBLA LOS DOMICILIOS 3 VECES
	SET @contador = 0
	WHILE @contador < 3
	BEGIN
		INSERT INTO #domicilios
			SELECT
				@sucursal,
				@cliente,
				@factura,
				cb.farmacia,
				'',
				'',
				cb.direccion,
				cb.colonia,
				REPLACE(cb.poblacion,',','') poblacion1,
				'',	--	cb.poblacion,		
				cb.codigo_postal,
				RTRIM(LTRIM(es.sanofi)),
				'MX'
			FROM clientes_baan cb	WITH (NOLOCK)
			INNER JOIN estados es WITH (NOLOCK)	ON cb.cve_estado = es.cve_estado
			WHERE cb.sucursal = @sucursal AND cb.cliente = @cliente
		SET @contador = @contador + 1
	END

--	SELECT
----		RTRIM(CONVERT(VARCHAR,i.sucursal										)				)	,
----		RTRIM(i.cliente																							)	,
----		RTRIM(i.factura																							)	,
--		RTRIM(CONVERT(VARCHAR(10),i.InvoiceDate,121)								)	,
--		RTRIM(CONVERT(VARCHAR(10),i.DueDate,121)										)	,
--		RTRIM(CONVERT(VARCHAR,i.TotalAmount													))	,
--		RTRIM(CONVERT(VARCHAR,i.Balance															))	,
--		RTRIM(CONVERT(VARCHAR,i.Tax																	))	,
--		RTRIM(CONVERT(VARCHAR,i.SanofiOrderTotalDiscount						))	,
--		RTRIM(CONVERT(VARCHAR,i.WholesalerOrderTotalDiscount				))	,
--		RTRIM(CONVERT(VARCHAR,i.ShippingCharges											))	,
--		RTRIM(CONVERT(VARCHAR,i.WholesalerCustomerCode							))	 ,
--		RTRIM(CONVERT(VARCHAR,i.InvoiceNumber												))	 ,
--		RTRIM(CONVERT(VARCHAR,i.WholesalerOrderNumber								))	 ,
--		RTRIM(i.CurrencyCode																				)		
--	FROM #invoice i WHERE renglon = @row
	
	--SELECT
	--	CONVERT(VARCHAR,cliente)																,
	--	RTRIM(d.CompanyName)																		,
	--	RTRIM(d.FirstName)																			,
	--	RTRIM(d.LastName)																				,
	--	RTRIM(d.Address1)																				,
	--	RTRIM(d.Address2)																				,
	--	RTRIM(d.Address3)																				,
	--	RTRIM(d.City)																						,
	--	RTRIM(d.Postal_Code)																		,
	--	RTRIM(d.State)																					,
	--	RTRIM(d.Country)
	--FROM #domicilios d 
	--WHERE d.sucursal = @almacen AND d.cliente = @cliente AND d.factura = @factura

	--SELECT 
	--	RTRIM(i.SKU																	)	, 
	--	RTRIM(i.Descripcion													)	, 
	--	RTRIM(CONVERT(VARCHAR,i.Quantity						))	, 
	--	RTRIM(CONVERT(VARCHAR,i.UnitPrice						))	, 
	--	RTRIM(CONVERT(VARCHAR,i.InvoiceLineNumber		))	, 
	--	RTRIM(CONVERT(VARCHAR,i.FinalUnitPrice			))	, 
	--	RTRIM(CONVERT(VARCHAR,i.SanofiDiscount			))	, 
	--	RTRIM(CONVERT(VARCHAR,i.WholesalerDiscount	))	, 
	--	RTRIM(CONVERT(VARCHAR,i.FreeQuantity				))	
	--FROM #items i
	--WHERE i.sucursal = @almacen AND i.cliente = @cliente AND i.factura = @factura

	SET @row = @row + 1
END



--	SELECT * FROM #facturas_sanofi
--	SELECT * FROM #facturas
--	SELECT * FROM #invoice
--	SELECT * FROM #items
--	SELECT * FROM #domicilios

--	SELECT * FROM #resultados


	SELECT --	DISTINCT
--		d.sucursal	,	-------------------	APOYO
		d.factura,
		RIGHT('00'+CONVERT(VARCHAR,sucursal						),2)		+
		CONVERT(VARCHAR,cliente							)		cliente											,
		RTRIM(d.CompanyName									)		CompanyName									,
		RTRIM(d.FirstName										)		FirstName										,
		RTRIM(d.LastName										)		LastName										,
		RTRIM(d.Address1										)		Address1										,
		RTRIM(d.Address2										)		Address2										,
		RTRIM(d.Address3										)		Address3										,
		RTRIM(d.City												)		City												,
		RTRIM(d.Postal_Code									)		Postal_Code									,
		RTRIM(d.State												)		State												,
		RTRIM(d.Country)												Country
	FROM #domicilios d 
	ORDER BY sucursal, cliente
	--	WHERE d.sucursal = @almacen AND d.cliente = @cliente AND d.factura = @factura



DROP TABLE #domicilios
DROP TABLE #Invoice
DROP TABLE #facturas
DROP TABLE #facturas_sanofi
--	DROP TABLE #items
--DROP TABLE #resultados

GO

