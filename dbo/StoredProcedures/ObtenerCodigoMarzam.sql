-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE ObtenerCodigoMarzam
@ean varchar(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

SELECT Top 1 [codigo]
      ,[ean]
      ,[descripcion]
      ,[precio]
FROM [192.168.90.129].[SmartphoneNueva].[dbo].[productos]
where ean=@ean

END

GO

