-- =============================================
-- Author: Francisco Roberto Martínez Hernández 
-- Update date: 
-- Create date: 11/09/2024
-- Description:	
/*
 EXEC [dbo].[JOB_Paso10FacturaPerfectaFAhorro]
*/
-- =============================================
CREATE PROCEDURE [dbo].[JOB_Paso10FacturaPerfectaFAhorro]
AS
BEGIN
    DECLARE
    @IdUsuario VARCHAR(20),
    @Periodo INT = 0,
	@Id INT = 0,
	@TotalFAhorro decimal(20,2)=0.00,	
	@TotalMarzam decimal(20,2)=0.00

	 WHILE EXISTS(SELECT TOP 1 1 FROM [dbo].[ControlFacturaPerfectaFAhorro] WHERE IdProceso = 10 AND IdEstado in (1,4) AND Procesar = 1)
	 BEGIN 
		SET @IdUsuario = NULL
		SET @Periodo  = NULL
        SET @Id = 0	

		SELECT TOP 1 @Id = Id, @IdUsuario = [Usuario], @Periodo = [Periodo] FROM [dbo].[ControlFacturaPerfectaFAhorro] WHERE IdProceso = 10 AND IdEstado in (1,4) AND Procesar = 1
		/*INICIA PROCESO */		
		BEGIN TRY
		    UPDATE [dbo].[ControlFacturaPerfectaFAhorro] SET [Procesar] = 0 WHERE  Id = @Id

				/************** Cuerpo del proceso ***************/
				--Se mandan los totales de este periodo a la tabla [CPagoAhorro].[TotalesFacturaPerfecta] 
				EXEC  CPagoAhorro.usp_obtener_totalesTrama03 @Periodo
				--Se envian los datos a IBS por openquery en caso que no exista el periodo en curso
				IF EXISTS(SELECT FTPER FROM OPENQUERY(AS400,'SELECT FTPER,FTSTS FROM MA4620EP.Z3OFACACUI') WHERE FTPER = @Periodo AND FTSTS = 0)
				BEGIN 
					PRINT ' => SI EXISTE u_U'
								UPDATE AS4
								SET 
									AS4.FTCSTS = CASE  WHEN T.C13_Tasa_iva = 0.16 THEN '826'   
														WHEN T.C13_Tasa_iva = 0.08 THEN '808' 
													END,
									AS4.FTPER  = T.Periodo,
									AS4.FTSER  = S.ValorPredefinido,
									AS4.FTINVN = CONCAT(
													CASE WHEN T.C13_Tasa_iva=0.16 THEN '826'  
									  					WHEN T.C13_Tasa_iva=0.08 THEN '808'
													END,
													RIGHT(CONCAT('000000000000',PERIODO),9)
													),
									AS4.FTFEC  = CONVERT(VARCHAR(10),T.FechaPeriodo, 112),
									AS4.FTRFC  = RfcR.ValorPredefinido,
									AS4.FTTOB  = T.C42_Total_Bruto,               
									AS4.FTTON  = T.C6_Total_neto,                 
									AS4.FTTIVA = T.C10_Tipo_iva,                  
									AS4.FTTOI  = T.C9_Total_impuestos,            
									AS4.FTTIV  = T.C13_Tasa_iva,                  
									AS4.FTBIV  = T.C12_Base_Traslado,             
									AS4.FTIVA  = T.C14_Bruto_iva,                 
									AS4.FTDES  = T.C25_Total_descuento_comercial, 
									AS4.FTI08  = ISNULL(T.C55_Tasa_IEPS1,0),        
									AS4.FTINE  = ISNULL(T.C56_Importe_NETO_IEPS1,0),
									AS4.FTTIMP = T.C57_Impuesto,                    
									AS4.FTBIE  = ISNULL(T.C59_Base,0),              
									AS4.FTI25  = ISNULL(T.C60_Tasa_IEPS2,0),        
									AS4.FTINI  = ISNULL(T.C61_Importe_NETO_IEPS2,0),
									AS4.FTTIMT = T.C62_Impuesto ,                   
									AS4.FTBAS  = ISNULL(T.C64_Base,0),              
									AS4.FTTIM  = ISNULL(T.C65_Tasa0,0),             
									AS4.FTI00  = ISNULL(T.C66_Importe_Tasa0,0),     
									AS4.FTTI0  = T.C67_Impuesto,                    
									AS4.FTBA0  = ISNULL(T.C69_Base_Tasa0,0),        
									AS4.FTFCH  = CONVERT(VARCHAR(10),FechaActualizacion, 112),
									AS4.FTHOR  = FORMAT(FechaActualizacion,'HHmmss')
									--AS4.FTSTS  = 0  /*Solo pruebas no se debe modificar*/
             				FROM OPENQUERY(AS400,'SELECT 
             									FTCSTS,FTPER,FTSER,FTINVN,FTFEC,FTRFC,FTTOB,FTTON,FTTIVA,FTTOI,FTTIV,FTBIV,FTIVA,FTDES,FTI08,FTINE,FTTIMP,FTBIE,FTI25,FTINI,FTTIMT,FTBAS,FTTIM,FTI00,FTTI0,FTBA0,FTFCH,FTHOR,FTSTS
             									FROM MA4620EP.Z3OFACACUI') AS4								 
             				INNER JOIN [CPagoAhorro].[TotalesFacturaPerfecta] T ON T.Periodo = AS4.FTPER
             					LEFT JOIN [dbo].[TramasCfdiAhorro] AS S    ON    S.IdTrama='01' AND    S.Posicion=3
             					LEFT JOIN [dbo].[TramasCfdiAhorro] AS RfcR ON RfcR.IdTrama='01' AND RfcR.Posicion=10
             				WHERE AS4.FTPER = @Periodo
				END
				ELSE
				BEGIN
						IF NOT EXISTS(SELECT FTPER FROM OPENQUERY(AS400,'SELECT FTPER FROM MA4620EP.Z3OFACACUI') WHERE FTPER = @Periodo)
						BEGIN
							PRINT ' => NO EXISTE :P'
							INSERT INTO 
             				OPENQUERY(AS400,'SELECT 
             									FTCSTS,FTPER,FTSER,FTINVN,FTFEC,FTRFC,FTTOB,FTTON,FTTIVA,FTTOI,FTTIV,FTBIV,FTIVA,FTDES,FTI08,FTINE,FTTIMP,FTBIE,FTI25,FTINI,FTTIMT,FTBAS,FTTIM,FTI00,FTTI0,FTBA0,FTFCH,FTHOR,FTSTS
             									FROM MA4620EP.Z3OFACACUI')
             				SELECT 
             					CASE  WHEN T.C13_Tasa_iva = 0.16 THEN '826'   
             							WHEN T.C13_Tasa_iva = 0.08 THEN '808' 
             					END FTCSTS,
             					T.Periodo AS FTPER, 
             					S.ValorPredefinido AS FTSER, 
             					CONCAT(
             						CASE WHEN T.C13_Tasa_iva=0.16 THEN '826'  
             							WHEN T.C13_Tasa_iva=0.08 THEN '808'
             						END,
             						RIGHT(CONCAT('000000000000',PERIODO),9)
             					) AS FTINVN,
             					CONVERT(VARCHAR(10),FechaPeriodo, 112)        AS FTFEC 
             					,RfcR.ValorPredefinido                        AS FTRFC 
             					,T.C42_Total_Bruto                            AS FTTOB 
             					,T.C6_Total_neto                              AS FTTON 
             					,T.C10_Tipo_iva                               AS FTTIVA 
             					,T.C9_Total_impuestos                         AS FTTOI 
             					,T.C13_Tasa_iva                               AS FTTIV 
             					,T.C12_Base_Traslado                          AS FTBIV 
             					,T.C14_Bruto_iva                              AS FTIVA 
             					,T.C25_Total_descuento_comercial              AS FTDES 
             					,ISNULL(T.C55_Tasa_IEPS1,0)                   AS FTI08 
             					,ISNULL(T.C56_Importe_NETO_IEPS1,0)           AS FTINE 
             					,T.C57_Impuesto                               AS FTTIMP 
             					,ISNULL(T.C59_Base,0)                         AS FTBIE 
             					,ISNULL(T.C60_Tasa_IEPS2,0)                   AS FTI25 
             					,ISNULL(T.C61_Importe_NETO_IEPS2,0)           AS FTINI 
             					,T.C62_Impuesto                               AS FTTIMT 
             					,ISNULL(T.C64_Base,0)                         AS FTBAS 
             					,ISNULL(T.C65_Tasa0,0)                        AS FTTIM 
             					,ISNULL(T.C66_Importe_Tasa0,0)                AS FTI00 
             					,T.C67_Impuesto                               AS FTTI0 
             					,ISNULL(T.C69_Base_Tasa0,0)                   AS FTBA0 
             					--,T.FechaActualizacion /*Pruebas*/
             					,CONVERT(VARCHAR(10),FechaActualizacion, 112) AS FTFCH 
             					,FORMAT(FechaActualizacion,'HHmmss')          AS FTHOR 
             					,0 AS FTSTS   --SELECT *
             				FROM [CPagoAhorro].[TotalesFacturaPerfecta] T
             				LEFT JOIN [dbo].[TramasCfdiAhorro] AS S    ON    S.IdTrama='01' AND    S.Posicion=3
             				LEFT JOIN [dbo].[TramasCfdiAhorro] AS RfcR ON RfcR.IdTrama='01' AND RfcR.Posicion=10
             				WHERE Periodo = @Periodo
						END
				END				
  
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

