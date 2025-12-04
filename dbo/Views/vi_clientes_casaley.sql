
CREATE view [dbo].[vi_clientes_casaley]
as
select 
	sucursal, cliente, farmacia, status
from clientes_baan where --sucursal = 17 and 
	ctepadre = '610'
	and status NOT LIKE '%BAJA%'
	AND cliente <> '99610'

GO

