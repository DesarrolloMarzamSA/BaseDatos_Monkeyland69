
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_genera_catalogo_fcias_farmatodo_cofar]
	@sucursal TINYINT

as	

--declare @sucursal tinyint
--declare @descuento varchar(6)
--set @sucursal = 1

select	left(convert(varchar(13), convert(bigint, t1.cod_barras)) + replicate(' ', 13), 13) +
			left(t1.descripcion + replicate(' ', 35), 35) + 
			case t1.grupo_est 
				when 'PC01A' then left(convert(varchar, convert(money, round(t1.prec_farm, 2, 2) + (round(t1.prec_farm, 2, 2) * 0.5))) + replicate(' ', 9), 9)
				else left(convert(varchar, convert(money, round(t1.prec_farm, 2, 2))) + replicate(' ', 9), 9)
			end +
			case 
				when t1.clas_fis = 'B' then '10000'
				when t1.clas_fis = 'BA' then '10000'
				when t1.clas_fis = 'N' then '000  '
				when t1.clas_fis = 'NA' then '000  ' 
				when t1.clas_fis = 'H' then left(convert(varchar(5), convert(int, t1.descto_prod * 100)) + replicate(' ', 5), 5)
				when t1.clas_fis = 'HA' then left(convert(varchar(5), convert(int, t1.descto_prod * 100)) + replicate(' ', 5), 5)
			end
from		maestro_productos_baan t1 inner join inventario_baan t2 on 
			t1.codigo = t2.codigo and 
			t2.sucursal = @sucursal
where	convert(int, t1.codigo) < dbo.gobierno() and
			isnumeric(t1.cod_barras) = 1 and
			substring(t1.status, 1,1) <> 'B' 
order by 
			t1.descripcion
GO
