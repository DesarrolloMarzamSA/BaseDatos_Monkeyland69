-- =============================================
-- Author:		mandrade
-- Create date: 12/10/2015
-- Description:	obtiene consecutivo walmart
-- =============================================
CREATE PROCEDURE [dbo].[usp_consecutivo_walmart] @nombreArchivo varchar(350), @hashMD5 varchar(350)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SELECT TOP 1 [idPedido] as idConsecutivo
	FROM [dbo].[pedidoWalmartConsec]
	where nombreArchivo=@nombreArchivo and  hashMD5=@hashMD5
END

GO

