--exec usp_fnacional_tijuana_genera_ofertas 25, 'C2713', 'LIBRE'



CREATE PROCEDURE [dbo].[usp_fnacional_tijuana_genera_ofertas] @sucursal int, @primer_bolsa varchar(5), @segunda_bolsa varchar(5)
as
select
left(convert(varchar(2), @sucursal) + '            ', 12) +
left(convert(varchar(13), convert(bigint, t1.cod_barras)) + '             ', 13) +  
left(t1.descripcion + '                                  ', 30) +
left(right('000000' + convert(varchar(12), round(case t1.grupo_est when 'PC01A' then t1.prec_farm + (t1.prec_farm * 0.5) else t1.prec_farm end, 2, 0)), 12), 9) +
right('000' + convert(varchar(6), t3.porcentaje), 6) + 
'000000000000000000000' +
case 
when t1.clas_fis in ('N', 'NA') then '000.00'
when t1.clas_fis in ('B', 'BA') then '100.00'
when t1.clas_fis in ('H', 'HA') then right('000' + convert(varchar(6), t1.descto_prod), 6)
end 
from maestro_productos_baan t1 inner join inventario_baan t2 on t1.codigo = t2.codigo and t2.sucursal = @sucursal
inner join dboferta t3 on t1.codigo = t3.codigo and t3.sucursal = @sucursal and t3.bolsa = @primer_bolsa
where
isnumeric(t1.cod_barras) = 1 and 
t1.status not like 'B%' and 
convert(bigint, t1.codigo) < dbo.gobierno() 
union
select
left(convert(varchar(2), @sucursal) + '            ', 12) +
left(convert(varchar(13), convert(bigint, t1.cod_barras)) + '             ', 13) +  
left(t1.descripcion + '                                  ', 30) +
left(right('000000' + convert(varchar(12), round(case t1.grupo_est when 'PC01A' then t1.prec_farm + (t1.prec_farm * 0.5) else t1.prec_farm end, 2, 0)), 12), 9) +
right('000' + convert(varchar(6), t3.porcentaje), 6) + 
'000000000000000000000' +
case 
when t1.clas_fis in ('N', 'NA') then '000.00'
when t1.clas_fis in ('B', 'BA') then '100.00'
when t1.clas_fis in ('H', 'HA') then right('000' + convert(varchar(6), t1.descto_prod), 6)
end 
from maestro_productos_baan t1 inner join inventario_baan t2 on t1.codigo = t2.codigo and t2.sucursal = @sucursal
inner join dboferta t3 on t1.codigo = t3.codigo and t3.sucursal = @sucursal and t3.bolsa = @segunda_bolsa
where
t3.codigo not in (select codigo from dboferta where sucursal = @sucursal and bolsa = @primer_bolsa) and
isnumeric(t1.cod_barras) = 1 and 
t1.status not like 'B%' and 
convert(bigint, t1.codigo) < dbo.gobierno()

GO

