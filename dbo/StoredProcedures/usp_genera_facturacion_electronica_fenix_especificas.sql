-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_genera_facturacion_electronica_fenix_especificas] @fecha varchar(10)='', @sucursal char(2)=''
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

--declare @total_del_registro int

--select @total_del_registro = count(*) from
--facturacion_electronica_estandar t1 --inner join series_facturacion t2 on t1.sucursal = t2.sucursal
--inner join maestro_productos t3 on t1.codigo = t3.codigo 
--left outer join CatTiendasFenix t4 on t1.sucursal = t4.sucursal and t1.cliente = t4.cliente
--inner join sucursales s ON s.sucursal = t1.sucursal
--where t1.sucursal=5 and factura in (1605723,1605725,1605726,1605727,1605728,1612109,1612112,1612113,1612114) or
--	  t1.sucursal=6 and factura in (1644162,1644164,1644165,1665673,1695883,1695884,1695885,1695886,1695887,1695888,1695889,1695890,1695891,1695892,1695893,1695894,1695895,1695896,1695897,1695898,1695899,1695900,1695901,1695902,1695903,1695904,1695905,1695906,1695907,1695908,1695909,1695910,1695911,1695912,1695913,1695914,1695915,1695916,1695917,1695918,1695919,1695920,1695921,1695922,1695923,1695924,1695925,1695926,1695927,1695928,1695929,1695930,1704432,1704433,1704434,1704435,1704436,1704437,1704438,1704439,1704440,1704441,1704442,1704443,1704444,1704445,1704446,1704447,1704448,1704449,1704450,1704451,1704452,1704453,1704454,1704455,1704456,1704457,1704458,1704459,1704460,1704461,1704462,1704463,1704464,1704465,1704466,1704467,1704468,1704469,1704470,1704471,1704472,1704473,1704474,1704475,1704476,1704477) or
--	  t1.sucursal=16 and factura in (466109,466110,466111,466112,466113,466114,467877,467878,467879,467880,467881,467882) or
--      t1.sucursal=17 and factura in (1988114,1988115,1988116,1988117,1988118,1988120,1988153,1988154,1988155,1988156,1988157,1988158,2057243,2057244,2057245,2057246,2057807,2057808,2057809,2057810,2057811,2057812,2057813,2057814,2057815,2059380,2059381,2059382,2059383,2060393,2060394,2060395,2062778,2062779,2066989,2066990,2067549,2067550,2067551,2067552,2067553,2067554,2067555,2067556,2067557,2071119,2071120,2071971,2071972,2074210,2074211,2076980,2076981,2078249,2078250) or
--      t1.sucursal=18 and factura in (772355,772356,772357,772358,776205,776206,776207,776208) or
--      t1.sucursal=21 and factura in (2233167,2233177,2233489,2293175,2293210,2364354,2364381,2388572,2422264,2422265,2422267,2422267,2448810,2448812,2473151,2473152,2473153,2473154,2500784,2520316,2532852)

