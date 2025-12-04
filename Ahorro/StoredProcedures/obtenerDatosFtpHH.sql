
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Ahorro].[obtenerDatosFtpHH]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT [letra]
      ,[sucursal]
      ,[interfase]
      ,[ip]
      ,[usuario]
      ,[password]
      ,[volumen]
      ,[respuestas]
  FROM [dbo].[rutas_pedidos_AS400]

END

GO

