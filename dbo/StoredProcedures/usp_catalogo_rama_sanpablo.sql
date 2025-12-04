SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[usp_catalogo_rama_sanpablo]
as

SELECT 
	t1.codigo, 
	t1.descripcion, 
		CASE WHEN t1.prec_farm > 9999.99 THEN 0.01 ELSE t1.prec_farm END prec_farm,
		CASE WHEN t1.prec_pub  > 9999.99 THEN 0.01 ELSE t1.prec_pub  END prec_pub,
	t1.grupo_est,
	t1.iva,
	t1.lab_largo,
	t1.cod_lab,
	t1.clas_ssa,
	t1.cod_barras_tandem,
	t1.clas_fis	,
	t1.fecha_alta,
	t1.refrigerado,
	t1.clas_abc,
	t1.descto_prod
INTO #temp_bi_catalogo
FROM maestro_productos_baan t1 
INNER JOIN inventario_baan t2 ON t1.codigo = t2.codigo and t2.sucursal = 1
INNER JOIN iva_sucursales t3 ON t2.sucursal = t3.sucursal
WHERE --	t1.prec_farm < 9999.99 and
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
	CONVert(varchar(6), fecha_alta, 12) +
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
	CASE refrigerado when 'R' then 'R' else ' ' end +
	CASE clas_ssa 
	WHEN 1 THEN 'P'
	WHEN 2 THEN 'P'
	WHEN 3 THEN 'P'
	ELSE ' '    
	END +
	left(cod_barras_tandem + '             ', 13) +
	CASE clas_abc 
	WHEN 'A' THEN 'I'
	WHEN 'B' THEN 'I'
	ELSE ' '    
	END +
	left(clas_abc + ' ', 1) +
	case clas_fis
	when 'H'  then right('0000' + convert(varchar(4), convert(int, descto_prod)), 4)
	when 'HA' then right('0000' + convert(varchar(4), convert(int, descto_prod)), 4)
	else 'XXXX'
	end
FROM #temp_bi_catalogo

DROP TABLE #temp_bi_catalogo

SELECT NANUM, NANAME , NANCA1,NANCA2 FROM AS400.S101FEBT.MA4620EF04.SRBNAM  WHERE NANAME LIKE '%RAMA%'
GO
