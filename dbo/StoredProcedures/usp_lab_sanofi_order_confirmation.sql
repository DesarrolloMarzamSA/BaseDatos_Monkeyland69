USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO


CREATE 
--	CREATE
PROCEDURE [dbo].[usp_lab_sanofi_order_confirmation] 
@almacen INT, @fecha VARCHAR(10)
WITH ENCRYPTION
AS

/*
usp_lab_sanofi_order_confirmation 1, '2011-02-11'
*/
--	DECLARE @fecha VARCHAR(10)
--	SET @fecha = '2010-01-06'
--	DECLARE @almacen INT
--	SET @almacen = 1

DECLARE @SEP VARCHAR(10)
SET @SEP = '|'
DECLARE @contador INT

DECLARE @Tax MONEY
DECLARE @TotalDiscount MONEY
DECLARE @TotalAmount MONEY

CREATE TABLE #resultados	(
	sucursal		INT							,
	cliente			VARCHAR(   5)		,
	factura			VARCHAR(   8)		,
	col1	VARCHAR(1000)
)

--	IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE='BASE TABLE' AND TABLE_NAME='#order') 
--	DROP TABLE #order
--	ELSE
CREATE TABLE #order	(
	renglon												INT,								--	 1
	sucursal											INT,								--	 2
	cliente												VARCHAR(5),					--	 3
	factura												VARCHAR(10),				--	 4
	WhosalerOrderNumber						VARCHAR(60),
	B2BOrderNumber								VARCHAR(60),
	Tax														MONEY,
	ShippingCharges								MONEY,
	SanofiOrderTotalDiscount			MONEY,
	WhosalerOrderTotalDiscount		MONEY,
	TotalAmount										MONEY,
	DeliverDate										VARCHAR(10),	--	DATETIME,
	OrderStatus										VARCHAR(20),
	RejectionReason								VARCHAR(60),
	WholesalerCustomerCode				VARCHAR(90),
	ShippingMethod								VARCHAR(20),
	Memo													VARCHAR(240),
	PaymentType										VARCHAR(120),
	PaymentAccountNumber					VARCHAR(120),
	PONumber											VARCHAR(50)
	PRIMARY KEY (sucursal, cliente, factura)
)

/*	TABLA PARA GENERAR EL DETALLE EN BASE A LA TABLA #facturas	*/
CREATE TABLE #items		(
	sucursal						INT,													--	 1
	cliente							VARCHAR(5),										--	 2
	factura							INT,													--	 3
	B2BLineKey					INT,													--	 4
	SKU									VARCHAR(120),									--	 5
	Quantity						INT,													--	 6
	FreeQuantity				INT,													--	 7
	ListPrice						MONEY,												--	 8
	SellPrice						MONEY,												--	 8
	SanofiDiscount			MONEY,												--	 9
	WholesalerDiscount	MONEY,												--	10
	TotalAmount					MONEY													--	11
	PRIMARY KEY (sucursal, cliente, factura, SKU, Quantity)
)

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
	--	PRIMARY KEY (cliente, orden)
)
CREATE INDEX idx_domicilios on #domicilios (sucursal, cliente, factura)

CREATE TABLE #facturas	(
	id_recno	INT IDENTITY,
	sucursal	INT,
	cliente		VARCHAR(5),
	factura		VARCHAR(10)	
	PRIMARY KEY (sucursal, cliente, factura)
	)

/*
SELECT *
INTO #pedidos
FROM facturacion_electronica_estandar
WHERE SUCURSAL = @almacen
AND ISNUMERIC( LTRIM(RTRIM(orden) ) ) = 1
and fecha_factura = CONVERT(DATETIME,@fecha,121)
--	AND segto = 'E1' and ctepadre = '041'
--	and CLIENTE = '81661'
*/
/*
SELECT		--	TOP 50
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
INTO #pedidos
FROM monkeyland.dbo.facturacion_electronica_estandar f				WITH(NOLOCK)
INNER JOIN sucursales s 								WITH(NOLOCK)	ON s.almacen = @almacen AND s.sucursal = f.sucursal
INNER JOIN lab_sanofi_cat_productos mpb WITH(NOLOCK)	ON mpb.codigo = f.codigo
/*mpb.lab_corto = 'SANOFI' AND mpb.cod_barras IS NOT NULL AND */
WHERE f.fecha_tandem = CONVERT(DATETIME,@fecha,121)
AND ISNUMERIC( LTRIM(RTRIM(orden) ) ) = 1
--and f.sucursal = @almacen
*/

INSERT INTO #facturas	(sucursal, cliente, factura)
	SELECT DISTINCT sucursal, cliente, factura 
	FROM fes_sanofi f
	WHERE f.fecha_tandem = CONVERT(DATETIME,@fecha,121)
--GROUP BY cliente, orden
	--ORDER BY cliente, orden


--	SELECT * FROM #facturas

DECLARE @row INT
SET @row = 1
DECLARE @sucursal			INT
DECLARE @cliente	VARCHAR(5)
DECLARE @factura	VARCHAR(10)
DECLARE @orden		VARCHAR(10)

