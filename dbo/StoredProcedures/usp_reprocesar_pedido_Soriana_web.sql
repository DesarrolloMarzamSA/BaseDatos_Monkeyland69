-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_reprocesar_pedido_Soriana_web] @idpedido varchar(150)=''
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   delete from soriana.[dbo].[PedidoSoriana] where hashMD5=@idpedido
   delete from monkeyland.[dbo].[hashes_md5] where [firma]=@idpedido
   delete from soriana.[dbo].[ConsecutivoPedido] where hashmd5=@idpedido
END

GO

