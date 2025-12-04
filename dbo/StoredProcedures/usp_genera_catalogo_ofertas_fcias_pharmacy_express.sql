CREATE PROCEDURE usp_genera_catalogo_ofertas_fcias_pharmacy_express
	@sucursal tinyint,
	@primer_bolsa varchar(5),
	@segunda_bolsa varchar(5)
	
as

declare @descuento varchar(6)

--declare @descuento varchar(6)
--declare @primer_bolsa  varchar(5)
--declare @segunda_bolsa  varchar(5)
--declare @sucursal as tinyint
--set @primer_bolsa = 'LIBRE'
--set @segunda_bolsa = 'ZZZZZ'
--set @sucursal = 3

select	@descuento = right(replicate(' ', 6) + convert(varchar(6), descuento), 6) 
from		clientes_baan 
where	sucursal = 3 and 
			cliente = '84145'

select	right('00' + convert(varchar, @sucursal), 2) +
			replicate(' ', 10) +
			left(convert(varchar(13), convert(bigint, t1.cod_barras)) + replicate(' ', 13), 13) +
			left(t1.descripcion + replicate(' ', 35), 35) + 
			case t1.grupo_est 
				when 'PC01A' then right(replicate(' ', 9) + convert(varchar(9), t1.prec_farm + (t1.prec_farm * 0.5)), 9)
				else right(replicate(' ', 9) + convert(varchar(9), round(t1.prec_farm, 2, 2)), 9) 
			end +
			case
				when t3.cant_base = 0 and t3.cant_oferta = 0 then right(replicate(' ', 6) + convert(varchar(6), t3.porcentaje * 100), 6)
				when t3.cant_base > 0 and t3.cant_oferta > 0 then right(replicate(' ', 6) + convert(varchar(6), convert(money, t3.cant_oferta) / (convert(money, t3.cant_base) + convert(money, t3.cant_oferta) * 100)), 6)
				else right(replicate(' ', 6) + convert(varchar(6), t3.porcentaje * 100), 6)
			end +
			'      1' +
			'      0' +
			case 
				when t1.clas_fis = 'N' then '  0.00' 
				when t1.clas_fis = 'NA' then '  0.00' 
				when t1.clas_fis = 'B' then right(replicate(' ', 6) + convert(varchar(6), @descuento), 6)
				when t1.clas_fis = 'BA' then right(replicate(' ', 6) + convert(varchar(6), @descuento), 6)
				when t1.clas_fis = 'H' then right(replicate(' ', 6) + convert(varchar(6), t1.descto_prod), 6) 
				when t1.clas_fis = 'HA' then right(replicate(' ', 6) + convert(varchar(6), t1.descto_prod), 6) 
			end
from		maestro_productos_baan t1 INNER JOIN inventario_baan t2 ON 
			t1.codigo = t2.codigo AND 
			t2.sucursal = @sucursal INNER JOIN dboferta t3 ON 
			t2.codigo = t3.codigo AND
			t2.sucursal = t3.sucursal AND 
			t3.bolsa = @primer_bolsa 
WHERE	convert(int, t1.codigo) < dbo.gobierno() and
			isnumeric(t1.cod_barras) = 1 and
			substring(t1.status, 1,1) <> 'B' 
union
select	right('00' + convert(varchar, @sucursal), 2) +
			replicate(' ', 10) +
			left(convert(varchar(13), convert(bigint, t1.cod_barras)) + replicate(' ', 13), 13) +
			left(t1.descripcion + replicate(' ', 35), 35) + 
			case t1.grupo_est 
				when 'PC01A' then right(replicate(' ', 9) + convert(varchar(9), t1.prec_farm + (t1.prec_farm * 0.5)), 9)
				else right(replicate(' ', 9) + convert(varchar(9), round(t1.prec_farm, 2, 2)), 9) 
			end +
			case
				when t3.cant_base = 0 and t3.cant_oferta = 0 then right(replicate(' ', 6) + convert(varchar(6), t3.porcentaje * 100), 6)
				when t3.cant_base > 0 and t3.cant_oferta > 0 then right(replicate(' ', 6) + convert(varchar(6), convert(money, t3.cant_oferta) / (convert(money, t3.cant_base) + convert(money, t3.cant_oferta) * 100)), 6)
				else right(replicate(' ', 6) + convert(varchar(6), t3.porcentaje * 100), 6)
			end +
			'      1' +
			'      0' +
			case 
				when t1.clas_fis = 'N' then '  0.00' 
				when t1.clas_fis = 'NA' then '  0.00' 
				when t1.clas_fis = 'B' then right(replicate(' ', 6) + convert(varchar(6), @descuento), 6)
				when t1.clas_fis = 'BA' then right(replicate(' ', 6) + convert(varchar(6), @descuento), 6)
				when t1.clas_fis = 'H' then right(replicate(' ', 6) + convert(varchar(6), t1.descto_prod), 6) 
				when t1.clas_fis = 'HA' then right(replicate(' ', 6) + convert(varchar(6), t1.descto_prod), 6) 
			end
from		maestro_productos_baan t1 inner join inventario_baan t2 on 
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
										from	dboferta 
										where	sucursal = @sucursal and 
										bolsa = @primer_bolsa
									)

GO

