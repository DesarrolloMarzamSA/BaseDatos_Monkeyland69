-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_obtener_archivo_soriana_web] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

  SELECT [archivo]+'_'+convert(varchar,fechaRegistro,112)as [archivo]
      ,[hashMD5]
  FROM [soriana].[dbo].[ConsecutivoPedido]
   where convert(varchar,fechaRegistro,112)>= convert(varchar,getdate(),112)
END

GO

