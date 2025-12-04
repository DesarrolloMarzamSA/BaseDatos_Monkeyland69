-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- [spr_FarmAhorroConciDevoluciones] 250
-- =============================================
CREATE PROCEDURE [dbo].[spr_FarmAhorroConciDevoluciones]  @periodo int=0
AS

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

--insert into [dbo].[pedidos_fahorro_conciliacion]
--declare @periodo int=292
MERGE pedidos_fahorro_conciliacion T
USING(
       --declare @periodo int=292
       select distinct 
          convert(varchar(9), right('000000000' + cuenta_estilo_ahorro, 9)) cuenta_estilo_ahorro
          ,hash_md5,convert(int, orden) orden,cod_barras,p.sucursal,cuenta,tipo_pedido,codigo,
          cant_ped,precio_far,convert(money,importe_oferta)as importe_oferta,convert(money,importe_pronto_pago) as importe_pronto_pago
		  ,tipo_oferta,convert(money,porcentaje_oferta/100) porcentaje_oferta,
          arch_tandem,status,timestamp,remisionado ,@periodo as periodo
       from detalle_fahorroFacturas dff 
       inner join pedidos_spt_fahorro p on 
       cast(isnull(dff.ihoref,'0') as int) = convert(int, replace(replace(p.orden, ' ', ''), '"', '')) 
       and dff.idprdc = p.codigo and substring(dff.idcuno,2,5) = p.cuenta 
       where dff.[PERIODO]=@periodo
) S
ON (S.[cuenta_estilo_ahorro]=T.[cuenta_estilo_ahorro] AND S.[orden]=T.[orden] AND S.[cuenta]=T.[cuenta] AND S.[tipo_pedido]=T.[tipo_pedido] 
  AND S.[codigo]=T.[codigo] AND S.[cant_ped]=T.[cant_ped] AND S.[precio_far]=T.[precio_far] AND S.[periodo]=T.[periodo])
WHEN NOT MATCHED THEN
INSERT ( [cuenta_estilo_ahorro],[hash_md5],[orden],[cod_barras],[sucursal],[cuenta],[tipo_pedido],[codigo],[cant_ped],[precio_far]
     ,[importe_oferta],[importe_pronto_pago],[tipo_oferta],[porcentaje_oferta],[arch_tandem],[status],[timestamp],[remisionado],[periodo])
values ( S.[cuenta_estilo_ahorro],S.[hash_md5],S.[orden],S.[cod_barras],S.[sucursal],S.[cuenta],S.[tipo_pedido],S.[codigo],S.[cant_ped],S.[precio_far]
     ,S.[importe_oferta],S.[importe_pronto_pago],S.[tipo_oferta],S.[porcentaje_oferta],S.[arch_tandem],S.[status],S.[timestamp],S.[remisionado],S.[periodo]);
--select * from pedidos_fahorro_conciliacion where periodo=292

--Respaldo (eliminar devolucion 1&1)
INSERT INTO [dbo].[mov_detalle_fahorroFacturas]
([SUCURSAL],[SERIE],[IDCUNO],[NANCA1],[IDINVN],[FACTURA],[IDLINE],[IDPRDC],[PCXPRC],[IDDESC],[IDQTY],[CF],[FARMACIA],[UNITARIO],[PUBLICO]
,[PRECIO_CANTIDAD],[NETO_UNITARIO],[NETO_CANTIDAD],[IVA],[IEPS],[IEPS_MONEDA],[TOTAL_IEPS],[IVA_MONEDA],[TOTAL_FINAL],[DTDCPR],[DESCOFERTA]
,[DESCCOMERCIAL],[DescComercialPesos],[IDGDSQ],[FECHAPROG],[IHOREF],[NATREG],[PERIODO],[RECALCULO],[HashCode],[ACCION])
--declare @periodo int=292
SELECT
df.[SUCURSAL],[SERIE],[IDCUNO],[NANCA1],[IDINVN],[FACTURA],[IDLINE],[IDPRDC],[PCXPRC],[IDDESC],[IDQTY],[CF],[FARMACIA],[UNITARIO],[PUBLICO]
,[PRECIO_CANTIDAD],[NETO_UNITARIO],[NETO_CANTIDAD],df.[IVA],[IEPS],[IEPS_MONEDA],[TOTAL_IEPS],[IVA_MONEDA],[TOTAL_FINAL],[DTDCPR],[DESCOFERTA]
,[DESCCOMERCIAL],[DescComercialPesos],[IDGDSQ],[FECHAPROG],[IHOREF],[NATREG],df.[PERIODO],1,[HashCode],'D'
FROM detalle_fahorroFacturas df
INNER JOIN [DiferenciaDevolucionesAhorro] dda on df.idinvn=dda.folio AND df.PCXPRC=dda.Producto AND df.[PERIODO]=dda.[PERIODO]
WHERE (df.idqty-dda.unidades) <= 0 
AND df.[PERIODO]=@periodo
--eliminar devolucion 1&1 
delete df
 --select df.SUCURSAL,SERIE,IDCUNO,NANCA1,IDINVN,FACTURA,IDLINE,IDPRDC,PCXPRC,IDDESC,IDQTY,Folio,Producto,DescripcionProducto,Indicadores,Unidades,(df.idqty-dda.unidades) as unidadesfalta
 --select df.*  into devolucionFahorroConciliacion 
