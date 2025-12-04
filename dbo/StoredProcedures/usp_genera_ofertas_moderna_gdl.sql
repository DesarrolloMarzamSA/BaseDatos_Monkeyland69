create   procedure [dbo].[usp_genera_ofertas_moderna_gdl] @sucursal int, @primer_bolsa varchar(5), @segunda_bolsa varchar(5), @cliente varchar(5)
as
--PROCEDIMIENTO PARA  OFERTAS FCIAS. MODERNA DE GDL
declare @descuento varchar(6)
select @descuento = right('   ' + convert(varchar(6), descuento), 6) from clientes_baan where sucursal = @sucursal and cliente = @cliente

select
right('00' + convert(varchar(2), @sucursal), 2) +
'          ' +
left(convert(varchar(13), convert(bigint, t1.cod_barras)) + '             ', 13) +
left(t1.descripcion + '                              ', 30) +
right('      ' + convert(varchar(10), t1.prec_farm), 9) +
right('   ' + convert(varchar(6), t2.porcentaje * 100), 6) +
right('       ' + convert(varchar(7), t2.cant_base), 7) +
right('       ' + convert(varchar(7), t2.cant_oferta), 7) +
'      0' +
case 
when t1.clas_fis = 'B' then @descuento
when t1.clas_fis = 'BA' then @descuento
when t1.clas_fis = 'N' then '  0.00' 
when t1.clas_fis = 'NA' then '  0.00' 
when t1.clas_fis = 'H' then right('   ' + convert(varchar(6), t1.descto_prod), 6) 
when t1.clas_fis = 'HA' then right('   ' + convert(varchar(6), t1.descto_prod), 6) end +
case
when t3.piezas = 0 then ' 0'
when t3.piezas between 1 and 50 then ' 1'
when t3.piezas > 50 then ' 2' end
from
maestro_productos_baan t1 inner join dboferta t2 on t1.codigo = t2.codigo 
inner join inventario_baan t3 on t1.codigo = t3.codigo and t3.sucursal = @sucursal
where
t2.sucursal = @sucursal and t2.bolsa = @primer_bolsa
union
select
right('00' + convert(varchar(2), @sucursal), 2) +
'          ' +
left(convert(varchar(13), convert(bigint, t1.cod_barras)) + '             ', 13) +
left(t1.descripcion + '                              ', 30) +
right('      ' + convert(varchar(10), t1.prec_farm), 9) +
right('   ' + convert(varchar(6), t2.porcentaje * 100), 6) +
right('       ' + convert(varchar(7), t2.cant_base), 7) +
right('       ' + convert(varchar(7), t2.cant_oferta), 7) +
'      0' +
case 
when t1.clas_fis = 'B' then @descuento
when t1.clas_fis = 'BA' then @descuento
when t1.clas_fis = 'N' then '  0.00' 
when t1.clas_fis = 'NA' then '  0.00' 
when t1.clas_fis = 'H' then right('   ' + convert(varchar(6), t1.descto_prod), 6) 
when t1.clas_fis = 'HA' then right('   ' + convert(varchar(6), t1.descto_prod), 6) end +
case
when t3.piezas = 0 then ' 0'
when t3.piezas between 1 and 50 then ' 1'
when t3.piezas > 50 then ' 2' end
from
maestro_productos_baan t1 inner join dboferta t2 on t1.codigo = t2.codigo 
inner join inventario_baan t3 on t1.codigo = t3.codigo and t3.sucursal = @sucursal
where
t2.sucursal = @sucursal and t2.bolsa = @segunda_bolsa and
isnumeric(t1.cod_barras) = 1 and
t2.codigo not in (select distinct codigo from dboferta where sucursal = @sucursal and bolsa = @primer_bolsa)

GO

