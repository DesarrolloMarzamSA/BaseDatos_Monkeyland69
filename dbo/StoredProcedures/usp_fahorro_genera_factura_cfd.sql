--select * from historica.dbo.encabezado where sucursal = 9 and factura = '00038403' and cliente = '05617'
--drop table perro
--exec [usp_fahorro_genera_factura_cfd] '2017-10-30', '2017-11-19', 0.16, 250
--select top 100 * from facturacion_cfd_spt_fahorro
CREATE procedure [dbo].[usp_fahorro_genera_factura_cfd] @fecha_inicial varchar(10), @fecha_final varchar(10), @iva_facturota money, @facturota int
as
set nocount on
declare @sucursal int 
declare @factura char(8)  
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
declare @desctoesp char(5) 
declare @orden varchar(30) 
declare @tipo_pedido varchar(1) 
declare @cuenta varchar(5) 
declare @nom_prod char(15) 
declare @remisionado tinyint
declare @ieps money
declare @ivaieps money
declare @ieps_porcentaje money


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

/*
drop table #encabezado
drop table #detalle

declare @fecha_inicial varchar(10)
declare @fecha_final varchar(10)
declare @iva_facturota money

select @fecha_inicial = '2010-04-21'
select @fecha_final = '2010-04-27'
select @iva_facturota= 0.16

select t1.* into #encabezado from encabezado t1 inner join sucursales t2 on t1.sucursal = t2.sucursal 
where 
t2.porcentaje_iva = @iva_facturota and t1.segto = 'C1' and t1.ctepadre = '007' and 
(t1.fechaprog between convert(datetime, @fecha_inicial, 121) and convert(datetime, @fecha_final, 121) or (t1.factura in (select factura from excepciones_spt_fahorro where incluir = 1))) and
t1.factura not in (select factura from excepciones_spt_fahorro where incluir = 0)

select t2.* into #detalle from encabezado t1 inner join detalle t2 on t1.sucursal = t2.sucursal and t1.factura = t2.factura inner join sucursales t3 on t1.sucursal = t3.sucursal where t3.porcentaje_iva = @iva_facturota and t1.segto = 'C1' and t1.ctepadre = '007' and
(t1.fechaprog between convert(datetime, @fecha_inicial, 121) and convert(datetime, @fecha_final, 121) or (t1.factura in (select factura from excepciones_spt_fahorro where incluir = 1))) and
t1.factura not in (select factura from excepciones_spt_fahorro where incluir = 0)

create index idx_temp_encabezado on #encabezado(sucursal, factura, cliente, orden, segto, ctepadre, fechaprog)
create index idx_temp_detalle on #detalle(sucursal, factura)
create index idx_temp_detalle_dest_det on #detalle(dest_det)
create index idx_temp_detalle_codigos on #detalle(codigos)
*/

select distinct
case when t1.sucursal=2 then 3 else t1.sucursal end as sucursal,
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
t1.horacap,
t1.hojordsur,
t1.hojfactura,
t1.tipfac,
t1.bulto,
t1.producee0,
t1.renglonee0,
t1.importe,
t1.controlado,
t1.desctoesp,
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
t1.orden,
t1.fianza,
t1.fechaalta,
t1.noalta,
t1.segto,
t1.ctepadre,
t1.filler,
t1.timestamp,
t1.folio_fiscal,
t1.fecha_tandem
into #encabezado from historica.dbo.encabezado t1 with(nolock) inner join sucursales t2 with(nolock) on t1.sucursal = t2.sucursal 
where 
t2.porcentaje_iva = @iva_facturota and t1.segto = 'C1' and t1.ctepadre = '007' and 
(t1.fechaprog between convert(datetime, @fecha_inicial, 121) and convert(datetime, @fecha_final, 121) or (t1.factura in (select factura from excepciones_spt_fahorro where incluir = 1))) and
t1.factura not in (select factura from excepciones_spt_fahorro where incluir = 0) and
isnumeric(t1.orden) = 1

select distinct
case when t2.sucursal=2 then 3 else t2.sucursal end as sucursal,
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
t2.timestamp,
t2.ISSRPR as ieps,	
t2.ISSRAR as ivaieps,	
t2.RMPESI AS ieps_porcentaje
into #detalle from historica.dbo.encabezado t1 with(nolock) inner join historica.dbo.detalle t2 with(nolock) on t1.sucursal = t2.sucursal and t1.serie = t2.serie and t1.factura = t2.factura inner join sucursales t3 on t1.sucursal = t3.sucursal where t3.porcentaje_iva = @iva_facturota and t1.segto = 'C1' and t1.ctepadre = '007' and
(t1.fechaprog between convert(datetime, @fecha_inicial, 121) and convert(datetime, @fecha_final, 121) or (t1.factura in (select factura from excepciones_spt_fahorro where incluir = 1))) and
t1.factura not in (select factura from excepciones_spt_fahorro where incluir = 0)

