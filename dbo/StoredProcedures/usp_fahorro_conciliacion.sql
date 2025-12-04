

--select * from periodos_facturacion_spt_fahorro where id=532
--exec usp_fahorro_conciliacion '2018-05-28', '2018-05-29' --119760
CREATE procedure [dbo].[usp_fahorro_conciliacion] @fecha_inicial varchar(10), @fecha_final varchar(10)
as
set nocount on


declare @cedis int 
declare @sucursal int 
declare @factura char(8)  
declare @cliente char(5) 
declare @porcentaje_iva money
declare @cuenta_estilo_ahorro varchar(10) 
declare @ruta char(3)  
declare @segto char(2) 
declare @ctepadre char(3) 
declare @rfc varchar(50) 
declare @farmacia char(39) 
declare @horacap datetime
declare @dueno char(30) 
declare @agente char(5) 
declare @controlador char(2) 
declare @domicilio char(40) 
declare @colonia char(23) 
declare @poblacion char(15) 
declare @codigos char(9)  
declare @descripcion varchar(30)  
declare @cod_barras varchar(13) 
declare @laboratorio varchar(16) 
declare @cant_real int 
declare @cant_ped int 
declare @cant_ped_fahorro int 
declare @cant_dev int 
declare @clas_fis char(2) 
declare @cant_base int 
declare @cant_ofert int 
declare @porcentaje money 
declare @prec_pub money 
declare @prec_farm money 
declare @desc_base money 
declare @def_iva money 
declare @grupo_estadistico varchar(10) 
declare @desctoesp money
declare @orden int
declare @tipo_pedido varchar(1) 
declare @cuenta varchar(5) 
declare @nom_prod char(15) 
declare @remisionado tinyint
declare @tipo_reclamacion char(2) 
declare @porcentaje_fahorro money
declare @porcentaje_marzam money
declare @diferencia_porcentaje_oferta money
declare @tipo_oferta char(2)
declare @ultimo_cambio_baan datetime
declare @ultimo_precio_notificado money
declare @ultima_oferta_notificada money
declare @prec_farm_marzam money
declare @prec_farm_fahorro money
declare @diferencia_precio money
declare @importe_bruto_marzam money
declare @importe_bruto_fahorro money
declare @diferencia_importe_bruto money
declare @importe_oferta_marzam money
declare @importe_oferta_fahorro money
declare @diferencia_importe_oferta money
declare @importe_desc_com_marzam money
declare @importe_desc_com_fahorro money
declare @dif_importe_desc_com money
declare @total_importe_neto_marzam money
declare @total_iva_neto_marzam money
declare @total_bonificacion_iva_marzam money
declare @total_marzam money
declare @importe_neto_fahorro money
declare @pronto_pago_unitario money
declare @iva_unitario money
declare @iva_neto_fahorro money
declare @total_fahorro money
declare @diferencia_totales money
declare @diferencia_importes_netos money
declare @status_pedsok char(2) --vacia  
declare @gestor_pedsok char(2) --vacia  
declare @costo_pedsok char(2) --vacia  
declare @oferta_pedsok char(2) --vacia  
declare @pronto_pago_pedsok char(2) --vacia  
declare @iva_neto_pedsok char(2) --vacia  
declare @neto_pedsok char(2) --vacia  
declare @monto_baan money
declare @tipo_pedido2 char(2)
declare @fecha_movimiento char(2) --vacia  
declare @pzas_pedidook char(2) --vacia  
declare @status varchar(15)  
declare @cuenta_estilo_baan varchar(15)
declare @bruto_menos_oferta_por_piezas money
declare @iva money 
declare @descuento_comercial money
declare @bonificacion_del_iva money
declare @total2 money
declare @reingresada_almacen varchar(15)

declare @calculada_cant_base int
declare @calculada_cant_ofert int
declare @calculada_porcentaje money
declare @calculada_desc_base money
declare @calculada_prec_farm money
declare @calculada_prec_pub money
declare @calculada_precio1 money
declare @calculada_precio2 money
declare @calculada_iva_linea money
declare @calculada_descuento_linea money
declare @calculada_bruto_linea money
declare @calculada_total money
declare @calculada_ahorrado_piezas money
declare @calculada_ahorrado_porcentaje money
declare @calculada_precio_neto money

select 
case when t1.sucursal=2 then 3 else t1.sucursal end as sucursal,
t1.serie,
t1.factura,
t1.cliente,
t1.ruta,
t1.facturado,
t1.farmacia,
t1.etiquetas,
t1.domicilio,
t1.colonia,
t1.itinerario,
t1.letradig,
t1.restodig,
t1.numdig,
t1.poblacion,
t1.jefeagente,
t1.numagente,
t1.control,
t1.diapago,
t1.cvecredito,
t1.filler2,
t1.password,
t1.fechaprog horacap,
t1.hojordsur,
t1.hojfactura,
t1.tipfac,
t1.bulto,
t1.producee0,
t1.renglonee0,
t1.importe,
t1.controlado,
convert(money, t1.desctoesp) desctoesp,
t1.dueno,
t1.meno999,
t1.mayp000,
t1.encima,
t1.jaula,
t1.rutaf,
t1.facturadof,
t1.itineraf,
t1.producto3a,
t1.prducto2a,
t1.producto1a,
t1.productob,
t1.productoc,
t1.fechaprog,
t1.repleon,
t1.limexcedid,
t1.impmenor,
t1.rutaencima,
t1.complerel,
t1.espnetos,
t1.mafnarch,
t1.prodimp,
t1.indcod,
t1.enestacion,
t1.numjob,
t1.puerta,
t1.filler3,
t1.tipoorden,
t1.tipofactur,
t1.cadenaid,
t1.modosepara,
t1.licitacion,
t1.contrato,
convert(int, convert(varchar(15), replace(replace(t1.orden, ' ', ''), '"', ''))) orden,
t1.fianza,
t1.fechaalta,
t1.noalta,
t1.segto,
t1.ctepadre,
t1.filler,
t1.timestamp,
t1.folio_fiscal into #encabezado from historica.dbo.encabezado t1 with(nolock) where 
t1.segto = 'C1' and t1.ctepadre = '007' and t1.fechaprog between convert(datetime, @fecha_inicial, 121) and convert(datetime, @fecha_final, 121)
and isnumeric(replace(replace(t1.orden, ' ', ''), '"', '')) = 1 --and t1.factura=32908001

