CREATE PROCEDURE [dbo].[usp_genera_fact_elect_det_farmacon_tij_000]
	@sucursal TINYINT,
	@fecha DATETIME,
	@segto VARCHAR(2),
	@ctepadre VARCHAR(3)
AS

--DECLARE @sucursal TINYINT
--DECLARE @segto VARCHAR(2)
--DECLARE @ctepadre VARCHAR(3)
--DECLARE @fecha DATETIME
--SET @sucursal = 6
--SET @segto = 'C2'
--SET @ctepadre = '599'
--SET @fecha = '2011-03-30'

SELECT	'J' + 
		RIGHT(REPLICATE('0', 7) + CONVERT(VARCHAR(7), CONVERT(BIGINT, t1.factura)), 7) +
		RIGHT('0000' + CONVERT(VARCHAR(4), DATEPART(YYYY,@fecha)), 4) +
		RIGHT('00' + CONVERT(VARCHAR(2), DATEPART(MM,@fecha)), 2) +
		RIGHT('00' + CONVERT(VARCHAR(2), DATEPART(DD,@fecha)), 2) +
		RIGHT(REPLICATE('0', 5) + t1.cliente, 5) + 
		'  ' +
		RIGHT(REPLICATE('0', 7) + CONVERT(VARCHAR(7), CONVERT(BIGINT, t1.codigo)), 7) +
		' ' +
		RIGHT(REPLICATE('0', 4) + CONVERT(VARCHAR(4), t1.piezas_surtidas_con_cargo), 4) +
		RIGHT(REPLICATE('0', 5) + CONVERT(VARCHAR(5), CONVERT(INT, t1.porcentaje_descto_oferta * 100)), 5) +
		CASE
			WHEN clas_fis = 'N' THEN '0000'
			WHEN clas_fis = 'NA' THEN '0000'
			WHEN clas_fis = 'B' THEN '9999'
			WHEN clas_fis = 'BA' THEN '9999'
			WHEN clas_fis = 'H' THEN RIGHT(REPLICATE('0', 4) + CONVERT(VARCHAR(4), CONVERT(INT, t1.porcentaje_descto_comercial * 100)), 4)
			WHEN clas_fis = 'HA' THEN RIGHT(REPLICATE('0', 4) + CONVERT(VARCHAR(4), CONVERT(INT, t1.porcentaje_descto_comercial * 100)), 4)
		END +
		RIGHT(REPLICATE('00', 2) + CONVERT(VARCHAR(2), CONVERT(INT, t1.porcentaje_iva)), 2) +
		RIGHT(REPLICATE('0', 7) + CONVERT(VARCHAR(7), CONVERT(INT, t1.precio_pub_sin_imp * 100)), 7) +
		RIGHT(REPLICATE('0', 7) + CONVERT(VARCHAR(7), CONVERT(INT, t1.precio_farm_sin_imp * 100)), 7) 
FROM	facturacion_electronica_estandar t1 
WHERE	t1.sucursal = @sucursal AND
		t1.segto = @segto AND
		t1.ctepadre = @ctepadre AND
		--t1.fecha_factura >= dateadd(d, -1, @fecha)
		t1.fecha_tandem >= dateadd(d, -1, convert(datetime, convert(varchar(10), @fecha, 121), 121))
ORDER BY t1.factura

GO

