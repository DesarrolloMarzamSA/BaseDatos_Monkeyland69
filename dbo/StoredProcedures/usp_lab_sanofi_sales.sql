
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE 
--CREATE 
PROCEDURE [dbo].[usp_lab_sanofi_sales]
@almacen INT, @fecha VARCHAR(10)
/*
usp_lab_sanofi_sales  5, '2011-02-11'
*/
WITH ENCRYPTION
AS

--	DECLARE @fecha VARCHAR(10)
--	SET @fecha = '2010-01-06'
--	DECLARE @almacen INT
--	SET @almacen = 1

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
--	PRIMARY KEY (sucursal, cliente, factura)
)

--	TABLA PARA POBLAR LA LISTA DE FACTURAS DEL DIA Y SUCURSAL
CREATE TABLE #facturas	(
	id_recno						INT IDENTITY,
	sucursal						INT,
	cliente							VARCHAR(5),
	factura							VARCHAR(10)	
--	PRIMARY KEY (sucursal, cliente, factura)
)

--	TABLA PARA GENERAR EL DETALLE EN BASE A LA TABLA #facturas
CREATE TABLE #items		(
	sucursal						INT,
	cliente							VARCHAR(5),
	factura							INT,
	SKU									VARCHAR(120),
	Descripcion					VARCHAR(240),
	Quantity						INT,
	UnitPrice						MONEY,
	InvoiceLineNumber		INT,
	FinalUnitPrice			MONEY,
	SanofiDiscount			MONEY,
	WholesalerDiscount	MONEY,
	FreeQuantity				INT
--	PRIMARY KEY (sucursal, cliente, factura)
)

--	TABLA PARA POBLAR LOS DOMICILIOS A PARTIR DE LA TABLA #corriente
CREATE TABLE #domicilios	(
	sucursal					INT,
	cliente						VARCHAR(5),
	factura						VARCHAR(10),
	CompanyName				VARCHAR(120),
	FirstName					VARCHAR(120),
	LastName					VARCHAR(120),  
	Address1					VARCHAR(120),
	Address2					VARCHAR(120),
	Address3					VARCHAR(120),
	City							VARCHAR(120),
	Postal_Code				VARCHAR(120),
	State							VARCHAR(120),
	Country						VARCHAR(120)
--	PRIMARY KEY (sucursal, cliente, factura)
)


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
	F.folio_fiscal 
INTO #facturas_sanofi
FROM facturacion_electronica_estandar f	WITH (NOLOCK)
INNER JOIN sucursales s									WITH (NOLOCK)	ON s.almacen = @almacen AND s.sucursal = f.sucursal
INNER JOIN lab_sanofi_cat_productos mpb	WITH (NOLOCK)	ON /*mpb.lab_corto = 'SANOFI' AND mpb.cod_barras IS NOT NULL 
	AND */
	mpb.codigo = f.codigo
WHERE f.fecha_tandem = CONVERT(DATETIME,@fecha,121)
AND ISNUMERIC( LTRIM(RTRIM(factura) ) ) = 1
--	and f.sucursal = @almacen
--	and segto = 'E1' and ctepadre = '041'

CREATE INDEX idx_fe_sanofi ON #facturas_sanofi (sucursal, factura)

--	POBLA LA LISTA DE FACTURAS DE LA SUCURSAL, CLIENTE Y FACTURA
INSERT INTO #facturas	(sucursal, cliente, factura)
	SELECT sucursal, cliente, factura 
	FROM #facturas_sanofi
	GROUP BY sucursal, cliente, factura
	ORDER BY sucursal, cliente, factura

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

CREATE TABLE #resultados	(
	col1	VARCHAR(1000)
)