select 
case when t2.sucursal=2 then 3 else t2.sucursal end sucursal,
t2.serie,
t2.factura,
t2.ubicacion,
t2.pichonera,
right(t2.codigos, 7) codigos,
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
case convert(money, t2.porcentaje) when 0 then convert(money, 0) else convert(money, t2.porcentaje)/10000 end porcentaje,
t2.cant_real,

case convert(money, t2.desc_base) when 0 then convert(money, 0) else convert(money, convert(money, t2.desc_base)/10000) end desc_base,
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
convert(money, t2.def_iva)/10000 def_iva,
t2.negado_nvo,
t2.imp_nota_v,
t2.filler,
t2.timestamp into #detalle from historica.dbo.encabezado t1 with(nolock) inner join historica.dbo.detalle t2 with(nolock) on t1.sucursal = t2.sucursal and t1.serie = t2.serie and t1.factura = t2.factura 
where 
t1.segto = 'C1' and 
t1.ctepadre = '007' and 
t1.fechaprog between convert(datetime, @fecha_inicial, 121) and convert(datetime, @fecha_final, 121) and
t2.dest_det = 'AAA'
and isnumeric(replace(replace(t1.orden, ' ', ''), '"', '')) = 1

create index idx_temp_encabezado on #encabezado(sucursal, serie, factura)
create index idx_temp_encabezado1 on #encabezado(cliente)
create index idx_temp_encabezado2 on #encabezado(orden)
create index idx_temp_encabezado3 on #encabezado(fechaprog)
create index idx_temp_detalle on #detalle(sucursal, serie, factura, codigos)
create index idx_temp_detalle_codigos on #detalle(codigos)

select 
convert(varchar(9), right('000000000' + cuenta_estilo_ahorro, 9)) cuenta_estilo_ahorro,
hash_md5,
convert(int, orden) orden,
cod_barras,
case when sucursal=2 then 3 else sucursal end sucursal,
cuenta,
tipo_pedido,
codigo,
cant_ped,
precio_far,
importe_oferta,
importe_pronto_pago,
tipo_oferta,
convert(money, porcentaje_oferta/100) porcentaje_oferta,
arch_tandem,
status,
timestamp,
remisionado into #pedidos_spt_fahorro from pedidos_spt_fahorro with(nolock) where timestamp between dateadd(d, -3, convert(datetime, @fecha_inicial, 121)) and dateadd(d, 3, convert(datetime, @fecha_final, 121))




create index idx_temp_pedidos_spt_fahorro1 on #pedidos_spt_fahorro(orden)
create index idx_temp_pedidos_spt_fahorro2 on #pedidos_spt_fahorro(codigo)
create index idx_temp_pedidos_spt_fahorro3 on #pedidos_spt_fahorro(cuenta)
create index idx_temp_pedidos_spt_fahorro4 on #pedidos_spt_fahorro(sucursal)
create index idx_temp_pedidos_spt_fahorro5 on #pedidos_spt_fahorro(cuenta_estilo_ahorro)
create index idx_temp_pedidos_spt_fahorro6 on #pedidos_spt_fahorro(orden, codigo, cuenta, sucursal)

create table #ultimo_cambio_baan(codigo varchar(7) not null, prec_farm money, timestamp datetime)
insert into #ultimo_cambio_baan select t2.codigo, t2.prec_farm, max(t1.fecha_hora) fecha_hora from cambios_precio_baan t1 with(nolock) inner join capa_ibs.dbo.maestro_productos t2 with(nolock) on t1.t_item = t2.codigo group by t2.codigo, t2.prec_farm

create index idx_temp_ultimo_cambio_baan on #ultimo_cambio_baan(codigo)
CREATE TABLE #cursor(
cedis int,
sucursal int,
factura char(8),
cliente char(5),
porcentaje_iva money,
cuenta_estilo_ahorro varchar(10),
ruta char(3),
segto char(2),
ctepadre char(3),
rfc varchar(50),
farmacia char(39),
horacap datetime,
dueno char(30),
agente char(5),
controlador char(2),
domicilio char(40),
colonia char(23),
poblacion char(15),
codigos char(9),
descripcion varchar(30),
cod_barras varchar(13),
laboratorio varchar(16),
cant_real int,
cant_ped int,
cant_ped_fahorro int,
cant_dev int,
clas_fis char(2),
cant_base int,
cant_ofert int,
porcentaje money,
prec_pub money,
prec_farm money,
desc_base money,
def_iva money,
grupo_estadistico varchar(10),
desctoesp money,
orden int,
tipo_pedido varchar(1),
cuenta varchar(5),
nom_prod char(15),
remisionado tinyint,
tipo_reclamacion char(2),
porcentaje_fahorro money,
porcentaje_marzam money,
diferencia_porcentaje_oferta money,
tipo_oferta char(2),
ultimo_cambio_baan datetime,
ultimo_precio_notificado money,
ultima_oferta_notificada money,
prec_farm_marzam money,
prec_farm_fahorro money,
diferencia_precio money,
importe_bruto_marzam money,
importe_bruto_fahorro money,
diferencia_importe_bruto money,
importe_oferta_marzam money,
importe_oferta_fahorro money,
diferencia_importe_oferta money,
importe_desc_com_marzam money,
importe_desc_com_fahorro money,
dif_importe_desc_com money,
total_importe_neto_marzam money,
total_iva_neto_marzam money,
total_bonificacion_iva_marzam money,
total_marzam money,
importe_neto_fahorro money,
pronto_pago_unitario money,
iva_unitario money,
iva_neto_fahorro money,
total_fahorro money,
diferencia_totales money,
diferencia_importes_netos money,
status_pedsok char(2),
gestor_pedsok char(2),
costo_pedsok char(2),
oferta_pedsok char(2),
pronto_pago_pedsok char(2),
iva_neto_pedsok char(2),
neto_pedsok char(2),
monto_baan money,
tipo_pedido2 char(2),
fecha_movimiento char(2),
pzas_pedidook char(2),
status varchar(15),
cuenta_estilo_baan varchar(15),
bruto_menos_oferta_por_piezas money,
iva money,
descuento_comercial money,
bonificacion_del_iva money,
total2 money,
reingresada_almacen varchar(15)
) 

