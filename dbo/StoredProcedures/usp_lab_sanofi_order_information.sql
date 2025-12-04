USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE 
--	CREATE 
PROCEDURE [dbo].[usp_lab_sanofi_order_information]
@almacen INT, @fecha VARCHAR(10)

WITH ENCRYPTION
AS

/*
usp_lab_sanofi_order_information 1, '2011-02-28'
*/

--DECLARE @fecha VARCHAR(10)
--SET @fecha = '2010-01-06'
--DECLARE @almacen INT
--SET @almacen = 1

DECLARE @SEP VARCHAR(10)
SET @SEP = '|'
DECLARE @contador INT

/*	TABLA PARA EL ENCABEZADO	*/
CREATE TABLE #Order	(
	renglon													INT,								--	 1
	sucursal												INT,								--	 2
	cliente													VARCHAR(5),					--	 3
	factura													VARCHAR(10),				--	 4
	WholesalerOrderNumber						VARCHAR(60),				--	 5
	B2BOrderNumber									VARCHAR(60),				--	 6
	WholesalerOrderTotalDiscount		MONEY,							--	 7
	TotalAmount											MONEY,							--	 8
	DeliveryDate										SMALLDATETIME,			--	 9
	OrderNotes											VARCHAR(500),				--	10
	PaymentType											VARCHAR(120),				--	11
	PONumber												VARCHAR(50)					--	12
--	PRIMARY KEY (sucursal, cliente, factura)
)

/*	TABLA PARA POBLAR LA LISTA DE FACTURAS DEL DIA Y SUCURSAL	*/
CREATE TABLE #facturas	(
	id_recno						INT IDENTITY,
	sucursal						INT,
	cliente							VARCHAR(5),
	factura							VARCHAR(10)	
--	PRIMARY KEY (sucursal, cliente, factura)
)

/*	TABLA PARA GENERAR EL DETALLE EN BASE A LA TABLA #facturas	*/
CREATE TABLE #OrderLine		(
	sucursal						INT,													--	 1
	cliente							VARCHAR(5),										--	 2
	factura							INT,													--	 3
	B2BLineKey					VARCHAR(120),									--	 4
	SKU									VARCHAR(120),									--	 5
	Quantity						INT,													--	 6
	FreeQuantity				INT,													--	 7
	ListPrice						MONEY,												--	 8
	SellPrice						MONEY,												--	 9
	WholesalerDiscount	MONEY,												--	10
	TotalAmount					MONEY,												--	11
	DeliveryDate				SMALLDATETIME,
	RequestedDeliveryDate	SMALLDATETIME
--	PRIMARY KEY (sucursal, cliente, factura)
)

/*	TABLA PARA POBLAR LOS DOMICILIOS A PARTIR DE LA TABLA #corriente	*/
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
FROM monkeyland.dbo.facturacion_electronica_estandar f		WITH(NOLOCK)
INNER JOIN sucursales s 								WITH(NOLOCK)	ON s.almacen = @almacen AND s.sucursal = f.sucursal
INNER JOIN lab_sanofi_cat_productos mpb 	WITH(NOLOCK)	ON /*mpb.lab_corto = 'SANOFI' AND mpb.cod_barras IS NOT NULL 
	AND*/ mpb.codigo = f.codigo
WHERE f.fecha_tandem = CONVERT(DATETIME,@fecha,121)
	AND ISNUMERIC( LTRIM(RTRIM(factura) ) ) = 1
--and f.sucursal = @sucursal
--	and segto = 'E1' and ctepadre = '041'

/*	POBLA LA LISTA DE FACTURAS DE LA SUCURSAL, CLIENTE Y FACTURA	*/
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
	sucursal		INT							,
	cliente			VARCHAR(   5)		,
	factura			VARCHAR(   8)		,
	col1	VARCHAR(1000)
)

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

/*	INSERTA LOS ENCABEZADOS DESDE LA LISTA DE #facturas	*/
	INSERT INTO #Order
	SELECT
		@row																								,	--	 1
		@sucursal																						,	--	 2
		@cliente																						,	--	 3
		@factura																						,	--	 4
		@factura							WholesalerOrderNumber					,	--	 5
		@factura							B2BOrderNumber								,	--	 6
		@descuentos						WholesalerOrderTotalDiscount	,	--	 7
		@TotalAmount					TotalAmount										,	--	 8
		CONVERT(DATETIME,@fecha,121)								DeliveryDate									,	--	 9
		'N/A'									OrderNotes										,	--	10
		'Account'							PaymentType										,	--	11
		@orden								PONumber									--	,	--	11
		
		
		--'N/A'									OrderNotes										,	--	 9
		--'Our Transport'				ShippingMethod								,	--	11
		--@impuestos						Tax														,	--	12
		--0											ShippingCharges								,	--	13
		--@cliente							CustomerCode									,	--	 6

