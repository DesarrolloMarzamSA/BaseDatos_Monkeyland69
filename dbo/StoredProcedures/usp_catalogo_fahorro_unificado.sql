SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_catalogo_fahorro_unificado]
as
declare @x_Dummy varchar(5000)
declare	@descuento money
set		@descuento = 18.00
select	codigo, 
		piezas
into	#existencia
from	openquery	([as400], 
'SELECT	LPPRDC AS "codigo", 
		SUM(LPLOQT) AS "piezas" 
FROM    MA4620EF04.WHOLOP AS WHOLOP 
WHERE   WHOLOP.LPLZON NOT IN (''AA'',''DC'',''DP'',''ME'',''50'',''51'')
GROUP BY 
		LPPRDC 
HAVING	SUM(LPLOQT) > 0'		
		)
select	@x_Dummy =	'	SELECT	DDDMK2 AS "codigo", 
								DDDIS1 AS "porcentaje", 
								DDDIFD AS "vigencia_inicial", 
								DDDITD AS "vigencia_final" 
						FROM	MA4620EF04.SRODID 
						WHERE	SUBSTR(DDCDMC, 1, 1) = ''''Z'''' AND 
								(DDDMK1 = ''''99007'''' OR 
								DDDMK2 = ''''99007'''' OR 
								DDDMK3 = ''''99007'''' OR 
								DDDMK4 = ''''99007'''' OR 
								DDDMK5 = ''''99007'''') AND 
								DDDIFD <= '
select	@x_Dummy = @x_Dummy + convert(varchar, getdate(), 112) +  ' AND DDDITD >= ' + convert(varchar, getdate(), 112) + ''
execute('select * into x_oferta from openquery(as400, ''' + @x_Dummy + ''')')
select	convert(varchar, convert(money, sum(case t1.grupo_est 
			when 'PC01A' then t1.prec_farm + (t1.prec_farm * 0.5) 
			else t1.prec_farm 
		end)))
from	maestro_productos_baan t1 inner join cat_fahorro_fijo t2 on
		t1.codigo = t2.codigo inner join #existencia t3 on
		t1.codigo = t3.codigo left outer join x_oferta t4 on
		t1.codigo = t4.codigo
union all
select	left(convert(varchar(13), convert(bigint, t1.cod_barras)) + '             ', 13) + '|' +
		'    ' + right('000000000' + t1.codigo, 9) + '|' +
		left(t1.descripcion + '                                                            ', 60) + '|' +
		right('000000000000' + convert(varchar(6), t1.iva * 100), 15) + '|' +
		left(right('000000000000' + convert(varchar(15), case t1.grupo_est when 'PC01A' then t1.prec_farm + (t1.prec_farm * 0.5) else t1.prec_farm end), 18), 15) + '|' +
		left(right('000000000000' + convert(varchar(15), case t1.grupo_est when 'PC01A' then t1.prec_pub + (t1.prec_pub * 0.5) else t1.prec_pub end), 18), 15) + '|' +
		case 
			when t1.clas_fis = 'B'  then right('000000000000' + convert(varchar(16), @descuento), 15)
			when t1.clas_fis = 'BA' then right('000000000000' + convert(varchar(16), @descuento), 15)
			when t1.clas_fis = 'N'  then '000000000000.00' 
			when t1.clas_fis = 'NA' then '000000000000.00' 
			when t1.clas_fis = 'H'  then right('000000000000' + convert(varchar(16), t1.descto_prod), 15) 
			when t1.clas_fis = 'HA' then right('000000000000' + convert(varchar(16), t1.descto_prod), 15)  
		end + '|' +
		case t1.clas_ssa 
			when '1' then '1' 
			when '2' then '1' 
			when '3' then '1' 
			when '4' then '1' 
			when '5' then '1' 
			when '6' then '1' 
			when '7' then '0' 
			when '8' then '0' 
			when '9' then '0' 
			else '0' 
		end + '|' +
		left(t1.lab_largo + '                                                            ', 60) + '|' +
		case t1.refrigerado 
			when 'R' then '1' 
			else '0' 
		end  + '|' +
		case t1.clas_ssa 
			when '1' then '1' 
			when '2' then '3' 
			when '3' then '3' 
			else '0' 
		end + '|' +
		'1  ' + '|00000000000000|000000000000.00|000000000000.00|' +
		case t3.piezas 
			when 0 then '000000' 
			else '999999' 
		end + '|' +
		--'999999' + '|' +
		'0' + '|' +
		'0' + '|' +
		right('000000000000' + convert(varchar(12), isnull(t4.porcentaje, 0) * 100), 15) + '|' +
		case 
			when t1.clas_fis = 'B' then '000000000004.88' 
			when t1.clas_fis = 'BA' then '000000000004.88' 
			else '000000000000.00' 
		end + '|' +
		isnull(convert(varchar(8), t4.vigencia_final, 112), '00000000')
from	maestro_productos_baan t1 inner join cat_fahorro_fijo t2 on
		t1.codigo = t2.codigo inner join #existencia t3 on
		t1.codigo = t3.codigo left outer join x_oferta t4 on
		t1.codigo = t4.codigo
drop table #existencia
drop table x_oferta

GO
