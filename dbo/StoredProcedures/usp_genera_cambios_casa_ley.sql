CREATE procedure [dbo].[usp_genera_cambios_casa_ley]
as
select	distinct
			replace(convert(varchar(10), current_timestamp, 121), '-', '') + 
			right(replicate('0', 13) + convert(varchar(13), convert(bigint, t2.cod_barras)), 13) +
			'0000217357' + 
			case t2.grupo_est 
				when 'PC01A' then right(replicate(' ', 10) + convert(varchar(10), convert(money, round(t2.prec_farm, 2, 2) + (round(t2.prec_farm, 2, 2) * 0.5))), 10)
				else right(replicate(' ', 10) + convert(varchar(10), convert(money, round(t2.prec_farm, 2, 2))), 10)
			end +
						case t2.grupo_est 
				when 'PC01A' then right(replicate(' ', 10) + convert(varchar(10), convert(money, round(t2.prec_pub, 2, 2) + (round(t2.prec_pub, 2, 2) * 0.5))), 10)
				else right(replicate(' ', 10) + convert(varchar(10), convert(money, round(t2.prec_pub, 2, 2))), 10)
			end,
			max(t1.fecha_hora)
from		cambios_precio_baan t1 inner join maestro_productos_baan t2 on 
			t1.t_item = t2.codigo
where	datediff(dd, t1.fecha_hora, current_timestamp) <= 5 and
			isnumeric(t2.cod_barras) = 1 and
			convert(int, t2.codigo) < dbo.gobierno() and
			substring(t2.status, 1, 1) <> 'B'
group by
			t2.cod_barras,
			t2.grupo_est,
			t2.prec_pub,
			t2.prec_farm

GO

