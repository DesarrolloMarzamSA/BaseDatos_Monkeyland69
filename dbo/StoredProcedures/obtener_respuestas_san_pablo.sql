-- =============================================
-- Author:		mandrade
-- Create date: 25/06/2015
-- Description:	obtener nombres de archivo de respuestas
-- =============================================
CREATE PROCEDURE [obtener_respuestas_san_pablo]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SELECT distinct archivoPedido,'R'+substring(archivoPedido,2,11)as archivoRespuesta,hashMd5	
	FROM [monkeyland].[dbo].[pedidoRamaSanPablo_historia]
	where estatus=1
END

GO

