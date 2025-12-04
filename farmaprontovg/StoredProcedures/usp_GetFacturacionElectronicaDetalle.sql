

CREATE  PROCEDURE [farmaprontovg].[usp_GetFacturacionElectronicaDetalle]
	@sucursal INT,
	@fecha DATETIME,
	@segto VARCHAR(2),
	@ctepadre VARCHAR(3),
	@cliente VARCHAR(5),
	@folio_fiscal VARCHAR(8)
AS

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
WHERE 	t1.ctepadre = @ctepadre AND
		t1.sucursal = @sucursal AND
		t1.cliente = @cliente AND
		t1.folio_fiscal = @folio_fiscal
		
		
ORDER BY t1.cod_barras

GO