CREATE TABLE #facturacion_spt_fahorro(
	[cedis] [int] NOT NULL,
	[sucursal] [int] NOT NULL,
	[factura] [char](8) NOT NULL,
	[cliente] [char] (5) NOT NULL,
	[porcentaje_iva] money NOT NULL,
	[cuenta_estilo_ahorro] [varchar](10) NOT NULL,
	[ruta] [char](3) NULL,
	[segto] [char](2) NULL,
	[ctepadre] [char](3) NULL,
	[rfc] [varchar](50) NULL,
	[farmacia] [char](39) NULL,
	[horacap] [datetime] NULL,
	[dueno] [char](30) NULL,
	[agente] [char](5) NULL,
	[controlador] [char](2) NULL,
	[domicilio] [char](40) NULL,
	[colonia] [char](23) NULL,
	[poblacion] [char](15) NULL,
	[codigos] [char](9) NOT NULL,
	[descripcion] [varchar](30) NULL,
	[cod_barras] [varchar](13) NULL,
	[t_seak] [varchar](16) NULL,
	[cant_real] [int] NULL,
	[cant_ped] [int] NOT NULL,
	[cant_ped_fahorro] [int] NOT NULL,
	[cant_dev] [int] NULL,
	[clas_fis] [char](2) NULL,
	[cant_base] [int] NULL,
	[cant_ofert] [int] NULL,
	[porcentaje] [money] NULL,
	[prec_pub] [money] NULL,
	[prec_farm] [money] NULL,
	[desc_base] [money] NULL,
	[def_iva] [money] NULL,
	[grupo_estadistico] [varchar](10) NULL,
	[desctoesp] [money] NULL,
	[descto] [money] NULL,
	[prec_neto] [money] NULL,
	[total] [money] NULL,
	[orden] int NULL,
	[ahorrado_piezas] [money] NULL,
	[ahorrado_porcentaje] [money] NULL,
	[folio] [char](8) NULL,
	[fecha_fact] [datetime] NULL,
	[tipo_pedido] [varchar](1) NULL,
	[cliente_tranny] [varchar](5) NULL,
	[remisionado] [tinyint] NULL,
	[tipo_reclamacion] char(2) null,
	[porcentaje_fahorro] money,
	[porcentaje_marzam] money,
	[diferencia_porcentaje_oferta] money,
	[tipo_oferta] char(2),
	[ultimo_cambio_baan] datetime,
	[ultimo_precio_notificado] money,
	[ultima_oferta_notificada] money,
	[prec_farm_marzam] money,
	[prec_farm_fahorro] money,
	[diferencia_precio] money,
	[importe_bruto_marzam] money,
	[importe_bruto_fahorro] money,
	[diferencia_importe_bruto] money,
	[importe_oferta_marzam] money,
	[importe_oferta_fahorro] money,
	[diferencia_importe_oferta] money,
	[importe_desc_com_marzam] money,
	[importe_desc_com_fahorro] money,
	[dif_importe_desc_com] money,
	[total_importe_neto_marzam] money,
	[total_iva_neto_marzam] money,
	[total_bonificacion_iva_marzam] money,
	[total_marzam] money,
	[importe_neto_fahorro] money,
	[pronto_pago_unitario] money,
	[iva_unitario] money,
	[iva_neto_fahorro] money,
	[total_fahorro] money,
	[diferencia_totales] money,
	[diferencia_importes_netos] money,
	[status_pedsok] char(2), --vacia  
	[gestor_pedsok] char(2), --vacia  
	[costo_pedsok] char(2), --vacia  
	[oferta_pedsok] char(2), --vacia  
	[pronto_pago_pedsok] char(2), --vacia  
	[iva_neto_pedsok] char(2), --vacia  
	[neto_pedsok] char(2), --vacia  
	[monto_baan] money,
	[tipo_pedido2] char(2),
	[fecha_movimiento] char(2), --vacia  
	[pzas_pedidook] char(2), --vacia  
	[status] varchar(15),
	[cuenta_estilo_baan] varchar(15),
	[bruto_menos_oferta_por_piezas] money,
	[iva] money ,
	[descuento_comercial] money,
	[bonificacion_del_iva] money,
	[total2] money,
	[reingresada_almacen] varchar(15)
) 

select * into #historico_catalogos_spt_fahorro from historica.dbo.historico_catalogos_spt_fahorro where timestamp between dateadd(d, -3, convert(datetime, @fecha_inicial, 121)) and dateadd(d, 3, convert(datetime, @fecha_final, 121))
create index idx_temp_historico_catalogos_spt_fahorro on #historico_catalogos_spt_fahorro(cedis, cod_prov, timestamp)


