-- =============================================
-- Author:		mandrade
-- Create date: 30/01/2018
-- Description:	"Actualiza Diferencias en precio" Recalcula precio farmacia, oferta y descuento Comercial
--
-- =============================================
CREATE PROCEDURE [dbo].[spr_FarmAhorroConciDifereciaPrecio] @periodo int=0 aS
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
,[DESCCOMERCIAL],[DescComercialPesos],[IDGDSQ],[FECHAPROG],[IHOREF],[NATREG],d.[PERIODO],3,[HashCode],'C'
FROM detalle_fahorroFacturas d 
inner join pedidos_fahorro_conciliacion p  on 
cast(isnull(d.ihoref,'0') as int) = convert(int, replace(replace(p.orden, ' ', ''), '"', '')) 
and d.idprdc = p.codigo and substring(d.idcuno,2,5) = p.cuenta and d.periodo=p.periodo
where cast(d.FARMACIA as money)<>p.precio_far and d.periodo=@periodo 
--//////////////////////////////////////////////////////////////////////////////////////////////////
update  dff set 
    dff.FARMACIA=p.precio_far,
	dff.dtdcpr=(p.porcentaje_oferta*100),
	dff.recalculo=3
	--select dff.recalculo, *
from detalle_fahorroFacturas dff 
inner join pedidos_fahorro_conciliacion p  on 
cast(isnull(dff.ihoref,'0') as int) = convert(int, replace(replace(p.orden, ' ', ''), '"', '')) 
and dff.idprdc = p.codigo and substring(dff.idcuno,2,5) = p.cuenta and dff.periodo=p.periodo
where cast(dff.FARMACIA as money)<>p.precio_far and
-- dff.recalculo=3 and 
dff.periodo=@periodo 


update  dff set 
dff.unitario=(p.precio_far-((p.precio_far*isnull(dff.dtdcpr,0))/100)),
dff.precio_cantidad=((p.precio_far-(p.precio_far*isnull(dtdcpr,0)/100))*dff.idqty),	
dff.desccomercial=cast((cast(((p.importe_pronto_pago*1)/p.precio_far) as numeric(10,4))*100) as varchar)
--select dff.*
--dff.unitario,(p.precio_far-((p.precio_far*isnull(dff.dtdcpr,0))/100))
from detalle_fahorroFacturas dff 
inner join pedidos_fahorro_conciliacion p  on 
cast(isnull(dff.ihoref,'0') as int) = convert(int, replace(replace(p.orden, ' ', ''), '"', '')) 
and dff.idprdc = p.codigo and substring(dff.idcuno,2,5) = p.cuenta and dff.periodo=p.periodo
where dff.recalculo=3 and dff.periodo=@periodo --and dff.idinvn=32952059


update  dff set 
dff.neto_unitario=(dff.unitario-(dff.unitario*cast(isnull(dff.desccomercial,'0')as numeric(20,2))/100)),
dff.neto_cantidad=(dff.precio_cantidad-(dff.precio_cantidad*cast(isnull(dff.desccomercial,'0')as numeric(20,2))/100)),
dff.ieps_moneda=((dff.precio_cantidad*dff.ieps)/100)
from detalle_fahorroFacturas dff 
inner join pedidos_fahorro_conciliacion p  on 
cast(isnull(dff.ihoref,'0') as int) = convert(int, replace(replace(p.orden, ' ', ''), '"', '')) 
and dff.idprdc = p.codigo and substring(dff.idcuno,2,5) = p.cuenta and dff.periodo=p.periodo
where dff.recalculo=3 and dff.periodo=@periodo


update  dff set 
dff.total_ieps=(dff.neto_cantidad+dff.ieps_moneda),
dff.iva_moneda=((dff.precio_cantidad*dff.iva)/100),
 dff.descoferta=cast(cast(((dff.farmacia*dff.idqty)*dff.dtdcpr/100)as numeric(10,2)) as varchar)
 from detalle_fahorroFacturas dff 
