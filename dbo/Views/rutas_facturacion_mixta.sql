create view rutas_facturacion_mixta as
  select
  letra,
sucursal,
interfase,
ip,
usuario,
password,
volumen,
fact_elec,
RESPUESTAS,
dbcopi,
DBDeVOLS DBDVOLS,
ofertas,
programa_ofertas,
facturacion
from
rutas_tandem

GO

