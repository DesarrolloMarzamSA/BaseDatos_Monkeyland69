USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_genera_catalogo_abc] @sucursal tinyint
WITH ENCRYPTION
as
--exec usp_genera_catalogo_abc 4
declare @descuento money
select @descuento = convert(money, descuento) from clientes_baan where sucursal = 3 and cliente = '81205'


select
right('00' + convert(varchar(2), @sucursal), 2) +
'          ' +
left(ltrim(isnull(t3.cod_barras_abc, t1.cod_barras_tandem)) + '             ', 13) +
left(t1.descripcion + '                              ', 30) +
right('                 ' + convert(varchar(17), round(convert(money, case t1.grupo_est when 'PC01A' then (t1.prec_farm + (t1.prec_farm * 0.5)) else t1.prec_farm end), 2, 1)), 9) +
case 
when t1.clas_fis = 'B'  then right('      ' + convert(varchar(6), @descuento), 6) 
when t1.clas_fis = 'BA' then right('      ' + convert(varchar(6), @descuento), 6) 
when t1.clas_fis = 'N'  then '  0.00' 
when t1.clas_fis = 'NA' then '  0.00' 
when t1.clas_fis = 'H'  then right('      ' + convert(varchar(6), t1.descto_prod), 6) 
when t1.clas_fis = 'HA' then right('      ' + convert(varchar(6), t1.descto_prod), 6) end
from maestro_productos_baan t1 inner join inventario_baan t2 on t1.codigo = t2.codigo and t2.sucursal = @sucursal
left outer join gdl_abc_catalogo t3 on t1.codigo = t3.codigo
where
t2.piezas > 0 and 
isnumeric(t1.cod_barras) = 1 and 
convert(int, t1.codigo) < dbo.gobierno()
order by
t1.descripcion


GO
