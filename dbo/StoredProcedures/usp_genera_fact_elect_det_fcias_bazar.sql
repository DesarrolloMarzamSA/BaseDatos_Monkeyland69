
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_genera_fact_elect_det_fcias_bazar]
	@sucursal TINYINT,
	@fecha DATETIME,
	@segto VARCHAR(2),
	@ctepadre VARCHAR(3)

AS

--DECLARE @sucursal TINYINT
--DECLARE @segto VARCHAR(2)
--DECLARE @ctepadre VARCHAR(3)
--DECLARE @fecha DATETIME
--SET @sucursal = 13
--SET @segto = 'C2'
--SET @ctepadre = '468'
--SET @fecha = '2011-03-29'

SELECT	t1.cliente +
		RIGHT('                    ' + SUBSTRING(t2.farmacia, 1, 20), 20) +
		t1.factura +
		RIGHT('000000000' + t1.codigo, 9) +
		RIGHT('00000' + CONVERT(VARCHAR, t1.piezas_surtidas_con_cargo), 5) +
		RIGHT('00000000' + CONVERT(VARCHAR, t1.porcentaje_descto_oferta/100), 8) +
		LEFT(t1.clas_fis + '  ', 2) + 
		RIGHT('000000000000' + CONVERT(VARCHAR, t1.precio_pub_sin_imp), 12) +
		RIGHT('000000000000' + CONVERT(VARCHAR, t1.precio_farm_sin_imp), 12) +
		' ' +
		LEFT(t1.cod_barras + '             ', 13) +
		' ' +
		RIGHT('00' + CONVERT(VARCHAR, DATEPART(YY,@fecha)), 2) +
		'/' +
		RIGHT('00' + CONVERT(VARCHAR, DATEPART(MM,@fecha)), 2) +
		'/' +
		RIGHT('00' + CONVERT(VARCHAR, DATEPART(DD,@fecha)), 2) 
FROM	facturacion_electronica_estandar t1 INNER JOIN clientes_baan t2 ON
		t1.sucursal = t2.sucursal and
		t1.cliente = t2.cliente
WHERE	t1.sucursal = @sucursal AND
		t1.fecha_tandem = convert(datetime, convert(varchar(10), @fecha, 121), 121) AND
		t1.segto = @segto AND
		t1.ctepadre = @ctepadre
ORDER BY t2.cliente
GO
