CREATE PROCEDURE [dbo].[usp_genera_cambios_fcias_farmapronto]
AS
DECLARE @descuento VARCHAR(6)

SELECT	@descuento = RIGHT(REPLICATE('0', 6) + CONVERT(VARCHAR(6), descuento), 6) 
FROM	clientes_baan 
WHERE	sucursal = 1 AND
		cliente = '32580'
create table #resultados(orden int identity(1,1), texto1 varchar(500))

insert into #resultados(texto1)
SELECT	CONVERT(VARCHAR(8), CURRENT_TIMESTAMP - 1, 112) +
		RIGHT(REPLICATE('0', 9) + t2.codigo, 9) +
		LEFT(t2.descripcion + REPLICATE(' ', 40), 40) +
		CASE t2.grupo_est 
			WHEN 'PC01A' THEN RIGHT(REPLICATE('0', 10) + CONVERT(VARCHAR(10), ROUND(t2.prec_farm, 2, 2) + (ROUND(t2.prec_farm, 2, 2) * 0.5)), 10)
			ELSE RIGHT(REPLICATE('0', 10) + CONVERT(VARCHAR(10), ROUND(t2.prec_farm, 2, 2)), 10) 
		END +
		CASE t2.grupo_est 
			WHEN 'PC01A' THEN RIGHT(REPLICATE('0', 10) + CONVERT(VARCHAR(10), ROUND(t2.prec_pub, 2, 2) + (ROUND(t2.prec_pub, 2, 2) * 0.5)), 10)
			ELSE RIGHT(REPLICATE('0', 10) + CONVERT(VARCHAR(10), ROUND(t2.prec_pub, 2, 2)), 10) 
		END +
		RIGHT(REPLICATE('0', 6) + CONVERT(VARCHAR(6), t2.iva * 100), 6) +
		CASE t2.grupo_est 
			WHEN 'PC01A' THEN '050.00' 
			ELSE '000.00' 
		END +
		'000.00' +
		LEFT(t2.clas_fis + REPLICATE(' ', 2), 2) +
		LEFT(CONVERT(VARCHAR(13), CONVERT(BIGINT, t2.cod_barras)) + REPLICATE(' ', 13), 13) + 
		CASE 
			WHEN t2.clas_fis = 'B' THEN @descuento
			WHEN t2.clas_fis = 'BA' THEN @descuento
			WHEN t2.clas_fis = 'N' THEN '000.00' 
			WHEN t2.clas_fis = 'NA' THEN '000.00' 
			WHEN t2.clas_fis = 'H' THEN RIGHT(REPLICATE('0', 6) + CONVERT(VARCHAR(6), t2.descto_prod), 6) 
			WHEN t2.clas_fis = 'HA' THEN RIGHT(REPLICATE('0', 6) + CONVERT(VARCHAR(6), t2.descto_prod), 6) 
		END +
		REPLICATE(' ', 14)
FROM	cambios_precio_baan t1 INNER JOIN maestro_productos_baan t2 ON 
		t1.t_item = t2.codigo
WHERE	DATEDIFF(DD, t1.fecha_hora, CURRENT_TIMESTAMP) <= 1 AND
		ISNUMERIC(t2.cod_barras) = 1 AND
		CONVERT(INT, t2.codigo) < dbo.gobierno() AND
		SUBSTRING(t2.status, 1, 1) <> 'B'
ORDER BY t2.descripcion



select texto1 + right('00000' + convert(varchar(5), orden), 5) consecutivo from #resultados where texto1 is not null

GO

