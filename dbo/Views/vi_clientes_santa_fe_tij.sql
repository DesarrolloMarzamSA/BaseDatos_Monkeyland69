CREATE--create 
view [dbo].[vi_clientes_santa_fe_tij]
as
select 
	sucursal, cliente, farmacia, status
from clientes_baan where --sucursal = 17 and 
	ctepadre = '668'
	and status NOT LIKE '%BAJA%'
	AND cliente <> '99668'

GO

