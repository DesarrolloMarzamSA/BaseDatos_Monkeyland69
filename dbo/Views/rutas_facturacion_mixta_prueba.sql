 create view rutas_facturacion_mixta_prueba as
  select
  letra,
sucursal,
interfase,
ip,
usuario,
password,
volumen,
fact_elec,
respuestas,
ofertas,
programa_ofertas,
facturacion
from
rutas_tandem_prueba

GO

