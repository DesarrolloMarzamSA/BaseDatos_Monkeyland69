-- =============================================
-- Author: Francisco Roberto Martínez Hernández
-- Create date: 28/03/2019
-- Description:	obtiene el historico del proceso de la factura perfecta con el periodo especifico
-- Exec [dbo].[usp_ObtenerControlFacturaPerfecta] 313
-- =============================================
CREATE PROCEDURE [dbo].[usp_ObtenerControlFacturaPerfecta]
@Periodo int
AS
BEGIN

      IF NOT EXISTS(SELECT TOP 1 1 FROM [dbo].[ControlFacturaPerfectaFAhorro] WHERE Periodo = @Periodo)
	  BEGIN
		INSERT INTO [dbo].[ControlFacturaPerfectaFAhorro]
        ([Periodo],[OrdenEjecucion],[IdProceso],[IdEstado])
        SELECT @Periodo,[OrdenEjecucion],[ID],0 FROM  [dbo].[ProcesosFacturaPerfectaFAhorro]
        
	  END
	
      SELECT C.[Id],C.[Periodo],C.[OrdenEjecucion],C.[IdProceso],P.[Proceso],C.[IdEstado],E.[Estado],C.[Mensaje],C.[Usuario]
			,C.[Intento],C.[TotalFAhorro],C.[TotalMarzam],C.[Diferencia],C.[UltimaEjecucion]
			,C.[FechaRegistro],C.[Procesar]
	  FROM [dbo].[ControlFacturaPerfectaFAhorro] C
	   INNER JOIN [dbo].[ProcesosFacturaPerfectaFAhorro] P ON P.Id = C.[IdProceso] AND P.BorradoLogico = 0
	   LEFT JOIN [dbo].[EstadosFacturaPerfecta] E on E.Id = C.[IdEstado] AND E.BorradoLogico = 0
	  WHERE Periodo = @Periodo
END

GO

