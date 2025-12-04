SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Abraham Marcelino Ramirez Vega
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[obtener_pedido_valido_sanofi] 
	@md5 varchar(60)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


--SELECT     pedidos_sanofi.Sku,cabecero_sanofi.ws_customer_code AS codigo_cliente, cabecero_sanofi.b2b_order_number AS orden_sanofi,
-- [monkeyland].[dbo].[EantoMarzam](pedidos_sanofi.Sku) AS codigo_marzam, 
--                      pedidos_sanofi.Quantity AS cantidad, archivos.serie_hand_held
--FROM         cabecero_sanofi INNER JOIN
--             pedidos_sanofi ON cabecero_sanofi.md5 = pedidos_sanofi.md5 INNER JOIN
--             archivos ON pedidos_sanofi.md5 = archivos.md5
--WHERE     (cabecero_sanofi.b2b_order_number = @numero_orden_sanofi)
--ORDER BY pedidos_sanofi.Sku


SELECT     pedidos_sanofi.Sku,cabecero_sanofi.ws_customer_code AS codigo_cliente, cabecero_sanofi.b2b_order_number AS orden_sanofi,
 [monkeyland].[dbo].[EantoMarzam](pedidos_sanofi.Sku) AS codigo_marzam, 
                      pedidos_sanofi.Quantity AS cantidad, archivos.serie_hand_held
FROM         cabecero_sanofi INNER JOIN
             pedidos_sanofi ON cabecero_sanofi.md5 = pedidos_sanofi.md5 INNER JOIN
             archivos ON pedidos_sanofi.md5 = archivos.md5
WHERE     (cabecero_sanofi.md5 = @md5)
ORDER BY pedidos_sanofi.Sku

END
GO