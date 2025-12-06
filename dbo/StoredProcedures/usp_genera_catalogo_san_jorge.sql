
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[usp_genera_catalogo_san_jorge]

as
select
'            ' +
left(convert(varchar(13), convert(bigint, t1.cod_barras)) + '             ', 13) +
left(t1.descripcion + '                                  ', 30) +
case t1.grupo_est when 'PC01A' then right('          ' + convert(varchar(9), round(t1.prec_farm, 2, 2) + (round(t1.prec_farm, 2, 2) * 0.5)), 9)
else right('          ' + convert(varchar(9), round(t1.prec_farm, 2, 2)), 9) end +
case 
when t1.clas_fis in ('N', 'NA') then '  0.00'
when t1.clas_fis in ('B', 'BA') then '100.00'
else right('   ' + convert(varchar(6), t1.descto_prod), 6) end
from
maestro_productos_baan t1
where
isnumeric(t1.cod_barras) = 1 and 
t1.status not like 'B%' and 
convert(bigint, t1.codigo) < dbo.gobierno() 
order by
t1.descripcion




GO
