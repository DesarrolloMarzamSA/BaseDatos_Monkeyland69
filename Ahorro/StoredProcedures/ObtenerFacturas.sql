

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Ahorro].[ObtenerFacturas]
@fechaFactura varchar(10)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;
	SET DATEFORMAT dmy;
	
	SELECT cuentaEstiloAhorro, orden, nombreArchivo, contenido, fechaFactura 
	FROM [Ahorro].[encabezadoFacturasAhorro] 
	WHERE fechaFactura >= @fechaFactura;
END

GO

