




CREATE view [dbo].[maestro_productos]
as
SELECT 
codigo,
cod_barras,
descripcion,
desc_corta,
grupo_est,
clas_fis,
clas_ssa,
clas_abc,
cod_lab,
lab_corto,
lab_largo,
lab_rfc,
tipo_prod,
sus_act1,
desc_sus_act1,
sus_act2,
desc_sus_act2,
round(prec_farm, 2, 1) prec_farm,
round(prec_pub, 2, 1) prec_pub,
round(p_costo, 2, 1) p_costo,
descto,
descto_prod,
iva,
refrigerado,
fecha_alta,
fecha_baja,
grupo_producto,
pzas_empaque_original,
status,
cod_barras_tandem,
derecho_devolucion,
clave_clas_promocion,
clas_promocion,
desc_grupo_est,
timestamp,
fuente,
codigo_int
from 
capa_ibs.dbo.maestro_productos with(nolock)

GO

