CREATE procedure [dbo].[usp_genera_catalogo_oferta_farmacon]
	@sucursal int
as
declare @primer_bolsa  as varchar(5)
declare @segunda_bolsa as varchar(5)
set @primer_bolsa = 'C2599'
set @segunda_bolsa = ''

--declare @primer_bolsa  as varchar(5)
--declare @segunda_bolsa as varchar(5)
--declare @sucursal as tinyint
--set @primer_bolsa = 'C2599'
--set @segunda_bolsa = 'LIBRE'
--set @sucursal = 17

select	t1.cod_barras +
			right('00000000' + convert(varchar(8), cast(t1.prec_farm*100 as int)), 8) +
			'0000' +
			'0000' +
			case
				when cant_base = 0 and cant_oferta = 0 then right(replicate('0', 5) + convert(varchar(5), convert(int, porcentaje * 10000)), 5)
				when cant_base > 0 and cant_oferta > 0 then right(replicate('0', 5) + convert(varchar(5), convert(int, (convert(money, cant_oferta) / (convert(money, cant_base) + convert(money, cant_oferta))) * 10000)), 5)
				else right(replicate('0', 5) + convert(varchar(5), convert(int, porcentaje * 10000)), 5)
			end +
			convert(varchar(8), t3.vigencia_inicial, 112) +
			case 
					when dateadd(d, 7, vigencia_final) > dateadd(d, 7, current_timestamp) then convert(varchar(8), dateadd(d, 7, current_timestamp), 112)
					else convert(varchar(8), vigencia_final, 112)   			
			end +
			case
				when t2.sucursal = 3 then '25'
				when t2.sucursal = 6 then '02'
				when t2.sucursal = 16 then '03'
				when t2.sucursal = 17 then '25'
				when t2.sucursal = 18 then '26'
				when t2.sucursal = 25 then '02'
			end
from		maestro_productos_baan t1 inner join inventario_baan t2 on 
			t1.codigo = t2.codigo and 
			t2.sucursal = @sucursal inner join dboferta t3 on 
			t2.codigo = t3.codigo and 
			t2.sucursal = t3.sucursal and 
			t3.bolsa = @primer_bolsa 
where	convert(int, t1.codigo) < dbo.gobierno() and
			t2.piezas > 0
union
select	t1.cod_barras +
			right('00000000' + convert(varchar(8), cast(t1.prec_farm*100 as int)), 8) +
			'0000' +
			'0000' +
			case
				when cant_base = 0 and cant_oferta = 0 then right(replicate('0', 5) + convert(varchar(5), convert(int, porcentaje * 10000)), 5)
				when cant_base > 0 and cant_oferta > 0 then right(replicate('0', 5) + convert(varchar(5), convert(int, (convert(money, cant_oferta) / (convert(money, cant_base) + convert(money, cant_oferta))) * 10000)), 5)
				else right(replicate('0', 5) + convert(varchar(5), convert(int, porcentaje * 10000)), 5)
			end +
			convert(varchar(8), t3.vigencia_inicial, 112) +
						case 
					when dateadd(d, 7, vigencia_final) > dateadd(d, 7, current_timestamp) then convert(varchar(8), dateadd(d, 7, current_timestamp), 112)
					else convert(varchar(8), vigencia_final, 112)   			
			end +
			case
				when t2.sucursal = 3 then '25'
				when t2.sucursal = 6 then '02'
				when t2.sucursal = 16 then '03'
				when t2.sucursal = 17 then '25'
				when t2.sucursal = 18 then '26'
				when t2.sucursal = 25 then '02'
			end
from		maestro_productos_baan t1 inner join inventario_baan t2 on
			t1.codigo = t2.codigo and
			t2.sucursal = @sucursal inner join dboferta t3 on 
			t2.codigo = t3.codigo and 
			t2.sucursal = t3.sucursal and 
			t3.bolsa = '' 
where	t3.disponible > 10 and
			t2.piezas > 0 and
			convert(int, t1.codigo) < dbo.gobierno() and 
			t3.codigo not in	(	
										select	codigo 
										from		dboferta 
										where	sucursal = @sucursal and
										bolsa = @primer_bolsa
									)

GO

