
--select * from maestro_productos_baan where descripcion like '%kenolan%'
--select * from maestro_productos_baan where cod_barras = '7501090520766'
--select * from dboferta where sucursal = 17 and codigo = '0008402'
--exec usp_genera_ofertas_moderna 17, 'C2214', 'LIBRE'

CREATE procedure [dbo].[usp_genera_ofertas_moderna] @sucursal int, @primer_bolsa varchar(5), @segunda_bolsa varchar(5)
as

select
'       0' + 
left(t1.descripcion + '                                                  ', 31) + 
case 
when t1.clas_fis = 'B'  then '100.00'
when t1.clas_fis = 'BA' then '100.00'
when t1.clas_fis = 'N'  then '  0.00' 
when t1.clas_fis = 'NA' then '  0.00' 
when t1.clas_fis = 'H'  then right('   ' + convert(varchar(6), t1.descto_prod), 6) 
when t1.clas_fis = 'HA' then right('   ' + convert(varchar(6), t1.descto_prod), 6) end +
right('       ' + convert(varchar(7), convert(money, 100 * 
case
when t2.cant_base = 0 then t2.porcentaje 
else convert(money, t2.cant_oferta) / convert(money, t2.cant_base + t2.cant_oferta) end
)), 7)  +
right('0000000000000000' + t1.cod_barras, 13) + 
'       0' +
right('           ' + convert(varchar(20), convert(money, case t1.grupo_est when 'PC01A' then t1.prec_farm + (t1.prec_farm * 0.5) else t1.prec_farm end)), 11) +
'       017          '
from
maestro_productos_baan t1 inner join dboferta t2 on t1.codigo = t2.codigo 
where
t2.sucursal = @sucursal and t2.bolsa = @primer_bolsa and
convert(int, t1.codigo ) < dbo.gobierno() and
substring(t1.status, 1, 1) <> 'B' 

union

select
'       0' + 
left(t1.descripcion + '                                                  ', 31) + 
case 
when t1.clas_fis = 'B'  then '100.00'
when t1.clas_fis = 'BA' then '100.00'
when t1.clas_fis = 'N'  then '  0.00' 
when t1.clas_fis = 'NA' then '  0.00' 
when t1.clas_fis = 'H'  then right('   ' + convert(varchar(6), t1.descto_prod), 6) 
when t1.clas_fis = 'HA' then right('   ' + convert(varchar(6), t1.descto_prod), 6) end +
right('       ' + convert(varchar(7), convert(money, 100 * 
case
when t2.cant_base = 0 then t2.porcentaje 
else convert(money, t2.cant_oferta) / convert(money, t2.cant_base + t2.cant_oferta) end
)), 7)  +
right('0000000000000000' + t1.cod_barras, 13) + 
'       0' +
right('           ' + convert(varchar(20), convert(money, case t1.grupo_est when 'PC01A' then t1.prec_farm + (t1.prec_farm * 0.5) else t1.prec_farm end)), 11) +
'       017          '
from
maestro_productos_baan t1 inner join dboferta t2 on t1.codigo = t2.codigo 
where
convert(int, t1.codigo ) < dbo.gobierno() and
substring(t1.status, 1, 1) <> 'B' and
t2.sucursal = @sucursal and t2.bolsa = @segunda_bolsa and
t2.codigo not in (select distinct codigo from dboferta where sucursal = @sucursal and bolsa = @primer_bolsa)

GO

