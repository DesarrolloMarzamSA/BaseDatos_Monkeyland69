



CREATE view [dbo].[dbcataut]
as
select
segto SEGMENTO,
ctepadre CADENA,
codigo CODIGO,
status STATUS,
cod_barrcli COD_BARRCLI,
cod_prodcli COD_PRODCLI,
fecalt FECALT,
grupo GRUPO,
grupo_factura GRUPO_FACTURA,
desc_espec DESC_ESPEC,
empaque EMPAQUE,
familia FAMILIA,
subfamilia SUBFAMILIA,
precio_farmacia PRECIO_FARMACIA,
precio_publico PRECIO_PUBLICO,
fecha_inicio_precios FECHA_INICIO_PRECIOS,
fecha_fin_precios FECHA_FIN_PRECIOS,
fechamod FECHAMOD,
horamod HORAMOD,
usuario USUARIO,
tipomov TIPOMOV,
statud_old STATUD_OLD,
fechamod_old FECHAMOD_OLD,
horamod_old HORAMOD_OLD,
usuario_old USUARIO_OLD,
clasificacion_fiscal CLASIFICACION_FISCAL,
cau_codigo_para_venta CAU_CODIGO_PARA_VENTA,
filler FILLER,
fecha_hora_cambio TIMESTAMP
from
capa_ibs.dbo.catalogo_autoservicios 
where 
sucursal = 3

GO

