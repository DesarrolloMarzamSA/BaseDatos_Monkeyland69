CREATE procedure usp_genera_catalogo_ofertas_fcias_Yza_Pharmacy
	@sucursal tinyint,
	@primer_bolsa varchar(5),
	@segunda_bolsa varchar(5)
as
declare @descuento varchar(6)

--declare @sucursal as tinyint
--declare @primer_bolsa  varchar(5)
--declare @segunda_bolsa  varchar(5)
--declare @descuento varchar(6)
--set @sucursal = 5
--set @primer_bolsa = 'LIBRE'
--set @segunda_bolsa = 'XXXXX'

select	@descuento = right(replicate(' ', 6) + convert(varchar(6), descuento), 6) 
from		clientes_baan 
where	sucursal = @sucursal and 
			cliente = '11500'

select	left(convert(varchar(12), @sucursal) + replicate(' ', 12), 12) +
			left(rtrim(ltrim(t1.cod_barras_tandem)) + replicate(' ', 13), 13) + 
			left(t1.descripcion + replicate(' ', 30), 30) + 
			case t1.grupo_est 
				when 'PC01A' then right(replicate(' ', 9) + convert(varchar(9), t1.prec_farm + (t1.prec_farm * 0.5)), 9)
				else right(replicate(' ', 9) + convert(varchar(9), t1.prec_farm), 9) 
			end +
			right(replicate(' ', 6) + convert(varchar(6), convert(money, t3.porcentaje * 100)), 6) +
			'      0' +
			'      0' +
			'      0' +
			case 
				when t1.clas_fis = 'B' then @descuento
				when t1.clas_fis = 'BA' then @descuento
				when t1.clas_fis = 'N' then '  0.00' 
				when t1.clas_fis = 'NA' then '  0.00' 
				when t1.clas_fis = 'H' then right(replicate(' ', 6) + convert(varchar(6), t1.descto_prod), 6) 
				when t1.clas_fis = 'HA' then right(replicate(' ', 6) + convert(varchar(6), t1.descto_prod), 6) 
			end +
			case t1.grupo_est 
				when 'PC01A' then right(replicate(' ', 9) + convert(varchar(9), t1.prec_pub + (t1.prec_pub * 0.5)), 9)
				else right(replicate(' ', 9) + convert(varchar(9), t1.prec_pub), 9) 
			end
from		maestro_productos_baan t1 INNER JOIN inventario_baan t2 on 
			t1.codigo = t2.codigo AND 
			t2.sucursal = @sucursal INNER JOIN dboferta t3 on 
			t2.codigo = t3.codigo AND
			t2.sucursal = t3.sucursal AND 
			t3.bolsa = @primer_bolsa 
where	convert(int, t1.codigo) < dbo.gobierno() and
			isnumeric(t1.cod_barras_tandem) = 1 and
			substring(t1.status, 1,1) <> 'B' 
union
select	left(convert(varchar(12), @sucursal) + replicate(' ', 12), 12) +
			left(rtrim(ltrim(t1.cod_barras_tandem)) + replicate(' ', 13), 13) + 
			left(t1.descripcion + replicate(' ', 30), 30) + 
			case t1.grupo_est 
				when 'PC01A' then right(replicate(' ', 9) + convert(varchar(9), t1.prec_farm + (t1.prec_farm * 0.5)), 9)
				else right(replicate(' ', 9) + convert(varchar(9), t1.prec_farm), 9) 
			end +
			right(replicate(' ', 6) + convert(varchar(6), convert(money, t3.porcentaje * 100)), 6) +
			'      0' +
			'      0' +
			'      0' +
			case 
				when t1.clas_fis = 'B' then @descuento
				when t1.clas_fis = 'BA' then @descuento
				when t1.clas_fis = 'N' then '  0.00' 
				when t1.clas_fis = 'NA' then '  0.00' 
				when t1.clas_fis = 'H' then right(replicate(' ', 6) + convert(varchar(6), t1.descto_prod), 6) 
				when t1.clas_fis = 'HA' then right(replicate(' ', 6) + convert(varchar(6), t1.descto_prod), 6) 
			end +
			case t1.grupo_est 
				when 'PC01A' then right(replicate(' ', 9) + convert(varchar(9), t1.prec_pub + (t1.prec_pub * 0.5)), 9)
				else right(replicate(' ', 9) + convert(varchar(9), t1.prec_pub), 9) 
			end
from		maestro_productos_baan t1 INNER JOIN inventario_baan t2 ON 
			t1.codigo = t2.codigo AND 
			t2.sucursal = @sucursal INNER JOIN dboferta t3 ON 
			t2.codigo = t3.codigo AND
			t2.sucursal = t3.sucursal AND 
			t3.bolsa = @segunda_bolsa 
where	convert(int, t1.codigo) < dbo.gobierno() and
			isnumeric(t1.cod_barras_tandem) = 1 and
			substring(t1.status, 1,1) <> 'B' and
			t3.codigo not in	(	
											select	codigo 
											from		dboferta 
											where	sucursal = @sucursal and 
														bolsa = @primer_bolsa
										)

GO

