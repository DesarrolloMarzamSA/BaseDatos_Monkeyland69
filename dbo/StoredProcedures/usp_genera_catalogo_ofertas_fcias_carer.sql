CREATE procedure usp_genera_catalogo_ofertas_fcias_carer
	@sucursal tinyint,
	@primer_bolsa varchar(5),
	@segunda_bolsa varchar(5)
as

--declare @primer_bolsa  as varchar(5)
--declare @segunda_bolsa as varchar(5)
--declare @sucursal as tinyint
--set @primer_bolsa = 'LIBRE'
--set @segunda_bolsa = 'XXXXX'
--set @sucursal = 4

select	right( replicate('0', 8) + convert(varchar(8), convert(bigint, t1.codigo)), 8) +
			--right(replicate(' ', 13) + convert(varchar(13), convert(bigint, t1.cod_barras)), 13) +
			right(replicate(' ', 13) + convert(varchar(13), t1.cod_barras), 13) +
			replace(convert(varchar(10), getdate(), 3), '/', '') +
			case t1.grupo_est
				when 'PC01A' then left(convert(varchar(9), convert(int, (t1.prec_farm * 100) + (t1.prec_farm * 0.5))) + replicate(' ', 9), 9)
				else left(convert(varchar(9), convert(int, t1.prec_farm * 100)) + replicate(' ', 9), 9) 
			end +
			'1 ' +
			case
				when cant_base = 0 and cant_oferta = 0 then left(replace(convert(varchar(5), convert(money, porcentaje * 100)), '.', '') + replicate(' ', 4), 4)
				when cant_base > 0 and cant_oferta > 0 then left(replace(convert(varchar(5), (convert(money, cant_oferta) / (convert(money, cant_base) + convert(money, cant_oferta))) * 100), '.', '') + replicate(' ', 4), 4)
				else left(replace(convert(varchar(5), convert(money, porcentaje * 100)), '.', '') + replicate(' ', 4), 4)
			end 
from		maestro_productos_baan t1 inner join inventario_baan t2 on 
			t1.codigo = t2.codigo and 
			t2.sucursal = @sucursal inner join dboferta t3 on 
			t2.codigo = t3.codigo and 
			t2.sucursal = t3.sucursal and 
			t3.bolsa = @primer_bolsa 
where	convert(int, t1.codigo) < dbo.gobierno() and
			isnumeric(t1.cod_barras) = 1 and
			substring(t1.status, 1,1) <> 'B' 
union
select	right( replicate('0', 8) + convert(varchar(8), convert(bigint, t1.codigo)), 8) +
			--right(replicate(' ', 13) + convert(varchar(13), convert(bigint, t1.cod_barras)), 13) +
			right(replicate(' ', 13) + convert(varchar(13), t1.cod_barras), 13) +
			replace(convert(varchar(10), getdate(), 3), '/', '') +
			case t1.grupo_est
				when 'PC01A' then left(convert(varchar(9), convert(int, (t1.prec_farm * 100) + (t1.prec_farm * 0.5))) + replicate(' ', 9), 9)
				else left(convert(varchar(9), convert(int, t1.prec_farm * 100)) + replicate(' ', 9), 9) 
			end +
			'1 ' +
			case
				when cant_base = 0 and cant_oferta = 0 then left(replace(convert(varchar(5), convert(money, porcentaje * 100)), '.', '') + replicate(' ', 4), 4)
				when cant_base > 0 and cant_oferta > 0 then left(replace(convert(varchar(5), (convert(money, cant_oferta) / (convert(money, cant_base) + convert(money, cant_oferta))) * 100), '.', '') + replicate(' ', 4), 4)
				else left(replace(convert(varchar(5), convert(money, porcentaje * 100)), '.', '') + replicate(' ', 4), 4)
			end 
from		maestro_productos_baan t1 INNER JOIN inventario_baan t2 on 
			t1.codigo = t2.codigo AND 
			t2.sucursal = @sucursal INNER JOIN dboferta t3 on 
			t2.codigo = t3.codigo AND 
			t2.sucursal = t3.sucursal AND 
			t3.bolsa = @segunda_bolsa 
where	convert(int, t1.codigo) < dbo.gobierno() and
			isnumeric(t1.cod_barras) = 1 and
			substring(t1.status, 1,1) <> 'B' and
			convert(int, t1.codigo) < dbo.gobierno() and 
			t3.codigo not in	(	
										select	codigo 
										from		dboferta 
										where	sucursal = @sucursal and 
													bolsa = @primer_bolsa
									)

GO

