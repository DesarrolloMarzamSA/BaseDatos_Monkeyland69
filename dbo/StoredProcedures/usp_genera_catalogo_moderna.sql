
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO





--exec usp_genera_catalogo_moderna 17
CREATE procedure [dbo].[usp_genera_catalogo_moderna] @sucursal int
WITH ENCRYPTION
as

select 
'          17' +
left(t1.descripcion + '                                                  ', 31) +
case 
when t1.clas_fis = 'B'  then '100.00'
when t1.clas_fis = 'BA' then '100.00'
when t1.clas_fis = 'N'  then '  0.00' 
when t1.clas_fis = 'NA' then '  0.00' 
when t1.clas_fis = 'H'  then right('   ' + convert(varchar(6), t1.descto_prod), 6) 
when t1.clas_fis = 'HA' then right('   ' + convert(varchar(6), t1.descto_prod), 6) end +
right('0000000000000000' + t1.cod_barras, 13) + 
right('           ' + convert(varchar(20), convert(money, case t1.grupo_est when 'PC01A' then t1.prec_farm + (t1.prec_farm * 0.5) else t1.prec_farm end)), 11) 
from
maestro_productos_baan t1 inner join inventario_baan t2 on t1.codigo = t2.codigo
where
t2.sucursal = @sucursal and
isnumeric(t1.cod_barras) = 1 and 
convert(int, t1.codigo) < dbo.gobierno() and
t2.piezas > 0



GO
