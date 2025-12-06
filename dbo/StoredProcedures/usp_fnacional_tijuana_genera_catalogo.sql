
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
--exec usp_fnacional_tijuana_genera_catalogo 17



CREATE PROCEDURE [dbo].[usp_fnacional_tijuana_genera_catalogo] @sucursal int
WITH ENCRYPTION
as
select
left(convert(varchar(2), @sucursal) + '            ', 12) +
left(convert(varchar(13), convert(bigint, t1.cod_barras)) + '             ', 13) +  
left(t1.descripcion + '                                  ', 30) +
left(right('000000' + convert(varchar(12), round(case t1.grupo_est when 'PC01A' then t1.prec_farm + (t1.prec_farm * 0.5) else t1.prec_farm end, 2, 0)), 12), 9) +
case 
when t1.clas_fis in ('N', 'NA') then '000.00'
when t1.clas_fis in ('B', 'BA') then '100.00'
when t1.clas_fis in ('H', 'HA') then right('000' + convert(varchar(6), t1.descto_prod), 6)
end 
from maestro_productos_baan t1 inner join inventario_baan t2 on t1.codigo = t2.codigo and t2.sucursal = @sucursal
where
isnumeric(t1.cod_barras) = 1 and 
t1.status not like 'B%' and 
convert(bigint, t1.codigo) < dbo.gobierno()
GO
