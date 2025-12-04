

CREATE procedure [dbo].[usp_fahorro_migra_encabezado_detalle]
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

select * into #encabezado from encabezado where segto = 'C1' and ctepadre = '007' and fechaprog > dateadd(dd, -5, current_timestamp)
select t2.* into #detalle from encabezado t1 inner join detalle t2 on t1.sucursal = t2.sucursal and t1.factura = t2.factura where t1.fechaprog > dateadd(dd, -5, current_timestamp) and t1.segto = 'C1' and t1.ctepadre = '007'
create index idx_temp_encabezado on #encabezado(sucursal, factura, cliente, orden, segto, ctepadre, fechaprog)
create index idx_temp_detalle on #detalle(sucursal, factura)
create index idx_temp_detalle_dest_det on #detalle(dest_det)
create index idx_temp_detalle_codigos on #detalle(codigos)

update pedidos_spt_fahorro set remisionado = 0 where timestamp > DATEADD(DD, -10, CURRENT_TIMESTAMP)

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
	[remisionado] [tinyint] NULL
) 

declare mi_cursor cursor fast_forward for
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
replace(replace(t1.orden, ' ', ''), '"', '') orden,
t8.tipo_pedido, 
t8.cuenta,
t2.nom_prod,
t8.remisionado
from 
#encabezado t1 inner join #detalle t2 on t1.sucursal = t2.sucursal and t1.factura = t2.factura  
inner join maestro_productos_baan t3 on t2.codigos = '00' + t3.codigo  
left outer join clientes_baan t6 on t1.sucursal = t6.sucursal and t1.cliente = t6.cliente  
inner join pedidos_spt_fahorro t8 on t8.sucursal = t1.sucursal and  convert(int, replace(replace(t8.orden, ' ', ''), '"', '')) = convert(int, replace(replace(t1.orden, ' ', ''), '"', '')) and '00' + t8.codigo = t2.codigos and t1.cliente = t8.cuenta
left outer join devoluciones_spt_fahorro t9 on t9.devfa_sucursal = t2.sucursal and  t9.devfa_folio_remision = t2.factura and '00' + t9.devfa_codigo = t2.codigos and t9.devfa_tipo_reclamacion not in ('CR', 'NC') and t9.devfa_fecha_problema is null
inner join iva_sucursales t10 on t1.sucursal = t10.sucursal 
where 
convert(int, t3.codigo) < dbo.gobierno() and 
t8.remisionado = 0 and 
t2.dest_det = 'AAA' and 
t1.orden <> ''
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
								@remisionado

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
--select @calculada_descuento_linea = dbo.fn_redondearas(@calculada_precio1 * @calculada_desc_base, 2)
--select @calculada_descuento_linea = dbo.fn_redondearas((@calculada_prec_farm * @calculada_desc_base) * (1 - @calculada_porcentaje), 2)
select @calculada_descuento_linea = dbo.fn_redondearas(dbo.fn_redondearas(convert(decimal(20, 4), @calculada_prec_farm) * (1 - convert(decimal(20, 4), @calculada_porcentaje)), 2) * convert(decimal(20, 4), @calculada_desc_base), 2)
select @calculada_bruto_linea = dbo.fn_redondearas(@calculada_precio2 * @cant_ped, 2)
select @calculada_total = @calculada_prec_farm * (1 - @calculada_porcentaje) * @cant_ped

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
		select @calculada_ahorrado_porcentaje = dbo.fn_redondearas(@calculada_prec_farm * @calculada_porcentaje, 2)
	end
else			
	begin
		select @calculada_ahorrado_porcentaje = 0
	end

select @calculada_precio_neto = 0

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
remisionado)
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
@remisionado)

	
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
								@remisionado
end

close mi_cursor
deallocate mi_cursor

select 
convert(varchar(12), convert(int, orden)) + '_' + cuenta_estilo_ahorro + '.fac' archivo, 
right('000000000' + cuenta_estilo_ahorro, 9) + ' ' +
right('00000000' + orden, 8) + '  ' +
factura + 
replace(convert(varchar(10), horacap, 104), '.', '') +
replace(convert(varchar(10), horacap, 104), '.', '') +
cod_barras +
right('000000' + convert(varchar(6), cant_ped), 6) +
right('0000000000' + convert(varchar(10), prec_farm), 10) +  
right('0000000000' + convert(varchar(10), convert(money, ahorrado_porcentaje)), 10) +
right('0000000000' + convert(varchar(10), convert(money, dbo.fn_redondearas(descto, 2))), 10) +    
right('0000000000' + convert(varchar(10), convert(money, dbo.fn_redondearas(dbo.fn_redondearas(dbo.fn_redondearas(prec_farm * (1 - porcentaje), 2) * (1 - desc_base), 2) * def_iva, 2))), 10) detalle
from
#facturacion_spt_fahorro
order by
orden,
cuenta_estilo_ahorro,
cod_barras

drop table #encabezado
drop table #detalle
drop table #facturacion_spt_fahorro

GO

