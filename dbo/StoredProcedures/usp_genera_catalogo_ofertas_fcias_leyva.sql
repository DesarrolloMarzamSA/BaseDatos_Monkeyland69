
CREATE PROCEDURE [dbo].[usp_genera_catalogo_ofertas_fcias_leyva]
	@sucursal TINYINT,
	@primer_bolsa VARCHAR(5),
	@segunda_bolsa VARCHAR(5)
AS

DECLARE @descuento AS VARCHAR(7)
/*
--DECLARE @descuento AS VARCHAR(7)
--DECLARE @primer_bolsa  AS VARCHAR(5)
--DECLARE @segunda_bolsa AS VARCHAR(5)
--DECLARE @sucursal AS TINYINT
--SET @primer_bolsa = 'PLUS6'
--SET @segunda_bolsa = 'LIBRE'
--SET @sucursal = 1

SELECT	@descuento = RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR(6), descuento), 6) 
FROM	clientes_baan 
WHERE	sucursal = @sucursal AND 
		cliente = '08590'

SELECT	RIGHT(REPLICATE('0', 2) + CONVERT(VARCHAR(2), @sucursal), 2) +
		REPLICATE(' ', 10) +
		LEFT(CONVERT(VARCHAR(13), CONVERT(BIGINT, t1.cod_barras)) + REPLICATE(' ', 13), 13) +
		LEFT(t1.descripcion + REPLICATE(' ', 30), 30) +
		CASE t1.grupo_est 
			WHEN 'PC01A' THEN RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR(9), CONVERT(MONEY, ROUND(t1.prec_farm, 2, 2) + (ROUND(t1.prec_farm, 2, 2) * 0.5))), 9)
			ELSE RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR(9), CONVERT(MONEY, ROUND(t1.prec_farm, 2, 2))), 9)
		END  +
		RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR(6), CONVERT(MONEY, t3.porcentaje * 100)), 6) +
		'      0' +
		'      0' +
		'      0' +
		CASE 
			WHEN t1.clas_fis = 'B' THEN @descuento
			WHEN t1.clas_fis = 'BA' THEN @descuento
			WHEN t1.clas_fis = 'N' THEN '  0.00'
			WHEN t1.clas_fis = 'NA' THEN '  0.00' 
			WHEN t1.clas_fis = 'H' THEN RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR(6), CONVERT(MONEY, ROUND(t1.descto_prod, 2, 2))), 6)
			WHEN t1.clas_fis = 'HA' THEN RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR(6), CONVERT(MONEY, ROUND(t1.descto_prod, 2, 2))), 6)
		END
FROM	maestro_productos_baan t1 INNER JOIN inventario_baan t2 ON 
		t1.codigo = t2.codigo AND 
		t2.sucursal = @sucursal INNER JOIN dboferta t3 ON 
		t2.codigo = t3.codigo AND 
		t2.sucursal = t3.sucursal AND 
		t3.bolsa = @primer_bolsa 
WHERE	t3.vigencia_final > CONVERT(DATETIME, CONVERT(VARCHAR(10), GETDATE(), 121), 121) AND
		CONVERT(INT, t1.codigo) < dbo.gobierno() AND
		ISNUMERIC(t1.cod_barras) = 1 AND
		SUBSTRING(t1.status, 1,1) <> 'B' --AND
UNION
SELECT	RIGHT(REPLICATE('0', 2) + CONVERT(VARCHAR(2), @sucursal), 2) +
		REPLICATE(' ', 10) +
		LEFT(CONVERT(VARCHAR(13), CONVERT(BIGINT, t1.cod_barras)) + REPLICATE(' ', 13), 13) +
		LEFT(t1.descripcion + REPLICATE(' ', 30), 30) +
		CASE t1.grupo_est 
			WHEN 'PC01A' THEN RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR(9), CONVERT(MONEY, ROUND(t1.prec_farm, 2, 2) + (ROUND(t1.prec_farm, 2, 2) * 0.5))), 9)
			ELSE RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR(9), CONVERT(MONEY, ROUND(t1.prec_farm, 2, 2))), 9)
		END  +
		RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR(6), CONVERT(MONEY, t3.porcentaje * 100)), 6) +
		'      0' +
		'      0' +
		'      0' +
		CASE 
			WHEN t1.clas_fis = 'B' THEN @descuento
			WHEN t1.clas_fis = 'BA' THEN @descuento
			WHEN t1.clas_fis = 'N' THEN '  0.00'
			WHEN t1.clas_fis = 'NA' THEN '  0.00' 
			WHEN t1.clas_fis = 'H' THEN RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR(6), CONVERT(MONEY, ROUND(t1.descto_prod, 2, 2))), 6)
			WHEN t1.clas_fis = 'HA' THEN RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR(6), CONVERT(MONEY, ROUND(t1.descto_prod, 2, 2))), 6)
		END
FROM	maestro_productos_baan t1 INNER JOIN inventario_baan t2 on 
		t1.codigo = t2.codigo AND 
		t2.sucursal = @sucursal INNER JOIN dboferta t3 on 
		t2.codigo = t3.codigo AND 
		t2.sucursal = t3.sucursal AND 
		t3.bolsa = @segunda_bolsa 
WHERE	t3.vigencia_final > CONVERT(DATETIME, CONVERT(VARCHAR(10), GETDATE(), 121), 121) AND
		CONVERT(INT, t1.codigo) < dbo.gobierno() AND
		ISNUMERIC(t1.cod_barras) = 1 AND
		SUBSTRING(t1.status, 1,1) <> 'B' AND
		CONVERT(INT, t1.codigo) < dbo.gobierno() AND 
		t3.disponible > 10 AND
		t3.codigo NOT IN	(	
								SELECT	codigo 
								FROM	dboferta 
								WHERE	sucursal = @sucursal AND 
										bolsa = @primer_bolsa
							)  
*/

