-- =============================================
-- Author: Francisco Roberto Martínez Hernández
-- Create date: 28/03/2019
-- Description:	obtiene la configuracion de los pasos a seguir en la factura perfecta de farmacias del ahorro
-- Exec [dbo].[usp_PasosFacturaPerfectaFAhorro]
-- =============================================
CREATE PROCEDURE [dbo].[usp_PasosFacturaPerfectaFAhorro]
AS
BEGIN

		SELECT [Id],[OrdenEjecucion],[Proceso],[Descripcion],[PAntecesor],[PSucesor],[ValidaAntecesor],[ValidaSucesor],[FechaRegistro]
		FROM [dbo].[ProcesosFacturaPerfectaFAhorro] 
		WHERE [BorradoLogico]=0

END

GO

