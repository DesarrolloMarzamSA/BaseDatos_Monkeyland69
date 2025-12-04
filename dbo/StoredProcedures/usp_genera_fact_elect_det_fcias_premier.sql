USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_genera_fact_elect_det_fcias_premier]
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
--SET @sucursal = 1
--SET @segto = 'C2'
--SET @ctepadre = '080'
--SET @fecha = '02-09-2009'

SELECT	LEFT(CONVERT(VARCHAR(12), CONVERT(BIGINT, t1.factura)) + REPLICATE(' ', 12), 12) +
		LEFT(CONVERT(VARCHAR(14), t1.cliente) + REPLICATE(' ', 12), 12) +
		RIGHT(REPLICATE('0', 4) + CONVERT(VARCHAR(4), DATEPART(YYYY, @fecha)), 4) +
		RIGHT(REPLICATE('0', 2) + CONVERT(VARCHAR(2), DATEPART(MM, @fecha)), 2) +
		RIGHT(REPLICATE('0', 2) + CONVERT(VARCHAR(2), DATEPART(DD, @fecha)), 2) +
		LEFT(CONVERT(VARCHAR(13), CONVERT(BIGINT, t1.cod_barras)) + REPLICATE(' ', 13), 13) +
		RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR(9), t1.precio_farm_sin_imp), 9)  + 
		RIGHT(REPLICATE(' ', 7) + CONVERT(VARCHAR(7), t1.piezas_surtidas_con_cargo), 7) +
		RIGHT(REPLICATE(' ', 7) + CONVERT(VARCHAR(7), t1.piezas_surtidas_sin_cargo), 7) +
		RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR(9), CONVERT(INT, t1.porcentaje_iva)), 9) +
		RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR(6), t1.porcentaje_descto_oferta), 6) +
		RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR(6), t1.porcentaje_descto_comercial), 6)
FROM	facturacion_electronica_estandar t1 
WHERE	t1.sucursal = @sucursal AND
		t1.segto = @segto AND
		t1.ctepadre = @ctepadre AND
		--t1.fecha_factura = @fecha
		fecha_tandem = convert(datetime, @fecha, 105)
ORDER BY t1.factura
GO