inner join pedidos_fahorro_conciliacion p  on 
cast(isnull(dff.ihoref,'0') as int) = convert(int, replace(replace(p.orden, ' ', ''), '"', '')) 
and dff.idprdc = p.codigo and substring(dff.idcuno,2,5) = p.cuenta and dff.periodo=p.periodo
where dff.recalculo=3 and dff.periodo=@periodo


update  dff set 
 dff.total_final=(dff.total_ieps+(dff.iva_moneda-(dff.iva_moneda*cast(isnull(dff.desccomercial,'0')as numeric(20,2))/100))),
 dff.desccomercialpesos=cast(cast((dff.precio_cantidad*cast(isnull(dff.desccomercial,'0')as numeric(20,2))/100) as numeric(10,2)) as varchar)
from detalle_fahorroFacturas dff 
inner join pedidos_fahorro_conciliacion p  on 
cast(isnull(dff.ihoref,'0') as int) = convert(int, replace(replace(p.orden, ' ', ''), '"', '')) 
and dff.idprdc = p.codigo and substring(dff.idcuno,2,5) = p.cuenta and dff.periodo=p.periodo
where dff.recalculo=3 and dff.periodo=@periodo 
--////////////////////////////////////////////////////////////////////////////////////////////////
INSERT INTO [dbo].[mov_detalle_fahorroFacturas]
([SUCURSAL],[SERIE],[IDCUNO],[NANCA1],[IDINVN],[FACTURA],[IDLINE],[IDPRDC],[PCXPRC],[IDDESC],[IDQTY],[CF],[FARMACIA],[UNITARIO],[PUBLICO]
,[PRECIO_CANTIDAD],[NETO_UNITARIO],[NETO_CANTIDAD],[IVA],[IEPS],[IEPS_MONEDA],[TOTAL_IEPS],[IVA_MONEDA],[TOTAL_FINAL],[DTDCPR],[DESCOFERTA]
,[DESCCOMERCIAL],[DescComercialPesos],[IDGDSQ],[FECHAPROG],[IHOREF],[NATREG],[PERIODO],[RECALCULO],[HashCode],[ACCION])
SELECT
d.[SUCURSAL],[SERIE],[IDCUNO],[NANCA1],[IDINVN],[FACTURA],[IDLINE],[IDPRDC],[PCXPRC],[IDDESC],[IDQTY],[CF],[FARMACIA],[UNITARIO],[PUBLICO]
,[PRECIO_CANTIDAD],[NETO_UNITARIO],[NETO_CANTIDAD],d.[IVA],[IEPS],[IEPS_MONEDA],[TOTAL_IEPS],[IVA_MONEDA],[TOTAL_FINAL],[DTDCPR],[DESCOFERTA]
,[DESCCOMERCIAL],[DescComercialPesos],[IDGDSQ],[FECHAPROG],[IHOREF],[NATREG],d.[PERIODO],3,[HashCode],'U'
FROM detalle_fahorroFacturas d 
inner join pedidos_fahorro_conciliacion p  on 
cast(isnull(d.ihoref,'0') as int) = convert(int, replace(replace(p.orden, ' ', ''), '"', '')) 
and d.idprdc = p.codigo and substring(d.idcuno,2,5) = p.cuenta and d.periodo=p.periodo
where d.recalculo=3 and d.periodo=@periodo 


