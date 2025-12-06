
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_importa_fact_elec_std_SAMAYOA]  
@fecha varchar(10)

WITH ENCRYPTION
as
set nocount on
declare @sucursal tinyint 
declare @cliente varchar(5) 
declare @digito_verificador varchar(1) 
declare @serie varchar(1) 
declare @factura varchar(8) 
declare @fecha_factura datetime 
declare @codigo varchar(7) 
declare @descripcion varchar(40) 
declare @cod_barras varchar(13) 
declare @clas_fis varchar(2) 
declare @piezas_surtidas_con_cargo int 
declare @piezas_surtidas_sin_cargo int 
declare @precio_farm_sin_imp money 
declare @precio_pub_sin_imp money 
declare @precio_pub_con_imp money 
declare @importe_bruto money 
declare @porcentaje_descto_oferta money 
declare @descto_oferta money 
declare @porcentaje_descto_comercial money 
declare @descto_comercial money 
declare @ieps money 
declare @iva money 
declare @bonificacion_iva money 
declare @porcentaje_utilidad money 
declare @importe_neto money 
declare @orden varchar(10) 
declare @porcentaje_iva money 
declare @filler varchar(5) 
declare @no_registro int 
declare @desc_comerc_prod money 
declare @porcentaje_iva2 money 
declare @iva2 money 
declare @bonificacion_iva2 money 
declare @porcentaje_ieps money 
declare @desc_comerc_ieps money 
declare @iva_del_iesps money 
declare @bonificacion_iva_del_iesps money 
declare @timestamp datetime 
declare @segto char(2) 
declare @ctepadre char(3) 
declare @rfc char(13) 
declare @tipo_documento varchar(1) 
declare @folio_fiscal varchar(8) 
declare @fecha_tandem smalldatetime
	

create table #fes(
sucursal tinyint,
cliente varchar(5),
digito_verificador char(1),
serie varchar(1),
factura char(8),
fecha_factura datetime,
codigo varchar(7),
descripcion varchar(30),
cod_barras varchar(13),
clas_fis char(2),
piezas_surtidas_con_cargo int,
piezas_surtidas_sin_cargo int,
precio_farm_sin_imp money,
precio_pub_sin_imp money,
precio_pub_con_imp money,
importe_bruto money,
porcentaje_descto_oferta money,
descto_oferta money,
porcentaje_descto_comercial money,
descto_comercial money,
ieps money,
iva money,
bonificacion_iva money,
porcentaje_utilidad money,
importe_neto money,
orden varchar(10),
porcentaje_iva money,
filler varchar(5),
no_registro int,
desc_comerc_prod money,
porcentaje_iva2 money,
iva2 money,
bonificacion_iva2 money,
porcentaje_ieps money,
desc_comerc_ieps money,
iva_del_iesps money,
bonificacion_iva_del_iesps money,
timestamp datetime,
segto char(2),
ctepadre char(3),
rfc varchar(50),
tipo_documento varchar(1),
folio_fiscal varchar(8),
fecha_tandem smalldatetime)

create clustered index tdx_tmp_fes on #fes(sucursal, cliente, factura, codigo)

