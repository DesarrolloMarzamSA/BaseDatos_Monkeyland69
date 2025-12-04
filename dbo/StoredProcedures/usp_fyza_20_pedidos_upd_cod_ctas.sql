USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE	--	CREATE	--	DROP
PROCEDURE [dbo].[usp_fyza_20_pedidos_upd_cod_ctas]
WITH ENCRYPTION
AS


UPDATE pedidos_fyza_20 SET 
	codigo = ISNULL(cc.codigo, '0000000')	,
	descripcion = cc.descripcion					,
	pedido = pc.orden_pharmacy						,
	cantidad_pedida = cantidad_solicitada
FROM pedidos_fyza_20 pc
LEFT OUTER JOIN maestro_productos_baan cc ON 
	cc.cod_barras = RIGHT(REPLICATE('0',13) + RTRIM(LTRIM(upc)), 13 )
--WHERE /*linea = @linea 
--	AND */
--	tienda = @tienda AND
--	upc = @upc AND 
--	cantidad_solicitada = @cantidad_solicitada

UPDATE pedidos_fyza_20 SET 
	sucursal = ISNULL(ct.sucursal, 0),
	cliente = ISNULL(ct.cliente, '00000'),
	letra = s.ibs_letra
	--cliente_ibs = ISNULL(ct.cliente_ibs, 'Z00000'),
	--letra = ISNULL(LEFT(ct.cliente_ibs, 1), 'Z')
FROM pedidos_fyza_20 pc
LEFT OUTER JOIN cat_cuentas_yza ct ON 
	ct.cuenta_estilo_yza = CONVERT(INT,pc.tienda)
LEFT OUTER JOIN sucursales s ON
	s.sucursal = ct.sucursal 
--WHERE /*linea = @linea 
--	AND */
--	ct.tienda = @tienda AND
--	upc = @upc AND 
--	cantidad_solicitada = @cantidad_solicitada
GO
