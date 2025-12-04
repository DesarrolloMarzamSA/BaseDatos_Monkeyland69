
CREATE procedure [dbo].[usp_futurama_catalogo]
as



declare @descuento money
--select @descuento = convert(money, descuento) from clientes_baan where sucursal = 24 and cliente = '99845'
select @descuento = convert(money, 16)


select 
' C' +
t1.codigo +
/*case t1.clas_ssa
when '1' then '1'
when '2' then '1'
when '3' then '1'
when '4' then '1'
when '5' then '1'
when '6' then '1'
else '2' end +*/
'1' +
' ' +
' ' +
' ' +
case t1.clas_ssa
when '1' then '1'
when '2' then '1'
when '3' then '1'
when '4' then '1'
when '5' then '1'
when '6' then '1'
else '0' end +
case t1.refrigerado
when 'R' then '1'
else '0' end +
case t1.clas_ssa
when '1' then '1'
when '2' then '2'
when '3' then '3'
when '4' then '4'
when '5' then '5'
when '5' then '6'
when '5' then '7'
else ' ' end +
case t1.iva
when 0 then '4' 
else '2' end +
left(t1.descripcion + '                                                            ', 35) +
left(t1.lab_corto + '          ', 10) +
right('00000000000000000' + convert(varchar(17), case t1.grupo_est when 'PC01A' then convert(int, 100 * (t1.prec_pub +  (t1.prec_pub  * 0.5))) else convert(int, t1.prec_pub * 100) end), 9) + 
right('00000000000000000' + convert(varchar(17), case t1.grupo_est when 'PC01A' then convert(int, 100 * (t1.prec_farm + (t1.prec_farm * 0.5))) else convert(int, t1.prec_farm * 100) end), 9) +
'0' +
'      ' + 
right('             ' + convert(varchar(13), convert(bigint, t1.cod_barras)), 13) +
right('    ' + case 
when t1.clas_fis = 'H' then convert(varchar(5), 100 * convert(int, t1.descto_prod))
when t1.clas_fis = 'HA' then convert(varchar(5), 100 * convert(int, t1.descto_prod))
else '    ' end, 4) +
'    ' +
right('    ' + case 
when t1.clas_fis = 'B' then convert(varchar(5), 100 * convert(int, @descuento))
when t1.clas_fis = 'BA' then convert(varchar(5), 100 * convert(int, @descuento))
else '    ' end, 4) +
'3000' +
'    ' +
case 
when t1.clas_fis = 'B'  then '0506'
when t1.clas_fis = 'BA' then '0506'
else '    ' end + 
right('    ' + case 
when t1.clas_fis = 'H' then convert(varchar(5), 100 *  convert(int, 15 - t1.descto_prod))
when t1.clas_fis = 'HA' then convert(varchar(5), 100 * convert(int, 15 - t1.descto_prod))
else '    ' end, 4) 
from
maestro_productos_baan t1 left outer join dboferta t2 on t1.codigo = t2.codigo  and t2.bolsa = 'LIBRE' and t2.sucursal = 24
inner join inventario_baan t3 on t1.codigo = t3.codigo and t3.sucursal = 24
where
t1.lab_corto <> 'ASTRAZ' and
convert(int, t1.codigo) < dbo.gobierno() and
substring(t1.status, 1, 1) <> 'B' 
--and t3.piezas >= 1
order by t1.codigo

GO