create index idx_temp_encabezado on #encabezado(sucursal, factura, cliente, orden, segto, ctepadre, fechaprog)
create index idx_temp_detalle on #detalle(sucursal, factura)
create index idx_temp_detalle_dest_det on #detalle(dest_det)
create index idx_temp_detalle_codigos on #detalle(codigos)

--delete from #detalle where sucursal = 13 and factura = '00034733' and codigos = '001472902' and cant_ped = 4
--delete from #detalle where sucursal = 13 and factura = '00034743' and codigos = '000624001' and cant_ped = 1

--delete from #encabezado where sucursal = 9 and factura = '00038403' and cliente = '05617'
--delete from #detalle where sucursal = 9 and factura = '00038403'  and codigos in ('002846004','002973101')


--delete from #encabezado where sucursal = 4 and factura = '02624782' and cliente = '87584'
--delete from #detalle where sucursal = 4 and factura = '02624782'  and codigos in ('000526801', '000965702', '002713002', '002913202')


CREATE TABLE #facturacion_spt_fahorro(
	[sucursal] [int] NOT NULL,
	[factura] [char](8) NOT NULL,
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
	[cant_real] [smallint] NULL,
	[cant_ped] [smallint] NOT NULL,
	[cant_dev] [smallint] NULL,
	[clas_fis] [char](2) NULL,
	[cant_base] [smallint] NULL,
	[cant_ofert] [smallint] NULL,
	[porcentaje] [money] NULL,
	[prec_pub] [money] NULL,
	[prec_farm] [money] NULL,
	[desc_base] [money] NULL,
	[def_iva] [money] NULL,
	[grupo_estadistico] [varchar](10) NULL,
	[desctoesp] [char](5) NULL,
	[descto] [money] NULL,
	[prec_neto] [money] NULL,
	[total] [money] NULL,
	[orden] [varchar](8) NULL,
	[ahorrado_piezas] [money] NULL,
	[ahorrado_porcentaje] [money] NULL,
	[folio] [char](8) NULL,
	[fecha_fact] [datetime] NULL,
	[tipo_pedido] [varchar](1) NULL,
	[cliente_tranny] [varchar](5) NULL,
	[remisionado] [tinyint] NULL,
	[ieps]  [money] NULL,
	[ivaieps]  [money] NULL,
	[ieps_porcentaje] [money] NULL
) 

