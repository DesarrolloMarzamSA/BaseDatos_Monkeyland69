

CREATE PROCEDURE [farmaprontovg].[usp_GetFacturacionElectronicaEncabezado]
	@sucursal INT,
	@fecha DATETIME,
	@segto VARCHAR(2),
	@ctepadre VARCHAR(3),
	@cliente VARCHAR(5),
	@folio_fiscal VARCHAR(8)
AS
DECLARE @BrutoIEPS VARCHAR(12)

SELECT	@BrutoIEPS = RIGHT(REPLICATE(' ', 12) + CONVERT(VARCHAR(12), SUM((CONVERT(BIGINT, ISNULL(t1.importe_bruto, 0) * 100) - CONVERT(BIGINT, ISNULL(t1.descto_oferta, 0) * 100)) / 2)), 12)
FROM 	facturacion_electronica_estandar t1 INNER JOIN maestro_productos t2 ON
		CONVERT(BIGINT, t1.cod_barras) = CONVERT(BIGINT, t2.cod_barras)
WHERE 	t1.fecha_tandem = convert(datetime, @fecha, 105) and
		t1.segto = @segto AND 
		t1.ctepadre = @ctepadre AND
		t1.sucursal = @sucursal AND
		t1.cliente = @cliente AND
		ISNUMERIC(t1.cod_barras) = 1 AND
		ISNUMERIC(t2.cod_barras) = 1 AND
		t1.folio_fiscal = @folio_fiscal AND
		t2.cod_barras IS NOT NULL AND		
		t2.grupo_est IN ('PC01G', 'PC01A')

		
SELECT 	'F' +
		RIGHT(REPLICATE(' ', 10) + t1.serie + CONVERT(VARCHAR(10), CONVERT(BIGINT, t1.folio_fiscal)), 10) +
		REPLICATE('0', 3) +
		REPLICATE('0', 3) +
		CONVERT(VARCHAR(8), t1.fecha_factura, 112) +
		RIGHT(REPLICATE('0', 12) + CONVERT(VARCHAR(12), CONVERT(BIGINT, SUM(importe_neto) * 100)), 12) + 
		RIGHT(REPLICATE('0', 12) + CONVERT(VARCHAR(12), CONVERT(BIGINT, SUM(t1.descto_comercial) * 100)), 12) +
		RIGHT(REPLICATE('0', 12) + CONVERT(VARCHAR(12),
		ISNULL(SUM(CASE WHEN t1.clas_fis = 'N' THEN ISNULL(CONVERT(BIGINT, t1.importe_bruto * 100),0) - ISNULL(CONVERT(BIGINT, t1.descto_oferta*100),0) END),0) +  
		ISNULL(SUM(CASE WHEN t1.clas_fis = 'B' THEN ISNULL(CONVERT(BIGINT, t1.importe_bruto * 100),0) - ISNULL(CONVERT(BIGINT, t1.descto_oferta*100),0) END), 0) +  
		ISNULL(SUM(CASE WHEN t1.clas_fis = 'H' THEN ISNULL(CONVERT(BIGINT, t1.importe_bruto * 100),0) - ISNULL(CONVERT(BIGINT, t1.descto_oferta*100),0) END), 0) +
		ISNULL(SUM(CASE WHEN t1.clas_fis = 'NA' THEN CONVERT(BIGINT, (t1.importe_bruto-descto_oferta) * 100) END), 0) +
		ISNULL(SUM(CASE WHEN t1.clas_fis = 'BA' THEN CONVERT(BIGINT, (t1.importe_bruto-descto_oferta) * 100) END), 0) +
		ISNULL(SUM(CASE WHEN t1.clas_fis = 'HA' THEN CONVERT(BIGINT, (t1.importe_bruto-descto_oferta) * 100) END), 0) + 
		CONVERT(BIGINT, SUM(t1.iva) * 100)), 12) +
		RIGHT(REPLICATE('0', 12) + CONVERT(VARCHAR, CONVERT(BIGINT, SUM(t1.iva)*100)), 12) + 
		CASE
			WHEN @BrutoIEPS IS NOT NULL THEN @BrutoIEPS
			WHEN @BrutoIEPS IS NULL THEN REPLICATE('0', 12)
		END +
		RIGHT(REPLICATE('0', 6) + CONVERT(VARCHAR(6), SUM(t1.piezas_surtidas_con_cargo)), 6) +  
		RIGHT(REPLICATE(' ', 18) + t1.serie + CONVERT(VARCHAR(18), CONVERT(BIGINT, t1.folio_fiscal)), 18)
FROM 	facturacion_electronica_estandar t1 
WHERE 	t1.ctepadre = @ctepadre AND
		t1.sucursal = @sucursal AND
		t1.cliente = @cliente AND
		t1.folio_fiscal = @folio_fiscal
		
GROUP BY t1.serie,fecha_factura, t1.folio_fiscal

GO

