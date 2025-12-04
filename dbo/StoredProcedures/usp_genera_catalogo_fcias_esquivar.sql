--	usp_genera_catalogo_fcias_esquivar2 5
--drop procedure usp_genera_catalogo_fcias_esquivar
create PROCEDURE [dbo].[usp_genera_catalogo_fcias_esquivar]
	@sucursal TINYINT
AS
	DECLARE @descuento money

--DECLARE @sucursal TINYINT
--DECLARE @descuento VARCHAR(6)
--SET @sucursal = 5

--SELECT @descuento =		RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR(6), descuento), 6) 
SELECT @descuento =	descuento FROM clientes_baan where sucursal = 5 and cliente = '99142'

SELECT	RIGHT('00' + CONVERT(VARCHAR, @sucursal), 2) +
		REPLICATE(' ', 10) +
		LEFT(CONVERT(VARCHAR(13), CONVERT(BIGINT, t1.cod_barras)) + REPLICATE(' ', 13), 13) + 
		LEFT(t1.descripcion + '                              ', 30) + 
		--LEFT(RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR(15),		CASE t1.grupo_est 
		--															WHEN 'PC01A' THEN t1.prec_farm + (t1.prec_farm * 0.5) 
		--															ELSE t1.prec_farm 
		--														END), 12), 9) + 
		CASE t1.grupo_est 
			WHEN 'PC01A' THEN RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR(9), ROUND(t1.prec_farm, 2, 2) + (ROUND(t1.prec_farm, 2, 2) * 0.5)), 9)
			ELSE RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR(9), ROUND(t1.prec_farm, 2, 2)), 9) 
		END +
		RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR(9), t1.prec_pub), 9) +
		CASE 
			WHEN t1.clas_fis = 'B' THEN RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR(6), @descuento), 6)
			WHEN t1.clas_fis = 'BA' THEN RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR(6), @descuento), 6)
			WHEN t1.clas_fis = 'N' THEN '  0.00' 
			WHEN t1.clas_fis = 'NA' THEN '  0.00' 
			WHEN t1.clas_fis = 'H' THEN RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR(6), case when t1.descto_prod > @descuento then @descuento else t1.descto_prod end), 6) 
			WHEN t1.clas_fis = 'HA' THEN RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR(6), case when t1.descto_prod > @descuento then @descuento else t1.descto_prod end), 6) 
		END +
		CASE 
			WHEN t2.piezas = 0 THEN ' 0'
			WHEN t2.piezas BETWEEN 1 AND 49 THEN ' 1'
			WHEN t2.piezas BETWEEN 50 AND 99 THEN ' 2'
			WHEN t2.piezas BETWEEN 100 AND 149 THEN ' 3'
			WHEN t2.piezas >= 150 THEN ' 4'
			ELSE ' 0'
		END
FROM	maestro_productos_baan t1 INNER JOIN inventario_baan t2 ON 
		t1.codigo = t2.codigo AND 
		t2.sucursal = @sucursal
WHERE	CONVERT(INT, t1.codigo) < dbo.gobierno() AND
		ISNUMERIC(t1.cod_barras) = 1 AND
		SUBSTRING(t1.status, 1,1) <> 'B' 
ORDER BY t1.descripcion

GO

