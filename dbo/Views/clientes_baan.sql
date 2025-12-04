




CREATE view [dbo].[clientes_baan] 
as
select
sucursal,
letra,
cliente,
farmacia,
direccion,
colonia,
poblacion,
codigo_postal,
cve_estado,
rfc,
descuento,
agrupacion,
segto,
ctepadre,
compania,
limite,
usado,
agen_cod,
agen_nombre,
agen_empleado,
plazo,
status,
tipo,
bric,
fecha_alta,
vta_psicotropicos,
modo_factura,
ruta,
timestamp,
cliente_ibs
from
capa_ibs.dbo.clientes_baan with(nolock)

GO

