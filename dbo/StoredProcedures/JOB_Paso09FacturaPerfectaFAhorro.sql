-- =============================================
-- Author: Francisco Roberto Martínez Hernández 
-- Update date: 
-- Create date: 03/0472019
-- Description:	
/*
 EXEC [dbo].[JOB_Paso09FacturaPerfectaFAhorro]
*/
-- =============================================
CREATE PROCEDURE [dbo].[JOB_Paso09FacturaPerfectaFAhorro]
@IdUsuario VARCHAR(20),
@Periodo INT
AS
BEGIN
    	
	IF EXISTS(SELECT TOP 1 1 FROM [dbo].[ControlFacturaPerfectaFAhorro] WITH(NOLOCK) WHERE Periodo = @Periodo AND IdProceso = 8 AND IdEstado <> 2 )
	BEGIN 
		RAISERROR('¡El paso anterior a este proceso no se ha finalizado, validar el flujo de ejecución!',16,1);
		RETURN;
	END	
    ELSE IF EXISTS(SELECT TOP 1 1 FROM [dbo].[ControlFacturaPerfectaFAhorro] WITH(NOLOCK) WHERE Periodo = @Periodo AND IdProceso = 8 AND Diferencia > 0/*AND Diferencia <> 0*/ )
	BEGIN 
		RAISERROR('¡No se puede realizar este proceso 09[GenerarLayoutCFDI] ya que existe diferencía!',16,1);
		RETURN;
	END
		    
		BEGIN TRY		  		  
					
			IF EXISTS(SELECT TOP 1 1 FROM detalle_fahorroFacturasCopiaPeriodo WHERE PERIODO = @Periodo)
	           DELETE detalle_fahorroFacturasCopiaPeriodo WHERE PERIODO = @Periodo
	
			--Se activa bandera para ser procesado por un JOB
			UPDATE [dbo].[ControlFacturaPerfectaFAhorro]  
			  SET 
			   [Usuario] = @IdUsuario, 
			   [UltimaEjecucion] = GETDATE(), 
			   [IdEstado]=2,			
			   [Procesar] = 0
			WHERE Periodo = @Periodo AND IdProceso = 9
		END TRY
		BEGIN CATCH
			IF EXISTS(SELECT TOP 1 1 FROM [dbo].[ControlFacturaPerfectaFAhorro] WHERE Periodo = @Periodo AND IdProceso = 9)
			UPDATE [dbo].[ControlFacturaPerfectaFAhorro] SET [IdEstado] = 3, Mensaje = ERROR_MESSAGE() WHERE Periodo = @Periodo AND IdProceso = 9
		END CATCH
		
END

GO

