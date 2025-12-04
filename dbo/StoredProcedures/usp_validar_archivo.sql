-- =============================================
-- Author:		mandrade
-- Create date: 18/11/2015
-- Description:	obtener informacion de archivo de pedido Comercial Mexicana
-- =============================================
CREATE PROCEDURE usp_validar_archivo @hashMD5 varchar(250)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	select count(*) from [monkeyland].[dbo].[pedido_comercial_mexicana] where hashMD5=@hashMD5
END

GO

