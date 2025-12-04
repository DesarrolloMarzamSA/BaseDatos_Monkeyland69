CREATE
--	CREATE
PROCEDURE usp_lab_sanofi_producto_factura	
--	DECLARE 
@almacen INT, @fecha	VARCHAR(10)
/*
SET @almacen = 3
SET @fecha = '2012-02-20'
*/

AS
/*
usp_lab_sanofi_producto_factura 1,'2012-02-20'
*/


/*
SELECT '00' + codigo codigo,descripcion,status 
INTO #prods_sanofi 
FROM maestro_productos_baan mpb WHERE mpb.lab_corto = 'SANOFI'
--INNER JOIN maestro_productos_baan mpb ON mpb.lab_corto = 'SANOFI' AND mpb.codigo = f.codigo
ALTER TABLE #prods_sanofi ADD PRIMARY KEY (codigo)
*/

CREATE TABLE #facturas_productos	(
	sucursal									INT					NOT NULL,
	Numero_Factura						VARCHAR(10)	NOT NULL,
	SKU												VARCHAR( 9)	NOT NULL,
	Descripcion								VARCHAR(30)					,
	Cantidad_Facturada				INT									,
	Cantidad_Pedida						INT									,
	Precio_Unitario						MONEY								,
	Numero_de_Linea_Factura		INT					NOT NULL,
	Precio_Unitario_Final			MONEY								,
	Descto_Sanofi							MONEY								,
	Descto_Mayorista					MONEY								,
	Piezas_gratis							INT									,
	Orden_Compra							VARCHAR(20)					,
	Estatus										VARCHAR(10)					,
	
	PRIMARY KEY ( Numero_Factura, SKU, Numero_de_Linea_Factura)
)

INSERT INTO #facturas_productos
SELECT
	e.sucursal																							sucursal								,
	LEFT(e.factura,10)																			Numero_Factura					, 
	SUBSTRING(d.codigos, 3, 7)															SKU											, 
	LEFT(p.descripcion,30)																	Descripcion							, 
	0																												Cantidad_Facturada			,
	d.cant_ped																							Cantidad_Pedida					, 
	d.prec_farm																							Precio_Unitario					,
	999																											Numero_de_Linea_Factura	,
	d.prec_farm																							Precio_Unitario_Final		,	
	0																												Descto_Sanofi						,
	0																												Descto_Mayorista				,
	d.cant_ofert																						Piezas_gratis						,
	RTRIM(LTRIM(e.orden))																		Orden_Compra						
	,CASE d.dest_det WHEN 'AAA' THEN 'SUR'	ELSE 'NEG'END		Estatus
		
FROM encabezado e						WITH (NOLOCK)
INNER JOIN sucursales s 		WITH (NOLOCK)	ON s.almacen = @almacen AND s.sucursal = e.sucursal
INNER JOIN detalle d				WITH (NOLOCK)	ON d.sucursal = e.sucursal AND d.factura = e.factura	 
--INNER JOIN lab_sanofi_detalle d				WITH (NOLOCK)	ON d.sucursal = e.sucursal AND d.factura = e.factura 	AND d.dest_det <> 'AAA'
INNER JOIN lab_sanofi_cat_productos p	WITH (NOLOCK)	ON p.codigo = SUBSTRING(d.codigos,3,7) 
--	INNER JOIN maestro_productos_baan p ON p.codigo = SUBSTRING(d.codigos,3,7) AND p.lab_corto = 'SANOFI'
WHERE e.fecha_tandem --= CONVERT(SMALLDATETIME,@fecha,121)
BETWEEN	CONVERT(DATETIME,DATEADD(DD,  -7, CONVERT(DATETIME, @fecha,121) ),121 )
		AND CONVERT(DATETIME,DATEADD(DD,  -1, CONVERT(DATETIME, @fecha,121) ),121 )
---and e.sucursal = @almacen	

--	UNION
INSERT INTO #facturas_productos
SELECT
	f.sucursal																												sucursal								,
	f.factura																													Numero_Factura					, 
	SUBSTRING(det.codigos, 3, 7)																			SKU											, 
	f.descripcion																											Descripcion							, 
	f.piezas_surtidas_con_cargo																				Cantidad_Facturada			,
	det.cant_real																											Cantidad_Pedida					, 
	f.precio_farm_sin_imp																							Precio_Unitario					,
	f.no_registro																											Numero_de_Linea_Factura	,
	f.precio_farm_sin_imp																							Precio_Unitario_Final		,	
	f.descto_comercial																								Descto_Sanofi						,
	f.descto_oferta																										Descto_Mayorista				,
	f.piezas_surtidas_sin_cargo																				Piezas_gratis						,
	LEFT(RTRIM(LTRIM(f.orden)),10)																		Orden_Compra						,
	CASE det.dest_det WHEN 'AAA' THEN 'SUR'			ELSE 'NEG'		END			Estatus
FROM facturacion_electronica_estandar f									WITH (NOLOCK)
--FROM lab_sanofi_fes f		WITH (NOLOCK)
--FROM lab_sanofi_fes f		WITH (NOLOCK)
--	INNER JOIN maestro_productos_baan p ON p.codigo = '00' + f.codigo AND p.lab_corto = 'SANOFI'
INNER JOIN sucursales s										WITH (NOLOCK)	ON s.almacen = @almacen AND s.sucursal = f.sucursal
INNER JOIN lab_sanofi_cat_productos p			WITH (NOLOCK)	ON p.codigo = f.codigo
INNER JOIN detalle det								WITH (NOLOCK)	ON det.sucursal = f.sucursal AND det.factura = f.factura	 
--INNER JOIN lab_sanofi_detalle det					WITH (NOLOCK)	ON f.sucursal = det.sucursal AND f.factura = det.factura 
	AND f.codigo = SUBSTRING(det.codigos, 3, 7) AND det.dest_det = 'AAA'
WHERE f.fecha_factura --= CONVERT(DATETIME,@fecha,121)
BETWEEN	CONVERT(DATETIME,DATEADD(DD,  -7, CONVERT(DATETIME, @fecha,121) ),121 )
		AND CONVERT(DATETIME,DATEADD(DD,  -1, CONVERT(DATETIME, @fecha,121) ),121 )
--	and f.sucursal = @almacen 
--	ORDER BY f.factura

SELECT --* 
--	sucursal									,
	Numero_Factura						,
	SKU												,
	Descripcion								,
	Cantidad_Facturada				,
	Cantidad_Pedida						,
	Precio_Unitario						,
	Numero_de_Linea_Factura		,
	Precio_Unitario_Final			,
	Descto_Sanofi							,
	Descto_Mayorista					,
	Piezas_gratis							,
	Orden_Compra							,
	Estatus										
FROM #facturas_productos
ORDER BY Numero_Factura

DROP TABLE #facturas_productos

GO