WHILE @row < ( SELECT COUNT(*) FROM #facturas )
BEGIN
	SET @sucursal			=	( SELECT sucursal	FROM #facturas WHERE id_recno = @row	)
	SET @cliente	= ( SELECT cliente FROM #facturas WHERE id_recno = @row	)
	SET @factura		=	( SELECT factura FROM #facturas WHERE id_recno = @row )

	SELECT * INTO #corriente
	FROM fes_sanofi f WHERE f.cliente = @cliente AND f.factura = @factura

	SET @orden		=	( SELECT TOP 1 orden FROM #corriente)
	SET @Tax = (SELECT SUM(iva) + SUM(ieps) FROM #corriente	)
	SET @TotalDiscount = (SELECT SUM(descto_comercial)FROM #corriente)
		--	SanofiOrderTotalDiscount
		--	WhosalerOrderTotalDiscount
	SET @TotalAmount = (SELECT SUM(descto_comercial)FROM #corriente)

	INSERT INTO	#order
	SELECT	
		@row																								,
		@almacen																								,
		@cliente																						,
		@factura																						,
		@factura								WhosalerOrderNumber					,
		@factura								B2BOrderNumber							,
		@Tax										Tax													,					
		0												ShippingCharges							,
		@TotalDiscount					SanofiOrderTotalDiscount		,
		@TotalDiscount					WhosalerOrderTotalDiscount	,
		@TotalAmount						TotalAmount									,
		@fecha									DeliverDate									,
		'InProgress'						OrderStatus									,
		'N/A'										RejectionReason							,
		@cliente								WholesalerCustomerCode			,
		'Own Medium'						ShippingMethod							,
		'N/A'										Memo												,
		'Account'								PaymentType									,
		@cliente								PaymentAccountNumber				,
		@orden									PONumber


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
	
	SET @row = @row + 1

--	POBLA LOS DOMICILIOS 3 VECES
	SET @contador = 0
	WHILE @contador < 3
	BEGIN
		INSERT INTO #domicilios
			SELECT
				@almacen		,
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
			WHERE cb.sucursal = @sucursal AND cliente = @cliente
		SET @contador = @contador + 1
	END
	
	INSERT INTO #resultados	
		SELECT 
				@sucursal,			--	IDENTIFICADOR
				@cliente,				--	IDENTIFICADOR
				@factura,				--	IDENTIFICADOR
			LTRIM(RTRIM(s.WhosalerOrderNumber))									 +	@sep	+
			LTRIM(RTRIM(s.B2BOrderNumber))												 +	@sep	+
			CONVERT(VARCHAR,s.Tax)														   +	@sep	+
			CONVERT(VARCHAR,s.ShippingCharges)									 +	@sep	+
			CONVERT(VARCHAR,s.SanofiOrderTotalDiscount)					 +	@sep	+
			CONVERT(VARCHAR,s.WhosalerOrderTotalDiscount)				 +	@sep	+
			CONVERT(VARCHAR,s.TotalAmount)										   +	@sep	+
			LTRIM(RTRIM(s.DeliverDate))												   +	@sep	+
			LTRIM(RTRIM(s.OrderStatus))                  +	@sep	+
			LTRIM(RTRIM(s.RejectionReason))              +	@sep	+
			LTRIM(RTRIM(s.WholesalerCustomerCode))       +	@sep	+
			LTRIM(RTRIM(s.ShippingMethod))               +	@sep	+
			LTRIM(RTRIM(s.Memo))                         +	@sep	+
			LTRIM(RTRIM(s.PaymentType))                  +	@sep	+
			LTRIM(RTRIM(s.PaymentAccountNumber))         +	@sep	+
			LTRIM(RTRIM(s.PONumber))                     +	@sep	+ ''
		FROM #order s
		WHERE s.sucursal = @sucursal AND s.cliente = @cliente AND s.factura = @factura
	
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


	INSERT INTO #resultados
	SELECT 
				@sucursal,			--	IDENTIFICADOR
				@cliente,				--	IDENTIFICADOR
				@factura,				--	IDENTIFICADOR
		RTRIM(CONVERT(VARCHAR,i.B2BLineKey					))	+ @sep + 
		RTRIM(i.SKU																	)		+ @sep + 
		RTRIM(CONVERT(VARCHAR,i.Quantity						))	+ @sep + 
		RTRIM(CONVERT(VARCHAR,i.FreeQuantity				))	+ @sep + 
		RTRIM(CONVERT(VARCHAR,i.ListPrice						))	+ @sep + 
		RTRIM(CONVERT(VARCHAR,i.SellPrice						))	+ @sep + 
		RTRIM(CONVERT(VARCHAR,i.SanofiDiscount			))	+ @sep + 
		RTRIM(CONVERT(VARCHAR,i.WholesalerDiscount	))	+ @sep + 
		RTRIM(CONVERT(VARCHAR,i.TotalAmount					))
	FROM #items i
	WHERE i.sucursal = @sucursal AND i.cliente = @cliente AND i.factura = @factura

	
END

--SELECT * FROM #pedidos
--SELECT * FROM #facturas
--SELECT * FROM #order
--SELECT * FROM #items
--SELECT * FROM #domicilios



SELECT --	* 
	--sucursal	,
	--cliente		,
	--factura		,
	col1	
FROM #resultados


DROP TABLE #order
--DROP TABLE #pedidos
DROP TABLE #facturas
DROP TABLE #domicilios
DROP TABLE #items
DROP TABLE #resultados
GO
