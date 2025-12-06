
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_genera_facturacion_electronica_nadro_encabezado]
	@sucursal INT,
	@fecha DATETIME,
	@segto VARCHAR(10),
	@ctepadre VARCHAR(10),
	@cliente VARCHAR(5),
	@folio_fiscal VARCHAR(10)

AS
	DECLARE @BrutoIEPS VARCHAR(12)
--DECLARE @folio_fiscal VARCHAR(10)	
--DECLARE @BrutoIEPS VARCHAR(15) 
--DECLARE @sucursal INT
--DECLARE @fecha DATETIME
--DECLARE @segto VARCHAR(10)
--DECLARE @ctepadre VARCHAR(10)
--DECLARE @cliente VARCHAR(5)
--SET @sucursal = 1
--SET @fecha = '20-02-2009'
--SET @segto = 'C1'
--SET @ctepadre = '868'
--SET @cliente = '74710'
--SET @folio_fiscal = '00043131'

SELECT 	@BrutoIEPS = RIGHT('            ' + CONVERT(VARCHAR, SUM((CONVERT(BIGINT, ISNULL(t1.importe_bruto,0)*100)-CONVERT(BIGINT, ISNULL(t1.descto_oferta,0)*100))/2)), 12)
FROM 	facturacion_electronica_estandar t1 INNER JOIN maestro_productos t2 ON
	CONVERT(BIGINT, t1.cod_barras) = CONVERT(BIGINT, t2.cod_barras)
WHERE 	--t1.fecha_factura = CONVERT(DATETIME, CONVERT(VARCHAR(10), @fecha, 121), 121) AND 
	t1.fecha_tandem = CONVERT(DATETIME, CONVERT(VARCHAR(10), @fecha, 121), 121) AND 
	t1.segto = @segto AND 
	t1.ctepadre = @ctepadre AND
	--t1.tipo_documento = 'R' AND   
	t1.sucursal = @sucursal AND
	t1.cliente = @cliente AND
	ISNUMERIC(t1.cod_barras)  = 1 AND
	ISNUMERIC(t2.cod_barras)  = 1 AND
	t1.folio_fiscal = @folio_fiscal AND
	t2.cod_barras IS NOT NULL AND
	t2.grupo_est IN ('PC01G', 'PC01A')

SELECT 	'F' +
	RIGHT('          ' + 'F' + t1.serie + CONVERT(VARCHAR, CONVERT(BIGINT, t1.folio_fiscal)), 10) +
	'000' +
	--RIGHT('0000000000' + CONVERT(VARCHAR, t1.folio_fiscal), 10) + 
	---RIGHT('0000000000' + CONVERT(VARCHAR, t1.folio_fiscal), 10) +
	'000' +
	CONVERT(VARCHAR(8), GETDATE(), 112) +
	RIGHT('000000000000' + CONVERT(VARCHAR, CONVERT(BIGINT, SUM(importe_neto)*100)), 12) + --AS TotalProntoPago   --TOTAL CON PRONTO PAGO
	RIGHT('000000000000' + CONVERT(VARCHAR, CONVERT(BIGINT, SUM(t1.descto_comercial)*100)), 12) +
	
	RIGHT('000000000000' + CONVERT(VARCHAR, ISNULL(SUM(CASE WHEN t1.clas_fis = 'N' THEN ISNULL(CONVERT(BIGINT, t1.importe_bruto*100),0)-ISNULL(CONVERT(BIGINT, descto_oferta*100),0) END),0) +  
	ISNULL(SUM(CASE WHEN t1.clas_fis = 'B' THEN ISNULL(CONVERT(BIGINT, t1.importe_bruto*100),0)-ISNULL(CONVERT(BIGINT, t1.descto_oferta*100),0) END),0) +  
	ISNULL(SUM(CASE WHEN t1.clas_fis = 'H' THEN ISNULL(CONVERT(BIGINT, t1.importe_bruto*100),0)-ISNULL(CONVERT(BIGINT, t1.descto_oferta*100),0) END),0) +
	ISNULL(SUM(CASE WHEN t1.clas_fis = 'NA' THEN CONVERT(BIGINT, t1.importe_bruto-descto_oferta*100) END),0) +
	ISNULL(SUM(CASE WHEN t1.clas_fis = 'BA' THEN CONVERT(BIGINT, t1.importe_bruto-descto_oferta*100) END),0) +
	ISNULL(SUM(CASE WHEN t1.clas_fis = 'HA' THEN CONVERT(BIGINT, t1.importe_bruto-descto_oferta*100) END),0) + 
	CONVERT(BIGINT, SUM(t1.iva)*100)), 12) + -- AS GranTotal , --GRAN TOTAL
	RIGHT('000000000000' + CONVERT(VARCHAR, CONVERT(BIGINT, SUM(t1.iva)*100)), 12) + --AS IVA15_2 , --IVA 15%
	CASE
		WHEN @BrutoIEPS IS NOT NULL THEN @BrutoIEPS
		WHEN @BrutoIEPS IS NULL THEN '000000000000'
	END +
	RIGHT('000000' + CONVERT(VARCHAR, SUM(t1.piezas_surtidas_con_cargo)), 6) +  --total_piezas
	'                  '
FROM 	facturacion_electronica_estandar t1 
WHERE --	t1.fecha_factura = CONVERT(DATETIME, CONVERT(VARCHAR(10), @fecha, 121), 121) AND 
		t1.fecha_tandem = CONVERT(DATETIME, CONVERT(VARCHAR(10), @fecha, 121), 121) AND 
	t1.segto = @segto AND 
	t1.ctepadre = @ctepadre AND
	--t1.tipo_documento = 'R' AND   
	t1.sucursal = @sucursal AND
	t1.cliente = @cliente AND
	t1.folio_fiscal = @folio_fiscal
GROUP BY t1.serie, t1.folio_fiscal
GO
