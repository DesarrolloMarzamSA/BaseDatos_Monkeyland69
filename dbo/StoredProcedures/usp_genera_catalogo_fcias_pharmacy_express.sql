
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_genera_catalogo_fcias_pharmacy_express]
	@sucursal TINYINT

AS
	declare @descuento money

--declare @sucursal tinyint
--declare @descuento varchar(6)
--set @sucursal = 3

select	@descuento = descuento 
from		clientes_baan 
where	sucursal = 3 and 
			cliente = '84145'

select	left(convert(varchar(13), convert(bigint, t1.cod_barras)) + replicate(' ', 13), 13) +
			left(t1.descripcion + replicate(' ', 35), 35) +
			case t1.grupo_est 
				when 'PC01A' then right(replicate(' ', 9) + convert(varchar(9), t1.prec_farm + (t1.prec_farm * 0.5)), 9)
				else right(replicate(' ', 9) + convert(varchar(9), round(t1.prec_farm, 2, 2)), 9) 
			end +
			case 
				when t1.clas_fis = 'N' then '  0.00' 
				when t1.clas_fis = 'NA' then '  0.00' 
				when t1.clas_fis = 'B' then right(replicate(' ', 6) + convert(varchar(6), @descuento), 6)
				when t1.clas_fis = 'BA' then right(replicate(' ', 6) + convert(varchar(6), @descuento), 6)
				when t1.clas_fis = 'H' then right(replicate(' ', 6) + convert(varchar(6), t1.descto_prod), 6) 
				when t1.clas_fis = 'HA' then right(replicate(' ', 6) + convert(varchar(6), t1.descto_prod), 6) 
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