--Respaldo 
INSERT INTO [dbo].[mov_detalle_fahorroFacturas]
([SUCURSAL],[SERIE],[IDCUNO],[NANCA1],[IDINVN],[FACTURA],[IDLINE],[IDPRDC],[PCXPRC],[IDDESC],[IDQTY],[CF],[FARMACIA],[UNITARIO],[PUBLICO]
,[PRECIO_CANTIDAD],[NETO_UNITARIO],[NETO_CANTIDAD],[IVA],[IEPS],[IEPS_MONEDA],[TOTAL_IEPS],[IVA_MONEDA],[TOTAL_FINAL],[DTDCPR],[DESCOFERTA]
,[DESCCOMERCIAL],[DescComercialPesos],[IDGDSQ],[FECHAPROG],[IHOREF],[NATREG],[PERIODO],[RECALCULO],[HashCode],[ACCION])
SELECT
d.[SUCURSAL],[SERIE],[IDCUNO],[NANCA1],[IDINVN],[FACTURA],[IDLINE],[IDPRDC],[PCXPRC],[IDDESC],[IDQTY],[CF],[FARMACIA],[UNITARIO],[PUBLICO]
,[PRECIO_CANTIDAD],[NETO_UNITARIO],[NETO_CANTIDAD],d.[IVA],[IEPS],[IEPS_MONEDA],[TOTAL_IEPS],[IVA_MONEDA],[TOTAL_FINAL],[DTDCPR],[DESCOFERTA]
,[DESCCOMERCIAL],[DescComercialPesos],[IDGDSQ],[FECHAPROG],[IHOREF],[NATREG],d.[PERIODO],5,[HashCode],'C'
FROM detalle_fahorroFacturas d 
inner join pedidos_fahorro_conciliacion p  on 
cast(isnull(d.ihoref,'0') as int) = convert(int, replace(replace(p.orden, ' ', ''), '"', '')) 
and d.idprdc = p.codigo and substring(d.idcuno,2,5) = p.cuenta and d.periodo=p.periodo
where cast(isnull(d.DTDCPR,'0') as money)<>cast(p.porcentaje_oferta*100 as money) and d.periodo=@periodo
 --//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--recalculo = 5 por diferencia oferta 
update  dff set 
    dff.FARMACIA=p.precio_far,
	dff.dtdcpr=(p.porcentaje_oferta*100),
	dff.recalculo=5
	--select dff.SUCURSAL,dff.SERIE,dff.IDCUNO,dff.NANCA1,dff.IDINVN,dff.FACTURA,dff.IDLINE,dff.IDPRDC,dff.PCXPRC,dff.IDDESC,dff.IDQTY,dff.FARMACIA,p.precio_far as precFarmaAhorro,dff.DTDCPR,(p.porcentaje_oferta*100) as porcentajOfertaAhorro,dff.DESCOFERTA,p.importe_oferta as importOfertaAhorro,dff.DESCCOMERCIAL,dff.DescComercialPesos
----into detalleFahorroDiferenOferta
from detalle_fahorroFacturas dff 
inner join pedidos_fahorro_conciliacion p  on 
cast(isnull(dff.ihoref,'0') as int) = convert(int, replace(replace(p.orden, ' ', ''), '"', '')) 
and dff.idprdc = p.codigo and substring(dff.idcuno,2,5) = p.cuenta and dff.periodo=p.periodo
where 
--dff.recalculo=5 and dff.periodo=257
 cast(isnull(dff.DTDCPR,'0') as money)<>cast(p.porcentaje_oferta*100 as money) and dff.periodo=@periodo
 

update  dff set 
dff.unitario=(p.precio_far-((p.precio_far*isnull(dtdcpr,0))/100)),
dff.precio_cantidad=((p.precio_far-(p.precio_far*isnull(dtdcpr,0)/100))*dff.idqty),	
dff.desccomercial=cast((cast(((p.importe_pronto_pago*1)/p.precio_far) as numeric(10,4))*100) as varchar)
--select dff.*
from detalle_fahorroFacturas dff 
inner join pedidos_fahorro_conciliacion p  on 
cast(isnull(dff.ihoref,'0') as int) = convert(int, replace(replace(p.orden, ' ', ''), '"', '')) 
and dff.idprdc = p.codigo and substring(dff.idcuno,2,5) = p.cuenta and dff.periodo=p.periodo
where dff.recalculo=5 and dff.periodo=@periodo


update  dff set 
dff.neto_unitario=(dff.unitario-(dff.unitario*cast(isnull(dff.desccomercial,'0')as numeric(20,2))/100)),
dff.neto_cantidad=(dff.precio_cantidad-(dff.precio_cantidad*cast(isnull(dff.desccomercial,'0')as numeric(20,2))/100)),
dff.ieps_moneda=((dff.precio_cantidad*dff.ieps)/100)
from detalle_fahorroFacturas dff 
inner join pedidos_fahorro_conciliacion p  on 
cast(isnull(dff.ihoref,'0') as int) = convert(int, replace(replace(p.orden, ' ', ''), '"', '')) 
and dff.idprdc = p.codigo and substring(dff.idcuno,2,5) = p.cuenta and dff.periodo=p.periodo
where dff.recalculo=5 and dff.periodo=@periodo


