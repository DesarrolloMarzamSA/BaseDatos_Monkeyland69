-- =============================================
-- Author: Francisco Roberto Martínez Hernández 
-- Update date: 
-- Create date: 03/0472019
-- Description:	
/*
 EXEC [dbo].[usp_ReversarFacturaPerfectaFAhorro]
*/
-- =============================================
CREATE PROCEDURE [dbo].[usp_ReversarFacturaPerfectaFAhorro]
@IdUsuario VARCHAR(20),
@Periodo INT
AS
BEGIN
    	
	IF EXISTS(SELECT TOP 1 1 FROM [dbo].[ControlFacturaPerfectaFAhorro] WITH(NOLOCK) WHERE Periodo = @Periodo AND IdProceso = 9 AND IdEstado = 2 )
	BEGIN 
		RAISERROR('¡Este folio ya fue finalizado no se pueden restaurar los valores!',16,1);
		RETURN;
	END	
    
		    
		BEGIN TRY		  
		    --declare	@IdUsuario VARCHAR(20)='ROBERT',  @Periodo INT=329
            --1.- eliminar el detalle del periodo 
            DELETE FROM detalle_fahorroFacturas WHERE PERIODO=@Periodo
			
            --2.-Insertar de nueva cuenta el detalle de la facturacion del periodo, se puede realiza desde ibs obteniendo las fechas de las facturas y modificando las fechas de extracción en el query que extrae
			MERGE detalle_fahorroFacturas T
			USING (
					SELECT SUCURSAL,SERIE,IDCUNO,NANCA1,IDINVN,FACTURA,IDLINE,IDPRDC,PCXPRC,IDDESC,IDQTY,CF,FARMACIA,
							UNITARIO,PUBLICO,PRECIO_CANTIDAD,NETO_UNITARIO,NETO_CANTIDAD,IVA,IEPS,IEPS_MONEDA,TOTAL_IEPS,IVA_MONEDA,
							TOTAL_FINAL,DTDCPR,DESCOFERTA,DESCCOMERCIAL,DescComercialPesos,IDGDSQ,FECHAPROG,IHOREF,NATREG,PERIODO,RECALCULO,HashCode
					FROM [dbo].[detalle_fahorroFacturasCopiaPeriodo] WHERE PERIODO = @Periodo
			) S
			ON (S.[IDINVN] = T.[IDINVN] AND S.[IDLINE] = T.[IDLINE] AND S.[IDPRDC] = T.[IDPRDC] AND S.[IDQTY]=T.[IDQTY] AND S.[PRECIO_CANTIDAD] = T.[PRECIO_CANTIDAD])	
	        WHEN NOT MATCHED THEN
			INSERT (SUCURSAL,SERIE,IDCUNO,NANCA1,IDINVN,FACTURA,IDLINE,IDPRDC,PCXPRC,IDDESC,IDQTY,CF,FARMACIA,
					UNITARIO,PUBLICO,PRECIO_CANTIDAD,NETO_UNITARIO,NETO_CANTIDAD,IVA,IEPS,IEPS_MONEDA,TOTAL_IEPS,IVA_MONEDA,
					TOTAL_FINAL,DTDCPR,DESCOFERTA,DESCCOMERCIAL,DescComercialPesos,IDGDSQ,FECHAPROG,IHOREF,NATREG,PERIODO,RECALCULO,HashCode)
            VALUES (SUCURSAL,SERIE,IDCUNO,NANCA1,IDINVN,FACTURA,IDLINE,IDPRDC,PCXPRC,IDDESC,IDQTY,CF,FARMACIA,
					UNITARIO,PUBLICO,PRECIO_CANTIDAD,NETO_UNITARIO,NETO_CANTIDAD,IVA,IEPS,IEPS_MONEDA,TOTAL_IEPS,IVA_MONEDA,
					TOTAL_FINAL,DTDCPR,DESCOFERTA,DESCCOMERCIAL,DescComercialPesos,IDGDSQ,FECHAPROG,IHOREF,NATREG,NULL,RECALCULO,HashCode);	

            --3.-Eliminar el periodo en la siguiente tabla que es el respaldo de la base de los pedidos
            DELETE FROM [dbo].[pedidos_fahorro_conciliacion] where PERIODO=@Periodo

			--4.-Se elimina de la tabla de movimientos
			DELETE FROM  [dbo].[mov_detalle_fahorroFacturas] where periodo=@Periodo
            --declare	@IdUsuario VARCHAR(20)='ROBERT',  @Periodo INT=329
			UPDATE [dbo].[ControlFacturaPerfectaFAhorro]
			   SET			  
				   [IdEstado] = 0
				  ,[Mensaje] = NULL
				  ,[Usuario] = @IdUsuario
				  ,[Intento] = 0
				  ,[TotalFAhorro] = 0
				  ,[TotalMarzam] = 0
				  ,[UltimaEjecucion] =  GETDATE()			
				  ,[Procesar] = 0
			 WHERE Periodo = @Periodo

		END TRY
		BEGIN CATCH
			RAISERROR('¡No se lograron restaurar los valores!, intentelo nuevamente',16,1);
		    RETURN;
		END CATCH
		
END

GO

