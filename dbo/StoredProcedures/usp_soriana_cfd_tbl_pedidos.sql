

CREATE
--	CREATE
PROCEDURE [dbo].[usp_soriana_cfd_tbl_pedidos]
--	DECLARE 
@serie_cfd VARCHAR(2), @folio_fiscal VARCHAR(8)
AS

DECLARE @tienda INT
SET @tienda = (SELECT numTienda FROM cfd_soriana_acuses_de_recibo WHERE serie_cfd = @serie_cfd AND folio_fiscal = @folio_fiscal)

/*
EXECUTE usp_soriana_cfd_tbl_pedidos 'FC', '01067777'
SET @fecha = '2010-07-01'
SET @folio_fiscal = '00316283'
set @serie_cfd = 'FG'
*/
SET @folio_fiscal = RIGHT(REPLICATE('0', 8) + @folio_fiscal,  8)

SELECT 
	'21329'																																				Proveedor								,
	s.serie_cfd + '-' + CONVERT(VARCHAR,CONVERT(INT,e.folio_fiscal))							Remision								,
--	0																																							Consecutivo							,
	CASE 
		WHEN CONVERT(INT,ISNUMERIC(LTRIM(RTRIM(e.orden))))	= 0 THEN 0	--CONVERT(INT,e.factura	)
		WHEN CONVERT(INT,ISNUMERIC(LTRIM(RTRIM(e.orden))))	> 0 THEN CONVERT(INT,e.orden		)
	END																																						FolioPedido							,
--	CONVERT(VARCHAR,CONVERT(INT,ISNULL(c.numTienda,@tienda)))																			Tienda									,
	CONVERT(VARCHAR,CONVERT(INT,@tienda))																			Tienda									,
	--CONVERT(VARCHAR,CONVERT(INT,n.numTienda))																			Tienda									,
	SUM(f.piezas_surtidas_con_cargo + f.piezas_surtidas_sin_cargo)								CantidadArticulos				,
	CASE 
		WHEN CONVERT(INT,ISNUMERIC(LTRIM(RTRIM(e.orden))))	= 0 THEN 'SI'																		--	A pie de camión
		WHEN CONVERT(INT,ISNUMERIC(LTRIM(RTRIM(e.orden))))	> 0 THEN 'NO'																		--	Cedis
	END																																						PedidoEmitidoProveedor	--	CONVERT(VARCHAR,CONVERT(INT,e.orden))
FROM encabezado_soriana e with(nolock) 
INNER JOIN sucursales s with(nolock) ON s.serie_cfd = @serie_cfd 
LEFT OUTER JOIN CatTiendasSoriana c			with(nolock) 				ON e.sucursal = c.sucursal AND e.cliente = c.cliente
INNER JOIN facturacion_electronica_estandar f	with(nolock) 	ON f.sucursal = e.sucursal AND f.factura = e.factura
LEFT OUTER JOIN cfd_soriana_acuses_de_recibo n	with(nolock) ON n.serie_cfd = @serie_cfd	AND	n.folio_fiscal = CONVERT(INT,@folio_fiscal)
WHERE e.sucursal = s.sucursal
	AND e.folio_fiscal = @folio_fiscal
	AND e.segto = 'E1' AND e.ctepadre in ('044','032')
	AND e.farmacia NOT LIKE '%ISSSTE%'
--	AND e.fechaprog = CONVERT(VARCHAR(10),@fecha,121)
GROUP BY 
s.serie_cfd, e.folio_fiscal, e.factura, e.fechaprog, e.orden, c.numTienda
--s.serie_cfd, e.folio_fiscal, e.factura, e.fechaprog, e.orden, n.numTienda

GO

