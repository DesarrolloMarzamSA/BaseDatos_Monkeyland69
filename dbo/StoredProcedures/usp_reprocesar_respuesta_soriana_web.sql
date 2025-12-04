-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_reprocesar_respuesta_soriana_web] @idcliente varchar(150)=''
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    update   soriana.[dbo].[PedidoSoriana] set  estatus=0  where hashMD5=@idcliente
END

GO

