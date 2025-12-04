
--select * from sysobjects where name like '%futurama%'
--select * from maestro_productos_baan where cod_barras in ('7501095401565', '5000167090475')
CREATE procedure [dbo].[usp_futurama_cambios]
as

declare @descuento money
--select @descuento = convert(money, descuento) from clientes_baan where sucursal = 24 and cliente = '99845'
select @descuento = convert(money, 16)

--select * from maestro_productos_baan where codigo = '1234302'
select
'         ' +
case t1.clas_ssa
when '1' then '1'
when '2' then '1'
when '3' then '1'
when '4' then '1'
when '5' then '1'
when '6' then '1'
else '2' end +
'      ' +
case right(left(t1.clas_fis + '  ', 2), 1)
when 'A' then '2'
else '4' end +
left(t1.descripcion + '                                                            ', 35) +
left(t1.lab_corto + '          ', 10) +
right('00000000000000000' + convert(varchar(17), case t1.grupo_est when 'PC01A' then convert(int, 100 * (t1.prec_pub +  (t1.prec_pub  * 0.5))) else convert(int, t1.prec_pub * 100) end), 9) + 
right('00000000000000000' + convert(varchar(17), case t1.grupo_est when 'PC01A' then convert(int, 100 * (t1.prec_farm + (t1.prec_farm * 0.5))) else convert(int, t1.prec_farm * 100) end), 9) +
'       ' +
t1.cod_barras +
right('    ' + case 
when t1.clas_fis = 'H' then convert(varchar(5), 100 * convert(int, t1.descto_prod))
when t1.clas_fis = 'HA' then convert(varchar(5), 100 * convert(int, t1.descto_prod))
else '    ' end, 4) +
case 
when t1.clas_fis = 'N'  then '0000'
when t1.clas_fis = 'NA' then '0000'
else '    ' end +
'                '
from
maestro_productos_baan t1 left outer join dboferta t2 on t1.codigo = t2.codigo  and t2.bolsa = 'LIBRE' and t2.sucursal = 24
inner join cambios_precio_baan t3 on t1.codigo = t3.t_item
where
datediff(d, t3.fecha_hora, current_timestamp) < 5 and
isnumeric(t1.cod_barras) = 1 and 
convert(int, t1.codigo) < dbo.gobierno() and
substring(t1.status, 1, 1) <> 'B'
order by
t1.codigo

GO

