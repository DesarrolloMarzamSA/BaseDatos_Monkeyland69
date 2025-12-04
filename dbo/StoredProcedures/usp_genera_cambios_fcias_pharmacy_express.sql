CREATE procedure usp_genera_cambios_fcias_pharmacy_express
as
select	left(convert(varchar(13), convert(bigint, t2.cod_barras)) + replicate(' ', 13), 13) +
			left(t2.descripcion + replicate(' ', 35), 35) + 
			case t2.grupo_est 
				when 'PC01A' then right(replicate(' ', 9) + convert(varchar(9), t2.prec_pub + (t2.prec_pub * 0.5)), 9)
				else right(replicate(' ', 9) + convert(varchar(9), t2.prec_pub), 9) 
			end 
from		cambios_precio_baan t1 inner join maestro_productos_baan t2 on 
			t1.t_item = t2.codigo
where	datediff(dd, t1.fecha_hora, current_timestamp) <= 5 and
			isnumeric(t2.cod_barras) = 1 and
			convert(int, t2.codigo) < dbo.gobierno() and
			substring(t2.status, 1, 1) <> 'B'
order by 
			t2.descripcion

GO

