
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE  [Ahorro].[MarcarIncidencia]
@hash varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

update [Ahorro].[encabezadoPedidosFiliales] set [estatus]=-10 where [hashMd5]=@hash

END

GO

