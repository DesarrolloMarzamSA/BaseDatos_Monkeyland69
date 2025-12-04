-- =============================================
-- Author: Francisco Roberto Martínez Hernández 
-- Update date: 
-- Create date: 03/0472019
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_07FP_ConciliarManualFAhorro]
@IdUsuario VARCHAR(20),
@Periodo INT
AS
BEGIN

    IF EXISTS( SELECT TOP 1 1 
				 FROM [dbo].[ControlFacturaPerfectaFAhorro] C WITH(NOLOCK) 
				 JOIN [dbo].[ProcesosFacturaPerfectaFAhorro] P WITH(NOLOCK)  ON P.PAntecesor = C.IdProceso
				WHERE C.Periodo = @Periodo AND P.Id = 7 AND C.IdEstado <> 2
	)
	BEGIN 
		RAISERROR('¡El paso minimo anterior necesario a este proceso no se ha finalizado 04[ObtenerTotalDevoluciones], validar el flujo de ejecución!',16,1);
		RETURN;
	END
	ELSE IF EXISTS(SELECT TOP 1 1 FROM [dbo].[ControlFacturaPerfectaFAhorro] WITH(NOLOCK) WHERE Periodo = @Periodo AND IdProceso = 8 AND IdEstado > 0  )
	BEGIN 
		RAISERROR('¡El paso siguiente a este proceso se esta realizando o ya finalizo, validar el flujo de ejecución!',16,1);
		RETURN;
	END
 --   ELSE IF EXISTS(SELECT TOP 1 1 FROM [dbo].[ControlFacturaPerfectaFAhorro] WITH(NOLOCK) WHERE Periodo = @Periodo AND IdProceso = 7 AND IdEstado IN (1,4) )
	--BEGIN 
	--	RAISERROR('¡Ya se genero el archivo proceso 07[GenerarConciliarManual] para este periodo favor de esperar el resultado!',16,1);
	--	RETURN;
	--	/*EXISTS(SELECT TOP 1 1 FROM [dbo].[ControlFacturaPerfectaFAhorro] WHERE IdProceso = 5 AND IdEstado in (1,4) AND Procesar = 1)*/
	--END
	ELSE IF EXISTS(SELECT TOP 1 1 FROM [dbo].[ControlFacturaPerfectaFAhorro] WITH(NOLOCK) WHERE Periodo = @Periodo AND IdProceso = 7 AND IdEstado = 2)
	BEGIN 
		RAISERROR('¡Ya se finalizó este proceso 07[GenerarConciliarManual] para este periodo favor de actualizar el resultado, o modifique las cantidades con el archivo generado anteriormente!',16,1);
		RETURN;
	END
	
	--Se activa bandera para poder subir la conciliacion manual
	UPDATE [dbo].[ControlFacturaPerfectaFAhorro]  
		  SET 
		   [Usuario] = @IdUsuario, 
		   [UltimaEjecucion] = GETDATE(), 
		   [IdEstado] = CASE WHEN [IdEstado] = 0 THEN 1 WHEN [IdEstado] = 3 THEN 4 ELSE 4 END ,
		   [Intento] = (ISNULL([Intento],0)+1),
		   [Procesar] = 1
		WHERE Periodo = @Periodo AND IdProceso = 7

    --Se modifican las columnas [DESCCOMERCIAL, DescComercialPesos] y [recalculo=9(Para indicar cambio en DescComercial manual)] 
	--para hacer que cuadre el total con el wizard de sql(edicion de filas)
	BEGIN TRY
			SELECT TOP (500) Id,SUCURSAL,SERIE,IDCUNO,FACTURA,IDLINE,IDPRDC,IDQTY,FARMACIA
							   ,PRECIO_CANTIDAD,DESCCOMERCIAL,DESCCOMERCIALPESOS, IHOREF, PERIODO, RECALCULO
			FROM detalle_fahorroFacturas
			WHERE (PERIODO = @Periodo) AND IVA NOT IN (8,16) AND (CAST(ISNULL(DESCOFERTA, 0) AS money) <= 0) AND (CAST(ISNULL(DescComercialPesos, 0) AS money) <= 0) AND RECALCULO IS NULL 
			ORDER BY CAST(ISNULL(DESCOFERTA,0) AS DECIMAL), PRECIO_CANTIDAD DESC,SUCURSAL
	END TRY
	BEGIN CATCH
		IF EXISTS(SELECT TOP 1 1 FROM [dbo].[ControlFacturaPerfectaFAhorro] WHERE Periodo = @Periodo AND IdProceso = 7)
			UPDATE [dbo].[ControlFacturaPerfectaFAhorro] SET [IdEstado] = 3, Mensaje = ERROR_MESSAGE() WHERE Periodo = @Periodo AND IdProceso = 7
	END CATCH
END

GO