insert into #fes
select 
t1.sucursal,
t1.cliente,
monkeyland.dbo.fn_digito_verificador(t1.cliente) digito_verificador,
t4.serie,
t1.factura,
convert(datetime, t1.fechaprog) fecha_factura,
right(t2.codigos, 7) codigo,
t3.descripcion,
right('0000000000000' + RTRIM(LTRIM(t3.cod_barras)), 13) ,
t2.clas_fis,
t2.cant_ped piezas_surtidas_con_cargo,
0 piezas_surtidas_sin_cargo,
t2.prec_farm precio_farm_sin_imp,
t2.prec_pub precio_pub_sin_imp,
t2.prec_pub * (1 + convert(money, convert(money, case isnumeric(def_iva) when 1 then def_iva else '0' end)/10000)) precio_pub_con_imp,
t2.prec_farm * t2.cant_ped importe_bruto,
convert(money, t2.porcentaje) / 100 porcentaje_descto_oferta,
dbo.fn_redondearas(convert(money, convert(money, t2.prec_farm * convert(money, convert(money, t2.porcentaje)/10000)) * t2.cant_ped), 2) descto_oferta,
convert(money, case isnumeric(t2.desc_base) when 1 then t2.desc_base else '0' end)/100  porcentaje_descto_comercial,
dbo.fn_redondearas((convert(money, t2.prec_farm * convert(money, convert(money, case isnumeric(t2.desc_base) when 1 then t2.desc_base else '0' end)/10000)) - (convert(money, t2.prec_farm * convert(money, convert(money, case isnumeric(t2.desc_base) when 1 then t2.desc_base else '0' end)/10000)) * convert(money, convert(money, case isnumeric(t2.porcentaje) when 1 then t2.porcentaje else '0' end)/10000))) * t2.cant_ped, 2) descto_comercial,
0 ieps,
dbo.fn_redondearas((t2.prec_farm - (t2.prec_farm * convert(money, case isnumeric(t2.porcentaje) when 1 then t2.porcentaje else '0' end)/10000)) * convert(money, case isnumeric(t2.def_iva) when 1 then t2.def_iva else '0' end)/10000 * t2.cant_ped, 2) iva,
dbo.fn_redondearas(((t2.prec_farm - 
(t2.prec_farm * convert(money, case isnumeric(t2.porcentaje) when 1 then t2.porcentaje else '0' end)/10000)) *
convert(money, case isnumeric(t2.def_iva) when 1 then t2.def_iva else '0' end)/10000) * 
convert(money, case isnumeric(t2.desc_base) when 1 then t2.desc_base else '0' end)/10000 * t2.cant_ped, 2) bonificacion_iva,
dbo.fn_redondearas(((t2.prec_pub - ((t2.prec_farm - convert(money, t2.prec_farm * convert(money, convert(money, case isnumeric(t2.porcentaje) when 1 then t2.porcentaje else '0' end)/10000)))))/t2.prec_pub)*100, 2)  porcentaje_utilidad,

dbo.fn_redondearas(((t2.prec_farm - (t2.prec_farm * convert(money, case isnumeric(t2.porcentaje) when 1 then t2.porcentaje else '0' end)/10000))
-
((t2.prec_farm - (t2.prec_farm * convert(money, case isnumeric(t2.porcentaje) when 1 then t2.porcentaje else '0' end)/10000))) * convert(money, case isnumeric(t2.desc_base) when 1 then t2.desc_base else '0' end)/10000
+
((t2.prec_farm - (t2.prec_farm * convert(money, case isnumeric(t2.porcentaje) when 1 then t2.porcentaje else '0' end)/10000)) * convert(money, t2.def_iva)/10000)
-
((t2.prec_farm - 
(t2.prec_farm * convert(money, case isnumeric(t2.porcentaje) when 1 then t2.porcentaje else '0' end)/10000)) *
convert(money, case isnumeric(t2.def_iva) when 1 then t2.def_iva else '0' end)/10000) * 
convert(money, case isnumeric(t2.desc_base) when 1 then t2.desc_base else '0' end)/10000) * t2.cant_ped, 2) importe_neto,
right(replace(t1.orden, ' ', ''), 10) orden,
convert(money, case isnumeric(t2.def_iva) when 1 then t2.def_iva else '0' end/100) porcentaje_iva,
'00000' filler,
0 no_registro,
dbo.fn_redondearas((convert(money, t2.prec_farm * convert(money, convert(money, case isnumeric(t2.desc_base) when 1 then t2.desc_base else '0' end)/10000)) - (convert(money, t2.prec_farm * convert(money, convert(money, case isnumeric(t2.desc_base) when 1 then t2.desc_base else '0' end)/10000)) * convert(money, convert(money, case isnumeric(t2.porcentaje) when 1 then t2.porcentaje else '0' end)/10000))) * t2.cant_ped, 2) desc_comerc_prod,
0 porcentaje_iva2,
0 iva2,
0 bonificacion_iva2,
0 porcentaje_ieps,
0 desc_comerc_ieps,
0 iva_del_iesps,
0 bonificacion_iva_del_iesps,
current_timestamp timestamp,
t1.segto,
t1.ctepadre,
left(t5.rfc + '             ', 13) rfc,
'R' tipo_documento,
t1.folio_fiscal,
t1.fecha_tandem
from 
historica.dbo.encabezado t1 with(nolock) inner join historica.dbo.detalle t2 with(nolock) on t1.sucursal = t2.sucursal and t1.serie = t2.serie and t1.factura = t2.factura and t2.dest_det = 'AAA'
inner join capa_ibs.dbo.maestro_productos t3 with(nolock) on t2.codigos = '00' + t3.codigo
inner join capa_ibs.dbo.sucursales t4 with(nolock) on t1.sucursal = t4.sucursal
inner join capa_ibs.dbo.clientes_baan t5 with(nolock) on t1.sucursal = t5.sucursal and t1.cliente = t5.cliente
where 
T1.SEGTO = 'C1' AND T1.CTEPADRE = '010' AND
t1.fechaprog = convert(datetime, @fecha, 121) 