/*

select top 100 * from pedidos_spt_fahorro order by timestamp asc
where timestamp between convert(datetime, '2010-03-24', 121) and convert(datetime, '2010-03-30', 121)
drop table #encabezado
drop table #detalle

declare @fecha_inicial varchar(10)
declare @fecha_final varchar(10)
declare @iva_facturota money

select @fecha_inicial = '2010-04-21'
select @fecha_final = '2010-04-27'
select @iva_facturota= 0.16

select t1.* into #encabezado from encabezado t1 inner join sucursales t2 on t1.sucursal = t2.sucursal 
where 
t2.porcentaje_iva = @iva_facturota and t1.segto = 'C1' and t1.ctepadre = '007' and 
(t1.fechaprog between convert(datetime, @fecha_inicial, 121) and convert(datetime, @fecha_final, 121) or (t1.factura in (select factura from excepciones_spt_fahorro where incluir = 1))) and
t1.factura not in (select factura from excepciones_spt_fahorro where incluir = 0)

select t2.* into #detalle from encabezado t1 inner join detalle t2 on t1.sucursal = t2.sucursal and t1.factura = t2.factura inner join sucursales t3 on t1.sucursal = t3.sucursal where t3.porcentaje_iva = @iva_facturota and t1.segto = 'C1' and t1.ctepadre = '007' and
(t1.fechaprog between convert(datetime, @fecha_inicial, 121) and convert(datetime, @fecha_final, 121) or (t1.factura in (select factura from excepciones_spt_fahorro where incluir = 1))) and
t1.factura not in (select factura from excepciones_spt_fahorro where incluir = 0)

create index idx_temp_encabezado on #encabezado(sucursal, factura, cliente, orden, segto, ctepadre, fechaprog)
create index idx_temp_detalle on #detalle(sucursal, factura)
create index idx_temp_detalle_dest_det on #detalle(dest_det)
create index idx_temp_detalle_codigos on #detalle(codigos)

select 
t8.sucursal, 
t1.factura, 
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
sum(t2.cant_ped - isnull(t9.devfa_piezas_teorico, 0)) cant_ped,
sum(isnull(t9.devfa_pzas_aceptadas, 0)) cant_dev, 
t2.clas_fis, 
t2.cant_base, 
t2.cant_ofert, 
convert(money, t2.porcentaje)/10000 porcentaje, 
t2.prec_pub, 
t2.prec_farm, 
convert(money, t2.desc_base)/10000 desc_base, 
convert(money, t2.def_iva)/10000 def_iva, 
t3.grupo_est grupo_estadistico, 
t1.desctoesp, 
replace(replace(t1.orden, ' ', ''), '"', '') orden,
t8.tipo_pedido, 
t8.cuenta,
t2.nom_prod,
t8.remisionado
from 
#encabezado t1 inner join #detalle t2 on t1.sucursal = t2.sucursal and t1.factura = t2.factura  
inner join maestro_productos t3 on t2.codigos = '00' + t3.codigo  
left outer join clientes_baan t6 on t1.sucursal = t6.sucursal and t1.cliente = t6.cliente  
--inner join cat_cuentas_spt_fahorro t7 on t1.sucursal = t7.sucursal_remision and t1.cliente =  t7.cuenta_remision
inner join pedidos_spt_fahorro t8 on convert(int, replace(replace(t8.orden, ' ', ''), '"', '')) = convert(int, replace(replace(t1.orden, ' ', ''), '"', '')) and '00' + t8.codigo = t2.codigos and t1.cliente = t8.cuenta and t1.sucursal = t8.sucursal
left outer join devoluciones_spt_fahorro t9 on t9.devfa_sucursal = t2.sucursal and  t9.devfa_folio_remision = t2.factura and '00' + t9.devfa_codigo = t2.codigos and t9.devfa_tipo_reclamacion not in ('CR', 'NC') and t9.devfa_fecha_problema is null
inner join sucursales t10 on t1.sucursal = t10.sucursal 
where 
convert(int, t3.codigo) < dbo.gobierno() and 
t2.dest_det = 'AAA' and 
t1.orden <> '' and
t10.porcentaje_iva = 0.16
group by 
t8.sucursal, 
t1.factura, 
t8.cuenta_estilo_ahorro, 
t1.ruta, 
t1.segto, 
t1.ctepadre, 
t6.rfc, 
t1.farmacia, 
t1.horacap, 
t1.dueno, 
t1.letradig + t1.restodig + t1.numdig, 
t1.control + t1.diapago, 
t1.domicilio, 
t1.colonia, 
t1.poblacion, 
t2.codigos, 
t3.descripcion, 
t3.cod_barras, 
t3.lab_corto, 
t2.cant_real, 
t2.clas_fis, 
t2.cant_base, 
t2.cant_ofert, 
convert(money, t2.porcentaje)/10000, 
t2.prec_pub, 
t2.prec_farm, 
convert(money, t2.desc_base)/10000, 
convert(money, t2.def_iva)/10000, 
t3.grupo_est, 
t1.desctoesp, 
replace(replace(t1.orden, ' ', ''), '"', ''),
t8.tipo_pedido, 
t8.cuenta,
t2.nom_prod,
t8.remisionado
order by 
t2.nom_prod
*/

