/*
usp_lab_sanofi_inventario  4, '2010-08-31'
*/

CREATE
--CREATE
PROCEDURE usp_lab_sanofi_inventario	
@almacen INT, @fecha VARCHAR(10)
AS

--DECLARE @almacen INT
--SET @almacen = 1
DECLARE @sep VARCHAR(10)
SET @sep = '|'

/*
CREATE TABLE #resultado	(
	col1			VARCHAR(1000)
	)
*/
	
CREATE TABLE #inventario_sanofi	(
	SKU								VARCHAR(200)	,
	EAN								VARCHAR(13)		,
	Existencia				DECIMAL(10,2)	,
	DiasInventario		DECIMAL(10,2),	
	ProductoNegado		DECIMAL(10,2)	,
	Desplazamiento		DECIMAL(10,2)	,
	Transito					DECIMAL(10,2)	,
	NoSucursal				VARCHAR(10)--		,
--	NombreSucursal		VARCHAR(250)
	)

CREATE TABLE #sanofi_producto_negado	(
	sucursal				INT					NOT NULL, 
	codigo					VARCHAR( 7) NOT NULL,
	ProductoNegado	INT
	PRIMARY KEY (sucursal, codigo)	)

CREATE TABLE #prods_sanofi						(
	codigo										VARCHAR( 7),
	cod_barras								VARCHAR(13),
	descripcion								VARCHAR(30),
	PRIMARY KEY (codigo)
)
--INNER JOIN maestro_productos_baan mpb ON mpb.lab_corto = 'SANOFI' AND mpb.cod_barras IS NOT NULL AND mpb.codigo = f.codigo


--DECLARE sucursales CURSOR FOR 
--SELECT sucursal 
--FROM sucursales WHERE almacen = @almacen
--ORDER BY sucursal

/*
INSERT INTO #prods_sanofi 
SELECT mpb.codigo, mpb.cod_barras, mpb.descripcion
FROM maestro_productos_baan mpb 
WHERE mpb.lab_corto = 'SANOFI' AND mpb.cod_barras IS NOT NULL
*/

--OPEN sucursales
--FETCH NEXT FROM sucursales INTO @sucursal

INSERT INTO #sanofi_producto_negado
SELECT 
	e.sucursal,
	SUBSTRING(d.codigos, 3, 7) codigo,
	SUM(cant_real) ProductoNegado
FROM encabezado e												WITH (NOLOCK)
INNER JOIN sucursales s 								WITH (NOLOCK)	ON s.almacen = @almacen AND s.sucursal = e.sucursal
INNER JOIN detalle d								WITH (NOLOCK)	ON d.sucursal = e.sucursal AND d.factura = e.factura	 
--INNER JOIN lab_sanofi_detalle d										WITH (NOLOCK)	ON e.sucursal = d.sucursal AND e.factura = d.factura AND d.dest_det IN ('FEA','FEP')
INNER JOIN lab_sanofi_cat_productos mpb	WITH (NOLOCK)	ON mpb.codigo = SUBSTRING(d.codigos, 3, 7)
WHERE 
e.fecha_tandem = CONVERT(DATETIME,@fecha,121)
--AND e.sucursal = @almacen
GROUP BY e.sucursal, d.codigos
ORDER BY e.sucursal, d.codigos

CREATE TABLE #desplazamiento (
	sucursal									INT					,
	codigo										VARCHAR( 7)	,
	vta_x_prod								INT
	PRIMARY KEY (sucursal, codigo)
)

INSERT INTO #desplazamiento
SELECT 		--	TOP 50
	f.sucursal, 
	f.codigo, 
--	AVG(CONVERT(DECIMAL(10,4),f.piezas_surtidas_con_cargo + f.piezas_surtidas_sin_cargo)) vta_promedio
	SUM(f.piezas_surtidas_con_cargo + f.piezas_surtidas_sin_cargo) vta_x_prod
