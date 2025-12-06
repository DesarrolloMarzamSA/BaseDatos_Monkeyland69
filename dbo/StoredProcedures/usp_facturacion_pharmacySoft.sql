
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		mandrade
-- Create date: 2013-10-23
-- Description:	facturacion de layout PharmacySoft
-- =============================================
CREATE PROCEDURE [dbo].[usp_facturacion_pharmacySoft]
	@sucursal varchar(max), 
	@ctepadre VARCHAR(50)='',
	@cte VARCHAR(150)='',
	@fecha DATETIME
WITH ENCRYPTION
AS
BEGIN
	SET NOCOUNT ON;
    SELECT	LEFT(CONVERT(VARCHAR(12), t1.folio_fiscal) + REPLICATE(' ', 12), 12) +
		LEFT(CONVERT(VARCHAR(13), t1.cliente) + REPLICATE(' ', 13), 13) +
		CONVERT(VARCHAR(8), t1.fecha_factura,  112) +
		LEFT(CONVERT(VARCHAR(15), t1.cod_barras) + REPLICATE(' ', 15), 15) +  
		RIGHT(REPLICATE(' ', 7) + CONVERT(VARCHAR(7), t1.piezas_surtidas_con_cargo), 7) +
		RIGHT(REPLICATE(' ', 7) + CONVERT(VARCHAR(7), t1.piezas_surtidas_sin_cargo), 7) +
		RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR(9), t1.precio_farm_sin_imp), 9) +
		RIGHT(REPLICATE(' ', 9)+ CONVERT(VARCHAR(9), t1.porcentaje_iva), 9) +
		RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR(6), t1.porcentaje_descto_oferta), 6) +
		RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR(6), t1.porcentaje_descto_comercial), 6)
FROM	facturacion_electronica_estandar t1 
WHERE	t1.sucursal =@sucursal AND
		t1.ctepadre = @ctepadre AND
		t1.fecha_tandem >= CONVERT(DATETIME, CONVERT(VARCHAR(10), @fecha, 121), 121)
END

GO
