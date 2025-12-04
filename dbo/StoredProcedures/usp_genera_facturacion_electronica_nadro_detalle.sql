USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[usp_genera_facturacion_electronica_nadro_detalle]
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
--DECLARE 
--SET @sucursal = 1
--SET @fecha = '17-02-2009'
--SET @segto = 'C1'
--SET @ctepadre = '868'
--SET @cliente = '74590'
--SET @folio_fiscal = ''
SELECT 	'P' +
	RIGHT('00000000' + CONVERT(VARCHAR, t1.codigo), 8) +
	RIGHT('000000' + CONVERT(VARCHAR, t1.piezas_surtidas_con_cargo), 6) +
	RIGHT('000000' + CONVERT(VARCHAR, t1.piezas_surtidas_sin_cargo), 6) +
	RIGHT('00000' + CONVERT(VARCHAR, CONVERT(BIGINT, t1.porcentaje_descto_oferta * 100)), 5) +
	RIGHT('00000000' + CONVERT(VARCHAR, CONVERT(BIGINT, t1.precio_farm_sin_imp*100)), 8) +
	RIGHT('00000000' + CONVERT(VARCHAR, CONVERT(BIGINT, t1.precio_pub_sin_imp*100)), 8 ) +
	RIGHT('00000000' + CONVERT(VARCHAR, CONVERT(BIGINT, t1.importe_bruto*100)), 8) +
	RIGHT('00000000' + CONVERT(VARCHAR, CONVERT(BIGINT, t1.precio_pub_sin_imp * t1.piezas_surtidas_con_cargo*100)), 8) +
	RIGHT('00000000' + CONVERT(VARCHAR, CONVERT(BIGINT, t1.iva*100)), 8) +
	RIGHT('00000000' + CONVERT(VARCHAR, CONVERT(BIGINT, t1.ieps*100)), 8) +
	CASE
		WHEN t1.clas_fis = 'N' THEN '00000'
		WHEN t1.clas_fis = 'NA' THEN '00000'
		WHEN t1.clas_fis = 'B' THEN RIGHT('00000' + CONVERT(VARCHAR, CONVERT(BIGINT, t1.porcentaje_descto_comercial*100)), 5)
		WHEN t1.clas_fis = 'BA' THEN RIGHT('00000' + CONVERT(VARCHAR, CONVERT(BIGINT, t1.porcentaje_descto_comercial*100)), 5)
		WHEN t1.clas_fis = 'H' THEN RIGHT('00000' + CONVERT(VARCHAR, CONVERT(BIGINT, t1.porcentaje_descto_comercial*100)), 5)
		WHEN t1.clas_fis = 'HA' THEN RIGHT('00000' + CONVERT(VARCHAR, CONVERT(BIGINT, t1.porcentaje_descto_comercial*100)), 5)
		ELSE '00000'
	END +
	'         ' +
	'1' +
	RIGHT('00000000000000' + CONVERT(VARCHAR, CONVERT(BIGINT, t1.cod_barras)), 14) +
	RIGHT('0000' + CONVERT(VARCHAR, CONVERT(BIGINT, t1.porcentaje_utilidad*100)), 4) +
	CASE
		WHEN t1.clas_fis = 'N' THEN '4'
		WHEN t1.clas_fis = 'NA' THEN '2'
		WHEN t1.clas_fis = 'B' THEN '4'
		WHEN t1.clas_fis = 'BA' THEN '2'
		WHEN t1.clas_fis = 'H' THEN '4'
		WHEN t1.clas_fis = 'HA' THEN '2'
	END +
	'0' +
	'0'
FROM 	facturacion_electronica_estandar t1
WHERE 	--t1.fecha_factura = CONVERT(DATETIME, CONVERT(VARCHAR(10), @fecha, 121), 121) AND 
	t1.fecha_tandem = CONVERT(DATETIME, CONVERT(VARCHAR(10), @fecha, 121), 121) AND 
	t1.segto = @segto AND 
	t1.ctepadre = @ctepadre AND
	--t1.tipo_documento = 'R' AND   
	t1.sucursal = @sucursal AND
	t1.cliente = @cliente AND
	t1.folio_fiscal = @folio_fiscal
ORDER BY t1.cod_barras
GO
