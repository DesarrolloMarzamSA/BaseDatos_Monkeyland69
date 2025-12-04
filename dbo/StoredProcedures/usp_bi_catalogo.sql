SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[usp_bi_catalogo] @sucursal tinyint
as

/*
usp_bi_catalogo 3
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
	t1.iva,
	t1.lab_largo,
	t1.cod_lab,
	clas_ssa,
	t1.cod_barras,
	t1.clas_fis	,
	t1.fecha_alta,
	t1.refrigerado
INTO #temp_bi_catalogo
FROM maestro_productos_baan t1 
INNER JOIN inventario_baan t2 ON t1.codigo = t2.codigo and t2.sucursal = @sucursal
INNER JOIN iva_sucursales t3 ON t2.sucursal = t3.sucursal
WHERE --	t1.prec_farm < 9999.99 and
prec_farm is not null and
prec_pub is not null and
CONVERT(INT, t1.codigo) < dbo.gobierno() and	
SUBSTRING(t1.STATUS, 1, 1) <> 'B'


select
	codigo +
	LEFT(descripcion + REPLICATE(' ',31), 31) +
	LEFT(right(REPLICATE('0', 7) + CONVERT(VARCHAR, 
		CASE grupo_est WHEN 'PC01A' THEN prec_farm * 1.5 ELSE prec_farm END), 10), 7) + 
	LEFT(Right(REPLICATE('0', 7) + CONVERT(VARCHAR, 
		CASE grupo_est WHEN 'PC01A' THEN prec_pub  * 1.5 ELSE prec_pub	END), 10), 7) + 
	RIGHt('00' + convert(varchar(2), CONVERT(INT, iva * 100)), 2) + 
	CASE clas_ssa 
	WHEN 1 THEN 'CO'
	WHEN 2 THEN 'CO'
	WHEN 3 THEN 'CO'
	WHEN 4 THEN 'ET'
	WHEN 5 THEN 'OT'
	WHEN 6 THEN 'OT'
	WHEN 7 THEN 'MC'
	WHEN 8 THEN 'PF'
	WHEN 9 THEN 'MI'
	ELSE 'MI' 
	END +
	LEFT(LAB_LARGO + '                               ', 25) +
	RIGHt('    ' + cod_lab, 4) +
	CONVert(varchar(8), fecha_alta, 112) +
	LEFT(clas_fis + '  ', 2) + 
	CASE clas_ssa 
	WHEN 1 THEN '1'
	WHEN 2 THEN '2'
	WHEN 3 THEN '3'
	ELSE ' '    
	END +
	CASE clas_ssa 
	WHEN 5 THEN 'L'
	WHEN 6 THEN 'L'
	ELSE ' '    
	END +
	CASE clas_ssa 
	WHEN 1 THEN 'P'
	WHEN 2 THEN 'P'
	WHEN 3 THEN 'P'
	ELSE ' '    
	END +
	CASE refrigerado when 'R' then 'R' else ' ' end +
	cod_barras +
	CASE clas_ssa 
	WHEN 1 THEN 'C'
	WHEN 2 THEN 'C'
	WHEN 3 THEN 'C'
	WHEN 4 THEN 'E'
	WHEN 5 THEN 'L'
	WHEN 6 THEN 'L'
	WHEN 7 THEN 'H'
	WHEN 8 THEN 'P'
	WHEN 9 THEN 'V'
	ELSE 'V'    
	END +
	LEFT(grupo_est + '     ', 5) col1
FROM #temp_bi_catalogo


DROP TABLE #temp_bi_catalogo

GO
