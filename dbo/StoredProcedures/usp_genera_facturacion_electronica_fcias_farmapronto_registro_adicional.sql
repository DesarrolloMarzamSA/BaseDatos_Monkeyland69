USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_genera_facturacion_electronica_fcias_farmapronto_registro_adicional]
	@sucursal INT,
	@fecha DATETIME,
	@segto VARCHAR(2),
	@ctepadre VARCHAR(3),
	@cliente VARCHAR(5),
	@folio_fiscal VARCHAR(8)
WITH ENCRYPTION
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

SELECT	'A' +
		RIGHT(REPLICATE('0', 11) + CONVERT(VARCHAR(11), ISNULL(SUM(CASE WHEN t1.clas_fis = 'N' THEN ISNULL(CONVERT(BIGINT, t1.importe_bruto * 100), 0) - ISNULL(CONVERT(BIGINT, descto_oferta * 100), 0) END), 0) + 
		ISNULL(SUM(CASE WHEN t1.clas_fis = 'B' THEN ISNULL(CONVERT(BIGINT, t1.importe_bruto * 100), 0) - ISNULL(CONVERT(BIGINT, descto_oferta * 100), 0) END), 0) +  
		ISNULL(SUM(CASE WHEN t1.clas_fis = 'H' THEN ISNULL(CONVERT(BIGINT, t1.importe_bruto * 100), 0) - ISNULL(CONVERT(BIGINT, descto_oferta * 100), 0) END), 0)), 11) +  -- AS Tasa0, --TASA0%
		REPLICATE('0', 11) +
		RIGHT(REPLICATE('0', 11) + CONVERT(VARCHAR(11), ISNULL(SUM(CASE WHEN t1.clas_fis = 'N' THEN ISNULL(CONVERT(BIGINT, t1.importe_bruto * 100), 0) - ISNULL(CONVERT(BIGINT, descto_oferta * 100), 0) END), 0) + 
		ISNULL(SUM(CASE WHEN t1.clas_fis = 'B' THEN ISNULL(CONVERT(BIGINT, t1.importe_bruto * 100), 0) - ISNULL(CONVERT(BIGINT, descto_oferta * 100), 0) END), 0) +  
		ISNULL(SUM(CASE WHEN t1.clas_fis = 'H' THEN ISNULL(CONVERT(BIGINT, t1.importe_bruto * 100), 0) - ISNULL(CONVERT(BIGINT, descto_oferta * 100), 0) END), 0)), 11) +  -- AS Tasa0, --TASA0%
		RIGHT(REPLICATE('0', 11) + CONVERT(VARCHAR(11), CONVERT(BIGINT, SUM(t1.iva) * 100)), 11) +
		RIGHT(REPLICATE('0', 11) + CONVERT(VARCHAR(11), CONVERT(BIGINT, SUM(t1.bonificacion_iva) * 100)), 11) +
		RIGHT(REPLICATE('0', 11) + CONVERT(VARCHAR(11), CONVERT(BIGINT, SUM(t1.bonificacion_iva) * 100)), 11) +
		RIGHT(REPLICATE('0', 12) + CONVERT(VARCHAR(12), CONVERT(BIGINT, SUM(t1.iva) * 100)), 12) +
		RIGHT(REPLICATE('0', 12) + CONVERT(VARCHAR(12), CONVERT(BIGINT, SUM(t1.bonificacion_iva) * 100)), 12) +
		'0001' +
		'00001' +
		REPLICATE(' ', 11)
FROM 	facturacion_electronica_estandar t1 
WHERE   --t1.fecha_factura = CONVERT(DATETIME, CONVERT(VARCHAR(10), @fecha, 121), 121) AND 
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
		
GROUP BY t1.folio_fiscal
GO
