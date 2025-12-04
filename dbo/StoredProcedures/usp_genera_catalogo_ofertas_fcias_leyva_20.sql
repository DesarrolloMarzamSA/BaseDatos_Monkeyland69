CREATE PROCEDURE usp_genera_catalogo_ofertas_fcias_leyva_20
	@sucursal TINYINT,
	@primer_bolsa VARCHAR(5),
	@segunda_bolsa VARCHAR(5)
AS
DECLARE @descuento varchar(6)

--DECLARE @sucursal TINYINT
--DECLARE @primer_bolsa  VARCHAR(5)
--DECLARE @segunda_bolsa  VARCHAR(5)
--DECLARE @descuento VARCHAR(6)
--SET @sucursal = 1
--SET @primer_bolsa = 'LIBRE'
--SET @segunda_bolsa = 'XXXXX'

SELECT	@descuento = RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR(6), descuento), 6) 
FROM	clientes_baan 
WHERE	sucursal = @sucursal AND 
		cliente = '08590'

SELECT	LEFT(CONVERT(VARCHAR(12), @sucursal) + REPLICATE(' ', 12), 12) +
		LEFT(CONVERT(VARCHAR(15), RTRIM(LTRIM(t1.cod_barras))) + replicate(' ', 15), 15) + 
		LEFT(t1.descripcion + REPLICATE(' ', 30), 30) + 
		CASE t1.grupo_est 
			WHEN 'PC01A' THEN RIGHT(REPLICATE(' ', 7) + CONVERT(VARCHAR(7), t1.prec_farm + (t1.prec_farm * 0.5)), 7) + '00'
			ELSE RIGHT(REPLICATE(' ', 7) + CONVERT(VARCHAR(7), t1.prec_farm), 7) + '00'
		END +
		RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR(6), CONVERT(MONEY, t3.porcentaje * 100)), 6) +
		'      0' +
		'      0' +
		'      0' +
		CASE 
			WHEN t1.clas_fis = 'B' THEN @descuento
			WHEN t1.clas_fis = 'BA' THEN @descuento
			WHEN t1.clas_fis = 'N' THEN '  0.00' 
			WHEN t1.clas_fis = 'NA' THEN '  0.00' 
			WHEN t1.clas_fis = 'H' THEN RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR(6), t1.descto_prod), 6) 
			WHEN t1.clas_fis = 'HA' THEN RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR(6), t1.descto_prod), 6) 
		END +
		CASE t1.grupo_est 
			WHEN 'PC01A' THEN RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR(9), t1.prec_pub + (t1.prec_pub * 0.5)), 9)
			ELSE RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR(9), t1.prec_pub), 9) 
		END +
		RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR(9), CONVERT(INT, (t1.iva * 100))), 9) +
		LEFT(CONVERT(VARCHAR(30), t1.lab_largo) + REPLICATE(' ', 30), 30) +
		REPLICATE(' ', 1) +
		REPLICATE(' ', 1) +
		REPLICATE(' ', 1) +
		REPLICATE(' ', 30) +
		REPLICATE(' ', 15) +
		REPLICATE(' ', 4) +
		REPLICATE(' ', 15)
FROM	maestro_productos_baan t1 INNER JOIN inventario_baan t2 ON 
		t1.codigo = t2.codigo AND 
		t2.sucursal = @sucursal INNER JOIN dboferta t3 ON 
		t2.codigo = t3.codigo AND
		t2.sucursal = t3.sucursal AND 
		t3.bolsa = @primer_bolsa 
WHERE	CONVERT(INT, t1.codigo) < dbo.gobierno() AND
		ISNUMERIC(t1.cod_barras_tandem) = 1 AND
		SUBSTRING(t1.status, 1,1) <> 'B' 
UNION
SELECT	LEFT(CONVERT(VARCHAR(12), @sucursal) + REPLICATE(' ', 12), 12) +
		LEFT(CONVERT(VARCHAR(15), RTRIM(LTRIM(t1.cod_barras))) + replicate(' ', 15), 15) + 
		LEFT(t1.descripcion + REPLICATE(' ', 30), 30) + 
		CASE t1.grupo_est 
			WHEN 'PC01A' THEN RIGHT(REPLICATE(' ', 7) + CONVERT(VARCHAR(7), t1.prec_farm + (t1.prec_farm * 0.5)), 7) + '00'
			ELSE RIGHT(REPLICATE(' ', 7) + CONVERT(VARCHAR(7), t1.prec_farm), 7) + '00'
		END +
		RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR(6), CONVERT(MONEY, t3.porcentaje * 100)), 6) +
		'      0' +
		'      0' +
		'      0' +
		CASE 
			WHEN t1.clas_fis = 'B' THEN @descuento
			WHEN t1.clas_fis = 'BA' THEN @descuento
			WHEN t1.clas_fis = 'N' THEN '  0.00' 
			WHEN t1.clas_fis = 'NA' THEN '  0.00' 
			WHEN t1.clas_fis = 'H' THEN RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR(6), t1.descto_prod), 6) 
			WHEN t1.clas_fis = 'HA' THEN RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR(6), t1.descto_prod), 6) 
		END +
		CASE t1.grupo_est 
			WHEN 'PC01A' THEN RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR(9), t1.prec_pub + (t1.prec_pub * 0.5)), 9)
			ELSE RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR(9), t1.prec_pub), 9) 
		END +
		RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR(9), CONVERT(INT, (t1.iva * 100))), 9) +
		LEFT(CONVERT(VARCHAR(30), t1.lab_largo) + REPLICATE(' ', 30), 30) +
		REPLICATE(' ', 1) +
		REPLICATE(' ', 1) +
		REPLICATE(' ', 1) +
		REPLICATE(' ', 30) +
		REPLICATE(' ', 15) +
		REPLICATE(' ', 4) +
		REPLICATE(' ', 15)
FROM	maestro_productos_baan t1 INNER JOIN inventario_baan t2 ON 
		t1.codigo = t2.codigo AND 
		t2.sucursal = @sucursal INNER JOIN dboferta t3 ON 
		t2.codigo = t3.codigo AND
		t2.sucursal = t3.sucursal AND 
		t3.bolsa = @segunda_bolsa 
where	CONVERT(INT, t1.codigo) < dbo.gobierno() AND
		ISNUMERIC(t1.cod_barras_tandem) = 1 AND
		SUBSTRING(t1.status, 1,1) <> 'B' AND
		t3.codigo NOT IN	(	
								SELECT	codigo 
								FROM	dboferta 
								WHERE	sucursal = @sucursal and 
										bolsa = @primer_bolsa
							)

GO

