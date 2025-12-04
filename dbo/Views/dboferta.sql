

CREATE view [dbo].[dboferta] as
select
sucursal,
codigo,
status,
bolsa,
tipo_oferta,
cant_base,
cant_oferta,
porcentaje,
vigencia_inicial,
vigencia_final,
disponible,
timestamp
from
capa_ibs.dbo.dboferta with(nolock)

GO