/*	POBLA LOS DETALLES	*/
	INSERT INTO #OrderLine
	SELECT 
		cr.sucursal																					,	--	 1
		cr.cliente																					,	--	 2
		cr.factura										                      ,	--	 3
		cr.factura										  B2BLineKey          ,	--	 4
		cr.Codigo												SKU									,	--	 4
		cr.piezas_surtidas_con_cargo		Quantity						,	--	 5
		cr.piezas_surtidas_sin_cargo		FreeQuantity				,	--	 6
		cr.precio_farm_sin_imp					ListPrice						,	--	 7
		cr.precio_farm_sin_imp					SellPrice						,	--	 8
		cr.descto_comercial							WholesalerDiscount	,	--	 9
		cr.importe_bruto								TotalAmount					,	--	10
		CONVERT(DATETIME,@fecha,121)		Deliverydate				,	--	11
		CONVERT(DATETIME,@fecha,121)		RequestedDeliveryDate	--	12
	FROM #corriente cr

	DROP TABLE #corriente

/*	POBLA LOS DOMICILIOS 3 VECES	*/
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
				REPLACE(cb.poblacion,',','') poblacion2,
				cb.codigo_postal,
				RTRIM(LTRIM(es.sanofi)),
				'MX'
			FROM clientes_baan cb			WITH(NOLOCK)
			INNER JOIN estados es 		WITH(NOLOCK)	ON cb.cve_estado = es.cve_estado
			WHERE cb.sucursal = @sucursal AND cb.cliente = @cliente
		SET @contador = @contador + 1
	END

/*	INSERTA ENCABEZADOS */
	INSERT INTO #resultados
	SELECT
				@sucursal,			--	IDENTIFICADOR
				@cliente,				--	IDENTIFICADOR
				@factura,				--	IDENTIFICADOR
		 RTRIM(CONVERT(VARCHAR,		i.WholesalerOrderNumber						))	+  @sep +
		 RTRIM(CONVERT(VARCHAR,		i.B2BOrderNumber									))	+  @sep +
		RTRIM(CONVERT(VARCHAR,		i.WholesalerOrderTotalDiscount		))	+ @sep +
		RTRIM(CONVERT(VARCHAR,		i.TotalAmount											))	+ @sep +
		RTRIM(CONVERT(VARCHAR(10),i.DeliveryDate,121)								)		+ @sep +
		 RTRIM(										i.OrderNotes											)		+  @sep +
		 RTRIM(										i.PaymentType											)		+  @sep +
		 RTRIM(										i.PONumber												)		
	FROM #Order i WHERE renglon = @row
	
	/*	INSERTA DOMICILIOS */
	INSERT INTO #resultados
	SELECT
				@sucursal,			--	IDENTIFICADOR
				@cliente,				--	IDENTIFICADOR
				@factura,				--	IDENTIFICADOR
		 RTRIM(d.CompanyName)																		+  @sep +
		 RTRIM(d.FirstName)																			+  @sep +
		 RTRIM(d.LastName)																				+  @sep +  
		 RTRIM(d.Address1)																				+  @sep +
		 RTRIM(d.Address2)																				+  @sep +
		 RTRIM(d.Address3)																				+  @sep +
		 RTRIM(d.City)																						+  @sep +
		 RTRIM(d.Postal_Code)																		+  @sep +
		 RTRIM(d.State)																					+  @sep +
		 RTRIM(d.Country)																				
	FROM #domicilios d 
	WHERE d.sucursal = @sucursal AND d.cliente = @cliente AND d.factura = @factura

/*	INSERTA DETALLES */
	INSERT INTO #resultados
	SELECT 
				@sucursal,			--	IDENTIFICADOR
				@cliente,				--	IDENTIFICADOR
				@factura,				--	IDENTIFICADOR
		RTRIM(								i.B2BLineKey										 )	+ @sep + 
		 RTRIM(								i.SKU														 )	+  @sep + 
		RTRIM(CONVERT(VARCHAR,i.Quantity											))	+ @sep + 
		RTRIM(CONVERT(VARCHAR,i.FreeQuantity									))	+ @sep + 
		RTRIM(CONVERT(VARCHAR,i.ListPrice											))	+ @sep + 
		RTRIM(CONVERT(VARCHAR,i.SellPrice											))	+ @sep + 
		RTRIM(CONVERT(VARCHAR,i.WholesalerDiscount						))	+ @sep + 
		RTRIM(CONVERT(VARCHAR,i.TotalAmount										))	+ @sep + 
		RTRIM(CONVERT(VARCHAR(10),i.DeliveryDate,121					))	+ @sep + 
		RTRIM(CONVERT(VARCHAR(10),i.RequestedDeliveryDate,121	))	
	FROM #OrderLine i
	WHERE i.sucursal = @sucursal AND i.cliente = @cliente AND i.factura = @factura

	SET @row = @row + 1
END

--	SELECT * FROM #facturas_sanofi
--	SELECT * FROM #facturas
--	SELECT * FROM #Order
--	SELECT * FROM #OrderLine
--	SELECT * FROM #domicilios

SELECT --* 
	--sucursal	,
	--cliente		,
	--factura		,
	col1	
FROM #resultados



DROP TABLE #domicilios
DROP TABLE #Order
DROP TABLE #facturas
DROP TABLE #facturas_sanofi
DROP TABLE #OrderLine
DROP TABLE #resultados
GO
