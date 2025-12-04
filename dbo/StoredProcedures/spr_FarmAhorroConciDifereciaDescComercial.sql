-- =============================================
-- Author:		mandrade
-- Create date: 30/01/2018
-- Description:	"Actualiza Diferencias en DESCUENTO COMERCIAL"
-- EXEC [dbo].[spr_FarmAhorroConciDifereciaDescComercial] 0
-- =============================================
CREATE PROCEDURE [dbo].[spr_FarmAhorroConciDifereciaDescComercial] @periodo int=0 aS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

--Respaldo 
INSERT INTO [dbo].[mov_detalle_fahorroFacturas]
([SUCURSAL],[SERIE],[IDCUNO],[NANCA1],[IDINVN],[FACTURA],[IDLINE],[IDPRDC],[PCXPRC],[IDDESC],[IDQTY],[CF],[FARMACIA],[UNITARIO],[PUBLICO]
,[PRECIO_CANTIDAD],[NETO_UNITARIO],[NETO_CANTIDAD],[IVA],[IEPS],[IEPS_MONEDA],[TOTAL_IEPS],[IVA_MONEDA],[TOTAL_FINAL],[DTDCPR],[DESCOFERTA]
,[DESCCOMERCIAL],[DescComercialPesos],[IDGDSQ],[FECHAPROG],[IHOREF],[NATREG],[PERIODO],[RECALCULO],[HashCode],[ACCION])
SELECT
d.[SUCURSAL],[SERIE],[IDCUNO],[NANCA1],[IDINVN],[FACTURA],[IDLINE],[IDPRDC],[PCXPRC],[IDDESC],[IDQTY],[CF],[FARMACIA],[UNITARIO],[PUBLICO]
,[PRECIO_CANTIDAD],[NETO_UNITARIO],[NETO_CANTIDAD],d.[IVA],[IEPS],[IEPS_MONEDA],[TOTAL_IEPS],[IVA_MONEDA],[TOTAL_FINAL],[DTDCPR],[DESCOFERTA]
,[DESCCOMERCIAL],[DescComercialPesos],[IDGDSQ],[FECHAPROG],[IHOREF],[NATREG],d.[PERIODO],6,[HashCode],'C'
FROM detalle_fahorroFacturas d 
inner join pedidos_fahorro_conciliacion p  on 
cast(isnull(d.ihoref,'0') as int) = convert(int, replace(replace(p.orden, ' ', ''), '"', '')) 
and d.idprdc = p.codigo and substring(d.idcuno,2,5) = p.cuenta and d.periodo=p.periodo
where d.periodo=@periodo and ((p.importe_pronto_pago*d.idqty)-cast(desccomercialpesos as money))>1
--/////////////////////////////////////////////////////////////////////////////////////////////////
--------------------------recalculo descuento comenrcial
update  dff set 
--dff.unitario=(p.precio_far-((p.precio_far*isnull(dtdcpr,0))/100)),
--dff.precio_cantidad=((p.precio_far-(p.precio_far*isnull(dtdcpr,0)/100))*dff.idqty),	
dff.desccomercial=cast((cast(((p.importe_pronto_pago*1)/p.precio_far) as numeric(10,4))*100) as varchar),
 dff.recalculo=6
--select dff.*,(p.importe_pronto_pago*dff.idqty),cast(desccomercialpesos as money)
--,p.precio_far,p.[porcentaje_oferta],p.[importe_oferta],p.[importe_pronto_pago],
--((p.importe_pronto_pago*dff.idqty)-cast(desccomercialpesos as money))
from detalle_fahorroFacturas dff 
inner join pedidos_fahorro_conciliacion p  on 
cast(isnull(dff.ihoref,'0') as int) = convert(int, replace(replace(p.orden, ' ', ''), '"', '')) 
and dff.idprdc = p.codigo and substring(dff.idcuno,2,5) = p.cuenta and dff.periodo=p.periodo
where --dff.recalculo=6 and 
dff.periodo=@periodo and ((p.importe_pronto_pago*dff.idqty)-cast(desccomercialpesos as money))>1


update  dff set 
dff.neto_unitario=(dff.unitario-(dff.unitario*cast(isnull(dff.desccomercial,'0')as numeric(20,2))/100)),
dff.neto_cantidad=(dff.precio_cantidad-(dff.precio_cantidad*cast(isnull(dff.desccomercial,'0')as numeric(20,2))/100)),
dff.ieps_moneda=((dff.precio_cantidad*dff.ieps)/100)
from detalle_fahorroFacturas dff 
inner join pedidos_fahorro_conciliacion p  on 
cast(isnull(dff.ihoref,'0') as int) = convert(int, replace(replace(p.orden, ' ', ''), '"', '')) 
and dff.idprdc = p.codigo and substring(dff.idcuno,2,5) = p.cuenta and dff.periodo=p.periodo
where dff.recalculo=6 and dff.periodo=@periodo


update  dff set 
dff.total_ieps=(dff.neto_cantidad+dff.ieps_moneda),
dff.iva_moneda=((dff.precio_cantidad*dff.iva)/100),
 dff.descoferta=cast(cast(((dff.farmacia*dff.idqty)*dff.dtdcpr/100)as numeric(10,2)) as varchar)
