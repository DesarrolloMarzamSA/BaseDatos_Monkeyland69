


CREATE procedure [dbo].[usp_genera_ofertas_sufacen] @sucursal int, @primer_bolsa varchar(5), @segunda_bolsa varchar(5)
as
--exec usp_genera_ofertas_sufacen 3, 'C2713', 'LIBRE'
set nocount on

declare @descuento varchar(6)
select @descuento = right('   ' + convert(varchar(6), descuento), 6) from clientes_baan where sucursal = 3 and cliente = '01312'



select
right('00' + convert(varchar(2), @sucursal), 2) + '          ' + 
left(convert(varchar(13), convert(bigint, t1.cod_barras)) + '             ', 13) + 
left(t1.descripcion + '                              ', 30) + 
left(right('       ' + convert(varchar(15), case t1.grupo_est when 'PC01A' then t1.prec_farm + (t1.prec_farm * 0.5) else t1.prec_farm end), 12), 9) + 
right('   ' + convert(varchar(6), t2.porcentaje * 100), 6) + 
'      0' + 
case when t2.porcentaje = 0 then right('       ' + convert(varchar(7), t2.cant_base), 7) else '      0' end + 
case when t2.porcentaje = 0 then right('       ' + convert(varchar(7), t2.cant_oferta), 7) else '      0' end + 
case 
when t1.clas_fis = 'B' then @descuento
when t1.clas_fis = 'BA' then @descuento
when t1.clas_fis = 'N' then '  0.00' 
when t1.clas_fis = 'NA' then '  0.00' 
when t1.clas_fis = 'H' then right('   ' + convert(varchar(6), t1.descto_prod), 6) 
when t1.clas_fis = 'HA' then right('   ' + convert(varchar(6), t1.descto_prod), 6) end +
left(right('       ' + convert(varchar(15), case t1.grupo_est when 'PC01A' then t1.prec_pub + (t1.prec_pub * 0.5) else t1.prec_pub end), 12), 9) +
t1.clas_fis 
col1,
t1.codigo,
t1.clas_fis
into #ofertas
from
maestro_productos_baan t1 inner join dboferta t2 on t1.codigo = t2.codigo 
inner join inventario_baan t3 on t1.codigo = t3.codigo and t3.sucursal = @sucursal
where
convert(int, t1.codigo) < dbo.gobierno() and
substring(t1.codigo, 1, 1) <> 'B' and
t2.sucursal = @sucursal and t2.bolsa = @primer_bolsa and
t1.status not like 'B%' --and
--t2.vigencia_final > convert(datetime, convert(varchar(10), current_timestamp, 121), 121)




insert into #ofertas
select
right('00' + convert(varchar(2), @sucursal), 2) + '          ' + 
left(convert(varchar(13), convert(bigint, t1.cod_barras)) + '             ', 13) + 
left(t1.descripcion + '                              ', 30) + 
left(right('       ' + convert(varchar(15), case t1.grupo_est when 'PC01A' then t1.prec_farm + (t1.prec_farm * 0.5) else t1.prec_farm end), 12), 9) + 
right('   ' + convert(varchar(6), t2.porcentaje * 100), 6) + 
'      0' + 
case when t2.porcentaje = 0 then right('       ' + convert(varchar(7), t2.cant_base), 7) else '      0' end + 
case when t2.porcentaje = 0 then right('       ' + convert(varchar(7), t2.cant_oferta), 7) else '      0' end + 
case 
when t1.clas_fis = 'B' then @descuento
when t1.clas_fis = 'BA' then @descuento
when t1.clas_fis = 'N' then '  0.00' 
when t1.clas_fis = 'NA' then '  0.00' 
when t1.clas_fis = 'H' then right('   ' + convert(varchar(6), t1.descto_prod), 6) 
when t1.clas_fis = 'HA' then right('   ' + convert(varchar(6), t1.descto_prod), 6) end +
left(right('       ' + convert(varchar(15), case t1.grupo_est when 'PC01A' then t1.prec_pub + (t1.prec_pub * 0.5) else t1.prec_pub end), 12), 9) +
t1.clas_fis 
col1,
t1.codigo,
t1.clas_fis
from
maestro_productos_baan t1 inner join dboferta t2 on t1.codigo = t2.codigo 
inner join inventario_baan t3 on t1.codigo = t3.codigo and t3.sucursal = @sucursal
where
convert(int, t1.codigo) < dbo.gobierno() and
substring(t1.codigo, 1, 1) <> 'B' and
t2.sucursal = @sucursal and t2.bolsa = @segunda_bolsa and
isnumeric(t1.cod_barras) = 1 and
t2.codigo not in (select distinct codigo from #ofertas) and
t1.status not like 'B%' --and
--t2.vigencia_final > convert(datetime, convert(varchar(10), current_timestamp, 121), 121)

select col1 from #ofertas order by clas_fis

drop table #ofertas

GO

