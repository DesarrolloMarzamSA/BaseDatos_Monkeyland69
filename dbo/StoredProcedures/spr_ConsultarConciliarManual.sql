-- =============================================
-- Author: Francisco Roberto Martínez Hernández 
-- Update date: 
-- Create date: 03/0472019
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[spr_ConsultarConciliarManual]
@Periodo INT
AS
BEGIN

	SELECT  Id,SUCURSAL,SERIE,IDCUNO,FACTURA,IDLINE,IDPRDC,IDQTY,FARMACIA
						,PRECIO_CANTIDAD,DESCCOMERCIAL,DESCCOMERCIALPESOS, IHOREF, PERIODO, RECALCULO
	FROM detalle_fahorroFacturas
	WHERE (PERIODO = @Periodo) AND RECALCULO =9
	ORDER BY CAST(ISNULL(DESCOFERTA,0) AS DECIMAL), PRECIO_CANTIDAD DESC,SUCURSAL

END

GO

