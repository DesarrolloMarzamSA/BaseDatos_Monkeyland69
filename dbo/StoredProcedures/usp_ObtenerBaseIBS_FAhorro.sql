-- =============================================
-- Author: Francisco Roberto Martínez Hernández 
-- Update date: 
-- Create date: 03/0472019
-- Description:	Obtiene las remisiones sin modificar de IBS con el periodo indicado
-- EXEC [dbo].[usp_ObtenerBaseIBS_FAhorro] 317
-- =============================================
CREATE PROCEDURE [dbo].[usp_ObtenerBaseIBS_FAhorro]
@Periodo INT
AS
BEGIN

   SELECT T.REMISION,D.FACTURA,D.SUCURSAL,D.SERIE,RTRIM(D.IDCUNO) IDCUNO,D.IDLINE,RTRIM(D.IDPRDC) IDPRDC,D.IDQTY,D.PRECIO_CANTIDAD,D.NETO_UNITARIO,D.NETO_CANTIDAD
         ,D.IVA,D.IEPS,D.TOTAL_FINAL,D.DESCOFERTA
		 --,D.DESCCOMERCIAL,D.DESCCOMERCIALPESOS
		 , D.IHOREF, D.PERIODO  
   FROM [dbo].[TotalPeriodoAhorro] T
   LEFT JOIN detalle_fahorroFacturas D ON D.idinvn = T.[remision]   
   WHERE T.periodo =@Periodo
END

GO

