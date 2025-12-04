
CREATE procedure [dbo].[usp_graba_historia_cfd_spt_fahorro] @facturota int, @iva int
as
delete from historica.dbo.facturas_spt_fahorro where facturota = @facturota and iva = @iva

insert into historica.dbo.facturas_spt_fahorro 
select 
t2.sucursal_remision, 
t1.factura, 
t2.cuenta_remision,
t1.ruta, 
t1.segto, 
t1.ctepadre, 
t1.rfc, 
t1.farmacia, 
t1.horacap, 
t1.dueno, 
t1.agente, 
t1.controlador, 
t1.domicilio, 
t1.colonia, 
t1.poblacion, 
t1.codigos, 
t1.descripcion, 
t1.cod_barras, 
t1.t_seak, 
t1.cant_real, 
t1.cant_ped, 
t1.cant_dev, 
t1.clas_fis, 
t1.cant_base, 
t1.cant_ofert, 
t1.porcentaje, 
t1.prec_pub, 
t1.prec_farm, 
t1.desc_base, 
t1.def_iva, 
t1.grupo_estadistico, 
t1.desctoesp, 
t1.descto, 
t1.prec_neto, 
t1.total, 
t1.orden, 
t1.ahorrado_piezas, 
t1.ahorrado_porcentaje, 
t1.folio, 
0, 
t1.fecha_fact,
@facturota, 
@iva,
t1.ieps,
t1.ivaieps,
t1.ieps_porcentaje
from
facturacion_cfd_spt_fahorro t1 with(nolock) inner join cat_cuentas_spt_fahorro t2 with(nolock) on t1.cuenta_estilo_ahorro = t2.cuenta_estilo_ahorro

GO

