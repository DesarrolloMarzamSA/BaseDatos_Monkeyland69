
CREATE procedure [dbo].[usp_genera_catalogo_oferta_fcias_farmatodo_cofar ]
	@sucursal tinyint,
	@primer_bolsa varchar(5),
	@segunda_bolsa varchar(5)
as

--declare @primer_bolsa  as varchar(5)
--declare @segunda_bolsa as varchar(5)
--declare @sucursal as tinyint
--set @primer_bolsa = 'plus6'
--set @segunda_bolsa = 'libre'
--set @sucursal = 1

select	left(convert(varchar(12), @sucursal) + replicate(' ', 12), 12) +
			left(convert(varchar(13), convert(bigint, t1.cod_barras)) + replicate(' ', 13), 13),
			descripcion = left(t1.descripcion + replicate(' ', 30), 30) +
			case t1.grupo_est 
				when 'PC01A' then left(convert(varchar, convert(money, round(t1.prec_farm, 2, 2) + (round(t1.prec_farm, 2, 2) * 0.5))) + replicate(' ', 9), 9)
				else left(convert(varchar, convert(money, round(t1.prec_farm, 2, 2))) + replicate(' ', 9), 9)
			end  +
			left(convert(varchar, convert(money, t3.porcentaje * 100)) + replicate(' ', 6), 6) +
			'0      ' +
			'0      ' +
			'0    ' +
			case 
				when t1.clas_fis = 'B' then '100.00'
				when t1.clas_fis = 'BA' then '100.00'
				when t1.clas_fis = 'N' then '0.00  '
				when t1.clas_fis = 'NA' then '0.00  ' 
				when t1.clas_fis = 'H' then left(convert(varchar(6), convert(money, t1.descto_prod)) + replicate(' ', 6), 6)
				when t1.clas_fis = 'HA' then left(convert(varchar, convert(money, t1.descto_prod)) +replicate(' ', 6), 6)
			end
from		maestro_productos_baan t1 inner join inventario_baan t2 on 
			t1.codigo = t2.codigo and 
			t2.sucursal = @sucursal inner join dboferta t3 on 
			t2.codigo = t3.codigo and 
			t2.sucursal = t3.sucursal and 
			t3.bolsa = @primer_bolsa 
where	convert(int, t1.codigo) < dbo.gobierno() and
			isnumeric(t1.cod_barras) = 1 and
			substring(t1.status, 1,1) <> 'B' and
			t3.disponible > 10 and
			t2.piezas > 10
union
select	left(convert(varchar(12), @sucursal) + replicate(' ', 12), 12) +
			left(convert(varchar(13), convert(bigint, t1.cod_barras)) + replicate(' ', 13), 13),
			descripcion = left(t1.descripcion + replicate(' ', 30), 30) +
			case t1.grupo_est 
				when 'PC01A' then left(convert(varchar, convert(money, round(t1.prec_farm, 2, 2) + (round(t1.prec_farm, 2, 2) * 0.5))) + replicate(' ', 9), 9)
				else left(convert(varchar, convert(money, round(t1.prec_farm, 2, 2))) + replicate(' ', 9), 9)
			end  +
			left(convert(varchar, convert(money, t3.porcentaje * 100)) + replicate(' ', 6), 6) +
			'0      ' +
			'0      ' +
			'0    ' +
			case 
				when t1.clas_fis = 'B' then '100.00'
				when t1.clas_fis = 'BA' then '100.00'
				when t1.clas_fis = 'N' then '0.00  '
				when t1.clas_fis = 'NA' then '0.00  ' 
				when t1.clas_fis = 'H' then left(convert(varchar(6), convert(money, t1.descto_prod)) + replicate(' ', 6), 6)
				when t1.clas_fis = 'HA' then left(convert(varchar, convert(money, t1.descto_prod)) +replicate(' ', 6), 6)
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
			t3.disponible > 10 and 
			t2.piezas > 10 and
			t3.codigo not in	(	
										select	codigo 
										from		dboferta 
										where	sucursal = @sucursal and 
													bolsa = @primer_bolsa
									)  
order by 
			descripcion

GO

