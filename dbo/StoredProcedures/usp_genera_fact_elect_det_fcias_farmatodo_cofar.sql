
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_genera_fact_elect_det_fcias_farmatodo_cofar]
	@sucursal TINYINT,
	@ctepadre VARCHAR(3),
	@fecha DATETIME
WITH ENCRYPTION
AS
--DECLARE @sucursal TINYINT
--DECLARE @ctepadre VARCHAR(3)
--DECLARE @fecha DATETIME
--SET @sucursal = 1
--SET @ctepadre = '125'
--SET @fecha = '2011-03-29'
SELECT	RIGHT(REPLICATE('0', 5) + t1.cliente, 5) + 
			LEFT(CONVERT(VARCHAR, CONVERT(BIGINT, t1.factura)) + REPLICATE(' ', 12), 12) +
			LEFT(CONVERT(VARCHAR, t2.codigo_farmacia) + REPLICATE(' ', 12), 12) +
			RIGHT('0000' + CONVERT(VARCHAR, DATEPART(YYYY,@fecha)), 4) +
			RIGHT('00' + CONVERT(VARCHAR, DATEPART(MM,@fecha)), 2) +
			RIGHT('00' + CONVERT(VARCHAR, DATEPART(DD,@fecha)), 2) +
			LEFT(t1.cod_barras + REPLICATE(' ', 13), 13) +
			RIGHT(REPLICATE(' ', 7) + CONVERT(VARCHAR, t1.piezas_surtidas_con_cargo), 7) +
			RIGHT(REPLICATE(' ', 7) + CONVERT(VARCHAR, t1.piezas_surtidas_sin_cargo), 7) +
			RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR, t1.precio_farm_sin_imp), 9) +
			RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR, t1.porcentaje_descto_oferta), 6) +
			RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR, t1.porcentaje_descto_comercial), 6) +
			RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR, t1.iva), 9)
FROM	facturacion_electronica_estandar t1 INNER JOIN cat_farmatodo_cofar_facturacion t2 ON
			t1.sucursal = t2.sucursal and
			t1.cliente = t2.cliente inner join cat_farmatodo_cofar t3 on
			t1.sucursal = t3.sucursal and
			t1.cliente = t3.cliente
WHERE	t1.sucursal = @sucursal AND
			t1.ctepadre = @ctepadre AND 
			t1.fecha_tandem >= convert(datetime, convert(varchar(10), @fecha, 121), 121)
ORDER BY 
			t1.factura

GO
