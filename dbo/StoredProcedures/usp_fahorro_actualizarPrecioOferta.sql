-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [usp_fahorro_actualizarPrecioOferta] @idperiodo int=0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

  drop table #pedidos_spt_fahorro
select distinct
convert(varchar(9), right('000000000' + cuenta_estilo_ahorro, 9)) cuenta_estilo_ahorro,
hash_md5,
convert(int, orden) orden,
cod_barras,
p.sucursal,
cuenta,
tipo_pedido,
codigo,
cant_ped,
precio_far,
importe_oferta,
importe_pronto_pago,
tipo_oferta,
porcentaje_oferta,
arch_tandem,
status,
timestamp,
remisionado into #pedidos_spt_fahorro 
from detalle_fahorroFacturas dff 
inner join pedidos_spt_fahorro p on 
cast(isnull(dff.ihoref,'0') as int) = convert(int, replace(replace(p.orden, ' ', ''), '"', '')) 
and dff.idprdc = p.codigo and substring(dff.idcuno,2,5) = p.cuenta
where dff.[PERIODO]=@idperiodo


--recalculo = 3,4 por precio

update  dff set 
   dff.PRECIO_CANTIDAD =  cast(dff.[PRECIO_CANTIDAD]/dff.IDQTY as numeric(13,2)), --det.idqty
    dff.recalculo=3
	--select dff.FACTURA,dff.IDPRDC,dff.PCXPRC,dff.FARMACIA,p.precio_far
from detalle_fahorroFacturas dff 
inner join #pedidos_spt_fahorro p  on 
cast(isnull(dff.ihoref,'0') as int) = convert(int, replace(replace(p.orden, ' ', ''), '"', '')) 
and dff.idprdc = p.codigo and substring(dff.idcuno,2,5) = p.cuenta 
where cast(dff.neto_unitario as money)<>p.precio_far and dff.[PERIODO]=@idperiodo

update  dff set 
dff.unitario=p.precio_far,
dff.neto_unitario=p.precio_far,
dff.dtdcpr=p.porcentaje_oferta
from detalle_fahorroFacturas dff 
inner join #pedidos_spt_fahorro p  on 
cast(isnull(dff.ihoref,'0') as int) = convert(int, replace(replace(p.orden, ' ', ''), '"', '')) 
and dff.idprdc = p.codigo and substring(dff.idcuno,2,5) = p.cuenta
where dff.recalculo=3  and dff.[PERIODO]=@idperiodo

update  dff set 
dff.precio_cantidad=(dff.precio_cantidad*dff.idqty),
dff.neto_cantidad=(dff.neto_unitario*dff.idqty)
from detalle_fahorroFacturas dff 
inner join #pedidos_spt_fahorro p  on 
cast(isnull(dff.ihoref,'0') as int) = convert(int, replace(replace(p.orden, ' ', ''), '"', '')) 
and dff.idprdc = p.codigo and substring(dff.idcuno,2,5) = p.cuenta 
where dff.recalculo=3  and dff.[PERIODO]=@idperiodo


update  dff set 
dff.descoferta=cast(((dff.neto_cantidad*dff.dtdcpr)/100) as varchar(50))
from detalle_fahorroFacturas dff 
inner join #pedidos_spt_fahorro p  on 
cast(isnull(dff.ihoref,'0') as int) = convert(int, replace(replace(p.orden, ' ', ''), '"', '')) 
and dff.idprdc = p.codigo and substring(dff.idcuno,2,5) = p.cuenta
where dff.recalculo=3  and dff.[PERIODO]=@idperiodo

update  dff set 
dff.neto_cantidad=(dff.neto_cantidad-cast(dff.descoferta as numeric(13,2)))
from detalle_fahorroFacturas dff 
inner join #pedidos_spt_fahorro p  on 
cast(isnull(dff.ihoref,'0') as int) = convert(int, replace(replace(p.orden, ' ', ''), '"', '')) 
and dff.idprdc = p.codigo and substring(dff.idcuno,2,5) = p.cuenta 
where dff.recalculo=3  and dff.[PERIODO]=@idperiodo