from detalle_fahorroFacturas df
inner join [DiferenciaDevolucionesAhorro] dda on df.idinvn=dda.folio and df.PCXPRC=dda.Producto and df.[PERIODO]=dda.[PERIODO]
where (df.idqty-dda.unidades) <= 0 
and df.[PERIODO]=@periodo
--and  dda.folio='32851267'


--select * from detalle_fahorroFacturas where idinvn=32851267
--select * from [DiferenciaDevolucionesAhorro] where folio='32851267'

--Respaldo Recalcular devolucion parcial(Solo ejecutar una vez)
INSERT INTO [dbo].[mov_detalle_fahorroFacturas]
([SUCURSAL],[SERIE],[IDCUNO],[NANCA1],[IDINVN],[FACTURA],[IDLINE],[IDPRDC],[PCXPRC],[IDDESC],[IDQTY],[CF],[FARMACIA],[UNITARIO],[PUBLICO]
,[PRECIO_CANTIDAD],[NETO_UNITARIO],[NETO_CANTIDAD],[IVA],[IEPS],[IEPS_MONEDA],[TOTAL_IEPS],[IVA_MONEDA],[TOTAL_FINAL],[DTDCPR],[DESCOFERTA]
,[DESCCOMERCIAL],[DescComercialPesos],[IDGDSQ],[FECHAPROG],[IHOREF],[NATREG],[PERIODO],[RECALCULO],[HashCode],[ACCION])
SELECT
d.[SUCURSAL],[SERIE],[IDCUNO],[NANCA1],[IDINVN],[FACTURA],[IDLINE],[IDPRDC],[PCXPRC],[IDDESC],[IDQTY],[CF],[FARMACIA],[UNITARIO],[PUBLICO]
,[PRECIO_CANTIDAD],[NETO_UNITARIO],[NETO_CANTIDAD],d.[IVA],[IEPS],[IEPS_MONEDA],[TOTAL_IEPS],[IVA_MONEDA],[TOTAL_FINAL],[DTDCPR],[DESCOFERTA]
,[DESCCOMERCIAL],[DescComercialPesos],[IDGDSQ],[FECHAPROG],[IHOREF],[NATREG],d.[PERIODO],1,[HashCode],'C'
FROM detalle_fahorroFacturas d
INNER JOIN [DiferenciaDevolucionesAhorro] dda on d.idinvn=dda.folio AND d.PCXPRC=dda.Producto AND d.[PERIODO]=dda.[PERIODO]
WHERE  (d.idqty-dda.unidades)>0 AND d.[PERIODO]=@periodo AND isnull(d.recalculo,0) <> 1 
--Recalcular devolucion parcial(Solo ejecutar una vez)
Update Det Set
	Det.IDQTY =  (det.IDQTY - dda.Unidades),
	Det.recalculo=1
	--insert into devolucionFahorroConciliacion
	--select det.*
	--select det.recalculo,det.idinvn,det.IDPRDC,det.PCXPRC,det.IDDESC,det.IDQTY,det.[PRECIO_CANTIDAD],cast(det.[PRECIO_CANTIDAD]/det.IDQTY as numeric(13,2))as precioCantUni,det.[NETO_UNITARIO] 
	--,dda.Folio,dda.Producto,dda.DescripcionProducto,dda.Unidades,dda.[CostoNeto],dda.[IVA],dda.[CostoTotal],(det.idqty-dda.unidades) as unidadesfalta
   From detalle_fahorroFacturas Det
Inner Join [DiferenciaDevolucionesAhorro] dda on Det.idinvn=dda.folio and Det.PCXPRC=dda.Producto and Det.[PERIODO]=dda.[PERIODO]
where  (Det.idqty-dda.unidades)>0 and Det.[PERIODO]=@periodo and isnull(det.recalculo,0) <> 1 
--select * from  detalle_fahorroFacturas where recalculo=1


update  dff set 
    dff.FARMACIA=p.precio_far,
	dff.dtdcpr=(p.porcentaje_oferta*100),
	dff.unitario=(p.precio_far-((p.precio_far*isnull(dtdcpr,0))/100)),
	dff.precio_cantidad=((p.precio_far-(p.precio_far*isnull(dtdcpr,0)/100))*dff.idqty),	
	dff.desccomercial=cast((cast(((p.importe_pronto_pago*1)/p.precio_far) as numeric(10,4))*100) as varchar)
--select distinct  dff.*,p.precio_far,p.[porcentaje_oferta],p.[importe_oferta],p.[importe_pronto_pago],dff.sucursal,p.sucursal
from detalle_fahorroFacturas dff 
inner join pedidos_fahorro_conciliacion p  on 
cast(isnull(dff.ihoref,'0') as int) = convert(int, replace(replace(p.orden, ' ', ''), '"', '')) 
and dff.idprdc = p.codigo and substring(dff.idcuno,2,5) = p.cuenta and dff.[PERIODO]=p.[PERIODO] --and   dff.sucursal=p.sucursal
where dff.recalculo=1 and dff.[PERIODO]=@periodo


