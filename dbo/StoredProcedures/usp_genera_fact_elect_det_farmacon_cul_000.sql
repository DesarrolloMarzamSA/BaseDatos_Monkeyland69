CREATE PROCEDURE [dbo].[usp_genera_fact_elect_det_farmacon_cul_000]
	@sucursal TINYINT,
	@fecha DATETIME,
	@segto VARCHAR(2),
	@ctepadre VARCHAR(3)
	
AS

--DECLARE @sucursal TINYINT
--DECLARE @segto VARCHAR(2)
--DECLARE @ctepadre VARCHAR(3)
--DECLARE @fecha DATETIME
--SET @sucursal = 17
--SET @segto = 'C2'
--SET @ctepadre = '599'
--SET @fecha = '2011-03-30'

SELECT	'C' + 
		LEFT(CONVERT(VARCHAR, CONVERT(BIGINT, t1.factura)) + REPLICATE(' ', 7), 7) +
		RIGHT('0000' + CONVERT(VARCHAR, DATEPART(YYYY,@fecha)), 4) +
		RIGHT('00' + CONVERT(VARCHAR, DATEPART(MM,@fecha)), 2) +
		RIGHT('00' + CONVERT(VARCHAR, DATEPART(DD,@fecha)), 2) +
		RIGHT(REPLICATE('0', 5) + t1.cliente, 5) + 
		'  ' +
		LEFT(CONVERT(VARCHAR, CONVERT(BIGINT, t1.codigo)) + REPLICATE(' ', 7), 7) +
		' ' +
		RIGHT(REPLICATE('0', 4) + CONVERT(VARCHAR, t1.piezas_surtidas_con_cargo), 4) +
		RIGHT(REPLICATE('0', 5) + CONVERT(VARCHAR, CONVERT(INT, t1.porcentaje_descto_oferta * 100)), 5) +
		RIGHT(REPLICATE('0', 4) + CONVERT(VARCHAR, CONVERT(INT, t1.porcentaje_descto_comercial * 100)), 4) +
		RIGHT(REPLICATE('00', 2) + CONVERT(VARCHAR, CONVERT(INT, t1.porcentaje_iva)), 2) +
		RIGHT(REPLICATE('0', 7) + CONVERT(VARCHAR, CONVERT(INT, t1.precio_pub_sin_imp * 100)), 7) +
		RIGHT(REPLICATE('0', 7) + CONVERT(VARCHAR, CONVERT(INT, t1.precio_farm_sin_imp * 100)), 7) 
FROM	facturacion_electronica_estandar t1 
WHERE	t1.sucursal = @sucursal AND
		t1.segto = @segto AND
		t1.ctepadre = @ctepadre AND
		--t1.fecha_factura = @fecha
		t1.fecha_tandem >= convert(datetime, convert(varchar(10), @fecha, 121), 121)
ORDER BY t1.factura

GO

