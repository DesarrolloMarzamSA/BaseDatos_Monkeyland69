

CREATE PROCEDURE [dbo].[usp_bi_ofertas] @sucursal int
AS 

/*
DECLARE @sucursal int
SET @sucursal = 1
[usp_bi_ofertas] 1
*/

SELECT 
	t1.codigo, 
	t1.descripcion, 
		CASE WHEN t1.prec_farm > 9999.99 THEN 0.01 ELSE t1.prec_farm END prec_farm,
		CASE WHEN t1.prec_pub  > 9999.99 THEN 0.01 ELSE t1.prec_pub  END prec_pub,
	t1.grupo_est,
	t1.lab_largo,
	t1.cod_lab,
	clas_ssa,
	t1.cod_barras,
	t1.clas_fis	,
	t1.fecha_alta,
	t1.refrigerado,
	t1.clas_abc,
	t2.cant_base,
	t2.cant_oferta,
	t2.porcentaje,
	t3.iva
INTO #temp_bi_ofertas
FROM maestro_productos_baan t1 
INNER JOIN dboferta t2 ON t1.codigo = t2.codigo and t2.sucursal = 21
INNER JOIN iva_sucursales t3 ON t2.sucursal = t3.sucursal
WHERE --	t1.prec_farm < 9999.99 and
CONVERT(INT, t1.codigo) < dbo.gobierno() and 
t2.bolsa = 'LIBRE' and
SUBSTRING(t1.STATUS, 1, 1) <> 'B'


select
	codigo +
	LEFT(descripcion + REPLICATE(' ',31), 31) +
	LEFT(RIGHT(REPLICATE('0', 7) + convert(VARCHAR, 
		CASE grupo_est WHEN 'PC01A' THEN prec_farm * 1.5 ELSE prec_farm END), 10), 7) + 
	RIGHT(REPLICATE('0', 4) + CONVERT(VARCHAR, cant_base), 4) +
	RIGHT(REPLICATE('0', 4) + CONVERT(VARCHAR, cant_oferta), 4) +
	RIGHT(REPLICATE(' ', 2) + CONVERT(VARCHAR, CONVERT(INT, ROUND(porcentaje * 100, 0, 2))), 2) +
	CASE clas_abc 
	WHEN 'A' THEN '3'
	WHEN 'B' THEN '2'
	WHEN 'C' THEN 'A'
	WHEN 'D' THEN 'B'
	WHEN 'E' THEN 'C'
	ELSE ' ' END + 
	' ' + 
	cod_barras col1
from #temp_bi_ofertas


DROP TABLE #temp_bi_ofertas

GO

