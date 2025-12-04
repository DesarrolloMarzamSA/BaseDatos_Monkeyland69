
CREATE  procedure [dbo].[usp_genera_cambios_precio_nacional]
as
begin
select 
left(convert(varchar(13), convert(bigint, t1.cod_barras)) + '             ', 13) + '|' + 
left(t1.descripcion + '                              ', 30) + '|' +
left(right('       ' + convert(varchar(15), case t1.grupo_est when 'PC01A' then t1.prec_pub + (t1.prec_farm * 0.5) else t1.prec_pub end), 12), 9) + '|' +
left(right('       ' + convert(varchar(15), case t1.grupo_est when 'PC01A' then t1.prec_farm + (t1.prec_farm * 0.5) else t1.prec_farm end), 12), 9)  col1
into #cambios
from maestro_productos_baan t1 inner join cambios_precio_baan t2 on t1.codigo = t2.t_item
where t2.fecha_hora > dateadd(dd, -5, current_timestamp) and
convert(int, t1.codigo) < dbo.gobierno() and
isnumeric(t1.cod_barras) = 1
order by 
t1.descripcion
end

select distinct col1 from #cambios
drop table #cambios

GO

