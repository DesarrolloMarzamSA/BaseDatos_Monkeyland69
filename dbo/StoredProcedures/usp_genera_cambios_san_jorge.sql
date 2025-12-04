
CREATE procedure [dbo].[usp_genera_cambios_san_jorge]
as

select
left(convert(varchar(13), convert(bigint, t2.cod_barras)) + '             ', 13) +
left(t2.descripcion + '                                  ', 30) + 
case t2.grupo_est when 'PC01A' then right('          ' + convert(varchar(9), round(t2.prec_pub, 2, 2) + (round(t2.prec_pub, 2, 2) * 0.5)), 9)
else right('          ' + convert(varchar(9), round(t2.prec_pub, 2, 2)), 9) end +
case t2.grupo_est when 'PC01A' then right('          ' + convert(varchar(9), round(t2.prec_farm, 2, 2) + (round(t2.prec_farm, 2, 2) * 0.5)), 9)
else right('          ' + convert(varchar(9), round(t2.prec_farm, 2, 2)), 9) end 
from
cambios_precio_baan t1 inner join maestro_productos_baan t2 on t1.t_item = t2.codigo
where
datediff(d, t1.fecha_hora, current_timestamp) < 5 and
isnumeric(t2.cod_barras) = 1 and 
convert(int, t2.codigo) < dbo.gobierno() and
t2.status not like 'B%'

GO

