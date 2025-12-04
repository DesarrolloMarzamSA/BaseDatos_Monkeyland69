CREATE procedure usp_genera_catalogo_ofertas_casa_ley
	@sucursal tinyint,
	@primer_bolsa varchar(5),
	@segunda_bolsa varchar(5)
as
declare @descuento varchar(6)

--declare @sucursal as tinyint
--declare @primer_bolsa  varchar(5)
--declare @segunda_bolsa  varchar(5)
--declare @descuento varchar(6)
--set @sucursal = 17
--set @primer_bolsa = 'LIBRE'
--set @segunda_bolsa = 'XXXXX'

select	replace(convert(varchar(10), current_timestamp, 121), '-', '') + 
			right(replicate('0', 13) + convert(varchar(13), convert(bigint, t1.cod_barras)), 13) +
			--right(replicate('0', 10) + convert(varchar(10), t1.codigo), 10) +
			'0000217357' +
			'   0' +
			'   0' +
			right(replicate(' ', 6) + convert(varchar(6), t3.porcentaje * 100), 6) + 
			'D' +
			replace(convert(varchar(10), t3.vigencia_inicial, 121), '-', '') + 
			replace(convert(varchar(10), t3.vigencia_final, 121), '-', '')
from		maestro_productos_baan t1 INNER JOIN inventario_baan t2 on 
			t1.codigo = t2.codigo AND 
			t2.sucursal = @sucursal INNER JOIN dboferta t3 on 
			t2.codigo = t3.codigo AND
			t2.sucursal = t3.sucursal AND 
			t3.bolsa = @primer_bolsa 
where	convert(int, t1.codigo) < dbo.gobierno() and
			isnumeric(t1.cod_barras) = 1 and
			substring(t1.status, 1,1) <> 'B' 
union
select	replace(convert(varchar(10), current_timestamp, 121), '-', '') + 
			right(replicate('0', 13) + convert(varchar(13), convert(bigint, t1.cod_barras)), 13) +
			--right(replicate('0', 10) + convert(varchar(10), t1.codigo), 10) +
			'0000217357' +
			'   0' +
			'   0' +
			right(replicate(' ', 6) + convert(varchar(6), t3.porcentaje * 100), 6) + 
			'D' +
			replace(convert(varchar(10), t3.vigencia_inicial, 121), '-', '') + 
			replace(convert(varchar(10), t3.vigencia_final, 121), '-', '')
from		maestro_productos_baan t1 INNER JOIN inventario_baan t2 ON 
			t1.codigo = t2.codigo AND 
			t2.sucursal = @sucursal INNER JOIN dboferta t3 ON 
			t2.codigo = t3.codigo AND
			t2.sucursal = t3.sucursal AND 
			t3.bolsa = @segunda_bolsa 
where	convert(int, t1.codigo) < dbo.gobierno() and
			isnumeric(t1.cod_barras) = 1 and
			substring(t1.status, 1,1) <> 'B' and
			t3.codigo not in	(	
											select	codigo 
											from		dboferta 
											where	sucursal = @sucursal and 
														bolsa = @primer_bolsa
										)

GO

