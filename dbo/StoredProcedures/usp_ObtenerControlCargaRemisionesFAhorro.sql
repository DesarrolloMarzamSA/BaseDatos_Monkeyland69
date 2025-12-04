-- =============================================
-- Author: Francisco Roberto Martínez Hernández
-- Create date: 28/03/2019
-- Description:	obtiene el historico de las extracciones que se han realizado
-- Exec [dbo].[usp_ObtenerControlCargaRemisionesFAhorro]
-- =============================================
CREATE PROCEDURE [dbo].[usp_ObtenerControlCargaRemisionesFAhorro]
AS
BEGIN

      SELECT TOP 100 CC.[ID],CC.[Usuario],CC.[InicioCarga],CC.[FinCarga],CC.[IdEstado],E.[Estado],CC.[Intento],CC.[UltimaEjecucion],CC.[FechaRegistro],CC.[Procesar]
        FROM [dbo].[ControlCargaRemisionesFAhorro] CC
	  INNER JOIN [dbo].[EstadosCargaRemisiones] E ON E.ID = CC.IdEstado	 
	  ORDER BY CC.[UltimaEjecucion] DESC 	
END

GO

