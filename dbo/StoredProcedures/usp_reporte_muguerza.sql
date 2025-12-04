
-- =============================================
-- Author:		mandrade
-- Create date: 19-11-2013
-- Description:	reporte muguerza
-- =============================================
CREATE PROCEDURE [dbo].[usp_reporte_muguerza] @fechaIni varchar(20),@fechaFin varchar(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SELECT sucursal,factura,serie, noalta as cliente ,filler ,fechaprog,nomb_factura as archivoXML,ruta_factura as rutaXML,msgWeb   FROM [monkeyland].[dbo].[facturasMuguerza] where fechaprog between @fechaIni and @fechaFin order by fechaprog
END

GO

