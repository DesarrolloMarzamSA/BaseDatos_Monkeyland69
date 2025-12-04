CREATE	--	CREATE
PROCEDURE usp_chedraui_pedidos_v3_upd_cod_ctas
AS


UPDATE pedidos_chedraui_v3 SET 
	codigo = ISNULL(cc.codigo, '0000000')	,
	descripcion = cc.descripcion					,
	pedido = pc.orden_pharmacy						,
	cantidad_pedida = cantidad_solicitada
FROM pedidos_chedraui_v3 pc
LEFT OUTER JOIN vi_catalogo_chedraui cc ON 
	cc.cod_barras = RIGHT(REPLICATE('0',13) + RTRIM(LTRIM(upc)), 13 )
--WHERE /*linea = @linea 
--	AND */
--	tienda = @tienda AND
--	upc = @upc AND 
--	cantidad_solicitada = @cantidad_solicitada

UPDATE pedidos_chedraui_v3 SET 
	sucursal = ISNULL(ct.sucursal, 0),
	cliente = ISNULL(ct.cliente, '00000'),
	cliente_ibs = ISNULL(ct.cliente_ibs, 'Z00000'),
	letra = ISNULL(LEFT(ct.cliente_ibs, 1), 'Z')
FROM pedidos_chedraui_v3 pc
LEFT OUTER JOIN catalogo_chedraui_tiendas_V3 ct ON 
	ct.tienda = CONVERT(INT,pc.tienda)
--WHERE /*linea = @linea 
--	AND */
--	ct.tienda = @tienda AND
--	upc = @upc AND 
--	cantidad_solicitada = @cantidad_solicitada

GO

