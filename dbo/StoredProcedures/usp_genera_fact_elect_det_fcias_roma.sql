
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_genera_fact_elect_det_fcias_roma]
	@sucursal TINYINT,
	@fecha DATETIME,
	@segto VARCHAR(2),
	@ctepadre VARCHAR(3)
WITH ENCRYPTION
AS

--DECLARE @sucursal TINYINT
--DECLARE @segto VARCHAR(2)
--DECLARE @ctepadre VARCHAR(3)
--DECLARE @fecha DATETIME
--SET @sucursal = 25
--SET @segto = 'C2'
--SET @ctepadre = '447'
--SET @fecha = '2011-03-30'

SELECT	'00' +
		CONVERT(VARCHAR(5), t1.cliente) +
		RIGHT(REPLICATE('0', 7) + CONVERT(VARCHAR(7), CONVERT(BIGINT, t1.factura)), 7) +
		RIGHT(REPLICATE('0', 7) + CONVERT(VARCHAR(7), CONVERT(BIGINT, t1.codigo)), 7) +
		RIGHT(REPLICATE('0', 7) + CONVERT(VARCHAR(7), t1.piezas_surtidas_con_cargo), 7) +
		RIGHT(REPLICATE('0', 10) + CONVERT(VARCHAR(10), CONVERT(INT, t1.precio_farm_sin_imp * 100)), 10) + 
		RIGHT(REPLICATE('0', 10) + CONVERT(VARCHAR(10), CONVERT(INT, t1.descto_oferta * 100)), 10) +
		RIGHT(REPLICATE('0', 10) + CONVERT(VARCHAR(10), CONVERT(INT, t1.descto_comercial * 100)), 10) +
		RIGHT(REPLICATE('0', 10) + CONVERT(VARCHAR(10), CONVERT(INT, t1.iva * 100)), 10) +
		RIGHT(REPLICATE('0', 10) + CONVERT(VARCHAR(10), CONVERT(INT, t1.importe_neto * 100)), 10) +
		RIGHT(REPLICATE('0', 4) + CONVERT(VARCHAR(4), CONVERT(INT, t1.porcentaje_descto_oferta * 100)), 4) +
		RIGHT(REPLICATE('0', 4) + CONVERT(VARCHAR(4), CONVERT(INT, t1.porcentaje_descto_comercial * 100)), 4) +
		LEFT(CONVERT(VARCHAR(13), CONVERT(BIGINT, t1.cod_barras)) + REPLICATE(' ', 13), 13) +
		' ' +
		RIGHT(REPLICATE('0', 10) + CONVERT(VARCHAR(10), CONVERT(INT, t1.precio_pub_sin_imp * 100)), 10) +
		RIGHT(REPLICATE('0', 10) + CONVERT(VARCHAR(10), CONVERT(BIGINT, t1.factura)), 10) 
FROM	facturacion_electronica_estandar t1 
WHERE	t1.sucursal = @sucursal AND
		t1.segto = @segto AND
		t1.ctepadre = @ctepadre AND
		--t1.fecha_factura = @fecha
		fecha_tandem = convert(datetime, convert(varchar(10), @fecha, 121), 121)
ORDER BY t1.factura
GO
