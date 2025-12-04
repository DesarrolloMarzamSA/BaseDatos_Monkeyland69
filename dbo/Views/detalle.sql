












CREATE view [dbo].[detalle]
as
select
t2.sucursal,
t2.factura,
t2.ubicacion,
t2.pichonera,
t2.codigos,
t2.cant_ped,
t2.cant_surt,
t2.cant_base,
t2.cant_ofert,
t2.clas_fis_r,
t2.prec_farm,
t2.prec_pub,
t2.num_fol,
t2.agru_sep,
t2.clas_fis,
t2.id_prog,
t2.validas,
t2.poss,
t2.netos,
t2.fol_ctl,
t2.dest_det,
t2.nom_prod,
t2.tipo_grup,
t2.real_s_cos,
t2.pcosto,
t2.pfarm_inv,
t2.seg_oferta,
t2.pzaofercos,
t2.tipo_ofert,
t2.proveedor,
t2.porcentaje,
t2.cant_real,
t2.desc_base,
t2.canc_ofer,
t2.prec_inc_p,
t2.ubi_bodega,
t2.emp_origin,
t2.bul_emp,
t2.lote1,
t2.lote2,
t2.lote3,
t2.tipo_grupo,
t2.ofedel_dis,
t2.ofede_ret,
t2.def_iva,
t2.negado_nvo,
t2.imp_nota_v,
t2.filler,
t2.timestamp
from
historica.dbo.encabezado t1 with(nolock) inner join historica.dbo.detalle t2 with(nolock) on t1.sucursal = t2.sucursal and t1.serie = t2.serie and t1.factura = t2.factura
where
t1.fechaprog > convert(datetime, '2011-07-01', 121)

GO

