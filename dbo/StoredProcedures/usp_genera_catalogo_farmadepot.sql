
CREATE procedure [dbo].[usp_genera_catalogo_farmadepot]
as

declare @descuento as money
select @descuento = descuento from clientes_baan where sucursal = 7 and cliente = '07602'


select 
left(t1.cod_barras + '               ', 15) + ';' + 
right('            ' + convert(varchar(12), convert(money, case t1.grupo_est when 'PC01A' then t1.prec_pub +  (t1.prec_pub * 0.5)  else t1.prec_pub  end)), 12) + ';' + 
right('            ' + convert(varchar(12), convert(money, case t1.grupo_est when 'PC01A' then t1.prec_farm + (t1.prec_farm * 0.5) else t1.prec_farm end)), 12) + ';' + 
case left(t1.clas_fis, 1)
when 'B' then 'B'
when 'N' then 'N'
when 'H' then 'L' else 'B' end + ';' + 
case 
when t1.clas_fis = 'B' then right('      ' + convert(varchar(6), @descuento), 6)
when t1.clas_fis = 'BA' then right('      ' + convert(varchar(6), @descuento), 6)
when t1.clas_fis = 'N' then '  0.00' 
when t1.clas_fis = 'NA' then '  0.00' 
when t1.clas_fis = 'H' then right('      ' + convert(varchar(6), t1.descto_prod), 6) 
when t1.clas_fis = 'HA' then right('      ' + convert(varchar(6), t1.descto_prod), 6) else '  0.00' end + ';' + 
case isnull(t2.porcentaje, 0)
when 0 then ' ' 
else 'O' end + ';' + 
right('      ' + convert(varchar(6), convert(money, 100 * isnull(t2.porcentaje, 0))), 6) 
from
maestro_productos_baan t1 left outer join dboferta t2 on t1.codigo = t2.codigo and t2.sucursal = 1 and t2.bolsa = 'LIBRE'
inner join inventario_baan_sin_filtro t3 on t1.codigo = t3.codigo and t3.sucursal = 1 and t3.piezas > 1 and t3.status = '' 
where
convert(int, t1.codigo) < dbo.gobierno() 
--and left(t1.status, 1) <> 'B' 
order by
t1.cod_barras

GO

