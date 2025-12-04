-- =============================================
-- Author: Francisco Roberto Martínez Hernández 
-- Update date: 
-- Create date: 03/0472019
-- Description:	
/*
 EXEC [dbo].[JOB_Paso04FacturaPerfectaFAhorro]
*/
-- =============================================
CREATE PROCEDURE [dbo].[JOB_Paso04FacturaPerfectaFAhorro]
AS
BEGIN

    DECLARE
    @IdUsuario VARCHAR(20),
    @Periodo INT = 0,
	@Id INT = 0,
	@TotalFAhorro decimal(20,2)=0.00,	
	@TotalMarzam decimal(20,2)=0.00

	 WHILE EXISTS(SELECT TOP 1 1 FROM [dbo].[ControlFacturaPerfectaFAhorro] WHERE IdProceso = 4 AND IdEstado in (1,4) AND Procesar = 1)
	 BEGIN 
		SET @IdUsuario = NULL
		SET @Periodo  = NULL
        SET @Id = 0
		SET @TotalFAhorro = 0.00
		SET @TotalMarzam = 0.00

		SELECT TOP 1 @Id = Id, @IdUsuario = [Usuario], @Periodo = [Periodo] FROM [dbo].[ControlFacturaPerfectaFAhorro] WHERE IdProceso = 4 AND IdEstado in (1,4) AND Procesar = 1
		/*INICIA PROCESO */		
		BEGIN TRY
		    UPDATE [dbo].[ControlFacturaPerfectaFAhorro] SET [Procesar] = 0 WHERE  Id = @Id

				/************** Cuerpo del proceso ***************/
				DECLARE @Tbl_TotalesMarzam AS TABLE(
				totalBrutoExento decimal(20,2),	totalBrutoGravado decimal(20,2), totalPiezas numeric(20,0),	totalBruto decimal(20,2), totalNeto decimal(20,2), totalDescuento decimal(20,2),
				totalImpuesto decimal(20,2), baseTrasladoIVA decimal(20,2),	tasaIVA decimal(20,2),	brutoIVA decimal(20,2),	descIVA decimal(20,2), netoIVA decimal(20,2), baseTrasladoIEPS decimal(20,2),
				tasaIEPS decimal(20,2), brutoIEPS	decimal(20,2),	descIEPS decimal(20,2), netoIEPS decimal(20,2), totalNetoSIVA decimal(20,2), totalDescuento2 decimal(20,2),	totalAlcohol decimal(20,2),
				totalLineas	decimal(20,2), descExento decimal(20,2), netoExento	decimal(20,2), descGravado decimal(20,2), netoGravado decimal(20,2), totalAjuste decimal(20,2), totalPrecioPublic decimal(20,2),
				totalOfer	decimal(20,2), totalOferProctj decimal(20,2), totalOferPz decimal(20,2), totalBasicSIVA	decimal(20,2), totalNetoCIVA decimal(20,2), totalBruto2 decimal(20,2), subtotal decimal(20,2),
				tasaIEPS1 decimal(20,2), importeIEPS1 decimal(20,2), baseIEPS1 decimal(20,2), tasaIEPS2	decimal(20,2), importeIEPS2	decimal(20,2), baseIEPS2 decimal(20,2), C29_netoExento decimal(20,2),
				C30_descGravado decimal(20,2), C31_netoGravado decimal(20,2)
				)

				INSERT INTO @Tbl_TotalesMarzam EXEC [dbo].[usp_obtener_totalesFahorro] @Periodo
				
				SELECT @TotalMarzam = totalNeto FROM @Tbl_TotalesMarzam
				SELECT @TotalFAhorro = sum(totalRemisionIVA) FROM [monkeyland].[dbo].[TotalPeriodoAhorro] WITH(NOLOCK) WHERE periodo = @Periodo
				/************** Cuerpo del proceso ***************/

			UPDATE [dbo].[ControlFacturaPerfectaFAhorro] SET [IdEstado] = 2,  TotalMarzam = @TotalMarzam, TotalFAhorro = @TotalFAhorro WHERE Id = @Id
		END TRY
		BEGIN CATCH
			IF EXISTS(SELECT TOP 1 1 FROM [dbo].[ControlFacturaPerfectaFAhorro] WHERE Id = @Id)
			  UPDATE [dbo].[ControlFacturaPerfectaFAhorro] SET [IdEstado] = 3, Mensaje = ERROR_MESSAGE() WHERE Id = @Id
		END CATCH
		/*FINALIZA PROCESO */		
	 END	
END

GO

