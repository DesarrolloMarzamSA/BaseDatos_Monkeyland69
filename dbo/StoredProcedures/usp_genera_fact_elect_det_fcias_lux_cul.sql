
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_genera_fact_elect_det_fcias_lux_cul]
	@sucursal TINYINT,
	@fecha DATETIME,
	@segto VARCHAR(2),
	@ctepadre VARCHAR(3)

AS

--DECLARE @sucursal TINYINT
--DECLARE @segto VARCHAR(2)
--DECLARE @ctepadre VARCHAR(3)
--DECLARE @fecha DATETIME
--SET @sucursal = 17
--SET @segto = 'C2'
--SET @ctepadre = '800'
--SET @fecha = '2011-03-29'

SELECT	'      ' +
		CONVERT(VARCHAR(5), t1.cliente) +
		CONVERT(VARCHAR(2), t1.digito_verificador) + 
		'  ' +
		RIGHT(REPLICATE(' ', 5) + CONVERT(VARCHAR(5), CONVERT(MONEY, t1.porcentaje_descto_comercial)), 5) +
		'  ' + 
		RIGHT(REPLICATE(' ', 5) + CONVERT(VARCHAR(5), CONVERT(MONEY, t1.porcentaje_descto_oferta)), 5) +
		LEFT(CONVERT(VARCHAR(13), CONVERT(BIGINT, t1.cod_barras)) + REPLICATE(' ', 13), 13) +
		RIGHT(REPLICATE('0', 4) + CONVERT(VARCHAR(4), DATEPART(YYYY, @fecha)), 4) +
		RIGHT(REPLICATE('0', 2) + CONVERT(VARCHAR(2), DATEPART(MM, @fecha)), 2) +
		RIGHT(REPLICATE('0', 2) + CONVERT(VARCHAR(2), DATEPART(DD, @fecha)), 2) +
		'  ' +
		RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR(9), CONVERT(MONEY, t1.iva)), 9) +
		'  ' +
		RIGHT(REPLICATE(' ', 10) + CONVERT(VARCHAR(10), CONVERT(BIGINT, t1.folio_fiscal)), 10) +
		'  ' +
		RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR(6), t1.piezas_surtidas_con_cargo), 6) +
		'  ' +
		RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR(9), CONVERT(MONEY, ROUND(t1.precio_farm_sin_imp, 2, 2))), 9) + 
		'  ' +
		'     0'
FROM	facturacion_electronica_estandar t1 
WHERE	t1.sucursal = @sucursal AND
		t1.segto = @segto AND
		t1.ctepadre = @ctepadre AND
		--t1.fecha_factura = @fecha
		--fecha_tandem = convert(datetime, convert(varchar(10), @fecha, 121), 121)
		
		 (t1.fecha_tandem = convert(datetime, convert(varchar(10), current_timestamp, 121), 121)
or  t1.fecha_tandem = convert(datetime, convert(varchar(10), current_timestamp+1, 121), 121))
		--fecha_tandem >= convert(datetime, convert(varchar(10), @fecha, 121), 121)
ORDER BY t1.folio_fiscal

GO
