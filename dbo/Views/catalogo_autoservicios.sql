

CREATE view [dbo].[catalogo_autoservicios]
as
select 
sucursal,
segto,
ctepadre,
codigo,
status,
cod_barrcli,
cod_prodcli,
fecalt,
grupo,
grupo_factura,
desc_espec,
empaque,
familia,
subfamilia,
precio_farmacia,
precio_publico,
fecha_inicio_precios,
fecha_fin_precios,
fechamod,
horamod,
usuario,
tipomov,
statud_old,
fechamod_old,
horamod_old,
usuario_old,
clasificacion_fiscal,
cau_codigo_para_venta,
filler,
fecha_hora_cambio
from
capa_ibs.dbo.catalogo_autoservicios with(nolock)

GO

