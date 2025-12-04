-- =============================================
-- Author:Francisco Roberto Martínez Hernández
-- Create date: 12/07/2018
-- Description:	Reporte de diferencias entre devolcuiones y precios agrupados por remision para farmacias del ahorro
-- Exec[dbo].[spr_ReporteDevolucionesDiferenciasAhorroTotales] 280
-- =============================================
CREATE PROCEDURE [dbo].[spr_ReporteDevolucionesDiferenciasAhorroTotales]
 @PeriodoI INT
AS
BEGIN
    DECLARE @Periodo INT=@PeriodoI
    IF EXISTS(SELECT TOP 1 1 FROM ReportesDiferenciasAhorro (NOLOCK) WHERE periodo=@Periodo)
	BEGIN
	    --DECLARE @Periodo int=275
	    SELECT  A.Periodo, A.Remision, A.FechaRemision, A.CuentaEstiloAhorro, A.Sucursal, A.Cuenta, A.Orden
		        ,SUM(ISNULL(PzasPedidasRemision,0)) AS PzasPedidasRemision
				,SUM(ISNULL(PzasDevueltas,0)) AS PzasDevueltas
				,SUM(ISNULL(DevBruta,0)) AS DevBruta
				,SUM(ISNULL(IvaDev,0)) AS IvaDev
				,SUM(ISNULL(DescComDev,0)) AS DescComDev
				,SUM(ISNULL(IvaDescComDev,0)) AS IvaDescComDev
				,SUM(ISNULL(OfertaDev,0)) AS OfertaDev
				,MIN(MinRecalculo) AS MinRecalculo	
				,MAX(MaxRecalculo) AS MaxRecalculo				
				,SUM(ISNULL(DiferenciaPrecio,0)) AS DiferenciaPrecio
				--,SUM(ISNULL(ImporteMarzam,0)) AS ImporteMarzam
				--,SUM(ISNULL(IvaMarzam,0)) AS IvaMarzam
				--,SUM(ISNULL(TotalMarzam,0)) AS TotalMarzam
				,MIN(ISNULL(B.totalRemision,0)) AS ImporteAhorro
				,MIN(ISNULL(B.totalIVA,0)) AS IvaAhorro
				,MIN(ISNULL(B.totalRemisionIVA,0)) AS TotalAhorro
				,SUM(ISNULL(BrutoDocumento,0)) AS BrutoDocumento
				,SUM(ISNULL(IvaDocumento,0)) AS IvaDocumento
				,SUM(ISNULL(TotalDocumento,0)) AS TotalDocumento
				,SUM(ISNULL(ImporteDocumento,0)) AS ImporteDocumento				
		FROM ReportesDiferenciasAhorro A (NOLOCK) 
		JOIN TotalPeriodoAhorro B ON A.Periodo=B.periodo AND A.Remision=B.remision
		WHERE A.periodo=@Periodo
		GROUP BY A.Periodo, A.Remision, A.FechaRemision, A.CuentaEstiloAhorro, A.Sucursal, A.Cuenta, A.Orden
		--,MinRecalculo,MaxRecalculo			
	    ORDER BY  A.Remision
	END
	ELSE
	BEGIN		   		
		   DECLARE @Msj varchar(4000) ='¡Aún no se realizan los calculos del detalle, imposible obtener los totales!'		  
		   RAISERROR (@Msj, 16, 1)
		   RETURN;	    
	END	
END

GO

