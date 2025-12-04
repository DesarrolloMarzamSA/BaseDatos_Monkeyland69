-- =============================================
-- Author: Francisco Roberto Martínez Hernández 
-- Update date: 
-- Create date: 03/0472019
-- Description:	
/*
 EXEC [dbo].[JOB_Paso07FacturaPerfectaFAhorro]
*/
-- =============================================
CREATE PROCEDURE [dbo].[JOB_Paso07FacturaPerfectaFAhorro]
@IdUsuario VARCHAR(20),
@Periodo INT,
@TblConciliarManual [TableType_ConciliarManualFAhorro] READONLY
AS
BEGIN
    	
	IF EXISTS(SELECT TOP 1 1 
				 FROM [dbo].[ControlFacturaPerfectaFAhorro] C WITH(NOLOCK) 
				 JOIN [dbo].[ProcesosFacturaPerfectaFAhorro] P WITH(NOLOCK)  ON P.PAntecesor = C.IdProceso
				WHERE C.Periodo = @Periodo AND P.Id = 7 AND C.IdEstado <> 2 )
	BEGIN 
		RAISERROR('¡El paso minimo anterior necesario a este proceso no se ha finalizado 04[ObtenerTotalDevoluciones], validar el flujo de ejecución!',16,1);
		RETURN;
	END
	--ELSE IF EXISTS(SELECT TOP 1 1 FROM [dbo].[ControlFacturaPerfectaFAhorro] WITH(NOLOCK) WHERE Periodo = @Periodo AND IdProceso = 8 AND IdEstado > 0  )
	--BEGIN 
	--	RAISERROR('¡El paso siguiente a este proceso se esta realizando o ya finalizo, validar el flujo de ejecución!',16,1);
	--	RETURN;
	--END 
	ELSE IF NOT EXISTS(SELECT TOP 1 1 FROM @TblConciliarManual WHERE PERIODO = @Periodo AND RECALCULO = 9)
	BEGIN 
		RAISERROR('¡No se encontro ningun registro para modificar con el periodo indicado!',16,1);
		RETURN;
	END
		
    
		BEGIN TRY		  
		    --select * from  @TblConciliarManual
				--/************** Cuerpo del proceso ***************/
				MERGE detalle_fahorroFacturas T
				USING (
						SELECT Id,SUCURSAL,SERIE,IDCUNO,FACTURA,IDLINE,IDPRDC,IDQTY,FARMACIA,PRECIO_CANTIDAD
								,ROUND(CAST(ISNULL(RTRIM(DESCCOMERCIAL),0) AS DECIMAL(18,4)), 2, 1) AS DESCCOMERCIAL
								,ROUND(CAST(ISNULL(RTRIM(DESCCOMERCIALPESOS),0) AS DECIMAL(18,4)), 2, 1) AS DESCCOMERCIALPESOS
								, IHOREF, PERIODO, RECALCULO
						FROM @TblConciliarManual WHERE PERIODO = @Periodo AND RECALCULO = 9
				) S
				ON (T.[Id] = S.[Id]  AND T.PERIODO = S.PERIODO AND T.[FACTURA] = S.[FACTURA] AND T.[IDLINE] = S.[IDLINE])	
	            WHEN MATCHED THEN
			    UPDATE
				   SET
				    T.DESCCOMERCIAL=CAST(S.DESCCOMERCIAL AS VARCHAR),
					T.DESCCOMERCIALPESOS=CAST(S.DESCCOMERCIALPESOS AS VARCHAR),
					T.RECALCULO=9;
					
		
		        DECLARE @TotalDescComModificado AS DECIMAL(18,2) =0
			      SELECT @TotalDescComModificado = SUM(CAST(ISNULL(RTRIM(DescComercialPesos),0) AS DECIMAL(18,2)))
			    FROM detalle_fahorroFacturas where recalculo=9 and  periodo = @Periodo 			
				--/************** Cuerpo del proceso ***************/
         
				UPDATE [dbo].[ControlFacturaPerfectaFAhorro] 
						 SET [IdEstado] = 2,
							 [Procesar] = 0,
							 [Mensaje]= 'TotalDescComModificado:'+ CAST(@TotalDescComModificado AS VARCHAR),
							 [Usuario] = @IdUsuario,
							 [UltimaEjecucion] = GETDATE()
							 --[Intento] = (ISNULL([Intento],0)+1)  
						WHERE Periodo = @Periodo AND IdProceso = 7
		END TRY
		BEGIN CATCH
			IF EXISTS(SELECT TOP 1 1 FROM [dbo].[ControlFacturaPerfectaFAhorro] WHERE Periodo = @Periodo AND IdProceso = 7)
			UPDATE [dbo].[ControlFacturaPerfectaFAhorro] SET [IdEstado] = 3, Mensaje = ERROR_MESSAGE() WHERE Periodo = @Periodo AND IdProceso = 7
		END CATCH
		
END

GO

