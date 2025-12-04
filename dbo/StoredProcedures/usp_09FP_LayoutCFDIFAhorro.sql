-- =============================================
-- Author: Francisco Roberto Martínez Hernández 
-- Update date: 
-- Create date: 03/0472019
-- Description:	
-- =============================================
create PROCEDURE [dbo].[usp_09FP_LayoutCFDIFAhorro]
@IdUsuario VARCHAR(20),
@Periodo INT
AS
BEGIN

    IF EXISTS(SELECT TOP 1 1 FROM [dbo].[ControlFacturaPerfectaFAhorro] WITH(NOLOCK) WHERE Periodo = @Periodo AND IdProceso = 8 AND IdEstado <> 2 )
	BEGIN 
		RAISERROR('¡El paso anterior a este proceso no se ha finalizado, validar el flujo de ejecución!',16,1);
		RETURN;
	END	
    ELSE IF EXISTS(SELECT TOP 1 1 FROM [dbo].[ControlFacturaPerfectaFAhorro] WITH(NOLOCK) WHERE Periodo = @Periodo AND IdProceso = 8 AND Diferencia > 0 /* AND Diferencia <> 0*/ )
	BEGIN 
		RAISERROR('¡No se puede realizar este proceso 09[GenerarLayoutCFDI] ya que existe diferencía!',16,1);
		RETURN;
	END
	IF EXISTS(SELECT TOP 1 1 FROM [dbo].[ControlFacturaPerfectaFAhorro] WITH(NOLOCK) WHERE Periodo = @Periodo AND IdProceso = 9 AND IdEstado IN (1,4) )
	BEGIN 
		RAISERROR('¡Ya se esta realizando un proceso 09[GenerarLayoutCFDI] para este periodo favor de esperar el resultado!',16,1);
		RETURN;
	END
	--ELSE IF EXISTS(SELECT TOP 1 1 FROM [dbo].[ControlFacturaPerfectaFAhorro] WITH(NOLOCK) WHERE Periodo = @Periodo AND IdProceso = 9 AND IdEstado = 2)
	--BEGIN 
	--	RAISERROR('¡Ya se finalizó este proceso 09[GenerarLayoutCFDI3] para este periodo favor de actualizar el resultado!',16,1);
	--	RETURN;
	--END

	--IF EXISTS(SELECT TOP 1 1 FROM detalle_fahorroFacturasCopiaPeriodo WHERE PERIODO = @Periodo)
	--  DELETE detalle_fahorroFacturasCopiaPeriodo WHERE PERIODO = @Periodo
	
	--Se activa bandera para ser procesado por un JOB
	UPDATE [dbo].[ControlFacturaPerfectaFAhorro]  
		  SET 
		   [Usuario] = @IdUsuario, 
		   [UltimaEjecucion] = GETDATE(), 
		   [IdEstado]=CASE WHEN [IdEstado] = 0 THEN 1 WHEN [IdEstado] = 3 THEN 4 ELSE 4 END ,
		   [Intento] =(ISNULL([Intento],0)+1),
		   [Procesar] = 1
		WHERE Periodo = @Periodo AND IdProceso = 9
END

GO

