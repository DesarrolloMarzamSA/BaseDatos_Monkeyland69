-- =============================================
-- Author:		<Author: Francisco Roberto Martínez Hernández>
-- Create date: <Create Date: 26/03/2018>
-- Description:	<Proceso automatizado para realizacion de factura perfecta de farmacias del ahorro>
-- Example exec [dbo].[spr_FacturaPerfectaAhorro_Proceso] '264','FPA.01','FPA01.TP'	
-- =============================================
CREATE PROCEDURE [dbo].[spr_FacturaPerfectaAhorro_Proceso] 	
	@Periodo as varchar(20),
	@IdProceso  as varchar(6),
	@ClaveSubProceso  as varchar(9)
AS
BEGIN

   IF(@IdProceso = 'FPA.01')
   BEGIN
        IF(@ClaveSubProceso = 'FPA01.TP')
        BEGIN
            SELECT SUM(ISNULL(totalIVA,0 )) AS totalIVA, SUM(ISNULL(totalRemision,0)) AS totalRemision ,
                   SUM(ISNULL(totalIVA,0 ) +	ISNULL(totalRemision,0)) SUM_totalIVA_totalRemision, 
				   SUM(totalRemisionIVA)totalRemisionIVA, COUNT(1) TotalRegistros
            FROM [monkeyland].[dbo].[TotalPeriodoAhorro] nolock where periodo=@Periodo
		END
		ELSE IF(@ClaveSubProceso = 'FPA01.DP')
        BEGIN
		    SELECT COUNT(DISTINCT(FOLIO))TotalFolios, COUNT(1) TotalRegistros 
		    FROM [monkeyland].[dbo].[DiferenciaDevolucionesAhorro] nolock where periodo=@Periodo
        END
   END

   IF(@IdProceso = 'FPA.02')
   BEGIN
     SELECT 'FPA02'
   END

   IF(@IdProceso = 'FPA.03')
   BEGIN
     SELECT 'FPA03'
   END

   IF(@IdProceso = 'FPA.04')
   BEGIN
     SELECT 'FPA04'
   END

   IF(@IdProceso = 'FPA.05')
   BEGIN
     SELECT 'FPA05'
   END

   IF(@IdProceso = 'FPA.06')
   BEGIN
     SELECT 'FPA06'
   END

   IF(@IdProceso = 'FPA.07')
   BEGIN
     SELECT 'FPA07'
   END

   IF(@IdProceso = 'FPA.08')
   BEGIN
     SELECT 'FPA08'
   END

   IF(@IdProceso = 'FPA.09')
   BEGIN
     SELECT 'FPA09'
   END

   IF(@IdProceso = 'FPA.10')
   BEGIN
     SELECT 'FPA10'
   END
  
END

GO