insert into #cursor
select distinct
t7.cedis,
t8.sucursal, 
t1.factura, 
t1.cliente,
convert(int, t10.porcentaje_iva * 100),
t8.cuenta_estilo_ahorro, 
t1.ruta, 
t1.segto, 
t1.ctepadre, 
t6.rfc, 
t1.farmacia, 
t1.horacap, 
t1.dueno, 
t1.letradig + t1.restodig + t1.numdig agente, 
t1.control + t1.diapago controlador, 
t1.domicilio, 
t1.colonia, 
t1.poblacion, 
t2.codigos, 
t3.descripcion, 
t3.cod_barras, 
t3.lab_corto laboratorio, 
t2.cant_real, 
t2.cant_ped - isnull(t9.devfa_pzas_aceptadas, 0) cant_ped,
t2.cant_ped - isnull(t9.devfa_pzas_aceptadas, 0) cant_ped_fahorro,
isnull(t9.devfa_pzas_aceptadas, 0) cant_dev, 
t2.clas_fis, 
t2.cant_base, 
t2.cant_ofert, 
t2.porcentaje, 
t2.prec_pub, 
t2.prec_farm, 
convert(money, t2.desc_base)/10000 desc_base, 
t2.def_iva, 
t3.grupo_est grupo_estadistico, 
convert(money, t1.desctoesp) desctoesp, 
t1.orden,
t8.tipo_pedido, 
t8.cuenta,
t2.nom_prod,
t8.remisionado,
t9.devfa_tipo_reclamacion,
convert(money, t8.porcentaje_oferta) porcentaje_fahorro,
t2.porcentaje porcentaje_marzam,
convert(money, t8.porcentaje_oferta) - t2.porcentaje diferencia_porcentaje_oferta,
t8.tipo_oferta,
t16.timestamp ultimo_cambio_baan,
t14.prec_far ultimo_precio_notificado,  
t14.oferta ultima_oferta_notificada,
t2.prec_farm prec_farm_marzam,
t8.precio_far prec_farm_fahorro,
t2.prec_farm - t8.precio_far diferencia_precio,
t2.prec_farm importe_bruto_marzam,
t8.precio_far importe_bruto_fahorro,
t2.prec_farm - t8.precio_far diferencia_importe_bruto,
round(t2.prec_farm * t2.porcentaje, 2) importe_oferta_marzam,
t8.importe_oferta importe_oferta_fahorro,
round(t2.prec_farm * t2.porcentaje, 2) - t8.importe_oferta diferencia_importe_oferta,
round((t2.prec_farm - round(t2.prec_farm * t2.porcentaje, 2)) * t2.desc_base, 2) importe_desc_com_marzam,
t8.importe_pronto_pago importe_desc_com_fahorro,
round((t2.prec_farm - round(t2.prec_farm * t2.porcentaje, 2)) * (t2.desc_base), 2) - t8.importe_pronto_pago  dif_importe_desc_com,
round(round(round(t2.prec_farm * (1 - t2.porcentaje), 2) * (1 - t2.desc_base), 2) * (t2.cant_ped - isnull(t9.devfa_pzas_aceptadas, 0)), 2) total_importe_neto_marzam,
round(round(round(t2.prec_farm * (1 - t2.porcentaje), 2) * (1 - t2.desc_base), 2) * t2.def_iva * (t2.cant_ped - isnull(t9.devfa_pzas_aceptadas, 0)), 2) total_iva_neto_marzam,
case t3.clas_fis when 'BA' then round(round(round(t2.prec_farm * (1 - t2.porcentaje), 2) * (t2.desc_base), 2) * t2.def_iva * (t2.cant_ped - isnull(t9.devfa_pzas_aceptadas, 0)), 2) when 'HA' then round(round(round(t2.prec_farm * (1 - t2.porcentaje), 2) * (t2.desc_base), 2) * t2.def_iva * (t2.cant_ped - isnull(t9.devfa_pzas_aceptadas, 0)), 2) else 0 end total_bonificacion_iva_marzam,  
round(round(round(t2.prec_farm * (1 - t2.porcentaje), 2) * (1 - t2.desc_base), 2) * (t2.cant_ped - isnull(t9.devfa_pzas_aceptadas, 0)), 2) + round(round(round(t2.prec_farm * (1 - t2.porcentaje), 2) * (1 - t2.desc_base), 2) * t2.def_iva * (t2.cant_ped - isnull(t9.devfa_pzas_aceptadas, 0)), 2) total_marzam,  
(t8.precio_far - t8.importe_pronto_pago - t8.importe_oferta) * (t2.cant_ped - isnull(t9.devfa_pzas_aceptadas, 0)) importe_neto_fahorro,  
round(round(t2.prec_farm * (1 - t2.porcentaje), 2) * t2.desc_base, 2) pronto_pago_unitario,  
round(round(round(t2.prec_farm * (1 - t2.porcentaje), 2) * (1 - t2.desc_base), 2) * t2.def_iva, 2) iva_unitario,  
round(round(round(t2.prec_farm * (1 - t2.porcentaje), 2) * (1 - t2.desc_base), 2) * t2.def_iva, 2) * (t2.cant_ped - isnull(t9.devfa_pzas_aceptadas, 0)) iva_neto_fahorro,  
(t8.precio_far - t8.importe_pronto_pago - t8.importe_oferta) * (t2.cant_ped - isnull(t9.devfa_pzas_aceptadas, 0)) + (round(round(round(t2.prec_farm * (1 - t2.porcentaje), 2) * (1 - t2.desc_base), 2) * t2.def_iva, 2) * (t2.cant_ped - isnull(t9.devfa_pzas_aceptadas, 0))) total_fahorro, 
(round(round(round(t2.prec_farm * (1 - t2.porcentaje), 2) * (1 - t2.desc_base), 2) * (t2.cant_ped - isnull(t9.devfa_pzas_aceptadas, 0)), 2) + round(round(round(t2.prec_farm * (1 - t2.porcentaje), 2) * (1 - t2.desc_base), 2) * t2.def_iva * (t2.cant_ped - isnull(t9.devfa_pzas_aceptadas, 0)), 2)) - ((t8.precio_far - t8.importe_pronto_pago - t8.importe_oferta) * (t2.cant_ped - isnull(t9.devfa_pzas_aceptadas, 0)) + (round(round(round(t2.prec_farm * (1 - t2.porcentaje), 2) * (1 - t2.desc_base), 2) * t2.def_iva, 2) * (t2.cant_ped - isnull(t9.devfa_pzas_aceptadas, 0)))) diferencia_totales,  
(round(round(round(t2.prec_farm * (1 - t2.porcentaje), 2) * (1 - t2.desc_base), 2) * (t2.cant_ped - isnull(t9.devfa_pzas_aceptadas, 0)), 2))-((t8.precio_far - t8.importe_pronto_pago - t8.importe_oferta) * (t2.cant_ped - isnull(t9.devfa_pzas_aceptadas, 0))) diferencia_importes_netos,  
'' status_pedsok,  
'' gestor_pedsok,  
'' costo_pedsok,  
'' oferta_pedsok,  
'' pronto_pago_pedsok,  
'' iva_neto_pedsok,  
'' neto_pedsok,  
t12.monto monto_baan, 
t8.tipo_pedido,  
'' fecha_movimiento,   
'' pzas_pedidook,  
case isnumeric(t13.sucursal) when 0 then '' else 'cancelada' end as Status,  
t10.letra + t6.cliente cuenta_estilo_baan,  
case isnull(t9.devfa_tipo_reclamacion, '')   
when 'ND' then (t2.prec_farm - round(t2.prec_farm * t2.porcentaje, 2)) * isnull(t9.devfa_pzas_aceptadas, 0)  
when 'FA' then (t2.prec_farm - round(t2.prec_farm * t2.porcentaje, 2)) * isnull(t9.devfa_pzas_aceptadas, 0)  
when 'NC' then (round(round(round(t2.prec_farm * (1 - t2.porcentaje), 2) * (1 - t2.desc_base), 2) * (t2.cant_ped - isnull(t9.devfa_pzas_aceptadas, 0)), 2) + round(round(round(t2.prec_farm * (1 - t2.porcentaje), 2) * (1 - t2.desc_base), 2) * t2.def_iva * (t2.cant_ped - isnull(t9.devfa_pzas_aceptadas, 0)), 2)) - ((t8.precio_far - t8.importe_pronto_pago - t8.importe_oferta) * t2.cant_ped - isnull(t9.devfa_pzas_aceptadas, 0) + (round(round(round(t2.prec_farm * (1 - t2.porcentaje), 2) * (1 - t2.desc_base), 2) * t2.def_iva, 2) * t2.cant_ped - isnull(t9.devfa_pzas_aceptadas, 0)))  
when 'NS' then (t2.prec_farm - round(t2.prec_farm * t2.porcentaje, 2)) * isnull(t9.devfa_pzas_aceptadas, 0)  
else 0 end as bruto_menos_oferta_por_piezas, 
(case when t2.def_iva > 0 then (case isnull(t9.devfa_tipo_reclamacion, '')   
when 'ND' then (t2.prec_farm - round(t2.prec_farm * t2.porcentaje, 2)) * isnull(t9.devfa_pzas_aceptadas, 0)  
when 'FA' then (t2.prec_farm - round(t2.prec_farm * t2.porcentaje, 2)) * isnull(t9.devfa_pzas_aceptadas, 0)  
when 'NC' then 0  
when 'NS' then (t2.prec_farm - round(t2.prec_farm * t2.porcentaje, 2)) * isnull(t9.devfa_pzas_aceptadas, 0)  
else 0 end) * t2.def_iva else 0 end) as iva, 
case isnull(t9.devfa_tipo_reclamacion, '') when 'NC' then 0 else round((t2.prec_farm - round(t2.prec_farm * t2.porcentaje, 2)) * t2.desc_base, 2) * isnull(t9.devfa_pzas_aceptadas, 0) end as descuento_comercial, 
case isnull(t9.devfa_tipo_reclamacion, '') when 'NC' then 0 else case when ((t2.prec_farm - round(t2.prec_farm * t2.porcentaje, 2)) * isnull(t9.devfa_pzas_aceptadas, 0)) > 0 then round(round(round(t2.prec_farm * (1 - t2.porcentaje), 2) * (1 - t2.desc_base), 2) * t2.def_iva * t2.cant_real, 2) * t2.desc_base else 0 end end as bonificacion_del_iva,  



