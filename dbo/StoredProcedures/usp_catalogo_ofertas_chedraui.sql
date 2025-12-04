

CREATE procedure [dbo].[usp_catalogo_ofertas_chedraui](@primer_bolsa varchar(5), @segunda_bolsa varchar(5))
as
begin
create table #resultados(llave varchar(8), ofertas varchar(150))

--truncate table chedraui_precios

--insert into chedraui_precios select codigo, prec_farm, prec_pub from maestro_productos_baan where convert(int, codigo) < 6900000

insert into #resultados
select
t3.ibs_letra + t1.codigo,
t3.ibs_letra + '           ' +
left(convert(varchar(13), convert(bigint, t2.cod_barras)) + '             ', 13) +
left(t2.descripcion + '                                        ', 30) +
left(right('       ' + convert(varchar(15), case t2.grupo_est when 'PC01A' then t2.prec_farm + (t2.prec_farm * 0.5) else t2.prec_farm end), 12), 9) +
right('   ' + convert(varchar(12), t1.porcentaje * 100), 6) +
'      0      0      0' +
case 
when t2.clas_fis = 'B' then '100.00'
when t2.clas_fis = 'BA' then '100.00'
when t2.clas_fis = 'N' then '  0.00' 
when t2.clas_fis = 'NA' then '  0.00' 
when t2.clas_fis = 'H' then right('   ' + convert(varchar(6), t2.descto_prod), 6) 
when t2.clas_fis = 'HA' then right('   ' + convert(varchar(6), t2.descto_prod), 6) end +
left(right('       ' + convert(varchar(15), case t2.grupo_est when 'PC01A' then t2.prec_farm + (t2.prec_farm * 0.5) else t2.prec_farm end), 12), 9) 
from 
dboferta t1 inner join maestro_productos_baan t2 on t1.codigo = t2.codigo
inner join sucursales t3 on t1.sucursal = t3.sucursal and t3.fisica = 1
where 
--t1.bolsa = @primer_bolsa and
t1.bolsa = 'LIBRE' and
convert(int, t2.codigo) < dbo.gobierno()

insert into #resultados
select
t3.ibs_letra + t1.codigo,
t3.ibs_letra + '           ' +
left(convert(varchar(13), convert(bigint, t2.cod_barras)) + '             ', 13) +
left(t2.descripcion + '                                        ', 30) +
left(right('       ' + convert(varchar(15), case t2.grupo_est when 'PC01A' then t2.prec_farm + (t2.prec_farm * 0.5) else t2.prec_farm end), 12), 9) +
right('   ' + convert(varchar(12), t1.porcentaje * 100), 6) +
'      0      0      0' +
case 
when t2.clas_fis = 'B' then '100.00'
when t2.clas_fis = 'BA' then '100.00'
when t2.clas_fis = 'N' then '  0.00' 
when t2.clas_fis = 'NA' then '  0.00' 
when t2.clas_fis = 'H' then right('   ' + convert(varchar(6), t2.descto_prod), 6) 
when t2.clas_fis = 'HA' then right('   ' + convert(varchar(6), t2.descto_prod), 6) end +
left(right('       ' + convert(varchar(15), case t2.grupo_est when 'PC01A' then t2.prec_farm + (t2.prec_farm * 0.5) else t2.prec_farm end), 12), 9) 
from 
dboferta t1 inner join maestro_productos_baan t2 on t1.codigo = t2.codigo
inner join sucursales t3 on t1.sucursal = t3.sucursal and t3.fisica = 1
where
t1.bolsa = @segunda_bolsa and t3.ibs_letra + t1.codigo not in (select t3.ibs_letra + t1.codigo from dboferta t1 inner join sucursales t3 on t1.sucursal = t3.sucursal and t3.fisica = 1 where t1.bolsa = @primer_bolsa) and
convert(int, t2.codigo) < dbo.gobierno()

select ofertas from #resultados
end

GO

