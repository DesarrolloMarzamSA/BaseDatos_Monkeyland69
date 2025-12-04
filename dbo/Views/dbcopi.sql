

create view dbcopi
as
select 
sucursal,
factura,
fecha_fact,
cliente,
causa,
opcion,
status_cop,
clave,
ampara,
nota_cred,
importe,
llave_dig,
ntro_folio,
captura,
fecha_nota,
ruta_copi,
bolsas,
timestamp
from historica.dbo.dbcopi

GO

