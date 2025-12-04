SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sanofi_get_direcciones_salida] @md5 varchar(50) 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

SELECT FirstName as CompanyName,FirstName,LastName
      ,Address1,Address2,Address3,City,PostalCode
      ,State,Country
  FROM direcciones_sanofi
  where md5=@md5

END

GO