FROM facturacion_electronica_estandar f				WITH (NOLOCK)
INNER JOIN sucursales s												WITH (NOLOCK)	ON s.almacen = @almacen AND s.sucursal = f.sucursal
INNER JOIN lab_sanofi_cat_productos mpb				WITH (NOLOCK)	ON mpb.codigo = f.codigo 
	/*mpb.lab_corto = 'SANOFI' AND mpb.cod_barras IS NOT NULL AND*/
WHERE f.sucursal = @almacen
AND f.fecha_tandem BETWEEN 
	DATEADD(DD, -7, CONVERT(DATETIME,@fecha,121) ) AND CONVERT(DATETIME,@fecha,121)
GROUP BY f.sucursal, f.codigo
ORDER BY f.sucursal, f.codigo

DECLARE @sucursal INT

INSERT INTO #inventario_sanofi
SELECT		--	TOP 50
	ib.codigo																											,
	mpb.cod_barras																	EAN						,
	CONVERT(DECIMAL(10,2),ib.piezas								)	Existencia		,
	CONVERT(DECIMAL(10,2),0												)	DiasInventario,
	CONVERT(DECIMAL(10,2),0												)	ProductoNegado,
	CONVERT(DECIMAL(10,2),ib.Desplazamiento				)	Desplazamiento,	--	(a)
	CONVERT(DECIMAL(10,2),ib.transito							)	Transito			,
	ib.sucursal																				NoSucursal	--	,
--	su.descripcion										NombreSucursal
FROM inventario_baan_sin_filtro ib					WITH (NOLOCK)
INNER JOIN sucursales s											WITH (NOLOCK)	ON s.almacen = @almacen --	AND s.sucursal = ib.sucursal
INNER JOIN maestro_productos_baan mpb				WITH (NOLOCK)	ON mpb.lab_corto = 'SANOFI' AND mpb.cod_barras IS NOT NULL 
	AND mpb.codigo = ib.codigo
LEFT OUTER JOIN #sanofi_producto_negado n		WITH (NOLOCK)	ON n.sucursal = @almacen AND n.codigo = mpb.codigo
WHERE ib.sucursal = @almacen 
	AND ib.status in ('C01','C02','D01','D02','S05','T01','A01', '   ')

--	(a)	.-	promedio de ventas de este producto en especial de los últimos 3 meses (Existencia / Desplazamiento)

UPDATE #inventario_sanofi SET
	Desplazamiento = (d.vta_x_prod / 3),	
	DiasInventario =	CASE WHEN Desplazamiento > 0 THEN (Existencia / Desplazamiento) * 30	--	SOLICITADO EL DIA 03 / 09 / 2010
										ELSE 0 END
FROM #inventario_sanofi i
INNER JOIN #desplazamiento d ON d.codigo = i.SKU

--	INSERT INTO #resultado

SELECT
	RTRIM(								i.SKU							 )	SKU							,--		+ @sep + 
	RTRIM(								i.EAN							 )	EAN							,--		+ @sep + 
	RTRIM(CONVERT(VARCHAR,i.Existencia			))	Existencia			,--		+ @sep + 
	RTRIM(CONVERT(VARCHAR,i.DiasInventario	))	DiasInventario	,--		+ @sep + 
	RTRIM(CONVERT(VARCHAR,i.ProductoNegado	))	ProductoNegado	,--		+ @sep + 
	RTRIM(CONVERT(VARCHAR,i.Desplazamiento	))	Desplazamiento	,--		+ @sep + 
	RTRIM(CONVERT(VARCHAR,i.Transito				))	Transito				,--		+ @sep + 
	RTRIM(CONVERT(VARCHAR,i.NoSucursal			))	NoSucursal			--		+ @sep + 
--	RTRIM(								i.NombreSucursal	 )
FROM	#inventario_sanofi i

--	SELECT * FROM #resultado

--SELECT * FROM #inventario_sanofi

DROP TABLE #sanofi_producto_negado
DROP TABLE #desplazamiento
DROP TABLE #inventario_sanofi
--DEALLOCATE sucursales

GO

