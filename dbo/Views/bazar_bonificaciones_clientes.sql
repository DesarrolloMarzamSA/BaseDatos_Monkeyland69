create view bazar_bonificaciones_clientes
as
select 
t2.sucursal,
t2.cliente,
t1.codigo,
t1.bonificacion,
t1.techo
from
bazar_bonificaciones t1 inner join clientes_baan t2 on t1.segto = t2.segto and t1.ctepadre = t2.ctepadre
where
t2.sucursal = 13 and 
t2.cliente <> '14530'

GO

