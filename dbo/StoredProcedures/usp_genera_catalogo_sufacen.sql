
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO


CREATE  procedure [dbo].[usp_genera_catalogo_sufacen] 

as

declare @descuento varchar(6)
select @descuento = right('   ' + convert(varchar(6), descuento), 6) from clientes_baan where sucursal = 3 and cliente = '01312'

select
'03          ' +
--left(convert(varchar(13), convert(bigint, t1.cod_barras)) + '             ', 13) + 
left(t1.cod_barras_tandem + '             ', 13) +
left(t1.descripcion + '                              ', 30) + 
left(right('       ' + convert(varchar(15), case t1.grupo_est when 'PC01A' then t1.prec_farm + (t1.prec_farm * 0.5) else t1.prec_farm end), 12), 9) + 
case 
when t1.clas_fis = 'B' then @descuento
when t1.clas_fis = 'BA' then @descuento
when t1.clas_fis = 'N' then '  0.00' 
when t1.clas_fis = 'NA' then '  0.00' 
when t1.clas_fis = 'H' then right('   ' + convert(varchar(6), t1.descto_prod), 6) 
when t1.clas_fis = 'HA' then right('   ' + convert(varchar(6), t1.descto_prod), 6) end +
left(right('       ' + convert(varchar(15), case t1.grupo_est when 'PC01A' then t1.prec_pub + (t1.prec_pub * 0.5) else t1.prec_pub end), 12), 9) +
' ' + 
left(t1.clas_fis + '  ', 2) +
left(right('       ' + convert(varchar(15), case t1.grupo_est when 'PC01A' then t1.prec_pub + (t1.prec_pub * 0.5) else t1.prec_pub end), 12), 9) +
left(right('       ' + convert(varchar(15), case t1.grupo_est when 'PC01A' then t1.prec_farm + (t1.prec_farm * 0.5) else t1.prec_farm end), 12), 9) +
t1.clas_fis
from maestro_productos_baan t1 inner join inventario_baan t2 on t1.codigo = t2.codigo and t2.sucursal = 3
where
convert(int, t1.codigo) < 7000000 and
isnumeric(t1.cod_barras) = 1 and
t2.piezas > 1 and
t1.status not like 'B%'
order by
t1.descripcion



GO
