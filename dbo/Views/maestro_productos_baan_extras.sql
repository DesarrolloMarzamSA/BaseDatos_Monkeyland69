create view maestro_productos_baan_extras
as
select 
codigo,
marca,
presentacion,
contenido1,
unidadcontenido1,
contenido2,
unidadcontenido2,
timestamp
from 
capa_ibs.dbo.maestro_productos_baan_extra

GO

