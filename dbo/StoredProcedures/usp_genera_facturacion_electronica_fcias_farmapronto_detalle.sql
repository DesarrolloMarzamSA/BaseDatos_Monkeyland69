CREATE  PROCEDURE [dbo].[usp_genera_facturacion_electronica_fcias_farmapronto_detalle]
	@sucursal INT,
	@fecha DATETIME,
	@segto VARCHAR(2),
	@ctepadre VARCHAR(3),
	@cliente VARCHAR(5),
	@folio_fiscal VARCHAR(8)
AS

--DECLARE @folio_fiscal VARCHAR(8)
--DECLARE @sucursal INT
--DECLARE @fecha DATETIME
--DECLARE @segto VARCHAR(2)
--DECLARE @ctepadre VARCHAR(3)
--DECLARE @cliente VARCHAR(5)
--SET @sucursal = 1
--SET @fecha = '2011-03-29'
--SET @segto = 'B2'
--SET @ctepadre = '676'
--SET @cliente = '34970'
--SET @folio_fiscal = '00636812'

SELECT	'P' +
		RIGHT(REPLICATE('0', 8) + CONVERT(VARCHAR(8), t1.codigo), 8) +
		RIGHT(REPLICATE('0', 6) + CONVERT(VARCHAR(6), t1.piezas_surtidas_con_cargo), 6) +
		RIGHT(REPLICATE('0', 6) + CONVERT(VARCHAR(6), t1.piezas_surtidas_sin_cargo), 6) +
		RIGHT(REPLICATE('0', 5) + CONVERT(VARCHAR(5), CONVERT(BIGINT, t1.porcentaje_descto_oferta * 100)), 5) +
		RIGHT(REPLICATE('0', 8) + CONVERT(VARCHAR(8), CONVERT(BIGINT, t1.precio_farm_sin_imp * 100)), 8) +
		RIGHT(REPLICATE('0', 8) + CONVERT(VARCHAR(8), CONVERT(BIGINT, t1.precio_pub_sin_imp * 100)), 8 ) +
		RIGHT(REPLICATE('0', 8) + CONVERT(VARCHAR, CONVERT(BIGINT, t1.importe_bruto * 100)), 8) +
		RIGHT(REPLICATE('0', 8) + CONVERT(VARCHAR, CONVERT(BIGINT, t1.precio_pub_sin_imp * t1.piezas_surtidas_con_cargo * 100)), 8) +
		RIGHT(REPLICATE('0', 8) + CONVERT(VARCHAR(8), CONVERT(BIGINT, t1.iva * 100)), 8) +
		RIGHT(REPLICATE('0', 8) + CONVERT(VARCHAR(8), CONVERT(BIGINT, t1.ieps * 100)), 8) +
		CASE
			WHEN t1.clas_fis = 'N'  THEN REPLICATE('0', 5)
			WHEN t1.clas_fis = 'NA' THEN REPLICATE('0', 5)
			WHEN t1.clas_fis = 'F'  THEN REPLICATE('0', 5)
			WHEN t1.clas_fis = 'FA' THEN REPLICATE('0', 5)
			WHEN t1.clas_fis = 'O'  THEN REPLICATE('0', 5)
			WHEN t1.clas_fis = 'OA' THEN REPLICATE('0', 5)						
			WHEN t1.clas_fis = 'B'  THEN RIGHT(REPLICATE('0', 5) + CONVERT(VARCHAR(5), CONVERT(BIGINT, t1.porcentaje_descto_comercial * 100)), 5)
			WHEN t1.clas_fis = 'BA' THEN RIGHT(REPLICATE('0', 5) + CONVERT(VARCHAR(5), CONVERT(BIGINT, t1.porcentaje_descto_comercial * 100)), 5)
			WHEN t1.clas_fis = 'H'  THEN RIGHT(REPLICATE('0', 5) + CONVERT(VARCHAR(5), CONVERT(BIGINT, t1.porcentaje_descto_comercial * 100)), 5)
			WHEN t1.clas_fis = 'HA' THEN RIGHT(REPLICATE('0', 5) + CONVERT(VARCHAR(5), CONVERT(BIGINT, t1.porcentaje_descto_comercial * 100)), 5)
			ELSE REPLICATE('0', 5)
		END +
		REPLICATE(' ', 1) +
		RIGHT(REPLICATE(' ', 8) + CONVERT(VARCHAR(8), CONVERT(BIGINT, t1.importe_neto * 100)), 8) +
		'1' +
		RIGHT(REPLICATE('0', 14) + CONVERT(VARCHAR(14), CONVERT(BIGINT, t1.cod_barras)), 14) +
		--RIGHT(REPLICATE('0', 4) + CONVERT(VARCHAR(4), CONVERT(BIGINT, t1.porcentaje_utilidad * 100)), 4) +
		RIGHT(REPLICATE('0', 4) + CONVERT(VARCHAR(4), CONVERT(BIGINT, case when t1.porcentaje_utilidad>0 then t1.porcentaje_utilidad else 0 end * 100)), 4) +
		CASE
			WHEN t1.clas_fis = 'N' THEN '4'
			WHEN t1.clas_fis = 'NA' THEN '2'
			WHEN t1.clas_fis = 'F' THEN '4'
			WHEN t1.clas_fis = 'FA' THEN '2'
			WHEN t1.clas_fis = 'O' THEN '4'
			WHEN t1.clas_fis = 'OA' THEN '2'
			WHEN t1.clas_fis = 'B' THEN '4'
			WHEN t1.clas_fis = 'BA' THEN '2'
			WHEN t1.clas_fis = 'H' THEN '4'
			WHEN t1.clas_fis = 'HA' THEN '2'
		END +
		'0' +
		'0'
FROM 	facturacion_electronica_estandar t1
WHERE 	--t1.fecha_factura = CONVERT(DATETIME, CONVERT(VARCHAR(10), @fecha, 121), 121) AND 
		--t1.fecha_tandem = convert(datetime, convert(varchar(10), @fecha, 121), 121) and
		--traer todas las facturas cargadas despues de las 6 de la mañana del dia anterior
		--a las 6 de la mañana del dia actual
		--si no se cargan las facturas puede surgir un problema al momento de realizar la carga
		--se recomienda quitar momentaneamente la segunda restriccion al times stamp en ese caso
		--timestamp>= convert(datetime,convert(varchar,dateadd(day,-1,@fecha),105) + ' 06:00:00',105) and 
		--timestamp< convert(datetime,convert(varchar,@fecha,105) + ' 06:00:00',105) and			
		--t1.segto = @segto AND 
		--t1.ctepadre = @ctepadre AND
		--t1.sucursal = @sucursal AND
		--t1.cliente = @cliente AND
		--t1.folio_fiscal = @folio_fiscal
		
		t1.ctepadre = @ctepadre AND
		t1.sucursal = @sucursal AND
		t1.cliente = @cliente AND
		t1.folio_fiscal = @folio_fiscal
		
		
ORDER BY t1.cod_barras

GO

