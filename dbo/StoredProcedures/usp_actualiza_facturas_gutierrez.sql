-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_actualiza_facturas_gutierrez]
AS
BEGIN
       -- SET NOCOUNT ON added to prevent extra result sets from
       -- interfering with SELECT statements. select  CONVERT(varchar,getdate()-2,112)
       SET NOCOUNT ON;    
declare @sqlQuery varchar(max)
declare @fecha varchar(8)
set @fecha=  CONVERT(varchar,getdate()-1,112)
CREATE TABLE #detalle_facturas(
       [SUCURSAL] [int] NOT NULL,
       [SERIE] [varchar](10) NULL,
       [IDCUNO] [char](11) NOT NULL ,
       [IDINVN] [numeric](12, 0) NOT NULL ,
       [FACTURA] [varchar](24) NOT NULL,
       [IDLINE] [numeric](5, 0) NOT NULL,
       [IDPRDC] [char](35) NOT NULL ,
       [PCXPRC] [numeric](13, 0) NULL,
       [IDDESC] [char](50) NOT NULL,
       [IDQTY] [numeric](15, 3) NOT NULL,
       [CF] [char](5) NOT NULL,
       [FARMACIA] [numeric](18, 4) NOT NULL,
	   [prec_pub][NUMERIC](18,4) NOT NULL,
       [UNITARIO] [numeric](18, 4) NOT NULL,
       [PRECIO_CANTIDAD] [numeric](13, 2) NOT NULL,
       [NETO_UNITARIO] [numeric](13, 2) NOT NULL,
       [NETO_CANTIDAD] [numeric](13, 2) NOT NULL,
       [IVA] [numeric](4, 2) NULL,
       [IEPS] [numeric](13, 2) NOT NULL,
       [IEPS_MONEDA] [numeric](13, 2) NULL,
       [TOTAL_IEPS] [numeric](13, 2) NULL,
       [IVA_MONEDA] [numeric](13, 2) NULL,
       [TOTAL_FINAL] [numeric](13, 2) NULL,
	   [OFERTA] [numeric](13, 2) NULL,
	   [DESCOFERTA] [numeric](13, 2) NULL,
       [FECHAPROG] [datetime2](7) null, 
       NOPEDIDO [VARCHAR](300) NULL,
	   [NATREG][VARCHAR](100) NULL,
	  
) 
set @sqlQuery= '
select CASE WHEN NOI.noz3lent=''''821'''' AND SUBSTRING(IDCUNO,1,1)=''''D'''' THEN CAST(''''04'''' AS INT) 
WHEN NOI.noz3lent=''''807'''' AND SUBSTRING(IDCUNO,1,1)=''''X'''' AND TRIM(SR.CMCSTS)=''''075'''' THEN CAST(''''24'''' AS INT) 
WHEN NOI.noz3lent=''''807'''' AND SUBSTRING(IDCUNO,1,1)=''''X'''' THEN CAST(''''23'''' AS INT) 
WHEN NOI.noz3lent=''''808'''' AND SUBSTRING(IDCUNO,1,1)=''''X'''' THEN CAST(''''24'''' AS INT) 
WHEN NOI.noz3lent=''''855'''' THEN CAST(''''09'''' AS INT) 
ELSE CAST(SUBSTRING(NOI.noz3lent,2,3)AS INT) 
END SUCURSAL,
(SELECT TRIM(LEZ3ISKC)AS LEZ3ISKC  FROM MA4620EF04.Z3BCTLLE WHERE LEZ3LENT = NOI.noz3lent) SERIE,
TRIM(IDCUNO) AS IDCUNO,IDINVN,
right(''''000000000000'''' || CAST(IDINVN AS varchar(12)), 8)as factura,
idline,IDPRDC
,decimal(PCXPRC,13,0) as PCXPRC,IDDESC,IDQTY,IDPCA5 as cf 
 ,round(IDSALP,2) as farmacia,T4.PSSALP AS prec_pub,
round(idnprc,2) as unitario,
cast(round(IDAMOU,2)as decimal(13,2)) as precio_cantidad ,
cast(round(IDNSVA/IDQTY,2) as decimal(13,2)) as neto_unitario
,cast(round(IDNSVA,2)as decimal(13,2)) as neto_cantidad
,T17.CTVATP as iva
,COALESCE(RMPESI,0) as IEPS
,cast((IDITET*(COALESCE(RMPESI,0)/100))as decimal(13,2)) as IEPS_MONEDA
,cast((IDITET+(IDITET*(COALESCE(RMPESI,0)/100)))as decimal(13,2)) as TOTAL_IEPS
,cast((IDNSVA+(IDNSVA*(COALESCE(RMPESI,0)/100)))*decimal((T17.CTVATP/100 ),5,2)as decimal(13,2)) as IVA_MONEDA
,cast(((IDITET+(IDITET*(COALESCE(RMPESI,0)/100))))+((IDNSVA+(IDNSVA*(COALESCE(RMPESI,0)/100)))*decimal((T17.CTVATP/100 ),5,2))as decimal(13,2)) as TOTAL_FINAL,
COALESCE(SROGDT.DTDCPR,0) as DTDCPR,
SUBSTR(CHAR((SELECT COALESCE(SUM(IDQTY * SROGDT.DTDCAM),0) FROM MA4620EF04.SRBGDT AS SROGDT 
WHERE  DTGDSQ = IDGDSQ AND SROGDT.DTDITY <> ''''H'''' AND SROGDT.DTDITY <> ''''3'''' AND SROGDT.DTDITY <> ''''O'''')),1,20) AS DescOferta,
TIMESTAMP(INSERT(INSERT(DIGITS(IHIDAT),5,0,''''-''''),8,0,''''-'''') || '''' 00:00:00.000'''') FECHAPROG,
TRIM(IFNULL(OHSURF,'''''''')) AS IHOREF,
NATREG 
from  MA4620EF04.SRBISD  
inner join MA4620EF04.SRBISH on IHINVN=IDINVN and IDCUNO=IHCUNO
inner join MA4620EF04.SRBSOH on IDORNO= OHORNO AND OHCUNO=IHCUNO 
inner join MA4620EF04.SRONAM ON IDCUNO=NANUM
INNER JOIN MA4620EF04.Z3BNOI NOI ON IDCUNO=NOI.NONUM
INNER JOIN MA4620EF04.SRBCMA SR ON IDCUNO=SR.CMCUNO 
LEFT JOIN MA4620EF04.SRBGDT AS SROGDT ON SROGDT.DTGDSQ = IDGDSQ AND SROGDT.DTDITY = ''''1'''' 
 LEFT JOIN MA4620EF04.SROPCR ON IDPRDC=PCIPRC AND PCXRTY=''''IA'''' 
 LEFT JOIN MA4620EF04.SRBVHC ON IDVAHC=HCVAHC 
 LEFT JOIN MA4620EF04.SROCTLFA T17 ON HCVATC=T17.CTVATC 
 left join MA4620EF04.SRBRPM as IPESH on IPESH.RPPRDC=IDPRDC 
 left join MA4620EF04.SRBCTLRM as IPESD on IPESD.RMMACO=IPESH.RPMACO 
 left join MA4620EF04.SROPRS T4 on IDPRDC = T4.PSPRDC AND T4.PSCCUR = ''''MXP'''' AND T4.PSUNIT = ''''PZA'''' AND T4.PSPRIL = ''''03''''
where IHTYPP=1 and  NANCA1 in(''''99963'''') and  IHIDAT>='+@fecha+'
 and IDNSVA<>0 and IDQTY <>0 and SUBSTRING(IDORDT,1,1) IN(''''F'''',''''R'''')
   order by IDINVN,IDLINE'



print(@sqlQuery)
print('select *  from openquery(as400, ''' + @sqlQuery + ''')')
insert into #detalle_facturas  execute('select *  from openquery(as400, ''' + @sqlQuery + ''')')

--SELECT *
--select replicate('0',7-len(IDCUNO))+cast(IDCUNO as varchar(20)) as cliente,
--substring(factura,2,7) as "Folio factura",
--'000000' as "clave producto",
--replicate('0',7-len(IDQTY))+cast(IDQTY as varchar(20)) as "Cantidad facturada",
--replace(replicate('0',11-len(FARMACIA+IEPS_MONEDA))+cast(FARMACIA+IEPS_MONEDA as varchar(20)),'.','.')  as "Presio facturado con IESPS",
--replace(replicate('0',11-len(DESCOFERTA))+cast(DESCOFERTA as varchar(30)),'.','.') as Oferta,
--replace(replicate('0',11-len(PRECIO_CANTIDAD-NETO_CANTIDAD))+cast(PRECIO_CANTIDAD-NETO_CANTIDAD as varchar(30)),'.','.') as Descuentos,
--case when CF ='B' OR CF ='H' OR CF = 'F' OR CF='O' or CF='N' 
-- THEN  '0000000000'
-- ELSE substring(replicate('0',11-len(cast((cast(FARMACIA*IDQTY-DESCOFERTA-(PRECIO_CANTIDAD-NETO_CANTIDAD) as decimal(8,2))*0.16) as nvarchar(30))))+cast((FARMACIA*IDQTY-DESCOFERTA-(PRECIO_CANTIDAD-NETO_CANTIDAD))*0.16 as nvarchar(30)),0,10) END AS "Iva mercancia",
----substring(replicate('0',11-len(cast((cast(precio_farm_sin_imp*piezas_surtidas_con_cargo-descto_oferta-descto_comercial as decimal(8,2))*0.16) as nvarchar(30))))+cast((precio_farm_sin_imp*piezas_surtidas_con_cargo-descto_oferta-descto_comercial)*0.16 as nvarchar(30)),0,10) as "Iva mercancia",
--substring(replicate('0',11-len( cast(cast((prec_pub*IDQTY-DESCOFERTA-(PRECIO_CANTIDAD-NETO_CANTIDAD))+(prec_pub*IDQTY-DESCOFERTA-(PRECIO_CANTIDAD-NETO_CANTIDAD))*0.16 as decimal(8,2)) as nvarchar(30)) )) +cast((prec_pub*IDQTY-DESCOFERTA-(PRECIO_CANTIDAD-NETO_CANTIDAD))+(prec_pub*IDQTY-DESCOFERTA-(PRECIO_CANTIDAD-NETO_CANTIDAD))*0.16  as nvarchar(30)),0,12) as "Importe",
--replace(replicate('0',5-len(OFERTA))+cast(OFERTA as varchar(30)),'.','.') as "Porcentaje oferta",
----replace(replicate('0',5-len(OFERTA))+cast(OFERTA as varchar(30)),'.','.') as "Descuento facturado",
--PCXPRC+' ' as "Amecop",
--replace(replicate('0',11-len(prec_pub+(prec_pub)*0.16))+cast(prec_pub+(prec_pub)*0.16 as varchar(30)),'.','.')as"Precio publico del producto",
--replicate('0',10-len(NOPEDIDO))+cast(NOPEDIDO as varchar(20)) as "Orden de compra",
--replace(cast(FECHAPROG as date),'-','')as "fecha facturacion",
--'0000000' as "Oferta sin cargo",
--'0000000' as "Bulto donde va producto"
--from #detalle_facturas where factura= 1170735  
--drop table #detalle_facturas 


-----------------------------------------------------------------------------------------------
-- Actualizar detalle de facturas
-----------------------------------------------------------------------------------------------
	   insert into detalle_facturas_gutierrez
       --select distinct SUCURSAL,SERIE,IDCUNO,IDINVN,FACTURA,IDLINE,IDPRDC,PCXPRC,IDDESC,IDQTY,CF,FARMACIA,UNITARIO,
       --PRECIO_CANTIDAD,NETO_UNITARIO,NETO_CANTIDAD,IVA,IEPS,IEPS_MONEDA,TOTAL_IEPS,IVA_MONEDA,TOTAL_FINAL,FECHAPROG,cast((PRECIO_CANTIDAD-NETO_CANTIDAD)as numeric(13,2)),GETDATE(),NOPEDIDO
       --from #detalle_facturas where IDINVN not in(select IDINVN from monkeyland.[dbo].[detalle_facturas] )--where convert(varchar,FECHAPROG,112)>=@fecha)
       select distinct d.SUCURSAL,d.SERIE,d.IDCUNO,d.IDINVN,d.FACTURA,d.IDLINE,d.IDPRDC,d.PCXPRC,d.IDDESC,d.IDQTY,d.CF,d.FARMACIA,d.prec_pub,d.UNITARIO,
       d.PRECIO_CANTIDAD,d.NETO_UNITARIO,d.NETO_CANTIDAD,d.IVA,d.IEPS,d.IEPS_MONEDA,d.TOTAL_IEPS,d.IVA_MONEDA,d.TOTAL_FINAL,d.OFERTA,d.DESCOFERTA,d.FECHAPROG,
       cast((d.PRECIO_CANTIDAD-d.NETO_CANTIDAD)as numeric(13,2)),GETDATE(),d.NOPEDIDO,1 AS ESTATUS,1 as ESTATUSD,GETDATE(), d.NATREG  
       from #detalle_facturas d
       left join  detalle_facturas_gutierrez d1 on d.IDINVN=d1.IDINVN
       where d1.IDINVN is null    
       drop table #detalle_facturas   
    --   --delete Conciliacion.[dbo].detalle_facturas where IDCUNO in ('99004','99139', '99044', '99032') and convert(varchar,FECHAPROG,112)>=convert(varchar,getdate()-2,112)

	   -- select * from detalle_facturas_gutierrez order by FECHAPROG desc
END

GO