update  dff set 
dff.neto_unitario=(dff.unitario-(dff.unitario*cast(isnull(dff.desccomercial,'0')as numeric(20,2))/100)),
dff.neto_cantidad=(dff.precio_cantidad-(dff.precio_cantidad*cast(isnull(dff.desccomercial,'0')as numeric(20,2))/100)),
dff.ieps_moneda=((dff.precio_cantidad*dff.ieps)/100)
--select dff.*
from detalle_fahorroFacturas dff 
inner join pedidos_fahorro_conciliacion p  on 
cast(isnull(dff.ihoref,'0') as int) = convert(int, replace(replace(p.orden, ' ', ''), '"', '')) 
and dff.idprdc = p.codigo and substring(dff.idcuno,2,5) = p.cuenta and dff.[PERIODO]=p.[PERIODO]  --and dff.sucursal=p.sucursal
where dff.recalculo=1 and dff.[PERIODO]=@periodo


update  dff set 
dff.total_ieps=(dff.neto_cantidad+dff.ieps_moneda),
dff.iva_moneda=((dff.precio_cantidad*dff.iva)/100)
from detalle_fahorroFacturas dff 
inner join pedidos_fahorro_conciliacion p  on 
cast(isnull(dff.ihoref,'0') as int) = convert(int, replace(replace(p.orden, ' ', ''), '"', '')) 
and dff.idprdc = p.codigo and substring(dff.idcuno,2,5) = p.cuenta  and dff.[PERIODO]=p.[PERIODO]  --and dff.sucursal=p.sucursal
where dff.recalculo=1 and dff.[PERIODO]=@periodo

update  dff set 
 dff.total_final=(dff.total_ieps+(dff.iva_moneda-(dff.iva_moneda*cast(isnull(dff.desccomercial,'0')as numeric(20,2))/100))),
 dff.descoferta=cast(cast(((dff.farmacia*dff.idqty)*dff.dtdcpr/100)as numeric(10,2)) as varchar),
 dff.desccomercialpesos=cast(cast((dff.precio_cantidad*cast(isnull(dff.desccomercial,'0')as numeric(20,2))/100) as numeric(10,2)) as varchar)
from detalle_fahorroFacturas dff 
inner join pedidos_fahorro_conciliacion p  on 
cast(isnull(dff.ihoref,'0') as int) = convert(int, replace(replace(p.orden, ' ', ''), '"', '')) 
and dff.idprdc = p.codigo and substring(dff.idcuno,2,5) = p.cuenta and dff.[PERIODO]=p.[PERIODO] -- and dff.sucursal=p.sucursal
where dff.recalculo=1 and dff.[PERIODO]=@periodo
--///////////////////////////////////////////////////////////////////////////////////////////
INSERT INTO [dbo].[mov_detalle_fahorroFacturas]
([SUCURSAL],[SERIE],[IDCUNO],[NANCA1],[IDINVN],[FACTURA],[IDLINE],[IDPRDC],[PCXPRC],[IDDESC],[IDQTY],[CF],[FARMACIA],[UNITARIO],[PUBLICO]
,[PRECIO_CANTIDAD],[NETO_UNITARIO],[NETO_CANTIDAD],[IVA],[IEPS],[IEPS_MONEDA],[TOTAL_IEPS],[IVA_MONEDA],[TOTAL_FINAL],[DTDCPR],[DESCOFERTA]
,[DESCCOMERCIAL],[DescComercialPesos],[IDGDSQ],[FECHAPROG],[IHOREF],[NATREG],[PERIODO],[RECALCULO],[HashCode],[ACCION])
SELECT
d.[SUCURSAL],[SERIE],[IDCUNO],[NANCA1],[IDINVN],[FACTURA],[IDLINE],[IDPRDC],[PCXPRC],[IDDESC],[IDQTY],[CF],[FARMACIA],[UNITARIO],[PUBLICO]
,[PRECIO_CANTIDAD],[NETO_UNITARIO],[NETO_CANTIDAD],d.[IVA],[IEPS],[IEPS_MONEDA],[TOTAL_IEPS],[IVA_MONEDA],[TOTAL_FINAL],[DTDCPR],[DESCOFERTA]
,[DESCCOMERCIAL],[DescComercialPesos],[IDGDSQ],[FECHAPROG],[IHOREF],[NATREG],d.[PERIODO],1,[HashCode],'U'
FROM detalle_fahorroFacturas d 
inner join pedidos_fahorro_conciliacion p  on 
cast(isnull(d.ihoref,'0') as int) = convert(int, replace(replace(p.orden, ' ', ''), '"', '')) 
and d.idprdc = p.codigo and substring(d.idcuno,2,5) = p.cuenta and d.[PERIODO]=p.[PERIODO] -- and dff.sucursal=p.sucursal
where d.recalculo=1 and d.[PERIODO]=@periodo

END

GO

