CREATE--create 
view [dbo].[vi_clientes_moderna]
as
select 
	sucursal, cliente, farmacia, status
from clientes_baan where --sucursal = 17 and 
	ctepadre = '214'
	and status NOT LIKE '%BAJA%'
	AND cliente <> '99214'

GO

