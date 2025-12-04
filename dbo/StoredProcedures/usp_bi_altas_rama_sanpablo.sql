SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[usp_bi_altas_rama_sanpablo] 
as

/*
usp_bi_altas 1
*/

/*
DECLARE @sucursal int
SET @sucursal = 1
*/

SELECT 
	t1.codigo, 
	t1.descripcion, 
		CASE WHEN t1.prec_farm > 9999.99 THEN 0.01 ELSE t1.prec_farm END prec_farm,
		CASE WHEN t1.prec_pub  > 9999.99 THEN 0.01 ELSE t1.prec_pub  END prec_pub,
	t1.grupo_est,
	t3.iva,
	t1.lab_largo,
	t1.cod_lab,
	clas_ssa,
	t1.cod_barras,
	t1.clas_fis	
INTO #temp_bi_altas
FROM maestro_productos_baan t1 
INNER JOIN inventario_baan t2 ON t1.codigo = t2.codigo and t2.sucursal = 1
INNER JOIN iva_sucursales t3 ON t2.sucursal = t3.sucursal
WHERE --	t1.prec_farm < 9999.99 and
CONVERT(INT, t1.codigo) < dbo.gobierno() and	
SUBSTRING(t1.STATUS, 1, 1) <> 'B' and
DATEDIFF(dd, t1.fecha_alta, CURRENT_TIMESTAMP) < 5
	
--exec usp_bi_altas 6
select 
	codigo + 
	LEFT(descripcion + REPLICATE(' ', 30), 30) +
	' ' +
	LEFT(right(REPLICATE('0', 7) + convert(varchar, 
		CASE grupo_est WHEN 'PC01G' THEN prec_farm * 1.5 ELSE prec_farm END), 10), 7) +
	LEFT(right(REPLICATE('0', 7) + convert(varchar, 
		CASE grupo_est WHEN 'PC01G' THEN prec_pub  * 1.5 ELSE prec_pub	END), 10), 7) +
	RIGHT('00' + convert(varchar(2), convert(int, iva * 100)), 2) +
	LEFT(lab_largo + REPLICATE(' ', 30), 30) +
	LEFT(cod_lab + REPLICATE(' ',  4), 4)  +
	CASE clas_ssa 
		WHEN '1' THEN 'CO' 
		WHEN '2' THEN 'CO' 
		WHEN '3' THEN 'CO' 
		WHEN '4' THEN 'ET' 
		WHEN '5' THEN 'OT' 
		WHEN '5' THEN 'OT' 
		ELSE 'MI' END +
	REPLICATE(' ',  3) + 
	LEFT(clas_ssa + ' ', 1) +
	RIGHT(cod_barras, 10) +
	REPLICATE(' ',  1) +
	LEFT(clas_fis + REPLICATE(' ',  2), 2) +
	'750' col1
FROM #temp_bi_altas

DROP TABLE #temp_bi_altas



GO