from detalle_fahorroFacturas dff 
inner join pedidos_fahorro_conciliacion p  on 
cast(isnull(dff.ihoref,'0') as int) = convert(int, replace(replace(p.orden, ' ', ''), '"', '')) 
and dff.idprdc = p.codigo and substring(dff.idcuno,2,5) = p.cuenta and dff.periodo=p.periodo
where dff.recalculo=6 and dff.periodo=@periodo


update  dff set 
 dff.total_final=(dff.total_ieps+(dff.iva_moneda-(dff.iva_moneda*cast(isnull(dff.desccomercial,'0')as numeric(20,2))/100))),
 dff.desccomercialpesos=cast(cast((dff.precio_cantidad*cast(isnull(dff.desccomercial,'0')as numeric(20,2))/100) as numeric(10,2)) as varchar)
from detalle_fahorroFacturas dff 
inner join pedidos_fahorro_conciliacion p  on 
cast(isnull(dff.ihoref,'0') as int) = convert(int, replace(replace(p.orden, ' ', ''), '"', '')) 
and dff.idprdc = p.codigo and substring(dff.idcuno,2,5) = p.cuenta and dff.periodo=p.periodo
where dff.recalculo=6 and dff.periodo=@periodo
--///////////////////////////////////////////////////////////////////////////////////////////////////
INSERT INTO [dbo].[mov_detalle_fahorroFacturas]
([SUCURSAL],[SERIE],[IDCUNO],[NANCA1],[IDINVN],[FACTURA],[IDLINE],[IDPRDC],[PCXPRC],[IDDESC],[IDQTY],[CF],[FARMACIA],[UNITARIO],[PUBLICO]
,[PRECIO_CANTIDAD],[NETO_UNITARIO],[NETO_CANTIDAD],[IVA],[IEPS],[IEPS_MONEDA],[TOTAL_IEPS],[IVA_MONEDA],[TOTAL_FINAL],[DTDCPR],[DESCOFERTA]
,[DESCCOMERCIAL],[DescComercialPesos],[IDGDSQ],[FECHAPROG],[IHOREF],[NATREG],[PERIODO],[RECALCULO],[HashCode],[ACCION])
SELECT
d.[SUCURSAL],[SERIE],[IDCUNO],[NANCA1],[IDINVN],[FACTURA],[IDLINE],[IDPRDC],[PCXPRC],[IDDESC],[IDQTY],[CF],[FARMACIA],[UNITARIO],[PUBLICO]
,[PRECIO_CANTIDAD],[NETO_UNITARIO],[NETO_CANTIDAD],d.[IVA],[IEPS],[IEPS_MONEDA],[TOTAL_IEPS],[IVA_MONEDA],[TOTAL_FINAL],[DTDCPR],[DESCOFERTA]
,[DESCCOMERCIAL],[DescComercialPesos],[IDGDSQ],[FECHAPROG],[IHOREF],[NATREG],d.[PERIODO],6,[HashCode],'U'
FROM detalle_fahorroFacturas d 
inner join pedidos_fahorro_conciliacion p  on 
cast(isnull(d.ihoref,'0') as int) = convert(int, replace(replace(p.orden, ' ', ''), '"', '')) 
and d.idprdc = p.codigo and substring(d.idcuno,2,5) = p.cuenta and d.periodo=p.periodo
where d.recalculo=6 and d.periodo=@periodo

/*
update dff
set dff.[DESCCOMERCIAL]=cast((((p.importe_pronto_pago*1)/p.precio_far)*100) as varchar),
dff.[DescComercialPesos]=cast((p.[importe_pronto_pago]*dff.[IDQTY]) as varchar),
dff.RECALCULO=9
--select dff.*,
--cast(dff.desccomercialpesos as money)-(p.[importe_pronto_pago]*dff.[IDQTY]) as diferenciaComercial,
--p.importe_pronto_pago descComercialPesosAhorro,dff.[DescComercialPesos] descComercialPesosMarzam,
--((p.importe_pronto_pago*1)/p.precio_far)*100 as porcentComercial,
--cast((dff.precio_cantidad*(((p.importe_pronto_pago*1)/p.precio_far)*100)/100) as numeric(20,2)) as  pesosComercial,
--cast((p.[importe_pronto_pago]*dff.[IDQTY])as numeric(20,2)) as PesosComercialFarmaciasAhorro
------into diferenciaFahorroDescComercial
from detalle_fahorroFacturas dff 
inner join pedidos_fahorro_conciliacion p  on 
cast(isnull(dff.ihoref,'0') as int) = convert(int, replace(replace(p.orden, ' ', ''), '"', '')) 
and dff.idprdc = p.codigo and substring(dff.idcuno,2,5) = p.cuenta and dff.periodo=p.periodo
where  cast(dff.desccomercialpesos as money)<>(p.[importe_pronto_pago]*dff.[IDQTY]) and dff.periodo=257

*/
END

GO

