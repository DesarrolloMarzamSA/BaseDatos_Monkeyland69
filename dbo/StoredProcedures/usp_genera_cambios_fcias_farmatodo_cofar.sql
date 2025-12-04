create procedure [dbo].[usp_genera_cambios_fcias_farmatodo_cofar]
as
select	left(convert(varchar(13), convert(bigint, t2.cod_barras)) + replicate(' ', 13), 13) + 
			left(t2.descripcion + replicate(' ', 30), 30) + 
			case t2.grupo_est 
				when 'PC01A' then left(convert(varchar, convert(money, round(t2.prec_pub, 2, 2) + (round(t2.prec_pub, 2, 2) * 0.5))) + replicate(' ', 9), 9)
				else left(convert(varchar, convert(money, round(t2.prec_pub, 2, 2))) + replicate(' ', 9), 9)
			end +
			case t2.grupo_est 
				when 'PC01A' then left(convert(varchar, convert(money, round(t2.prec_farm, 2, 2) + (round(t2.prec_farm, 2, 2) * 0.5))) + replicate(' ', 9), 9)
				else left(convert(varchar, convert(money, round(t2.prec_farm, 2, 2))) + replicate(' ', 9), 9)
			end 
from		cambios_precio_baan t1 inner join maestro_productos_baan t2 on 
			t1.t_item = t2.codigo
where	datediff(dd, t1.fecha_hora, current_timestamp) <= 5 and
			isnumeric(t2.cod_barras) = 1 and
			convert(int, t2.codigo) < dbo.gobierno() and
			substring(t2.status, 1, 1) <> 'B'
order by t2.descripcion

GO