update  dff set 
dff.total_ieps=(dff.neto_cantidad+dff.ieps_moneda),
dff.iva_moneda=((dff.precio_cantidad*dff.iva)/100),
 dff.descoferta=cast(cast(((dff.farmacia*dff.idqty)*dff.dtdcpr/100)as numeric(10,2)) as varchar)
from detalle_fahorroFacturas dff 
inner join pedidos_fahorro_conciliacion p  on 
cast(isnull(dff.ihoref,'0') as int) = convert(int, replace(replace(p.orden, ' ', ''), '"', '')) 
and dff.idprdc = p.codigo and substring(dff.idcuno,2,5) = p.cuenta  and dff.periodo=p.periodo
where dff.recalculo=5 and dff.periodo=@periodo


update  dff set 
 dff.total_final=(dff.total_ieps+(dff.iva_moneda-(dff.iva_moneda*cast(isnull(dff.desccomercial,'0')as numeric(20,2))/100))),
 dff.desccomercialpesos=cast(cast((dff.precio_cantidad*cast(isnull(dff.desccomercial,'0')as numeric(20,2))/100) as numeric(10,2)) as varchar)
from detalle_fahorroFacturas dff 
inner join pedidos_fahorro_conciliacion p  on 
cast(isnull(dff.ihoref,'0') as int) = convert(int, replace(replace(p.orden, ' ', ''), '"', '')) 
and dff.idprdc = p.codigo and substring(dff.idcuno,2,5) = p.cuenta and dff.periodo=p.periodo
where dff.recalculo=5 and dff.periodo=@periodo
--////////////////////////////////////////////////////////////////////////////////////////////////////////
INSERT INTO [dbo].[mov_detalle_fahorroFacturas]
([SUCURSAL],[SERIE],[IDCUNO],[NANCA1],[IDINVN],[FACTURA],[IDLINE],[IDPRDC],[PCXPRC],[IDDESC],[IDQTY],[CF],[FARMACIA],[UNITARIO],[PUBLICO]
,[PRECIO_CANTIDAD],[NETO_UNITARIO],[NETO_CANTIDAD],[IVA],[IEPS],[IEPS_MONEDA],[TOTAL_IEPS],[IVA_MONEDA],[TOTAL_FINAL],[DTDCPR],[DESCOFERTA]
,[DESCCOMERCIAL],[DescComercialPesos],[IDGDSQ],[FECHAPROG],[IHOREF],[NATREG],[PERIODO],[RECALCULO],[HashCode],[ACCION])
SELECT
d.[SUCURSAL],[SERIE],[IDCUNO],[NANCA1],[IDINVN],[FACTURA],[IDLINE],[IDPRDC],[PCXPRC],[IDDESC],[IDQTY],[CF],[FARMACIA],[UNITARIO],[PUBLICO]
,[PRECIO_CANTIDAD],[NETO_UNITARIO],[NETO_CANTIDAD],d.[IVA],[IEPS],[IEPS_MONEDA],[TOTAL_IEPS],[IVA_MONEDA],[TOTAL_FINAL],[DTDCPR],[DESCOFERTA]
,[DESCCOMERCIAL],[DescComercialPesos],[IDGDSQ],[FECHAPROG],[IHOREF],[NATREG],d.[PERIODO],5,[HashCode],'U'
FROM detalle_fahorroFacturas d 
inner join pedidos_fahorro_conciliacion p  on 
cast(isnull(d.ihoref,'0') as int) = convert(int, replace(replace(p.orden, ' ', ''), '"', '')) 
and d.idprdc = p.codigo and substring(d.idcuno,2,5) = p.cuenta and d.periodo=p.periodo
where d.recalculo=5 and d.periodo=@periodo


END

GO

