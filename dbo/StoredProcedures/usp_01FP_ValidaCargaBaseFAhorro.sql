-- =============================================
-- Author: Francisco Roberto Martínez Hernández 
-- Update date: 
-- Create date: 03/0472019
-- Description:	
/*
 EXEC [dbo].[usp_01FP_ValidaCargaBaseFAhorro] '35556', 313
 */
-- =============================================
CREATE PROCEDURE [dbo].[usp_01FP_ValidaCargaBaseFAhorro]
@IdUsuario VARCHAR(20),
@Periodo INT
AS
BEGIN

    IF EXISTS(SELECT TOP 1 1 FROM [dbo].[ControlFacturaPerfectaFAhorro] WITH(NOLOCK) WHERE Periodo = @Periodo AND IdProceso = 1 AND IdEstado IN (1,4) )
	BEGIN 
		RAISERROR('¡Ya se esta realizando un proceso 01[ValidaCargaBase] para este periodo favor de esperar el resultado!',16,1);
		RETURN;
	END
	ELSE IF EXISTS(SELECT TOP 1 1 FROM [dbo].[ControlFacturaPerfectaFAhorro] WITH(NOLOCK) WHERE Periodo = @Periodo AND IdProceso = 1 AND IdEstado = 2)
	BEGIN 
		RAISERROR('¡Ya se finalizó este proceso 01[ValidaCargaBase] para este periodo favor de actualizar el resultado!',16,1);
		RETURN;
	END
	
    DECLARE @RegistrosTP INT = 0,
	        @RegistrosDD INT = 0,
			@RemisionesFaltantes INT=0

	SELECT @RegistrosTP = COUNT(1) 
	 FROM [monkeyland].[dbo].[TotalPeriodoAhorro]  WITH(NOLOCK) WHERE periodo = @Periodo
	IF(ISNULL(@RegistrosTP,0)<=0)
	BEGIN 	   
		RAISERROR('¡[TotalPeriodo] No se encontraron registros con el periodo indicado!',16,1);
		RETURN;
	END

	SELECT @RegistrosDD = COUNT(1) 
	 FROM [monkeyland].[dbo].[DiferenciaDevolucionesAhorro]  WITH(NOLOCK) WHERE periodo = @Periodo	
	IF(ISNULL(@RegistrosTP,0)<=0)
	BEGIN 	   
		RAISERROR('¡[Devoluciones] No se encontraron registros con el periodo indicado!',16,1);
		RETURN;
	END

	SELECT DISTINCT @RemisionesFaltantes = COUNT(tp.remision)	
	FROM [dbo].[TotalPeriodoAhorro] tp  WITH(NOLOCK)
	 LEFT JOIN detalle_fahorroFacturas df WITH(NOLOCK) ON tp.[remision] = df.idinvn 
	WHERE tp.periodo = @Periodo AND df.idinvn IS NULL 
	
	IF(ISNULL(@RemisionesFaltantes,0)>0)
	BEGIN 	  
	     DECLARE @MsjRemisiones VARCHAR(150) ='' 		   	 
		 SELECT  DISTINCT TOP 10 @MsjRemisiones = @MsjRemisiones + tp.remision +','	
	      FROM [dbo].[TotalPeriodoAhorro] tp
	       LEFT JOIN detalle_fahorroFacturas df  on tp.[remision] = df.idinvn 
	     WHERE tp.periodo = @Periodo and df.idinvn is null 

		 SET @MsjRemisiones = SUBSTRING(@MsjRemisiones,1,(LEN(@MsjRemisiones)-1))
		 SET @MsjRemisiones = '¡Faltan ('+ CAST(@RemisionesFaltantes AS VARCHAR) +') remisiones analize el rango de extracción [03 RemisionesIBS] Remisiones:'+ @MsjRemisiones +'... !'

	   RAISERROR(@MsjRemisiones,16,1);
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
		WHERE Periodo = @Periodo AND IdProceso = 1
END

GO

