
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_genera_facturacion_electronica_nadro_registro_adicional]
	@sucursal INT,
	@fecha DATETIME,
	@segto VARCHAR(10),
	@ctepadre VARCHAR(10),
	@cliente VARCHAR(5),
	@folio_fiscal VARCHAR(10)
WITH ENCRYPTION
AS
--DECLARE @folio_fiscal(10)	
--DECLARE @sucursal INT
--DECLARE @fecha DATETIME
--DECLARE @segto VARCHAR(10)
--DECLARE @ctepadre VARCHAR(10)
--DECLARE @cliente VARCHAR(5)
--SET @sucursal = 1
--SET @fecha = '17-02-2009'
--SET @segto = 'C1'
--SET @ctepadre = '868'
--SET @cliente = '74590'
--SET @folio_fiscal = ''
SELECT 	'A' +
	RIGHT('00000000000' + CONVERT(VARCHAR, ISNULL(SUM(CASE WHEN t1.clas_fis = 'N' THEN ISNULL(CONVERT(BIGINT, t1.importe_bruto*100),0)-ISNULL(CONVERT(BIGINT, descto_oferta*100),0) END),0) + 
	ISNULL(SUM(CASE WHEN t1.clas_fis = 'B' THEN ISNULL(CONVERT(BIGINT, t1.importe_bruto*100),0)-ISNULL(CONVERT(BIGINT, descto_oferta*100),0) END),0) +  
	ISNULL(SUM(CASE WHEN t1.clas_fis = 'H' THEN ISNULL(CONVERT(BIGINT, t1.importe_bruto*100),0)-ISNULL(CONVERT(BIGINT, descto_oferta*100),0) END),0)), 11) +  -- AS Tasa0, --TASA0%
	'00000000000' +
	RIGHT('00000000000' + CONVERT(VARCHAR, ISNULL(SUM(CASE WHEN t1.clas_fis = 'N' THEN ISNULL(CONVERT(BIGINT, t1.importe_bruto*100),0)-ISNULL(CONVERT(BIGINT, descto_oferta*100),0) END),0) + 
	ISNULL(SUM(CASE WHEN t1.clas_fis = 'B' THEN ISNULL(CONVERT(BIGINT, t1.importe_bruto*100),0)-ISNULL(CONVERT(BIGINT, descto_oferta*100),0) END),0) +  
	ISNULL(SUM(CASE WHEN t1.clas_fis = 'H' THEN ISNULL(CONVERT(BIGINT, t1.importe_bruto*100),0)-ISNULL(CONVERT(BIGINT, descto_oferta*100),0) END),0)), 11) +  -- AS Tasa0, --TASA0%
	RIGHT('00000000000' + CONVERT(VARCHAR, CONVERT(BIGINT, SUM(t1.iva)*100)), 11) +
	RIGHT('00000000000' + CONVERT(VARCHAR, CONVERT(BIGINT, SUM(t1.bonificacion_iva)*100)), 11) +
	RIGHT('00000000000' + CONVERT(VARCHAR, CONVERT(BIGINT, SUM(t1.bonificacion_iva)*100)), 11) +
	RIGHT('000000000000' + CONVERT(VARCHAR, CONVERT(BIGINT, SUM(t1.iva)*100)), 12) +
	RIGHT('000000000000' + CONVERT(VARCHAR, CONVERT(BIGINT, SUM(t1.bonificacion_iva)*100)), 12) +
	'0001' +
	'00001' +
	'           '
FROM 	facturacion_electronica_estandar t1 
WHERE --t1.fecha_factura = CONVERT(DATETIME, CONVERT(VARCHAR(10), @fecha, 121), 121) AND 
		t1.fecha_tandem >= CONVERT(DATETIME, CONVERT(VARCHAR(10), @fecha, 121), 121) AND 
	t1.segto = @segto AND 
	t1.ctepadre = @ctepadre AND
	--t1.tipo_documento = 'R' AND   
	t1.sucursal = @sucursal AND
	t1.cliente = @cliente AND
	t1.folio_fiscal = @folio_fiscal
GROUP BY t1.folio_fiscal
GO
