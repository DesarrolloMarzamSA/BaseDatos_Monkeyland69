-- =============================================
-- Author: Francisco Roberto Martínez Hernández 
-- Update date: 
-- Create date: 03/0472019
-- Description:	
/*
 EXEC [dbo].[JOB_01FP_ValidaCargaBaseFAhorro] 
*/
-- =============================================
CREATE PROCEDURE [dbo].[JOB_Paso01FacturaPerfectaFAhorro]
AS
BEGIN

    DECLARE
    @IdUsuario VARCHAR(20),
    @Periodo INT = 0,
	@Id INT = 0

	 WHILE EXISTS(SELECT TOP 1 1 FROM [dbo].[ControlFacturaPerfectaFAhorro] WHERE IdProceso = 1 AND IdEstado in (1,4) AND Procesar = 1)
	 BEGIN 
		SET @IdUsuario = NULL
		SET @Periodo  = NULL
        SET @Id = 0

		SELECT TOP 1 @Id = Id, @IdUsuario = [Usuario], @Periodo = [Periodo] FROM [dbo].[ControlFacturaPerfectaFAhorro] WHERE IdProceso = 1 AND IdEstado in (1,4) AND Procesar = 1
		/*INICIA PROCESO */		
		BEGIN TRY
		    UPDATE [dbo].[ControlFacturaPerfectaFAhorro] SET [Procesar] = 0 WHERE  Id = @Id

				/************** Cuerpo del proceso ***************/
				UPDATE df SET df.[PERIODO] = tp.[periodo]
				FROM  detalle_fahorroFacturas df 
				INNER JOIN [dbo].[TotalPeriodoAhorro] tp on df.idinvn=tp.[remision]
				WHERE tp.periodo = @Periodo 

				DELETE detalle_fahorroFacturasCopiaPeriodo WHERE PERIODO = @Periodo
				
				MERGE detalle_fahorroFacturasCopiaPeriodo T
				USING (
						SELECT SUCURSAL,SERIE,IDCUNO,NANCA1,IDINVN,FACTURA,IDLINE,IDPRDC,PCXPRC,IDDESC,IDQTY,CF,FARMACIA,
								UNITARIO,PUBLICO,PRECIO_CANTIDAD,NETO_UNITARIO,NETO_CANTIDAD,IVA,IEPS,IEPS_MONEDA,TOTAL_IEPS,IVA_MONEDA,
								TOTAL_FINAL,DTDCPR,DESCOFERTA,DESCCOMERCIAL,DescComercialPesos,IDGDSQ,FECHAPROG,IHOREF,NATREG,PERIODO,RECALCULO,HashCode
						FROM [dbo].[detalle_fahorroFacturas] WHERE PERIODO = @Periodo
				) S
				ON (S.PERIODO = T.PERIODO AND S.[IDINVN] = T.[IDINVN] AND S.[IDCUNO] = T.[IDCUNO] AND S.[IDLINE] = T.[IDLINE] AND S.[IDPRDC] = T.[IDPRDC] AND S.ihoref = T.ihoref )	
	            WHEN NOT MATCHED THEN
				INSERT (SUCURSAL,SERIE,IDCUNO,NANCA1,IDINVN,FACTURA,IDLINE,IDPRDC,PCXPRC,IDDESC,IDQTY,CF,FARMACIA,
						UNITARIO,PUBLICO,PRECIO_CANTIDAD,NETO_UNITARIO,NETO_CANTIDAD,IVA,IEPS,IEPS_MONEDA,TOTAL_IEPS,IVA_MONEDA,
						TOTAL_FINAL,DTDCPR,DESCOFERTA,DESCCOMERCIAL,DescComercialPesos,IDGDSQ,FECHAPROG,IHOREF,NATREG,PERIODO,RECALCULO,HashCode)
                VALUES (SUCURSAL,SERIE,IDCUNO,NANCA1,IDINVN,FACTURA,IDLINE,IDPRDC,PCXPRC,IDDESC,IDQTY,CF,FARMACIA,
						UNITARIO,PUBLICO,PRECIO_CANTIDAD,NETO_UNITARIO,NETO_CANTIDAD,IVA,IEPS,IEPS_MONEDA,TOTAL_IEPS,IVA_MONEDA,
						TOTAL_FINAL,DTDCPR,DESCOFERTA,DESCCOMERCIAL,DescComercialPesos,IDGDSQ,FECHAPROG,IHOREF,NATREG,PERIODO,RECALCULO,HashCode);	
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

