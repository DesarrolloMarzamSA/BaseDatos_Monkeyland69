-- =============================================
-- Author:		mandrade
-- Create date: 22/12/2017
-- Description:	reporte conciliacion farmacias del ahorro
-- =============================================
CREATE  PROCEDURE [dbo].[Reporte_Conciliacion_fahorro]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
   select distinct
	convert(varchar(9), right('000000000' + cuenta_estilo_ahorro, 9)) cuenta_estilo_ahorro,
	hash_md5,convert(int, orden) orden,cod_barras,p.sucursal,cuenta,tipo_pedido,codigo,
	cant_ped,precio_far,convert(money,importe_oferta)as importe_oferta,convert(money,importe_pronto_pago) as importe_pronto_pago,tipo_oferta,convert(money,porcentaje_oferta/100) porcentaje_oferta,
	arch_tandem,status,timestamp,remisionado 
into pedidos_spt_fahorro254
from detalle_fahorroFacturas dff 
inner join pedidos_spt_fahorro p on 
cast(isnull(dff.ihoref,'0') as int) = convert(int, replace(replace(p.orden, ' ', ''), '"', '')) 
and dff.idprdc = p.codigo and substring(dff.idcuno,2,5) = p.cuenta
where dff.[PERIODO]=254




select distinct
convert(varchar(9), right('000000000' + cuenta_estilo_ahorro, 9)) as cedis,
dff.[SUCURSAL] as sucursal,dff.[IDINVN] as facturaIBS,dff.factura,dff.[IDCUNO] as cliente,dff.[NANCA1] as clientePadre,dff.NATREG as rfc,dff.IDPRDC as codigos,
dff.IDDESC as descripcion,dff.PCXPRC as cod_barras,dff.IDQTY as cant_real,dff.IDQTY-isnull(cast(dv.unidades as int),0) as cant_ped_fahorro,
isnull(cast(dv.unidades as int),0) as cant_dev,dff.[CF] as clas_fiscal,
dff.[DTDCPR] as porcentaje,
dff.[PUBLICO] as prec_pub,dff.[FARMACIA] as prec_farm,isnull(dff.[DESCCOMERCIAL],'0') as desc_base,
dff.iva,dff.ihoref as orden, dff.idcuno as cuenta,cast((dff.[IVA_MONEDA]-(dff.[IVA_MONEDA]*cast(isnull(dff.desccomercial,0) as numeric(8,2))/100))as numeric(10,2)) as total_iva_neto_marzam
,cast((dff.[TOTAL_FINAL]-[IEPS_MONEDA])as numeric(10,2)) as total_marzam,dff.NETO_CANTIDAD-((p.precio_far - p.importe_pronto_pago - p.importe_oferta) * (dff.IDQTY)) as diferencia_importes_netos,p.porcentaje_oferta as pordentaje_fahorro,
convert(money,dff.dtdcpr/100) as porcentaje_marzam, p.porcentaje_oferta -convert(money,dff.dtdcpr/100) as diferencia_porcentaje_oferta,isnull(p.tipo_oferta,'')as tipo_oferta,
dff.farmacia as prec_farm_marzam,p.precio_far as prec_farm_fahorro,(dff.farmacia-p.precio_far) as diferencia_precio, dff.farmacia as importe_bruto_marzam,p.precio_far as importe_bruto_fahorro,
(dff.farmacia-p.precio_far) as diferencia_importe_bruto,dff.descoferta as importe_oferta_marzam,p.importe_oferta as importe_oferta_fahorro,
(convert(money,isnull(dff.descoferta,'0'))-p.importe_oferta) as diferencia_importe_oferta,
convert(money,dff.desccomercialpesos) as importe_desc_com_marzam,p.importe_pronto_pago importe_desc_com_fahorro,
convert(money,dff.desccomercialpesos)-p.importe_pronto_pago dif_importe_desc_com,p.orden,dff.ieps,dff.ieps_moneda
from detalle_fahorroFacturas dff 
inner join [dbo].[pedidos_spt_fahorro254] p on 
cast(isnull(dff.ihoref,'0') as int) = convert(int, replace(replace(p.orden, ' ', ''), '"', '')) 
and dff.idprdc = p.codigo and substring(dff.idcuno,2,5) = p.cuenta
left join [dbo].[DiferenciaDevolucionesAhorro] dv on dff.[FACTURA]=rtrim(dv.folio)
and dff.PCXPRC=rtrim(dv.producto) and dff.[PERIODO]=cast(dv.periodo as int)
where dff.[PERIODO]=254 and dff.[IDINVN]=32952059
--select * from historica..detalle where factura='32851565' and sucursal=7 and serie='FG'

--select * from detalle_fahorroFacturas where periodo =254 and idinvn in(32894988)
--select * from [DiferenciaDevolucionesAhorro] where periodo=254

--select * from [DiferenciaDevolucionesAhorro] where cast(periodo as int)=254
--16612
/*select dv.Folio,dv.Producto,dv.Unidades,dff.factura,dff.[PERIODO],dff.IDPRDC,dff.PCXPRC
 from  [dbo].[DiferenciaDevolucionesAhorro] dv
left join detalle_fahorroFacturas dff on rtrim(dv.folio)=rtrim(dff.[FACTURA])
and rtrim(dv.producto)=rtrim(dff.PCXPRC) --and cast(dv.periodo as int)=dff.[PERIODO]
where cast(dv.periodo as int)=254 and dff.factura is null  -- and rtrim(dv.folio)= '32894988'


select * from detalle_fahorroFacturas where [FACTURA]= 32927001

--32927001
select * from [dbo].[DiferenciaDevolucionesAhorro] where folio= 32927001 and cast(periodo as int)=254
select distinct tp.* from [dbo].[TotalPeriodoAhorro] tp where  tp.[remision] like '%32927001%'

update [dbo].[DiferenciaDevolucionesAhorro] set folio= '03009860' 
where folio= 3009860 and cast(periodo as int)=254

select IDINVN,FACTURA,PCXPRC,IDPRDC,dv.Folio,Producto,Unidades,p.orden,p.hash_md5
from detalle_fahorroFacturas dff 
left join #pedidos_spt_fahorro p on 
cast(isnull(dff.ihoref,'0') as int) = convert(int, replace(replace(p.orden, ' ', ''), '"', '')) 
and dff.idprdc = p.codigo and substring(dff.idcuno,2,5) = p.cuenta
left join [dbo].[DiferenciaDevolucionesAhorro] dv on dff.[FACTURA]=rtrim(dv.folio)
and dff.PCXPRC=rtrim(dv.producto) and dff.[PERIODO]=cast(dv.periodo as int)
where dff.FACTURA='32991584' and dff.PERIODO=254*/
END                            

--select * from pedidos_spt_fahorro where orden=43 and hash_md5='b081322660b00ca3201df54e66da1706' and cod_barras='7501287652683'
--7501287652683
--1

GO