declare mi_cursor cursor fast_forward for
select 
t8.sucursal, 
t1.factura, 
right('000000000' + t8.cuenta_estilo_ahorro, 9) cuenta_estilo_ahorro, 
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
sum(t2.cant_ped - isnull(t9.devfa_piezas_teorico, 0)) cant_ped,
sum(isnull(t9.devfa_piezas_teorico, 0)) cant_dev, 
t2.clas_fis, 
t2.cant_base, 
t2.cant_ofert, 
convert(money, t2.porcentaje)/10000 porcentaje, 
t2.prec_pub, 
t2.prec_farm, 
convert(money, t2.desc_base)/10000 desc_base, 
convert(money, t2.def_iva)/10000 def_iva, 
t3.grupo_est grupo_estadistico, 
t1.desctoesp, 
right(replace(replace(t1.orden, ' ', ''), '"', ''), 8) orden,
t8.tipo_pedido, 
t8.cuenta,
t2.nom_prod,
t8.remisionado,
t2.ieps,
t2.ivaieps,
t2.ieps_porcentaje
from 
#encabezado t1 inner join #detalle t2 on t1.sucursal = t2.sucursal and t1.factura = t2.factura  
inner join capa_ibs.dbo.maestro_productos t3 with(nolock) on t2.codigos = '00' + t3.codigo  
left outer join clientes_baan t6 with(nolock) on t1.sucursal = t6.sucursal and t1.cliente = t6.cliente  
--inner join cat_cuentas_spt_fahorro t7 on t1.sucursal = t7.sucursal_remision and t1.cliente =  t7.cuenta_remision
inner join pedidos_spt_fahorro t8 with(nolock) on convert(int, replace(replace(t8.orden, ' ', ''), '"', '')) = convert(int, replace(replace(t1.orden, ' ', ''), '"', '')) and '00' + t8.codigo = t2.codigos and t1.cliente = t8.cuenta and  t1.sucursal  = case when t8.sucursal=2 then 3 else t8.sucursal end
left outer join devoluciones_spt_fahorro t9 with(nolock) on case when t9.devfa_sucursal=2 then 3 else t9.devfa_sucursal end  = t2.sucursal and  t9.devfa_folio_remision = t2.factura and '00' + t9.devfa_codigo = t2.codigos and t9.devfa_tipo_reclamacion not in ('CR', 'NC')
inner join sucursales t10 with(nolock) on t1.sucursal = t10.sucursal 
where 
convert(int, t3.codigo) < dbo.gobierno() and 
t2.dest_det = 'AAA' and 
t1.orden <> '' and
t10.porcentaje_iva = @iva_facturota and
t8.tipo_pedido = 'N'
group by 
t8.sucursal, 
t1.factura, 
right('000000000' + t8.cuenta_estilo_ahorro, 9), 
t1.ruta, 
t1.segto, 
t1.ctepadre, 
t6.rfc, 
t1.farmacia, 
t1.horacap, 
t1.dueno, 
t1.letradig + t1.restodig + t1.numdig, 
t1.control + t1.diapago, 
t1.domicilio, 
t1.colonia, 
t1.poblacion, 
t2.codigos, 
t3.descripcion, 
t3.cod_barras, 
t3.lab_corto, 
t2.cant_real, 
t2.clas_fis, 
t2.cant_base, 
t2.cant_ofert, 
convert(money, t2.porcentaje)/10000, 
t2.prec_pub, 
t2.prec_farm, 
convert(money, t2.desc_base)/10000, 
convert(money, t2.def_iva)/10000, 
t3.grupo_est, 
t1.desctoesp, 
right(replace(replace(t1.orden, ' ', ''), '"', ''), 8),
t8.tipo_pedido, 
t8.cuenta,
t2.nom_prod,
t8.remisionado,
t2.ieps,
t2.ivaieps,
t2.ieps_porcentaje
order by 
t2.nom_prod

open mi_cursor

fetch next from mi_cursor into  @sucursal,
								@factura,
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
								@ieps,
								@ivaieps,
								@ieps_porcentaje

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
print(@factura+' '+@cuenta_estilo_ahorro)
insert into #facturacion_spt_fahorro(
sucursal,
factura,
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
ieps,
ivaieps,
ieps_porcentaje)
values(
@sucursal,
@factura,
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
@ieps,
@ivaieps,
@ieps_porcentaje)

	
fetch next from mi_cursor into  @sucursal,
								@factura,
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
								@ieps,
								@ivaieps,
								@ieps_porcentaje
end

close mi_cursor
deallocate mi_cursor

truncate table facturacion_cfd_spt_fahorro

insert into facturacion_cfd_spt_fahorro select * from #facturacion_spt_fahorro



declare @iva_graba_historia int
select @iva_graba_historia = convert(int, @iva_facturota * 100)

exec usp_graba_historia_cfd_spt_fahorro @facturota , @iva_graba_historia