insert into historica.dbo.fes_samayoa(sucursal,
cliente,
digito_verificador,
serie,
factura,
fecha_factura,
codigo,
descripcion,
cod_barras,
clas_fis,
piezas_surtidas_con_cargo,
piezas_surtidas_sin_cargo,
precio_farm_sin_imp,
precio_pub_sin_imp,
precio_pub_con_imp,
importe_bruto,
porcentaje_descto_oferta,
descto_oferta,
porcentaje_descto_comercial,
descto_comercial,
ieps,
iva,
bonificacion_iva,
porcentaje_utilidad,
importe_neto,
orden,
porcentaje_iva,
filler,
no_registro,
desc_comerc_prod,
porcentaje_iva2,
iva2,
bonificacion_iva2,
porcentaje_ieps,
desc_comerc_ieps,
iva_del_iesps,
bonificacion_iva_del_iesps,
timestamp,
segto,
ctepadre,
rfc,
tipo_documento,
folio_fiscal,
fecha_tandem)
select 
t1.sucursal,
t1.cliente,
t1.digito_verificador,
t1.serie,
t1.factura,
t1.fecha_factura,
t1.codigo,
t1.descripcion,
t1.cod_barras,
t1.clas_fis,
t1.piezas_surtidas_con_cargo,
t1.piezas_surtidas_sin_cargo,
t1.precio_farm_sin_imp,
t1.precio_pub_sin_imp,
t1.precio_pub_con_imp,
t1.importe_bruto,
t1.porcentaje_descto_oferta,
t1.descto_oferta,
t1.porcentaje_descto_comercial,
t1.descto_comercial,
t1.ieps,
t1.iva,
t1.bonificacion_iva,
t1.porcentaje_utilidad,
t1.importe_neto,
t1.orden,
t1.porcentaje_iva,
t1.filler,
t1.no_registro,
t1.desc_comerc_prod,
t1.porcentaje_iva2,
t1.iva2,
t1.bonificacion_iva2,
t1.porcentaje_ieps,
t1.desc_comerc_ieps,
t1.iva_del_iesps,
t1.bonificacion_iva_del_iesps,
t1.timestamp,
t1.segto,
t1.ctepadre,
t1.rfc,
t1.tipo_documento,
t1.folio_fiscal,
t1.fecha_tandem
from
#fes t1 with(nolock) left outer join historica.dbo.fes_samayoa t2 with(nolock) on t1.sucursal = t2.sucursal and t1.cliente = t2.cliente and t1.factura = t2.factura and t1.codigo = t2.codigo
where t2.factura is null 
GO
