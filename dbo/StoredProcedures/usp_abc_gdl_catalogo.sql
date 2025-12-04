--select top 100 * from dboferta where sucursal = 3

--exec [usp_abc_gdl_catalogo] 3

CREATE procedure [dbo].[usp_abc_gdl_catalogo] @sucursal as tinyint
as
declare @descuento money
select @descuento = convert(money, descuento) from clientes_baan where sucursal = 3 and cliente = '81205'

select 
--t1.cod_barras_TANDEM + '|' +
left(ltrim(isnull(t4.cod_barras_abc, t1.cod_barras_tandem)) + '             ', 13) + '|' +
right('             ' + t1.codigo, 13) + '|' +
left(t1.descripcion + '                                                            ', 60) + '|' +
left(right('00000000000000000' + convert(varchar(17), convert(money, t1.iva * 100)), 15), 15) + '|' +
left(right('00000000000000000' + convert(varchar(17), case t1.grupo_est when 'PC01A' then convert(money, t1.prec_farm + (t1.prec_farm * 0.5)) else convert(money, t1.prec_farm) end), 15),  15) + '|' +
left(right('00000000000000000' + convert(varchar(17), case t1.grupo_est when 'PC01A' then convert(money,  t1.prec_pub + (t1.prec_pub * 0.5)) else convert(money, t1.prec_pub) end), 15),  15) + '|' +
left(right('00000000000000000' + convert(varchar(17), 
case t1.grupo_est when 'PC01A' then convert(money, 
case 
when t1.clas_fis = 'B' then @descuento
when t1.clas_fis = 'BA' then @descuento
when t1.clas_fis = 'N' then 0
when t1.clas_fis = 'NA' then 0
when t1.clas_fis = 'H' then t1.descto_prod
when t1.clas_fis = 'HA' then t1.descto_prod end) else convert(money, 
case 
when t1.clas_fis = 'B' then @descuento
when t1.clas_fis = 'BA' then @descuento
when t1.clas_fis = 'N' then 0
when t1.clas_fis = 'NA' then 0
when t1.clas_fis = 'H' then t1.descto_prod
when t1.clas_fis = 'HA' then t1.descto_prod end
) end), 15),  15) + '|' +
case t1.clas_ssa
when '1' then '1'
when '2' then '1'
when '3' then '1'
when '4' then '1'
when '5' then '1'
else '0' end + '|' +
left(t1.lab_largo + '                                                            ', 60) + '|',
case t1.refrigerado
when 'R' then '1'
else '0' end  + '|' +
right(' ' + t1.clas_ssa, 1) + '|' +
'  1' + '|' +
'              ' + '|' +
case t1.grupo_est when 'PC01A' then '000000000050.00' else '000000000000.00' end + '|' +
'000000000000.00' + '|' +
case when t3.piezas > 1 then '999999' else '     0' end + '|' +
case SUBSTRING(t1.status, 1, 1) when 'B' then '1' else '0' end + '|' +
convert(varchar(1), t3.derecho_devolucion) + '|' +
left(right('00000000000000000' + convert(varchar(17), convert(money, (isnull(t2.porcentaje, 0) * 100))), 15),  15) + '|' +
'000000000000000' + '|' +
'        ',
convert(money, case t1.grupo_est when 'PC01A' then convert(money, t1.prec_farm + (t1.prec_farm * 0.5)) else convert(money, t1.prec_farm) end)
from
maestro_productos_baan t1 inner join inventario_baan t3 on t1.codigo = t3.codigo and t3.sucursal = @sucursal
left outer join dboferta t2 on t1.codigo = t2.codigo and t2.sucursal = t3.sucursal and t2.bolsa in ('PLUS1') 
left outer join gdl_abc_catalogo t4 on t1.codigo = t4.codigo
where
convert(int, t1.codigo) < dbo.gobierno() and
substring(t1.status, 1, 1) <> 'B'

GO

