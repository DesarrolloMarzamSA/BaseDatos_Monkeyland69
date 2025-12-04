USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_genera_catalogo_san_jose]
WITH ENCRYPTION
as
declare @descuento varchar(6)
select @descuento = right('   ' + convert(varchar(6), descuento), 6) from clientes_baan where sucursal = 7 and cliente = '07123'
select
right('00' + '7', 2) +
'          ' +
left(convert(varchar(13), convert(bigint, t1.cod_barras)) + '             ', 13) +
left(t1.descripcion + '                              ', 30) +
left(right('       ' + convert(varchar(15), case t1.grupo_est when 'PC01G' then t1.prec_farm + (t1.prec_farm * 0.5) else t1.prec_farm end), 12), 9) +
case 
when t1.clas_fis = 'B' then @descuento
when t1.clas_fis = 'BA' then @descuento
when t1.clas_fis = 'N' then '000.00' 
when t1.clas_fis = 'NA' then '000.00' 
when t1.clas_fis = 'H' then right('   ' + convert(varchar(6), t1.descto_prod), 6) 
when t1.clas_fis = 'HA' then right('   ' + convert(varchar(6), t1.descto_prod), 6) end 
from maestro_productos_baan t1 inner join inventario_baan t2 on t1.codigo = t2.codigo and t2.sucursal = 7
where
convert(int, t1.codigo) < dbo.gobierno() and
isnumeric(t1.cod_barras) = 1
order by
t1.descripcion
GO
