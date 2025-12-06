
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
--	usp_genera_catalogo_nacional 25

CREATE  procedure [dbo].[usp_genera_catalogo_nacional] @sucursal int
WITH ENCRYPTION
as
select
left(convert(varchar(13), convert(bigint, t1.cod_barras)) + '             ', 13) + '|' +
left(t1.descripcion + '                              ', 30) + '|' +
left(right('       ' + convert(varchar(15), case t1.grupo_est when 'PC01A' then t1.prec_farm + (t1.prec_farm * 0.5) else t1.prec_farm end), 12), 9) + '|' +
case 
when t1.clas_fis = 'B' then '100.00'
when t1.clas_fis = 'BA' then '100.00'
when t1.clas_fis = 'N' then '  0.00' 
when t1.clas_fis = 'NA' then '  0.00' 
when t1.clas_fis = 'H' then right('   ' + convert(varchar(6), t1.descto_prod), 6) 
when t1.clas_fis = 'HA' then right('   ' + convert(varchar(6), t1.descto_prod), 6) end +'|'+ 

clas_fis

from maestro_productos_baan t1 inner join inventario_baan t2 on t1.codigo = t2.codigo and t2.sucursal = @sucursal
where
convert(int, t1.codigo) < dbo.gobierno() and
isnumeric(t1.cod_barras) = 1 and
t2.piezas > 10 and
t1.status not like 'B%'
order by
t1.descripcion



GO
