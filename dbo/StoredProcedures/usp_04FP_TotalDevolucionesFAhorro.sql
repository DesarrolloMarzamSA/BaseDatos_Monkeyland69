-- =============================================
-- Author: Francisco Roberto Martínez Hernández 
-- Update date: 
-- Create date: 03/0472019
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_04FP_TotalDevolucionesFAhorro]
@IdUsuario VARCHAR(20),
@Periodo INT
AS
BEGIN

    IF EXISTS(SELECT TOP 1 1 FROM [dbo].[ControlFacturaPerfectaFAhorro] WITH(NOLOCK) WHERE Periodo = @Periodo AND IdProceso = 3 AND IdEstado <> 2 )
	BEGIN 
		RAISERROR('¡El paso anterior a este proceso no se ha finalizado, validar el flujo de ejecución!',16,1);
		RETURN;
	END
	ELSE IF EXISTS(SELECT TOP 1 1 FROM [dbo].[ControlFacturaPerfectaFAhorro] WITH(NOLOCK) WHERE Periodo = @Periodo AND IdProceso = 5 AND IdEstado > 0  )
	BEGIN 
		RAISERROR('¡El paso siguiente a este proceso se esta realizando o ya finalizo, validar el flujo de ejecución!',16,1);
		RETURN;
	END
    ELSE IF EXISTS(SELECT TOP 1 1 FROM [dbo].[ControlFacturaPerfectaFAhorro] WITH(NOLOCK) WHERE Periodo = @Periodo AND IdProceso = 4 AND IdEstado IN (1,4) )
	BEGIN 
		RAISERROR('¡Ya se esta realizando un proceso 04[ObtenerTotalDevoluciones] para este periodo favor de esperar el resultado!',16,1);
		RETURN;
	END
	ELSE IF EXISTS(SELECT TOP 1 1 FROM [dbo].[ControlFacturaPerfectaFAhorro] WITH(NOLOCK) WHERE Periodo = @Periodo AND IdProceso = 4 AND IdEstado = 2)
	BEGIN 
		RAISERROR('¡Ya se finalizó este proceso 04[ObtenerTotalDevoluciones] para este periodo favor de actualizar el resultado!',16,1);
		RETURN;
	END
	
	--Se activa bandera para ser procesado por un JOB
	UPDATE [dbo].[ControlFacturaPerfectaFAhorro]  
		  SET 
		   [Usuario] = @IdUsuario, 
		   [UltimaEjecucion] = GETDATE(), 
		   [IdEstado]=CASE WHEN [IdEstado] = 0 THEN 1 WHEN [IdEstado] = 3 THEN 4 END ,
		   [Intento] =(ISNULL([Intento],0)+1),
		   [Procesar] = 1
		WHERE Periodo = @Periodo AND IdProceso = 4
END

GO