/*

delete from historica.dbo.facturas_spt_fahorro where facturota = 154 and iva = 16
select * from chimpmaster.dbo.facturas_spt_fahorro where iva = 15 and facturota = '152'
select * from monkeyland.dbo.facturacion_cfd_spt_fahorro 

select * from encabezado where sucursal = 01 and factura = '08460677' 55300


select * from pedidos_spt_fahorro where timestamp between convert(datetime, '2010-04-21', 121) and convert(datetime, '2010-04-28', 121)
select * from chimpmaster.dbo.pedidos_spt_fahorro where sucursal = 1 and orden = '10538'

select * from pedidos_spt_fahorro where cuenta in ('55300', '51570') and orden = '10538'
update pedidos_spt_fahorro set cuenta_estilo_ahorro = right('000000000' + cuenta_estilo_ahorro, 9)

select * from cat_cuentas_spt_fahorro where cuenta_remision = '55300'





select * from monkeyland.dbo.facturacion_cfd_spt_fahorro  where sucursal = 1 and factura = '08430425' and codigos = '001116000'
select * from chimpmaster.dbo.facturas_spt_fahorro where sucursal = 1 and factura = '08430425' 

select * from cat_cuentas_spt_fahorro where cuenta_estilo_ahorro = '0150960-4'
select * from pedidos_spt_fahorro where sucursal = 1 and cuenta in ('55120', '50960') and orden = '14061'
select * from pedidos_spt_fahorro where timestamp between convert(datetime, '2010-04-10 01:00:00.920', 121) and convert(datetime, '2010-04-10 23:59:59.999', 121)
select count(*) from chimpmaster.dbo.pedidos_spt_fahorro where fecha < convert(datetime, '2010-06-01', 121)
select  from monkeyland.dbo.pedidos_spt_fahorro where timestamp < convert(datetime, '2010-06-01', 121)


select * from cat_cuentas_spt_fahorro where cuenta_remision = '55120'

select count(*) from chimpmaster.dbo.devoluciones_spt_fahorro
select count(*) from monkeyland.dbo.devoluciones_spt_fahorro

insert into monkeyland.dbo.devoluciones_spt_fahorro(
devfa_sucursal,
devfa_fecha_problema,
devfa_folio_remision,
devfa_codigo,
devfa_estatus,
devfa_num_cuenta,
devfa_pedido,
devfa_remision,
devfa_tipo_reclamacion,
devfa_codigo_barras,
devfa_piezas_teorico,
devfa_importe_farmacia,
devfa_importe_oferta,
devfa_importe_descto_com,
devfa_iva_total,
devfa_gestor,
devfa_autorizacion,
devfa_num_movimiento,
devfa_fecha_interfase,
devfa_filler2,
devfa_fecha_factura,
devfa_fecha_recepcion,
devfa_fecha_nota,
devfa_folio_devol,
devfa_pzas_vendidas,
devfa_pzas_aceptadas,
devfa_pzas_malestado,
devfa_pzas_sobrantes,
devfa_precio_costo,
devfa_precio_farmacia,
devfa_descto_comer_cte,
devfa_pzas_oferta,
devfa_cantidad_base,
devfa_cantidad_oferta,
devfa_porcentaje_oferta,
devfa_importe_devol_real,
devfa_importe_oferta_real,
devfa_importe_descto_com_real,
devfa_clasif_fiscal,
devfa_descto_comer_prod,
devfa_importe_iva,
devfa_importe_neto,
devfa_fecha_interfase_real,
devfa_cant_faltante_fact,
devfa_importe_folio_fact,
devfa_filler1)
select 
devfa_sucursal,
devfa_fecha_problema,
devfa_folio_remision,
devfa_codigo,
devfa_estatus,
devfa_num_cuenta,
devfa_pedido,
devfa_remision,
devfa_tipo_reclamacion,
devfa_codigo_barras,
devfa_piezas_teorico,
devfa_importe_farmacia,
devfa_importe_oferta,
devfa_importe_descto_com,
devfa_iva_total,
devfa_gestor,
devfa_autorizacion,
devfa_num_movimiento,
devfa_fecha_interfase,
devfa_filler2,
devfa_fecha_factura,
devfa_fecha_recepcion,
devfa_fecha_nota,
devfa_folio_devol,
devfa_pzas_vendidas,
devfa_pzas_aceptadas,
devfa_pzas_malestado,
devfa_pzas_sobrantes,
devfa_precio_costo,
devfa_precio_farmacia,
devfa_descto_comer_cte,
devfa_pzas_oferta,
devfa_cantidad_base,
devfa_cantidad_oferta,
devfa_porcentaje_oferta,
devfa_importe_devol_real,
devfa_importe_oferta_real,
devfa_importe_descto_com_real,
devfa_clasif_fiscal,
devfa_descto_comer_prod,
devfa_importe_iva,
devfa_importe_neto,
devfa_fecha_interfase_real,
devfa_cant_faltante_fact,
devfa_importe_folio_fact,
devfa_filler1
from chimpmaster.dbo.devoluciones_spt_fahorro

select * from excepciones_spt_fahorro




select * from historica.dbo.facturas_spt_fahorro where iva = 15 and facturota = 154
select * from historica.dbo.facturas_spt_fahorro where iva = 16 and facturota = 154
*/

GO

