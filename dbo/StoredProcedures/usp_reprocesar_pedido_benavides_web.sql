-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE usp_reprocesar_pedido_benavides_web @idpedido varchar(250)=''
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

  delete from [pedidos_fbenavides_ci] where hash_md5=@idpedido
delete from respuesta_benavides where hashmd5=@idpedido
delete from[hashes_md5_benavides] where [firma]=@idpedido
delete from [pedidos_fbenavides_hh] where hash_md5=@idpedido
delete from [dbo].[hashes_md5]where [firma]=@idpedido
END

GO

