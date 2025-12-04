

-- =============================================
-- Author:		mandrade
-- Create date: 15-12-2014
-- Description:	obtienepedido Original
-- =============================================
CREATE PROCEDURE [dbo].[usp_pedido_BenavidesReporte] @archivo varchar(350)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    select cia,mostrador as almacen,cantidad_pedida as catidadPedida,cod_bena as codigoBenavides,convert(varchar,fecha_pedido,112) as fechaPedido,pedido as numeroPedido
	 from pedidos_fbenavides_ci where hash_md5=@archivo
END

GO

