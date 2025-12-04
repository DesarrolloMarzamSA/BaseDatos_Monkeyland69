CREATE view [dbo].[remisiones_facturas_docufact]
as
select 
sucursal,
remision,
folio_fiscal,
cliente,
fecha,
timestamp
from 
historica.dbo.remisiones_facturas_docufact with(nolock)

GO

