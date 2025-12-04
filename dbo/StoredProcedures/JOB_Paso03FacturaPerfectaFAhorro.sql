-- =============================================
-- Author: Francisco Roberto Martínez Hernández 
-- Update date: 
-- Create date: 03/0472019
-- Description:	
/*
 EXEC [dbo].[JOB_Paso03FacturaPerfectaFAhorro]
*/
-- =============================================
CREATE PROCEDURE [dbo].[JOB_Paso03FacturaPerfectaFAhorro]
AS
BEGIN

    DECLARE
    @IdUsuario VARCHAR(20),
    @Periodo INT = 0,
	@Id INT = 0

	 WHILE EXISTS(SELECT TOP 1 1 FROM [dbo].[ControlFacturaPerfectaFAhorro] WHERE IdProceso = 3 AND IdEstado in (1,4) AND Procesar = 1)
	 BEGIN 
		SET @IdUsuario = NULL
		SET @Periodo  = NULL
        SET @Id = 0

		SELECT TOP 1 @Id = Id, @IdUsuario = [Usuario], @Periodo = [Periodo] FROM [dbo].[ControlFacturaPerfectaFAhorro] WHERE IdProceso = 3 AND IdEstado in (1,4) AND Procesar = 1
		/*INICIA PROCESO */		
		BEGIN TRY
		    UPDATE [dbo].[ControlFacturaPerfectaFAhorro] SET [Procesar] = 0 WHERE  Id = @Id

				/************** Cuerpo del proceso ***************/
				--select *, IDINVN,FACTURA,IVA from detalle_fahorroFacturas where periodo =313  and recalculo=1  --(Devolucion parcial)
				--Se concilian todas las devoluciones (en el cuerpo de este store)
				EXEC [dbo].[spr_FarmAhorroConciDevoluciones] @Periodo 
				/************** Cuerpo del proceso ***************/

			UPDATE [dbo].[ControlFacturaPerfectaFAhorro] SET [IdEstado] = 2 WHERE Id = @Id
		END TRY
		BEGIN CATCH
			IF EXISTS(SELECT TOP 1 1 FROM [dbo].[ControlFacturaPerfectaFAhorro] WHERE Id = @Id)
			  UPDATE [dbo].[ControlFacturaPerfectaFAhorro] SET [IdEstado] = 3, Mensaje = ERROR_MESSAGE() WHERE Id = @Id
		END CATCH
		/*FINALIZA PROCESO */		
	 END	
END

GO

