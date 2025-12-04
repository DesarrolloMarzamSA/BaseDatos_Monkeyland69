



CREATE procedure [dbo].[usp_genera_catalogo_sanborns]
as
declare @descuento money
select @descuento = convert(money, descuento) from clientes_baan where sucursal = 6 and cliente = '99041'

select
' ' + t1.cod_barras + '|' +
'000000000000000' + '|' +
left(replace(t1.descripcion, '|', ' ') + '                                   ', 35) + '|' + 
right('0000' + t3.depto, 4) + '|' + 
right('0000' + t3.subdepto, 4) + '|' + 
'9999' + '|' + 
case when charindex('A', t1.clas_fis) > 0 then '0' else '1' end + '|' + 
'00600292' + '|' + 
'0' + t1.codigo + '|' +
right('000000000000' + convert(varchar(15), case t1.grupo_est when 'PC01A' then convert(int, (t1.prec_farm + (t1.prec_farm * 0.5)) * 100) else convert(int, t1.prec_farm * 100) end), 12) + '|' + 
right('000000000000' + convert(varchar(15), case t1.grupo_est when 'PC01A' then convert(int, (t1.prec_pub +  (t1.prec_pub  * 0.5)) * 100) else convert(int, t1.prec_pub  * 100) end), 12) + '|' + 
right('00000000' + convert(varchar(15), convert(int, case 
when t1.clas_fis = 'B'  then @descuento*100
when t1.clas_fis = 'BA' then @descuento*100
when t1.clas_fis = 'N'  then 0
when t1.clas_fis = 'NA' then 0
when t1.clas_fis = 'H'  then case when t1.descto_prod > @descuento then @descuento*100 else t1.descto_prod*100 end
when t1.clas_fis = 'HA' then case when t1.descto_prod > @descuento then @descuento*100 else t1.descto_prod*100 end end)), 8) +
'|00000000|00000000|00000000|00000000|C|' +
replace(convert(varchar(10), current_timestamp, 4), '.', '') + '|' texto
from
maestro_productos_baan t1 inner join catalogo_productos_sanborns t3 on t3.cod_barras = t1.cod_barras 
where
convert(int, t1.codigo) < dbo.gobierno() and
substring(t1.status, 1, 1) <> 'B'

GO