--		select
--		'C00500' + 
--		convert(varchar(8), t1.fecha_factura, 112) + 
--		right('000000' + convert(varchar(6), @total_del_registro), 6) +
--		'                                                                                          C:' +
--		right(replicate('0',9)+isnull(t4.numtienda,'0'),9) + 
--		replicate(' ',99) + 
--		'F' +
--		--left(s.serie_cfd + right(t1.folio_fiscal,8),10) +
--		--modificacion para quitar cerros, a peticion de farmacias fenix
--		--left(s.serie_cfd + right(cast(cast(t1.folio_fiscal as int)as char(8)),8),10)+
--		--modificacion de la serie para la factura, capa intermedia aun utiliza sucursal 4
--		--por razones de integridad de datos, por lo que las facturas salen como FD
--		--pero tienen que salir como FU
--		case 
--		--la fecha esta asi por que hay facturas fiscales entregadas con FD por lo que
--		--las entregas de esos dias tiene que ir con FD y no FU
--		when convert(datetime, @fecha, 121)>=convert(datetime,'20130107',121)
--		then left(case when s.serie_cfd='FD' then 'FU' else s.serie_cfd end + right(cast(cast(t1.folio_fiscal as int)as char(8)),8),10)
--		else left(s.serie_cfd + right(cast(cast(t1.folio_fiscal as int)as char(8)),8),10)
--		end +
--		'000005' +
--		convert(varchar(8), t1.fecha_factura, 112) + 
--		right('000000000000' + convert(varchar(20), convert(bigint, t1.importe_neto * 100)), 12)+
--		right('000000000000' + convert(varchar(20), convert(bigint, t1.descto_comercial * 100)), 12) +
--		right('000000000000' + convert(varchar(20), convert(bigint, (t1.importe_bruto - t1.descto_oferta) * 100)), 12) +
--		right('000000000000' + convert(varchar(20), convert(bigint, 100 * t1.iva)), 12) + 
--		right('000000000000' + convert(varchar(20), case t3.grupo_est when 'PC01A' then convert(bigint, 100 * (t1.importe_bruto * 0.5)) else 0 end), 12)   +  --ieps
--		right('000000' + convert(varchar(6), t1.piezas_surtidas_con_cargo + t1.piezas_surtidas_sin_cargo), 6) + 
--		'                  A' + 
--		case t1.porcentaje_iva when 0 then right('00000000000' + convert(varchar(20), convert(bigint, 100 * convert(money, t1.importe_bruto - t1.descto_oferta))), 11) else '00000000000' end +
--		case t1.porcentaje_iva when 0 then right('00000000000' + convert(varchar(20), convert(bigint, 100 * t1.desc_comerc_prod)), 11) else '00000000000' end +
--		case t1.porcentaje_iva when s.porcentaje_iva then right('00000000000' + convert(varchar(20), convert(bigint, 100 * convert(money, t1.importe_bruto - t1.descto_oferta))), 11) else '00000000000' end +
--		case t1.porcentaje_iva when s.porcentaje_iva then right('00000000000' + convert(varchar(20), convert(bigint, 100 * t1.iva)), 11) else '00000000000' end + 
--		'0000000000000000000000000000000000000000000000' +
--		'0001' +
--		'00000' +
--		'           P' + 
--		'0' + t1.codigo +
--		right('000000' + convert(varchar(6), t1.piezas_surtidas_con_cargo), 6) +
--		right('000000' + convert(varchar(6), t1.piezas_surtidas_sin_cargo), 6) +
--		'00000' +
--		right('00000000' + convert(varchar(10), convert(bigint, 100 * t1.precio_farm_sin_imp)), 8) +
--		right('00000000' + convert(varchar(10), convert(bigint, 100 * t1.precio_pub_sin_imp)), 8) +
--		right('00000000' + convert(varchar(10), convert(bigint, 100 * t1.precio_farm_sin_imp * t1.piezas_surtidas_con_cargo)), 8) +
--		right('00000000' + convert(varchar(10), convert(bigint, 100 * t1.precio_pub_sin_imp * t1.piezas_surtidas_con_cargo)), 8) +
--		right('00000000' + convert(varchar(10), convert(bigint, 100 * t1.iva * t1.piezas_surtidas_con_cargo)), 8) +
--		case t3.grupo_est when 'PC01A' then right('00000000' + convert(varchar(12), convert(bigint, 100 * convert(money, precio_farm_sin_imp * 0.50))), 8) else '00000000' end +
--		'              10' +
--		t1.cod_barras +
--		right('0000' + convert(varchar(4), convert(int, porcentaje_utilidad * 100)), 4)  + 
--		'  ' + 
--		case left(t3.clas_fis, 1) when 'N' then '*' else ' '  end +
--		right('  ' + convert(varchar(2), isnull(t4.compania, 0)), 2) + 
--		'0' + isnull(t4.numtienda,'00000000') + 
--		'0500'
--		from
--			facturacion_electronica_estandar t1 --inner join series_facturacion t2 on t1.sucursal = t2.sucursal
--			inner join maestro_productos t3 on t1.codigo = t3.codigo 
--			--left outer join CatTiendasFenix t4 on t1.sucursal = t4.sucursal and t1.cliente = t4.cliente
--			left outer join CatTiendasFenix t4 on t1.sucursal =  case when t4.sucursal=1 then 21 else t4.sucursal end and t1.cliente = t4.cliente
--			inner join sucursales s ON s.sucursal = t1.sucursal
--where --t1.sucursal=5 and factura in (1457304,1457305) or
--	  --t1.sucursal=6 and factura in (1767328) or
--	  --t1.sucursal=16 and factura in () or
--      --t1.sucursal=17 and factura in (2124569,2124570) or
--      --t1.sucursal=18 and factura in () or
--      t1.sucursal=21 and factura in (1631259)

declare @total as int