(
	(
	case isnull(t9.devfa_tipo_reclamacion, '')   
	when 'ND' then (t2.prec_farm - round(t2.prec_farm * t2.porcentaje, 2)) * isnull(t9.devfa_pzas_aceptadas, 0)  
	when 'FA' then (t2.prec_farm - round(t2.prec_farm * t2.porcentaje, 2)) * isnull(t9.devfa_pzas_aceptadas, 0)  
	when 'NC' then 
		case isnull(t9.devfa_tipo_reclamacion, '')   
		when 'ND' then (t2.prec_farm - round(t2.prec_farm * t2.porcentaje, 2)) * isnull(t9.devfa_pzas_aceptadas, 0)  
		when 'FA' then (t2.prec_farm - round(t2.prec_farm * t2.porcentaje, 2)) * isnull(t9.devfa_pzas_aceptadas, 0)  
		
		when 'NS' then (t2.prec_farm - round(t2.prec_farm * t2.porcentaje, 2)) * isnull(t9.devfa_pzas_aceptadas, 0)  
		else 0 end 
	when 'NS' then (t2.prec_farm - round(t2.prec_farm * t2.porcentaje, 2)) * isnull(t9.devfa_pzas_aceptadas, 0)  
	else 0 end
	) 
	+ 
	(
	case 
	when ((t2.prec_farm - round(t2.prec_farm * t2.porcentaje, 2)) * isnull(t9.devfa_pzas_aceptadas, 0)) > 0 then round(round(round(t2.prec_farm * (1 - t2.porcentaje), 2) * (1 - t2.desc_base), 2) * t2.def_iva * t2.cant_real, 2) * t2.desc_base 
	else 0 end
	)
	) - (round((t2.prec_farm - round(t2.prec_farm * t2.porcentaje, 2)) * t2.desc_base, 2) * isnull(t9.devfa_pzas_aceptadas, 0)) - (case when ((t2.prec_farm - round(t2.prec_farm * t2.porcentaje, 2)) * isnull(t9.devfa_pzas_aceptadas, 0)) > 0 then round(round(round(t2.prec_farm * (1 - t2.porcentaje), 2) * (1 - t2.desc_base), 2) * t2.def_iva * t2.cant_real, 2) * t2.desc_base else 0 end) total, 

