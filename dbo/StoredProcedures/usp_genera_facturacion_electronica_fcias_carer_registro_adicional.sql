USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_genera_facturacion_electronica_fcias_carer_registro_adicional]
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
--SET @sucursal = 7
--SET @fecha = '2011-04-25'
--SET @segto = 'C1'
--SET @ctepadre = '868'
--SET @cliente = '08033'
--SET @folio_fiscal = '00564080'

SELECT	'S' +
			'1' +
			RIGHT(REPLICATE('0', 10) + CONVERT(VARCHAR(10), ISNULL(SUM(CASE WHEN t1.clas_fis = 'N' THEN ISNULL(CONVERT(BIGINT, t1.importe_bruto * 100), 0) - ISNULL(CONVERT(BIGINT, descto_oferta * 100), 0) END), 0) + 
			ISNULL(SUM(CASE WHEN t1.clas_fis = 'B' THEN ISNULL(CONVERT(BIGINT, t1.importe_bruto * 100), 0) - ISNULL(CONVERT(BIGINT, descto_oferta * 100), 0) END), 0) +  
			ISNULL(SUM(CASE WHEN t1.clas_fis = 'H' THEN ISNULL(CONVERT(BIGINT, t1.importe_bruto * 100), 0) - ISNULL(CONVERT(BIGINT, descto_oferta * 100), 0) END), 0)), 10) +  -- AS Tasa0, --TASA0%
			REPLICATE('0', 8) +
			REPLICATE('0', 8) +
			RIGHT(REPLICATE('0', 8) + CONVERT(VARCHAR(8), CONVERT(BIGINT, SUM(t1.iva) * 100)), 8) +
			REPLICATE('0', 8) 
FROM 	facturacion_electronica_estandar t1 
WHERE --t1.fecha_factura = CONVERT(DATETIME, CONVERT(VARCHAR(10), @fecha, 121), 121) AND 
		t1.fecha_tandem >= convert(datetime, convert(varchar(10), @fecha, 121), 121) and
		t1.segto in('C1','A1') and  
		t1.ctepadre = @ctepadre AND
		t1.sucursal = @sucursal AND
		t1.cliente = @cliente AND
		t1.folio_fiscal = @folio_fiscal
GROUP BY t1.folio_fiscal
GO
