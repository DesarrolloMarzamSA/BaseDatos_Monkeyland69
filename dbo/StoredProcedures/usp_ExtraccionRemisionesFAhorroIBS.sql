-- =============================================
-- Author: Francisco Roberto Martínez Hernández
-- Create date: 28/03/2019
-- Description:	obtiene detalle de Facturacion de Farmacias del ahorro y controla la transaccion de extracciones de IBS
-- Exec [usp_ExtraccionRemisionesFAhorroIBS] 
-- =============================================
CREATE PROCEDURE [dbo].[usp_ExtraccionRemisionesFAhorroIBS]
AS
BEGIN

	SET NOCOUNT ON;
	DECLARE
	@IdUsuario VARCHAR(20),
    @FechaInicial DATE,
    @FechaFinal DATE

	 WHILE EXISTS(SELECT TOP 1 1 FROM [ControlCargaRemisionesFAhorro] WHERE Procesar = 1)
	 BEGIN 
		SET @IdUsuario = NULL
		SET @FechaInicial  = NULL
        SET @FechaFinal  = NULL
		SELECT TOP 1 @IdUsuario = [Usuario], @FechaInicial = [InicioCarga], @FechaFinal = [FinCarga] FROM [ControlCargaRemisionesFAhorro] WHERE Procesar = 1
		/*INICIA PROCESO */		
		BEGIN TRY
		    UPDATE [dbo].[ControlCargaRemisionesFAhorro] SET [Procesar] = 0 WHERE [Usuario] = @IdUsuario AND  [InicioCarga] = @FechaInicial AND [FinCarga] = @FechaFinal
			--Se ejecuta la extraccion con el rango de fechas indicado
			EXEC [dbo].[usp_ObtenerDetalleRemisionesFAhorroIBS] @FechaInicial,@FechaFinal

			UPDATE [dbo].[ControlCargaRemisionesFAhorro] SET [IdEstado] = 2 WHERE [Usuario] = @IdUsuario AND  [InicioCarga] = @FechaInicial AND [FinCarga] = @FechaFinal
		END TRY
		BEGIN CATCH
			IF EXISTS(SELECT TOP 1 1 FROM [dbo].[ControlCargaRemisionesFAhorro] WHERE [Usuario] = @IdUsuario AND  [InicioCarga] = @FechaInicial AND [FinCarga] = @FechaFinal)
			  UPDATE [dbo].[ControlCargaRemisionesFAhorro] SET [IdEstado] = 3 WHERE [Usuario] = @IdUsuario AND  [InicioCarga] = @FechaInicial AND [FinCarga] = @FechaFinal
		END CATCH
		/*FINALIZA PROCESO */		
	 END	
END

GO