/*

"((case isnull(t6.devfa_tipo_reclamacion, '') " + '\n' +  
"when 'ND' then (t1.prec_farm - round(t1.prec_farm * t1.porcentaje, 2)) * t1.cant_dev " + '\n' + 
"when 'FA' then (t1.prec_farm - round(t1.prec_farm * t1.porcentaje, 2)) * t1.cant_dev " + '\n' + 
"when 'NC' then " + 
"case isnull(t6.devfa_tipo_reclamacion, '') " + '\n' +  
"when 'ND' then (t1.prec_farm - round(t1.prec_farm * t1.porcentaje, 2)) * t1.cant_dev " + '\n' + 
"when 'FA' then (t1.prec_farm - round(t1.prec_farm * t1.porcentaje, 2)) * t1.cant_dev " + '\n' + 
"when 'NC' then (round(round(round(t1.prec_farm * (1 - t1.porcentaje), 2) * (1 - t1.desc_base), 2) * t1.cant_ped, 2) + round(round(round(t1.prec_farm * (1 - t1.porcentaje), 2) * (1 - t1.desc_base), 2) * t1.def_iva * t1.cant_ped, 2)) - ((t1.precio_far - t1.importe_pronto_pago - t1.importe_oferta) * t1.cant_ped + (round(round(round(t1.prec_farm * (1 - t1.porcentaje), 2) * (1 - t1.desc_base), 2) * t1.def_iva, 2) * t1.cant_ped)) " + '\n' + 
"when 'NS' then (t1.prec_farm - round(t1.prec_farm * t1.porcentaje, 2)) * t1.cant_dev " + '\n' + 
"else 0 end " + '\n' +
"when 'NS' then (t1.prec_farm - round(t1.prec_farm * t1.porcentaje, 2)) * t1.cant_dev " + '\n' + 
"else 0 end) + (case when ((t1.prec_farm - round(t1.prec_farm * t1.porcentaje, 2)) * t1.cant_dev) > 0 then round(round(round(t1.prec_farm * (1 - t1.porcentaje), 2) * (1 - t1.desc_base), 2) * t1.def_iva * t1.cant_real, 2) * t1.desc_base else 0 end)) - (round((t1.prec_farm - round(t1.prec_farm * t1.porcentaje, 2)) * t1.desc_base, 2) * t1.cant_dev) - (case when ((t1.prec_farm - round(t1.prec_farm * t1.porcentaje, 2)) * t1.cant_dev)                                     > 0 then round(round(round(t1.prec_farm * (1 - t1.porcentaje), 2) * (1 - t1.desc_base), 2) * t1.def_iva * t1.cant_real, 2) * t1.desc_base else 0 end) total, " + '\n' +

truncate table historica.dbo.historico_catalogos_spt_fahorro


select top 100 * from pedidos_spt_fahorro
select top 100 * from historica.dbo.historico_catalogos_spt_fahorro
*/
case isnull(t15.sucursal, '0') when '0' then ' '  else 'reingresada' end reingresada_almacen  
from  
#encabezado t1 inner join #detalle t2 on t1.sucursal = t2.sucursal and t1.serie = t2.serie and t1.factura = t2.factura  
inner join capa_ibs.dbo.maestro_productos t3 with(nolock) on  cast(t2.codigos as bigint) = cast(t3.codigo  as bigint)-- t2.codigos = t3.codigo  
left outer join clientes_baan t6 with(nolock) on t1.sucursal = t6.sucursal and t1.cliente = t6.cliente  
inner join #pedidos_spt_fahorro t8 on convert(int, t8.orden) = t1.orden and t8.codigo = right(t2.codigos, 7) and t1.cliente = t8.cuenta and t1.sucursal = t8.sucursal
inner join cat_cuentas_spt_fahorro t7 with(nolock) on t7.cuenta_estilo_ahorro = t8.cuenta_estilo_ahorro
left outer join devoluciones_spt_fahorro t9 with(nolock) on  case when t9.devfa_sucursal=2 then 3 else t9.devfa_sucursal end = t2.sucursal and  t9.devfa_folio_remision = t2.factura and t9.devfa_codigo = t2.codigos and t9.devfa_tipo_reclamacion not in ('CR', 'NC')
inner join sucursales t10 with(nolock) on t1.sucursal = t10.sucursal 
left outer join dbcopi t13 with(nolock) on t1.sucursal = t13.sucursal and t1.factura = t13.factura 
left outer join facturas_reingresadas_almacen t15 with(nolock) on t1.sucursal = t15.sucursal and t1.factura = t15.factura 
left outer join facturas_baan_spt_fahorro t12 with(nolock) on t1.sucursal = t12.sucursal and t1.factura = t12.factura 
left outer join #historico_catalogos_spt_fahorro t14 with(nolock) on t7.cedis = t14.cedis and t14.cod_prov = '00' + t2.codigos and convert(datetime, convert(varchar(10), t1.timestamp, 121), 121) = t14.timestamp
left outer join #ultimo_cambio_baan t16 on t2.codigos = t16.codigo
where 
t1.orden <> ''
order by 
t3.descripcion



declare mi_cursor cursor fast_forward for
select distinct
cedis,
sucursal,
factura,
cliente,
porcentaje_iva,
cuenta_estilo_ahorro,
ruta,
segto,
ctepadre,
rfc,
farmacia,
horacap,
dueno,
agente,
controlador,
domicilio,
colonia,
poblacion,
codigos,
descripcion,
cod_barras,
laboratorio,
cant_real,
cant_ped,
cant_ped_fahorro,
cant_dev,
clas_fis,
cant_base,
cant_ofert,
porcentaje,
prec_pub,
prec_farm,
desc_base,
def_iva,
grupo_estadistico,
desctoesp,
orden,
tipo_pedido,
cuenta,
nom_prod,
remisionado,
tipo_reclamacion,
porcentaje_fahorro,
porcentaje_marzam,
diferencia_porcentaje_oferta,
tipo_oferta,
ultimo_cambio_baan,
ultimo_precio_notificado,
ultima_oferta_notificada,
prec_farm_marzam,
prec_farm_fahorro,
diferencia_precio,
importe_bruto_marzam,
importe_bruto_fahorro,
diferencia_importe_bruto,
importe_oferta_marzam,
importe_oferta_fahorro,
diferencia_importe_oferta,
importe_desc_com_marzam,
importe_desc_com_fahorro,
dif_importe_desc_com,
total_importe_neto_marzam,
total_iva_neto_marzam,
total_bonificacion_iva_marzam,
total_marzam,
importe_neto_fahorro,
pronto_pago_unitario,
iva_unitario,
iva_neto_fahorro,
total_fahorro,
diferencia_totales,
diferencia_importes_netos,
status_pedsok,
gestor_pedsok,
costo_pedsok,
oferta_pedsok,
pronto_pago_pedsok,
iva_neto_pedsok,
neto_pedsok,
monto_baan,
tipo_pedido2,
fecha_movimiento,
pzas_pedidook,
status,
cuenta_estilo_baan,
bruto_menos_oferta_por_piezas,
iva,
descuento_comercial,
bonificacion_del_iva,
total2,
reingresada_almacen
from #cursor

open mi_cursor

fetch next from mi_cursor into  @cedis,
								@sucursal,
								@factura,
								@cliente,
								@porcentaje_iva,
								@cuenta_estilo_ahorro,
								@ruta,
								@segto,
								@ctepadre,
								@rfc,
								@farmacia,
								@horacap,
								@dueno,
								@agente,
								@controlador,
								@domicilio,
								@colonia,
								@poblacion,
								@codigos,
								@descripcion,
								@cod_barras,
								@laboratorio,
								@cant_real,
								@cant_ped,
								@cant_ped_fahorro,
								@cant_dev,
								@clas_fis,
								@cant_base,
								@cant_ofert,
								@porcentaje,
								@prec_pub,
								@prec_farm,
								@desc_base,
								@def_iva,
								@grupo_estadistico,
								@desctoesp,
								@orden,
								@tipo_pedido,
								@cuenta,
								@nom_prod,
								@remisionado,
								@tipo_reclamacion,
								@porcentaje_fahorro,
								@porcentaje_marzam,
								@diferencia_porcentaje_oferta,
								@tipo_oferta,
								@ultimo_cambio_baan,
								@ultimo_precio_notificado,
								@ultima_oferta_notificada,
								@prec_farm_marzam,
								@prec_farm_fahorro,
								@diferencia_precio,
								@importe_bruto_marzam,
								@importe_bruto_fahorro,
								@diferencia_importe_bruto,
								@importe_oferta_marzam,
								@importe_oferta_fahorro,
								@diferencia_importe_oferta,
								@importe_desc_com_marzam,
								@importe_desc_com_fahorro,
								@dif_importe_desc_com,
								@total_importe_neto_marzam,
								@total_iva_neto_marzam,
								@total_bonificacion_iva_marzam,
								@total_marzam,
								@importe_neto_fahorro,
								@pronto_pago_unitario,
								@iva_unitario,
								@iva_neto_fahorro,
								@total_fahorro,
								@diferencia_totales,
								@diferencia_importes_netos ,
								@status_pedsok,
								@gestor_pedsok,
								@costo_pedsok,
								@oferta_pedsok,
								@pronto_pago_pedsok,
								@iva_neto_pedsok ,
								@neto_pedsok,
								@monto_baan,
								@tipo_pedido2,
								@fecha_movimiento,
								@pzas_pedidook,
								@status,
								@cuenta_estilo_baan,
								@bruto_menos_oferta_por_piezas,
								@iva,
								@descuento_comercial,
								@bonificacion_del_iva,
								@total2,
								@reingresada_almacen

