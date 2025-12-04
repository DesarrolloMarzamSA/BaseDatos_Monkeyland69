
CREATE PROCEDURE [farmaprontovg].[usp_GetFacturacionElectronicaRegistroAdicional]
	@sucursal INT,
	@fecha DATETIME,
	@segto VARCHAR(2),
	@ctepadre VARCHAR(3),
	@cliente VARCHAR(5),
	@folio_fiscal VARCHAR(8)
AS

SELECT	'A' +
		RIGHT(REPLICATE('0', 11) + CONVERT(VARCHAR(11), ISNULL(SUM(CASE WHEN t1.clas_fis = 'N' THEN ISNULL(CONVERT(BIGINT, t1.importe_bruto * 100), 0) - ISNULL(CONVERT(BIGINT, descto_oferta * 100), 0) END), 0) + 
		ISNULL(SUM(CASE WHEN t1.clas_fis = 'B' THEN ISNULL(CONVERT(BIGINT, t1.importe_bruto * 100), 0) - ISNULL(CONVERT(BIGINT, descto_oferta * 100), 0) END), 0) +  
		ISNULL(SUM(CASE WHEN t1.clas_fis = 'H' THEN ISNULL(CONVERT(BIGINT, t1.importe_bruto * 100), 0) - ISNULL(CONVERT(BIGINT, descto_oferta * 100), 0) END), 0)), 11) +  
		REPLICATE('0', 11) +
		RIGHT(REPLICATE('0', 11) + CONVERT(VARCHAR(11), ISNULL(SUM(CASE WHEN t1.clas_fis = 'N' THEN ISNULL(CONVERT(BIGINT, t1.importe_bruto * 100), 0) - ISNULL(CONVERT(BIGINT, descto_oferta * 100), 0) END), 0) + 
		ISNULL(SUM(CASE WHEN t1.clas_fis = 'B' THEN ISNULL(CONVERT(BIGINT, t1.importe_bruto * 100), 0) - ISNULL(CONVERT(BIGINT, descto_oferta * 100), 0) END), 0) +  
		ISNULL(SUM(CASE WHEN t1.clas_fis = 'H' THEN ISNULL(CONVERT(BIGINT, t1.importe_bruto * 100), 0) - ISNULL(CONVERT(BIGINT, descto_oferta * 100), 0) END), 0)), 11) +  
		RIGHT(REPLICATE('0', 11) + CONVERT(VARCHAR(11), CONVERT(BIGINT, SUM(t1.iva) * 100)), 11) +
		RIGHT(REPLICATE('0', 11) + CONVERT(VARCHAR(11), CONVERT(BIGINT, SUM(t1.bonificacion_iva) * 100)), 11) +
		RIGHT(REPLICATE('0', 11) + CONVERT(VARCHAR(11), CONVERT(BIGINT, SUM(t1.bonificacion_iva) * 100)), 11) +
		RIGHT(REPLICATE('0', 12) + CONVERT(VARCHAR(12), CONVERT(BIGINT, SUM(t1.iva) * 100)), 12) +
		RIGHT(REPLICATE('0', 12) + CONVERT(VARCHAR(12), CONVERT(BIGINT, SUM(t1.bonificacion_iva) * 100)), 12) +
		'0001' +
		'00001' +
		REPLICATE(' ', 11)
FROM 	facturacion_electronica_estandar t1 
WHERE   t1.ctepadre = @ctepadre AND
		t1.sucursal = @sucursal AND
		t1.cliente = @cliente AND
		t1.folio_fiscal = @folio_fiscal
		
GROUP BY t1.folio_fiscal

GO

