
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		mandrade
-- Create date: 2013-10-09
-- Description:	facturacion electronica layout PharmacySoft2_0
-- =============================================
CREATE PROCEDURE [dbo].[usp_genera_fact_elect_guadalupana] @fecha varchar(10),@ctepadre varchar(10)
WITH ENCRYPTION
AS
BEGIN
	-- usp_genera_fact_elect_guadalupana  '2013-10-09','486'
	SET NOCOUNT ON;
SELECT	LEFT(CONVERT(VARCHAR(12), t1.folio_fiscal) + REPLICATE(' ', 12), 12) +
		LEFT(CONVERT(VARCHAR(13), h.noalta) + REPLICATE(' ', 13), 13) +
		CONVERT(VARCHAR(8), t1.fecha_factura,  112) +
		LEFT(CONVERT(VARCHAR(13), t1.cod_barras) + REPLICATE(' ', 13), 13) +  
		RIGHT(REPLICATE(' ', 7-len(cast(t1.piezas_surtidas_con_cargo as varchar))), 7) + CONVERT(VARCHAR(6),t1.piezas_surtidas_con_cargo) +
		RIGHT(REPLICATE(' ', 7) + CONVERT(VARCHAR(7), t1.piezas_surtidas_sin_cargo), 7) +
		RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR(9), t1.precio_farm_sin_imp), 9) +
		RIGHT(REPLICATE(' ', 9)+ CONVERT(VARCHAR(9), t1.porcentaje_iva), 9) +
		RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR(6), t1.porcentaje_descto_oferta), 6) +
		RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR(6), t1.porcentaje_descto_comercial), 6)
FROM	facturacion_electronica_estandar t1 
inner join Historica.dbo.encabezado h on t1.folio_fiscal=h.folio_fiscal and t1.sucursal=h.sucursal
WHERE	t1.sucursal in (25) AND
		t1.ctepadre=@ctepadre AND
		t1.fecha_tandem >= CONVERT(DATETIME, CONVERT(VARCHAR(10),@fecha, 121), 121)		
END
GO
