CREATE PROCEDURE [dbo].[usp_genera_catalogo_fcias_carer]
	@sucursal TINYINT
as	

--declare @sucursal tinyint
--set @sucursal = 4

--declare @x_dummy varchar(4)

--select	@x_dummy = left(convert(varchar(4), convert(int, descuento)) + replicate('0', 4), 4) 
--from		clientes_baan 
--where	sucursal = @sucursal and 
--			cliente = '87135'

select	'A' +
			right( replicate('0', 8) + convert(varchar(8), convert(bigint, t1.codigo)), 8) +
			right(replicate('0', 13) + convert(varchar(13), convert(bigint, t1.cod_barras)), 13) +
			case
				when clas_ssa in ('1', '2', '3', '4', '5') then 'M'
				when clas_ssa = '6' then 'O'
				when clas_ssa = '7' then 'E'
				when clas_ssa in ('8', '9') then 'K'
			end  +
			case
				when clas_ssa in ('1', '2', '3', '4', '5', '6') then '1'
				else '0'
			end  +
			case
					when t1.refrigerado = 'R' then '1'
					else '0'
			end +
			case
					when t1.clas_ssa = '1' then '1'
					when t1.clas_ssa = '2' then '2'
					when t1.clas_ssa = '3' then '3'
					when t1.clas_ssa not in ('1', '2', '3') then '0'
			end +
			case
					when t1.iva = 0.00 then '3'
					else '1'
			end +
			right(replicate('0', 2) + convert(varchar(2), convert(int, (t1.iva * 100))), 2) +
			left(t1.descripcion + replicate(' ', 35), 35) + 
			left(t1.lab_largo + replicate(' ', 20), 20) + 
			case t1.grupo_est 
				when 'PC01A' then left(convert(varchar, convert(int, (t1.prec_farm * 100) + (t1.prec_farm * 100 * 0.5))) + replicate(' ', 9), 9)
				else left(convert(varchar, convert(int, t1.prec_farm * 100)) + replicate(' ', 9), 9)
			end +
			case t1.grupo_est 
				when 'PC01A' then left(convert(varchar, convert(int, (t1.prec_pub * 100) + (t1.prec_pub * 100 * 0.5))) + replicate(' ', 9), 9)
				else left(convert(varchar, convert(int, t1.prec_pub * 100)) + replicate(' ', 9), 9)
			end +			
			replace(convert(varchar(10), getdate(), 3), '/', '') +
			case 
				when t1.clas_fis = 'B' then 'B'
				when t1.clas_fis = 'BA' then 'B'
				when t1.clas_fis = 'N' then 'N'
				when t1.clas_fis = 'NA' then 'N' 
				when t1.clas_fis = 'F' then 'N'
				when t1.clas_fis = 'FA' then 'N'
				when t1.clas_fis = 'H' then  'L'
				when t1.clas_fis = 'HA' then 'L'
			end +
			-- cambiamos t2.porcentaje por t2.descuento
			/* Ya no necesitamos el case??
			case when t2.descuento is null then '000'
				else left(replace(convert(varchar(5), t2.descuento * 100), '.', '') + replicate(' ', 4), 4)
			end
			*/
			case 
				when t1.clas_fis = 'B' then left(replace(convert(varchar(5), t2.descuento * 100), '.', '') + replicate(' ', 4), 4)
				when t1.clas_fis = 'BA' then left(replace(convert(varchar(5), t2.descuento * 100), '.', '') + replicate(' ', 4), 4)
				when t1.clas_fis = 'N' then '000'
				when t1.clas_fis = 'NA' then '000' 
				when t1.clas_fis = 'F' then '000'
				when t1.clas_fis = 'FA' then '000'
				when t1.clas_fis = 'H' then left(replace(convert(varchar(5), t2.descuento * 100), '.', '') + replicate(' ', 4), 4)
				when t1.clas_fis = 'HA' then left(replace(convert(varchar(5), t2.descuento * 100), '.', '') + replicate(' ', 4), 4)
			end
from		maestro_productos_baan t1 inner join carer_descuentos t2 on 
			t1.codigo = t2.codigo 
where	convert(int, t1.codigo) < dbo.gobierno() and
			isnumeric(t1.cod_barras) = 1 and
			substring(t1.status, 1, 1) <> 'B' 
order by t1.descripcion

GO

