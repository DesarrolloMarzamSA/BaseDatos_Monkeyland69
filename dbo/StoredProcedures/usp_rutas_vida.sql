
-- =============================================
-- Author:		mandrade
-- Create date: 17/10/2014
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_rutas_vida]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    SELECT  ftp, usuario, contrasena, ruta, cliente,cliente	+ ' '+rutaInfo as Info
	FROM dbo.ruta_archivo_ftp where cliente='FarmaVida'
END

GO