update  dff set 
dff.recalculo=4,
dff.ieps_moneda=((dff.neto_cantidad*ieps)/100),
dff.total_ieps=(dff.neto_cantidad+dff.ieps_moneda),
dff.iva_moneda=((dff.neto_cantidad*iva)/100),
dff.total_final=(dff.neto_cantidad+dff.ieps_moneda+dff.iva_moneda),
dff.desccomercialpesos=(dff.neto_cantidad*cast(isnull(dff.desccomercial,'0') as numeric(13,2))/100)
from detalle_fahorroFacturas dff 
inner join #pedidos_spt_fahorro p  on 
cast(isnull(dff.ihoref,'0') as int) = convert(int, replace(replace(p.orden, ' ', ''), '"', '')) 
and dff.idprdc = p.codigo and substring(dff.idcuno,2,5) = p.cuenta 
where dff.recalculo=3  and dff.[PERIODO]=@idperiodo


--recalculo = 5,6 por oferta

update  dff set 
dff.recalculo=5,
dff.dtdcpr=p.porcentaje_oferta
--select dff.FACTURA,dff.IDPRDC,dff.PCXPRC,dff.FARMACIA,cast(isnull(dff.DTDCPR,'0') as numeric(13,2)),cast(p.porcentaje_oferta as numeric(13,2))
from detalle_fahorroFacturas dff 
inner join #pedidos_spt_fahorro p  on 
cast(isnull(dff.ihoref,'0') as int) = convert(int, replace(replace(p.orden, ' ', ''), '"', '')) 
and dff.idprdc = p.codigo and substring(dff.idcuno,2,5) = p.cuenta 
where cast(isnull(dff.DTDCPR,'0') as numeric(13,2))<>cast(p.porcentaje_oferta as numeric(13,2)) and dff.[PERIODO]=@idperiodo

update  dff set 
dff.neto_cantidad=(dff.neto_unitario*dff.idqty)
from detalle_fahorroFacturas dff 
inner join #pedidos_spt_fahorro p  on 
cast(isnull(dff.ihoref,'0') as int) = convert(int, replace(replace(p.orden, ' ', ''), '"', '')) 
and dff.idprdc = p.codigo and substring(dff.idcuno,2,5) = p.cuenta 
where dff.recalculo=5  and dff.[PERIODO]=@idperiodo

update  dff set 
dff.descoferta=cast(((dff.neto_cantidad*dff.dtdcpr)/100) as varchar(50))
from detalle_fahorroFacturas dff 
inner join #pedidos_spt_fahorro p  on 
cast(isnull(dff.ihoref,'0') as int) = convert(int, replace(replace(p.orden, ' ', ''), '"', '')) 
and dff.idprdc = p.codigo and substring(dff.idcuno,2,5) = p.cuenta
where dff.recalculo=5  and dff.[PERIODO]=@idperiodo

update  dff set 
dff.neto_cantidad=(dff.neto_cantidad-cast(dff.descoferta as numeric(13,2)))
from detalle_fahorroFacturas dff 
inner join #pedidos_spt_fahorro p  on 
cast(isnull(dff.ihoref,'0') as int) = convert(int, replace(replace(p.orden, ' ', ''), '"', '')) 
and dff.idprdc = p.codigo and substring(dff.idcuno,2,5) = p.cuenta 
where dff.recalculo=5  and dff.[PERIODO]=@idperiodo

update  dff set 
dff.recalculo=6,
dff.ieps_moneda=((dff.neto_cantidad*ieps)/100),
dff.total_ieps=(dff.neto_cantidad+dff.ieps_moneda),
dff.iva_moneda=((dff.neto_cantidad*iva)/100),
dff.total_final=(dff.neto_cantidad+dff.ieps_moneda+dff.iva_moneda),
dff.desccomercialpesos=(dff.neto_cantidad*cast(isnull(dff.desccomercial,'0') as numeric(13,2))/100)
from detalle_fahorroFacturas dff 
inner join #pedidos_spt_fahorro p  on 
cast(isnull(dff.ihoref,'0') as int) = convert(int, replace(replace(p.orden, ' ', ''), '"', '')) 
and dff.idprdc = p.codigo and substring(dff.idcuno,2,5) = p.cuenta 
where dff.recalculo=5  and dff.[PERIODO]=@idperiodo


END

GO