select 
'C00500'+
Rtrim(ididat) as a,
'                                                                                          C:'+
right(replicate('0',9)+isnull(Rtrim(num_tienda),'0'),9)+
replicate(' ',99) + 
'F'+SERIE+SUBSTRING(cast(IDINVN as varchar),6,7)+
' 000005' +
Rtrim(ididat)+
right('000000000000' + convert(varchar(20), convert(bigint,  precio_cantidad* 100)), 12) +
right('000000000000' + convert(varchar(20), convert(bigint, (precio_cantidad - neto_cantidad) * 100)), 12) +
right('000000000000' + convert(varchar(20), convert(bigint, (neto_cantidad) * 100)), 12) +
right('000000000000' + convert(varchar(20), convert(bigint, 100 * iva_moneda)), 12) +
right('000000000000' + convert(varchar(20), convert(bigint, 100 * ieps_moneda)), 12) +
right('000000' + convert(varchar(6), cast(IDQTY as int)), 6) +
'                  A' + 
right('00000000000' + convert(varchar(20), convert(bigint, 100 * neto_cantidad)), 11)+
right('00000000000' + convert(varchar(20), convert(bigint, 100 * (precio_cantidad - neto_cantidad))), 11)+
'00000000000'+
'00000000000'+
'0000000000000000000000000000000000000000000000'+
'0001' +
'00000' +
'           P'+
right(replicate('0',8)+Rtrim(isnull(IDPRDC,'0')),8)+
right('000000' + convert(varchar(6), CAST(IDQTY as bigint)), 6) +
right('000000' + convert(varchar(6), CAST(0 as bigint)), 6) +
'00000'+
right('00000000' + convert(varchar(10), convert(bigint, 100 * farmacia)), 8)+
right('00000000' + convert(varchar(10), convert(bigint, 100 * PSSALP)), 8)+
right('00000000' + convert(varchar(10), convert(bigint, 100 * precio_cantidad)), 8)+
right('00000000' + convert(varchar(10), convert(bigint, 100 * PSSALP * IDQTY)), 8)+
right('00000000' + convert(varchar(10), convert(bigint, 100 * iva_moneda)), 8) +
right('00000000' + convert(varchar(10), convert(bigint, 100 * IEPS_moneda)), 8)+
'              10' +
right('0000000000000'+cast(PCXPRC as varchar),13)+
right('0000' + convert(varchar(4), convert(int, ((10000*(1-(NETO_unitario/PSSALP)))))), 4)+
'  ' + 
case left(CF, 1) when 'N' then '*' WHEN 'F' then '*' else ' '  end +
right('  ' + convert(varchar(2), isnull(compania, 0)), 2) + 
right(replicate('0',8)+isnull(Rtrim(num_tienda),'0'),8)+ 
'0500' as b
into #facturas_temporal_fenix
 from openquery(AS400,'
select 
(SELECT TRIM(LEZ3ISKC)AS LEZ3ISKC  FROM MA4620EF04.Z3BCTLLE WHERE LEZ3LENT = NOI.noz3lent) SERIE,
IDORNO,ididat,OHCUNO,IDINVN,idline,IDPRDC,decimal(PCXPRC,13,0) as PCXPRC,IDDESC,IDQTY,IDPCA5 as cf 
,round(IDSALP,2) as farmacia, 
round(idnprc,2) as unitario,round(IDAMOU,2) as precio_cantidad ,round(IDNSVA/IDQTY,2) as neto_unitario 
,round(IDNSVA,2) as neto_cantidad 
,T17.CTVATP as iva 
,COALESCE(RMPESI,0) as IEPS 
,(IDITET*(COALESCE(RMPESI,0)/100)) as IEPS_MONEDA 
,(IDITET+(IDITET*(COALESCE(RMPESI,0)/100))) as TOTAL_IEPS 
,(IDNSVA+(IDNSVA*(COALESCE(RMPESI,0)/100)))*decimal((T17.CTVATP/100 ),5,2) as IVA_MONEDA 
,((IDITET+(IDITET*(COALESCE(RMPESI,0)/100))))+((IDNSVA+(IDNSVA*(COALESCE(RMPESI,0)/100)))*decimal((T17.CTVATP/100 ),5,2)) as TOTAL_FINAL 
,OHSURF,nanca1,PSSALP,ADMXGLNC as num_tienda,''04'' as compania
from MA4620EF04.SRBSOH 
INNER JOIN MA4620EF04.SRONAM ON OHCUNO=NANUM 
INNER join MA4620EF04.srbISD ON OHORNO=IDORNO 
LEFT JOIN MA4620EF04.SRBPRS ON IDPRDC=PSPRDC and PSPRIL=''03''
LEFT JOIN MA4620EF04.SROPCR ON IDPRDC=PCIPRC AND PCXRTY=''IA''
LEFT JOIN MA4620EF04.SRBVHC ON IDVAHC=HCVAHC 
LEFT JOIN MA4620EF04.SROCTLFA T17 ON HCVATC=T17.CTVATC 
left join MA4620EF04.SRBRPM as IPESH on IPESH.RPPRDC=IDPRDC 
left join MA4620EF04.SRBCTLRM as IPESD on IPESD.RMMACO=IPESH.RPMACO 
INNER JOIN MA4620EF04.Z3BNOI NOI ON IDCUNO=NOI.NONUM
inner join MA4620EF04.MXONAD on ADNUM=OHCUNO and ADADNO=2
where IDINVN= ''821001631259'' order by IDINVN,decimal(PCXPRC,13,0)
')
  
select @total=@@ROWCOUNT
  
select a+right('000000' + convert(varchar(6), @total), 6)+b from #facturas_temporal_fenix
  
drop table #facturas_temporal_fenix


END

GO

