
-- =============================================
-- Author:		mandrade
-- Create date: 23052014
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_cfdi_rutas]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
		select r.descripcion,r.ruta from ctlServidor s inner join ctlRuta r on s.idServidor=r.idServidor where s.filtro=2 and s.estatus=1
END

GO