SELECT	@descuento = RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR(6), descuento), 6) 
FROM	clientes_baan 
WHERE	sucursal = @sucursal AND 
		cliente = '08590'

SELECT	''+REPLICATE(' ', 12-LEN(CONVERT(VARCHAR(2), '01'))) + CONVERT(VARCHAR(2), '01') +
		REPLICATE(' ', 13-LEN(CONVERT(varchar(15), CONVERT(BIGINT, t1.cod_barras)))) + CONVERT(varchar(15), CONVERT(BIGINT, t1.cod_barras)) +
		REPLICATE(' ', 29-len(SUBSTRING(t1.descripcion,0,29)))+ltrim(rtrim(SUBSTRING(t1.descripcion,0,29)))+
		REPLICATE(' ', 8-len(CONVERT(varchar,t1.prec_farm)))+CONVERT(varchar,t1.prec_farm)	  +
		REPLICATE(' ', 6-len(CONVERT(varchar,monkeyland.dbo.udf_calc_descto_prod(clas_fis,19.00,descto_prod))))+CONVERT(varchar,monkeyland.dbo.udf_calc_descto_prod(clas_fis,19.00,descto_prod))+
		REPLICATE(' ', 5-LEN(CONVERT(VARCHAR(7), '0'))) + CONVERT(VARCHAR(7), '0') +
 		REPLICATE(' ', 6-LEN(CONVERT(VARCHAR(7), '0'))) + CONVERT(VARCHAR(7), '0') +
		REPLICATE(' ', 5-LEN(CONVERT(VARCHAR(7), '0'))) + CONVERT(VARCHAR(7), '0') +
		REPLICATE(' ', 5-LEN(CONVERT(varchar(15), replace(t1.descto_prod,'.00','')))) + CONVERT(varchar(15), replace(t1.descto_prod,'.00','')) +
	 	REPLICATE(' ', 8-len(CONVERT(varchar,t1.prec_pub))) +  CONVERT(varchar,t1.prec_pub)+
		REPLICATE(' ', 7-len(CONVERT(varchar,case when t1.iva=0.00 then 0 when t1.iva=0.11 then 11 when t1.iva=0.16 then 16 end)))+CONVERT(varchar,case when t1.iva=0.00 then 0 when t1.iva=0.11 then 11 when t1.iva=0.16 then 16 end) +
		REPLICATE(' ', 29-len(substring(t1.lab_largo,0,29)))+ltrim(rtrim(substring(t1.lab_largo,0,29))) +
		ltrim(rtrim(CONVERT(varchar,case when t2.piezas=0 then 0 when (t2.piezas>0 and t2.piezas<=50) then 1 when t2.piezas>50 then 2 else isnull(t2.piezas,'0')  end)))    as pzasDispo