WHILE @row <= @documentos
BEGIN
	SET @cliente			= ( SELECT cliente	FROM #facturas WHERE id_recno = @row	)
	SET @factura			=	( SELECT factura	FROM #facturas WHERE id_recno = @row	)
	SET @almacen			=	( SELECT sucursal	FROM #facturas WHERE id_recno = @row	)

	SELECT * INTO #corriente FROM #facturas_sanofi f
	WHERE f.sucursal = @almacen AND f.cliente = @cliente AND f.factura = @factura

	SET @orden				=	( SELECT TOP 1 orden														FROM #corriente)
	SET @descuentos		= ( SELECT SUM(descto_oferta + descto_comercial)	FROM #corriente)
	SET @TotalAmount	= ( SELECT SUM(importe_bruto)											FROM #corriente)
	SET @impuestos		= ( SELECT SUM(iva + ieps)												FROM #corriente)

--	INSERTA 

--	INSERTA LOS ENCABEZADOS DESDE LA LISTA DE #facturas
	INSERT INTO #Invoice
	SELECT
		@row,
		@almacen																						,	
		@cliente																						,	
		@factura																						,	
		CONVERT(DATETIME,@fecha,121)	InvoiceDate						,	
		CONVERT(DATETIME,@fecha,121)	DueDate								,	
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
	INSERT INTO #items
	SELECT 
		cr.sucursal																						,
		cr.cliente																						,
		cr.factura										                        ,
		cr.Codigo												SKU									  ,
		cr.Descripcion										                    ,
		cr.piezas_surtidas_con_cargo		Quantity						  ,
		cr.precio_farm_sin_imp					UnitPrice						  ,
		cr.no_registro									InvoiceLineNumber		  ,
		cr.importe_bruto								FinalUnitPrice			  ,
		cr.desc_comerc_prod							SanofiDiscount			  ,
		cr.descto_comercial							WholesalerDiscount	  ,
		cr.piezas_surtidas_sin_cargo		FreeQuantity				
	FROM #corriente cr


	DROP TABLE #corriente

	--	POBLA LOS DOMICILIOS 3 VECES
	SET @contador = 0
	WHILE @contador < 3
	BEGIN
		INSERT INTO #domicilios
			SELECT
				@almacen,
				@cliente,
				@factura,
				cb.farmacia,
				'',
				'',
				cb.direccion,
				cb.colonia,
				REPLACE(cb.poblacion,',','') poblacion1,
				REPLACE(cb.poblacion,',','') poblacion2,		
				cb.codigo_postal,
				RTRIM(LTRIM(es.sanofi)),
				'MX'
			FROM clientes_baan cb
			INNER JOIN estados es ON cb.cve_estado = es.cve_estado
			WHERE cb.sucursal = @almacen AND cb.cliente = @cliente
		SET @contador = @contador + 1
	END

	INSERT INTO #resultados
	SELECT
--		RTRIM(CONVERT(VARCHAR,i.sucursal										)				)	+ @sep +
--		RTRIM(i.cliente																							)	+ @sep +
--		RTRIM(i.factura																							)	+ @sep +
		RTRIM(CONVERT(VARCHAR(10),i.InvoiceDate,121)								)	+ @sep +
		RTRIM(CONVERT(VARCHAR(10),i.DueDate,121)										)	+ @sep +
		RTRIM(CONVERT(VARCHAR,i.TotalAmount													))	+ @sep +
		RTRIM(CONVERT(VARCHAR,i.Balance															))	+ @sep +
		RTRIM(CONVERT(VARCHAR,i.Tax																	))	+ @sep +
		RTRIM(CONVERT(VARCHAR,i.SanofiOrderTotalDiscount						))	+ @sep +
		RTRIM(CONVERT(VARCHAR,i.WholesalerOrderTotalDiscount				))	+ @sep +
		RTRIM(CONVERT(VARCHAR,i.ShippingCharges											))	+ @sep +
		RTRIM(CONVERT(VARCHAR,i.WholesalerCustomerCode							))	+ @sep +
		RTRIM(CONVERT(VARCHAR,i.InvoiceNumber												))	+ @sep +
		RTRIM(CONVERT(VARCHAR,i.WholesalerOrderNumber								))	+ @sep +
		RTRIM(i.CurrencyCode																				)	--,
	FROM #invoice i WHERE renglon = @row
	
	INSERT INTO #resultados
	SELECT
		RTRIM(d.CompanyName)																		+ @sep +
		RTRIM(d.FirstName)																			+ @sep +
		RTRIM(d.LastName)																				+ @sep +  
		RTRIM(d.Address1)																				+ @sep +
		RTRIM(d.Address2)																				+ @sep +
		RTRIM(d.Address3)																				+ @sep +
		RTRIM(d.City)																						+ @sep +
		RTRIM(d.State)																					+ @sep +
		RTRIM(d.Postal_Code)																		+ @sep +
		RTRIM(d.Country)
	FROM #domicilios d 
	WHERE d.sucursal = @almacen AND d.cliente = @cliente AND d.factura = @factura

	INSERT INTO #resultados
	SELECT 
		RTRIM(i.SKU																	)	+ @sep + 
		RTRIM(i.Descripcion													)	+ @sep + 
		RTRIM(CONVERT(VARCHAR,i.Quantity						))	+ @sep + 
		RTRIM(CONVERT(VARCHAR,i.UnitPrice						))	+ @sep + 
		RTRIM(CONVERT(VARCHAR,i.InvoiceLineNumber		))	+ @sep + 
		RTRIM(CONVERT(VARCHAR,i.FinalUnitPrice			))	+ @sep + 
		RTRIM(CONVERT(VARCHAR,i.SanofiDiscount			))	+ @sep + 
		RTRIM(CONVERT(VARCHAR,i.WholesalerDiscount	))	+ @sep + 
		RTRIM(CONVERT(VARCHAR,i.FreeQuantity				))	
	FROM #items i
	WHERE i.sucursal = @almacen AND i.cliente = @cliente AND i.factura = @factura

	SET @row = @row + 1
END

--	SELECT * FROM #facturas_sanofi
--	SELECT * FROM #facturas
--	SELECT * FROM #invoice
--	SELECT * FROM #items
--	SELECT * FROM #domicilios

SELECT * FROM #resultados



DROP TABLE #domicilios
DROP TABLE #Invoice
DROP TABLE #facturas
DROP TABLE #facturas_sanofi
DROP TABLE #items
DROP TABLE #resultados
GO