while @@fetch_status = 0 
begin

select @calculada_cant_base = @cant_base
select @calculada_cant_ofert = @cant_ofert
select @calculada_porcentaje = @porcentaje
select @calculada_desc_base = @desc_base

if @grupo_estadistico = 'PC01A'
begin
	select @calculada_prec_farm = dbo.fn_redondearas(@prec_farm + (@prec_farm * 0.50), 2)
	select @calculada_prec_pub = dbo.fn_redondearas(@prec_pub + (@prec_pub * 0.50), 2)
end
else
begin
	select @calculada_prec_farm = @prec_farm
	select @calculada_prec_pub = @prec_pub
end

select @calculada_precio1 = dbo.fn_redondearas(@calculada_prec_farm * (1 - @calculada_porcentaje), 2)
select @calculada_precio2 = dbo.fn_redondearas(@calculada_precio1 * (1 - @calculada_desc_base), 2)
select @calculada_iva_linea = dbo.fn_redondearas(@calculada_precio2 * @def_iva, 2)

select @calculada_descuento_linea = dbo.fn_redondearas(dbo.fn_redondearas(convert(decimal(20, 4), @calculada_prec_farm) * (1 - convert(decimal(20, 4), @calculada_porcentaje)), 2) * convert(decimal(20, 4), @calculada_desc_base), 2)
select @calculada_bruto_linea = dbo.fn_redondearas(@calculada_precio2 * @cant_ped, 2)
select @calculada_total = dbo.fn_redondearas(dbo.fn_redondearas(@calculada_prec_farm * (1 - @calculada_porcentaje), 2) * @cant_ped, 2)

if(@cant_base <> 0 and @cant_ofert <> 0)
begin
	select @calculada_ahorrado_piezas = (1 / (@cant_base + @cant_ofert)) * @cant_ped * @calculada_prec_farm
end
else				
begin					
	select @calculada_ahorrado_piezas = 0
end

if(@porcentaje <> 0)
	begin
		select @calculada_ahorrado_porcentaje = dbo.fn_redondearas(@calculada_prec_farm * @calculada_porcentaje, 2) * @cant_ped
	end
else			
	begin
		select @calculada_ahorrado_porcentaje = 0
	end

select @calculada_precio_neto = 0

