SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sanofi_get_datos_salida] @md5 varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

--SELECT     pedidos_sanofi.Sku, ISNULL(EAN.descripcion,'NA') as descripcion, pedidos_sanofi.cantidad_entregada, pedidos_sanofi.precio_facturado, 
--                      pedidos_sanofi.b2b_order_number, pedidos_sanofi.cantidad_entregada * pedidos_sanofi.precio_facturado AS precio_total, 
--                      pedidos_sanofi.SaDiscount, '' AS wholesaler_discount, 0 AS FreeQuantity, pedidos_sanofi.LineKey, 
--                      pedidos_sanofi.cantidad_entregada AS shipped_quantity, Quantity,order_line_status,
--                      isnull(EAN.prec_farm,0) as prec_farm,isnull(EAN.prec_pub,0) as prec_pub
--FROM         pedidos_sanofi LEFT JOIN (SELECT cod_barras,descripcion,prec_farm,prec_pub
--  FROM maestro_productos_baan) as EAN ON pedidos_sanofi.Sku = EAN.cod_barras
--where pedidos_sanofi.md5=@md5 

SELECT     pedidos_sanofi.Sku, ISNULL(EAN.descripcion,'NA') as descripcion, pedidos_sanofi.cantidad_entregada, pedidos_sanofi.precio_facturado, 
                      pedidos_sanofi.b2b_order_number, pedidos_sanofi.cantidad_entregada * pedidos_sanofi.precio_facturado AS precio_total, 
                      pedidos_sanofi.SaDiscount, '' AS wholesaler_discount, 0 AS FreeQuantity, pedidos_sanofi.LineKey, 
                      pedidos_sanofi.cantidad_entregada AS shipped_quantity, Quantity,order_line_status,
                      isnull(EAN.prec_farm,0) as prec_farm,isnull(EAN.prec_pub,0) as prec_pub
FROM         pedidos_sanofi 
inner join (SELECT codigo,descripcion,prec_farm,prec_pub
  FROM maestro_productos_baan) as EAN
  on [monkeyland].[dbo].[EantoMarzam](pedidos_sanofi.Sku)=EAN.codigo
where pedidos_sanofi.md5=@md5

END

GO
