

CREATE procedure [dbo].[usp_genera_catalogo_ofertas_san_jorge]
as

select 
'01          ' +
left(convert(varchar(13), convert(bigint, t2.cod_barras)) + '             ', 13) +
left(t2.descripcion + '                                  ', 30) +
case t2.grupo_est when 'PC01A' then right('          ' + convert(varchar(9), round(t2.prec_farm, 2, 2) + (round(t2.prec_farm, 2, 2) * 0.5)), 9)
else right('          ' + convert(varchar(9), round(t2.prec_farm, 2, 2)), 9) end +
right('          ' + convert(varchar(9), round(t1.porcentaje * 100, 2, 2)), 6) +
right('          ' + convert(varchar(10), t1.cant_base), 7) + 
right('          ' + convert(varchar(10), t1.cant_oferta), 7) +
'      0' +
case 
when t2.clas_fis in ('N', 'NA') then '  0.00'
when t2.clas_fis in ('B', 'BA') then '100.00'
else right('   ' + convert(varchar(6), t2.descto_prod), 6) end texto,
t1.codigo
into #ofertas_san_jorge
from dboferta t1 inner join maestro_productos_baan t2 on t1.codigo = t2.codigo
where
convert(bigint, t1.codigo) < dbo.gobierno() and
t1.sucursal = 1 and
t1.bolsa = 'MG  ' and
t1.status not like 'B%' and
t1.vigencia_inicial <= convert(datetime, convert(varchar(10), current_timestamp, 121), 121) and
t1.vigencia_final >= convert(datetime, convert(varchar(10), current_timestamp, 121), 121) 


insert into #ofertas_san_jorge
select 
'01          ' +
left(convert(varchar(13), convert(bigint, t2.cod_barras)) + '             ', 13) +
left(t2.descripcion + '                                  ', 30) +
case t2.grupo_est when 'PC01A' then right('          ' + convert(varchar(9), round(t2.prec_farm, 2, 2) + (round(t2.prec_farm, 2, 2) * 0.5)), 9)
else right('          ' + convert(varchar(9), round(t2.prec_farm, 2, 2)), 9) end +
right('          ' + convert(varchar(9), round(t1.porcentaje * 100, 2, 2)), 6) +
right('          ' + convert(varchar(10), t1.cant_base), 7) + 
right('          ' + convert(varchar(10), t1.cant_oferta), 7) +
'      0' +
case 
when t2.clas_fis in ('N', 'NA') then '  0.00'
when t2.clas_fis in ('B', 'BA') then '100.00'
else right('   ' + convert(varchar(6), t2.descto_prod), 6) end texto,
t1.codigo
from dboferta t1 inner join maestro_productos_baan t2 on t1.codigo = t2.codigo
where
convert(bigint, t1.codigo) < dbo.gobierno() and
t1.sucursal = 1 and
t1.bolsa = 'C2858' and
t1.codigo not in (select codigo from #ofertas_san_jorge) and 
t1.status not like 'B%' and
t1.vigencia_inicial <= convert(datetime, convert(varchar(10), current_timestamp, 121), 121) and
t1.vigencia_final >= convert(datetime, convert(varchar(10), current_timestamp, 121), 121) 


insert into #ofertas_san_jorge
select 
'01          ' +
left(convert(varchar(13), convert(bigint, t2.cod_barras)) + '             ', 13) +
left(t2.descripcion + '                                  ', 30) +
case t2.grupo_est when 'PC01A' then right('          ' + convert(varchar(9), round(t2.prec_farm, 2, 2) + (round(t2.prec_farm, 2, 2) * 0.5)), 9)
else right('          ' + convert(varchar(9), round(t2.prec_farm, 2, 2)), 9) end +
right('          ' + convert(varchar(9), round(t1.porcentaje * 100, 2, 2)), 6) +
right('          ' + convert(varchar(10), t1.cant_base), 7) + 
right('          ' + convert(varchar(10), t1.cant_oferta), 7) +
'      0' +
case 
when t2.clas_fis in ('N', 'NA') then '  0.00'
when t2.clas_fis in ('B', 'BA') then '100.00'
else right('   ' + convert(varchar(6), t2.descto_prod), 6) end texto,
t1.codigo
from dboferta t1 inner join maestro_productos_baan t2 on t1.codigo = t2.codigo
where
convert(bigint, t1.codigo) < dbo.gobierno() and
t1.sucursal = 1 and
t1.bolsa = 'LIBRE' and
t1.codigo not in (select codigo from #ofertas_san_jorge) and
t1.status not like 'B%' and
t1.vigencia_inicial <= convert(datetime, convert(varchar(10), current_timestamp, 121), 121) and
t1.vigencia_final >= convert(datetime, convert(varchar(10), current_timestamp, 121), 121) 
 
 
 
select texto from #ofertas_san_jorge

GO

