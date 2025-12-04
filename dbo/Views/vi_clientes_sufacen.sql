create 
view [dbo].[vi_clientes_sufacen]
as
select 
	sucursal, cliente, farmacia, status
from clientes_baan where --sucursal = 17 and 
	ctepadre = '216'
	and status NOT LIKE '%BAJA%'
	AND cliente <> '99216'

GO