insert into #facturacion_spt_fahorro(
cedis,
sucursal,
factura,
cliente,
porcentaje_iva,
cuenta_estilo_ahorro,
ruta,
segto,
ctepadre,
rfc,
farmacia,
horacap,
dueno,
agente,
controlador,
domicilio,
colonia,
poblacion,
codigos,
descripcion,
cod_barras,
t_seak,
cant_real,
cant_ped,
cant_ped_fahorro,
cant_dev,
clas_fis,
cant_base,
cant_ofert,
porcentaje,
prec_pub,
prec_farm,
desc_base,
def_iva,
grupo_estadistico,
desctoesp,
descto,
prec_neto,
total,
orden,
ahorrado_piezas,
ahorrado_porcentaje,
folio,
fecha_fact,
tipo_pedido,
cliente_tranny,
remisionado,
tipo_reclamacion,
porcentaje_fahorro,
porcentaje_marzam,
diferencia_porcentaje_oferta,
tipo_oferta,
ultimo_cambio_baan,
ultimo_precio_notificado,
ultima_oferta_notificada,
prec_farm_marzam,
prec_farm_fahorro,
diferencia_precio,
importe_bruto_marzam,
importe_bruto_fahorro,
diferencia_importe_bruto,
importe_oferta_marzam,
importe_oferta_fahorro,
diferencia_importe_oferta,
importe_desc_com_marzam,
importe_desc_com_fahorro,
dif_importe_desc_com,
total_importe_neto_marzam,
total_iva_neto_marzam,
total_bonificacion_iva_marzam,
total_marzam,
importe_neto_fahorro,
pronto_pago_unitario,
iva_unitario,
iva_neto_fahorro,
total_fahorro,
diferencia_totales,
diferencia_importes_netos ,
status_pedsok,
gestor_pedsok,
costo_pedsok,
oferta_pedsok,
pronto_pago_pedsok,
iva_neto_pedsok ,
neto_pedsok,
monto_baan,
tipo_pedido2,
fecha_movimiento,
pzas_pedidook,
status,
cuenta_estilo_baan,
bruto_menos_oferta_por_piezas,
iva,
descuento_comercial,
bonificacion_del_iva,
total2,
reingresada_almacen)
values(
@cedis,
@sucursal,
@factura,
@cliente,
@porcentaje_iva,
@cuenta_estilo_ahorro,
@ruta,
@segto,
@ctepadre,
@rfc,
@farmacia,
@horacap,
@dueno,
@agente,
@controlador,
@domicilio,
@colonia,
@poblacion,
@codigos,
@descripcion,
@cod_barras,
@laboratorio,
@cant_real,
@cant_ped,
@cant_ped_fahorro,
@cant_dev,
@clas_fis,
@cant_base,
@cant_ofert,
@porcentaje,
@prec_pub,
@prec_farm,
@desc_base,
@def_iva,
@grupo_estadistico,
@desctoesp,
@calculada_descuento_linea,
@calculada_precio_neto,
@calculada_total,
@orden,
@calculada_ahorrado_piezas,
@calculada_ahorrado_porcentaje,
0,
current_timestamp,
@tipo_pedido,
@cuenta,
@remisionado,
@tipo_reclamacion,
@porcentaje_fahorro,
@porcentaje_marzam,
@diferencia_porcentaje_oferta,
@tipo_oferta,
@ultimo_cambio_baan,
@ultimo_precio_notificado,
@ultima_oferta_notificada,
@prec_farm_marzam,
@prec_farm_fahorro,
@diferencia_precio,
@importe_bruto_marzam,
@importe_bruto_fahorro,
@diferencia_importe_bruto,
@importe_oferta_marzam,
@importe_oferta_fahorro,
@diferencia_importe_oferta,
@importe_desc_com_marzam,
@importe_desc_com_fahorro,
@dif_importe_desc_com,
@total_importe_neto_marzam,
@total_iva_neto_marzam,
@total_bonificacion_iva_marzam,
@total_marzam,
@importe_neto_fahorro,
@pronto_pago_unitario,
@iva_unitario,
@iva_neto_fahorro,
@total_fahorro,
@diferencia_totales,
@diferencia_importes_netos ,
@status_pedsok,
@gestor_pedsok,
@costo_pedsok,
@oferta_pedsok,
@pronto_pago_pedsok,
@iva_neto_pedsok ,
@neto_pedsok,
@monto_baan,
@tipo_pedido2,
@fecha_movimiento,
@pzas_pedidook,
@status,
@cuenta_estilo_baan,
@bruto_menos_oferta_por_piezas,
@iva,
@descuento_comercial,
@bonificacion_del_iva,
@total2,
@reingresada_almacen)

	
fetch next from mi_cursor into  @cedis,
								@sucursal,
								@factura,
								@cliente,
								@porcentaje_iva,
								@cuenta_estilo_ahorro,
								@ruta,
								@segto,
								@ctepadre,
								@rfc,
								@farmacia,
								@horacap,
								@dueno,
								@agente,
								@controlador,
								@domicilio,
								@colonia,
								@poblacion,
								@codigos,
								@descripcion,
								@cod_barras,
								@laboratorio,
								@cant_real,
								@cant_ped,
								@cant_ped_fahorro,
								@cant_dev,
								@clas_fis,
								@cant_base,
								@cant_ofert,
								@porcentaje,
								@prec_pub,
								@prec_farm,
								@desc_base,
								@def_iva,
								@grupo_estadistico,
								@desctoesp,
								@orden,
								@tipo_pedido,
								@cuenta,
								@nom_prod,
								@remisionado,
								@tipo_reclamacion,
								@porcentaje_fahorro,
								@porcentaje_marzam,
								@diferencia_porcentaje_oferta,
								@tipo_oferta,
								@ultimo_cambio_baan,
								@ultimo_precio_notificado,
								@ultima_oferta_notificada,
								@prec_farm_marzam,
								@prec_farm_fahorro,
								@diferencia_precio,
								@importe_bruto_marzam,
								@importe_bruto_fahorro,
								@diferencia_importe_bruto,
								@importe_oferta_marzam,
								@importe_oferta_fahorro,
								@diferencia_importe_oferta,
								@importe_desc_com_marzam,
								@importe_desc_com_fahorro,
								@dif_importe_desc_com,
								@total_importe_neto_marzam,
								@total_iva_neto_marzam,
								@total_bonificacion_iva_marzam,
								@total_marzam,
								@importe_neto_fahorro,
								@pronto_pago_unitario,
								@iva_unitario,
								@iva_neto_fahorro,
								@total_fahorro,
								@diferencia_totales,
								@diferencia_importes_netos ,
								@status_pedsok,
								@gestor_pedsok,
								@costo_pedsok,
								@oferta_pedsok,
								@pronto_pago_pedsok,
								@iva_neto_pedsok ,
								@neto_pedsok,
								@monto_baan,
								@tipo_pedido2,
								@fecha_movimiento,
								@pzas_pedidook,
								@status,
								@cuenta_estilo_baan,
								@bruto_menos_oferta_por_piezas,
								@iva,
								@descuento_comercial,
								@bonificacion_del_iva,
								@total2,
								@reingresada_almacen
end

close mi_cursor
deallocate mi_cursor


declare @periodoCiclo int

set @periodoCiclo=(SELECT id  FROM [monkeyland].[dbo].[periodos_facturacion_spt_fahorro] 
where convert(varchar,inicio,112)=replace(@fecha_inicial ,'-','') and convert(varchar,termino,112)=replace(@fecha_final,'-',''))

select distinct
cedis,
factura remision,
horacap fecha_remision,
cliente,
porcentaje_iva tasa_iva,
left(cuenta_estilo_ahorro, 7) sucursal_cte,
cuenta_estilo_ahorro cte_estilo_ahorro,
orden,
codigos codigo,
cod_barras,
descripcion,
clas_fis,
cant_ped,
cant_ped_fahorro,
cant_dev,
tipo_reclamacion,
porcentaje_fahorro,
porcentaje_marzam,
diferencia_porcentaje_oferta,
tipo_oferta,
ultimo_cambio_baan,
ultimo_precio_notificado,
ultima_oferta_notificada,
prec_farm_marzam,
prec_farm_fahorro,
diferencia_precio,
importe_bruto_marzam,
importe_bruto_fahorro,
diferencia_importe_bruto,
importe_oferta_marzam,
importe_oferta_fahorro,
diferencia_importe_oferta,
importe_desc_com_marzam,
importe_desc_com_fahorro,
dif_importe_desc_com,
total_importe_neto_marzam,
total_iva_neto_marzam,
total_bonificacion_iva_marzam,
total_marzam,
importe_neto_fahorro,
pronto_pago_unitario,
iva_unitario,
iva_neto_fahorro,
total_fahorro,
diferencia_totales,
diferencia_importes_netos,
status_pedsok,
gestor_pedsok,
costo_pedsok,
oferta_pedsok,
pronto_pago_pedsok,
iva_neto_pedsok,
neto_pedsok,
monto_baan,
tipo_pedido,
fecha_movimiento,
pzas_pedidook,
Status,
cuenta_estilo_baan,
bruto_menos_oferta_por_piezas,
iva,
descuento_comercial,
bonificacion_del_iva,
total2,
reingresada_almacen
--into facturacion_spt_fahorro
from #facturacion_spt_fahorro

--delete from historica..facturacion_spt_fahorroHistorico  where [idPeriodo]=@periodoCiclo

--insert into historica..facturacion_spt_fahorroHistorico 
--select * from #facturacion_spt_fahorro

drop table #facturacion_spt_fahorro

GO

