
CREATE
view [dbo].[devoluciones_dwh] 
as

select 
sucursal,
cliente,
factura,
tipo_nota,
fecha,
folio_nota,
codigo,
cantidad
from
capa_ibs.dbo.devoluciones_dwh WITH (NOLOCK)

GO

