CREATE view vi_ofertas_farmacon
as
select t1.*, case isnull(t2.porcentaje, 0) when 0 then isnull(t3.porcentaje, 0) else isnull(t2.porcentaje, 0) end as porcentaje /*, t2.porcentaje C2599, t3.porcentaje LIBRE*/
from
(select distinct sucursal, codigo from dboferta where sucursal = 17 and bolsa in ('C2599', 'LIBRE')) t1 
left outer join dboferta t2 on 
t1.sucursal = t2.sucursal and t1.codigo = t2.codigo and t2.bolsa = 'C2599'
left outer join dboferta t3 on 
t1.sucursal = t3.sucursal and t1.codigo = t3.codigo and t3.bolsa = 'LIBRE'

GO

