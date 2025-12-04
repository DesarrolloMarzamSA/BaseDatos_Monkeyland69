CREATE procedure [dbo].[usp_genera_catalogo_farmacon_exi]
	@sucursal tinyint
as
--declare @sucursal tinyint
--set @sucursal = 17 
select	right(replicate('0', 8) + convert(varchar(8), t1.codigo), 8) +
			t1.cod_barras +
			left (convert(varchar(50), descripcion) + replicate(' ', 50), 50) +
			right(replicate('0', 8) + convert(varchar, cast(case t1.grupo_est when 'PC01A' then t1.prec_pub + (t1.prec_pub * 0.5) else t1.prec_pub end * 100 as int)), 8) +
			right(replicate('0', 8) + convert(varchar, cast(case t1.grupo_est when 'PC01A' then t1.prec_farm + (t1.prec_farm * 0.5) else t1.prec_farm end * 100 as int)), 8) +
			case
				when clas_fis = 'N' then replicate('0', 4)
				when clas_fis = 'NA' then replicate('0', 4)
				when clas_fis = 'B' then replicate('9', 4)
				when clas_fis = 'BA' then replicate('9', 4)
				when clas_fis = 'H' then right(replicate('0', 4) + convert(varchar(4), cast(t1.descto_prod*100 as int)), 4)
				when clas_fis = 'HA' then right(replicate('0', 4) + convert(varchar(4), cast(t1.descto_prod*100 as int)), 4)
			end +
			case
				when (iva = .1500 or iva = .1600) then '1'
				else '3'
			end +
			clas_ssa +
			convert(varchar(8), t1.fecha_alta, 112) +
			'C' +
			replicate('0', 13) +
			case
				--when t2.sucursal = 3 then '25'
				when t2.sucursal = 6 then '02'
				when t2.sucursal = 16 then '03'
				when t2.sucursal = 17 then '25'
				when t2.sucursal = 18 then '26'
				when t2.sucursal = 25 then '02'
			end
from		maestro_productos_baan t1 inner join inventario_baan t2 on
			t1.codigo = t2.codigo
where 	isnumeric(t1.cod_barras) = 1 and
			t1.clas_ssa <> '' and t2.sucursal not in(3) and 
			t2.sucursal = @sucursal and
			convert(int, t1.codigo) < dbo.gobierno() and
			substring(t1.status, 1,1) <> 'B' and
			t2.piezas > 0

GO

