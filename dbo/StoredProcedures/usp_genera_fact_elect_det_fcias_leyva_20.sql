
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_genera_fact_elect_det_fcias_leyva_20]-- 1,'FLE940304UC2','2013-02-12'
	@sucursal TINYINT, 
	@rfc VARCHAR(50),
	@fecha DATETIME

AS
--DECLARE @sucursal TINYINT
--DECLARE @rfc VARCHAR(50)
--DECLARE @fecha DATETIME
--SET @sucursal = 1
--SET @rfc = 'FLE940304UC2'
--SET @fecha = '2012-07-23'

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
WHERE	t1.sucursal in (1,21) AND
		t1.rfc = @rfc AND
		t1.fecha_tandem >= CONVERT(DATETIME, CONVERT(VARCHAR(10), @fecha, 121), 121)
GO
