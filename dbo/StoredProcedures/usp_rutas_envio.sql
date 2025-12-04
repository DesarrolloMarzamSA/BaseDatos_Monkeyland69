-- =============================================
-- Author:		mandrade
-- Create date: 10062014
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_rutas_envio] @cliente varchar(350)
AS
BEGIN
	--[usp_rutas_envio] 'benavides'
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    SELECT  ftp, usuario, contrasena, ruta, cliente,cliente	+ ' '+rutaInfo as Info
	FROM monkeyland.dbo.ruta_archivo_ftp where cliente=@cliente
END

GO