FROM	maestro_productos_baan t1 INNER JOIN inventario_baan t2 ON 
		t1.codigo = t2.codigo AND 
		t2.sucursal = @sucursal INNER JOIN dboferta t3 ON 
		t2.codigo = t3.codigo AND 
		t2.sucursal = t3.sucursal AND 
		t3.bolsa = @primer_bolsa 
WHERE	t3.vigencia_final > CONVERT(DATETIME, CONVERT(VARCHAR(10), GETDATE(), 121), 121) AND
		CONVERT(INT, t1.codigo) < dbo.gobierno() AND
		ISNUMERIC(t1.cod_barras) = 1 AND
		SUBSTRING(t1.status, 1,1) <> 'B' --AND
UNION
SELECT	'' + REPLICATE(' ', 12-LEN(CONVERT(VARCHAR(2), '01'))) + CONVERT(VARCHAR(2), '01') +
		REPLICATE(' ', 13-LEN(CONVERT(varchar(15), CONVERT(BIGINT, t1.cod_barras)))) + CONVERT(varchar(15), CONVERT(BIGINT, t1.cod_barras)) +
		REPLICATE(' ', 29-len(SUBSTRING(t1.descripcion,0,29)))+ltrim(rtrim(SUBSTRING(t1.descripcion,0,29))) +
		REPLICATE(' ', 8-len(CONVERT(varchar,t1.prec_farm)))+CONVERT(varchar,t1.prec_farm)	  +
		REPLICATE(' ', 6-len(CONVERT(varchar,monkeyland.dbo.udf_calc_descto_prod(clas_fis,19.00,descto_prod))))+CONVERT(varchar,monkeyland.dbo.udf_calc_descto_prod(clas_fis,19.00,descto_prod))+
		REPLICATE(' ', 5-LEN(CONVERT(VARCHAR(7), '0'))) + CONVERT(VARCHAR(7), '0') +
		REPLICATE(' ', 6-LEN(CONVERT(VARCHAR(7), '0'))) + CONVERT(VARCHAR(7), '0') +
		REPLICATE(' ', 5-LEN(CONVERT(VARCHAR(7), '0'))) + CONVERT(VARCHAR(7), '0') +
		REPLICATE(' ', 5-LEN(CONVERT(varchar(15), replace(t1.descto_prod,'.00','')))) + CONVERT(varchar(15), replace(t1.descto_prod,'.00','')) +
		REPLICATE(' ', 8-len(CONVERT(varchar,t1.prec_pub))) +  CONVERT(varchar,t1.prec_pub) +
		REPLICATE(' ', 7-len(CONVERT(varchar,case when t1.iva=0.00 then 0 when t1.iva=0.11 then 11 when t1.iva=0.16 then 16 end)))+CONVERT(varchar,case when t1.iva=0.00 then 0 when t1.iva=0.11 then 11 when t1.iva=0.16 then 16 end) +
		REPLICATE(' ', 29-len(substring(t1.lab_largo,0,29)))+ltrim(rtrim(substring(t1.lab_largo,0,29))) +
		ltrim(rtrim(CONVERT(varchar,case when t2.piezas=0 then 0 when (t2.piezas>0 and t2.piezas<=50) then 1 when t2.piezas>50 then 2 else isnull(t2.piezas,'0')  end)))    as pzasDispo
FROM	maestro_productos_baan t1 INNER JOIN inventario_baan t2 on 
		t1.codigo = t2.codigo AND 
		t2.sucursal = @sucursal INNER JOIN dboferta t3 on 
		t2.codigo = t3.codigo AND 
		t2.sucursal = t3.sucursal AND 
		t3.bolsa = @segunda_bolsa 
WHERE	t3.vigencia_final > CONVERT(DATETIME, CONVERT(VARCHAR(10), GETDATE(), 121), 121) AND
		CONVERT(INT, t1.codigo) < dbo.gobierno() AND
		ISNUMERIC(t1.cod_barras) = 1 AND
		SUBSTRING(t1.status, 1,1) <> 'B' AND
		t3.disponible > 10 AND
		t3.codigo NOT IN	(	
								SELECT	codigo 
								FROM	dboferta 
								WHERE	sucursal = @sucursal AND 
										bolsa = @primer_bolsa
							)

GO

