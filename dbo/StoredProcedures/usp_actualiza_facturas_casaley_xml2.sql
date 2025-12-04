
CREATE PROCEDURE [dbo].[usp_actualiza_facturas_casaley_xml2]
AS
BEGIN
       -- SET NOCOUNT ON added to prevent extra result sets from
       -- interfering with SELECT statements. select  CONVERT(varchar,getdate()-2,112)
       SET NOCOUNT ON;    
declare @sqlQuery varchar(max)
declare @fecha varchar(8)
set @fecha=  CONVERT(varchar,getdate()-1,112)

CREATE TABLE #detalle_benavides(
       [SUCURSAL] [int] NOT NULL,
       [SERIE] [varchar](10) NULL,
       [IDCUNO] [char](11) NOT NULL ,
	   [NATREG] [char](50) NOT NULL ,
       [IDINVN] [numeric](12, 0) NOT NULL ,
       [FACTURA] [varchar](24) NOT NULL,
       [IDLINE] [numeric](5, 0) NOT NULL,
       [IDPRDC] [char](35) NOT NULL ,
       [PCXPRC] [numeric](13, 0) NULL,
       [IDDESC] [char](50) NOT NULL,
       [IDQTY] [numeric](15, 3) NOT NULL,
       [CF] [char](5) NOT NULL,
       [FARMACIA] [numeric](18, 4) NOT NULL,
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
       [FECHAPROG] [datetime2](7) null, 
       NOPEDIDO [VARCHAR](300) NULL
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
TRIM(IDCUNO) AS IDCUNO,NATREG,IDINVN,
right(''''000000000000'''' || CAST(IDINVN AS varchar(12)), 8)as factura,
idline,IDPRDC
,decimal(PCXPRC,13,0) as PCXPRC,IDDESC,IDQTY,IDPCA5 as cf 
 ,round(IDSALP,2) as farmacia,
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
TIMESTAMP(INSERT(INSERT(DIGITS(IHIDAT),5,0,''''-''''),8,0,''''-'''') || '''' 00:00:00.000'''') FECHAPROG,
TRIM(IFNULL(OHSURF,'''''''')) AS IHOREF
from  MA4620EF04.SRBISD  
inner join MA4620EF04.SRBISH on IHINVN=IDINVN and IDCUNO=IHCUNO
inner join MA4620EF04.SRBSOH on IDORNO= OHORNO AND OHCUNO=IHCUNO 
inner join MA4620EF04.SRONAM ON IDCUNO=NANUM
INNER JOIN MA4620EF04.Z3BNOI NOI ON IDCUNO=NOI.NONUM
INNER JOIN MA4620EF04.SRBCMA SR ON IDCUNO=SR.CMCUNO 
 LEFT JOIN MA4620EF04.SROPCR ON IDPRDC=PCIPRC AND PCXRTY=''''IA'''' 
 LEFT JOIN MA4620EF04.SRBVHC ON IDVAHC=HCVAHC 
 LEFT JOIN MA4620EF04.SROCTLFA T17 ON HCVATC=T17.CTVATC 
 left join MA4620EF04.SRBRPM as IPESH on IPESH.RPPRDC=IDPRDC 
 left join MA4620EF04.SRBCTLRM as IPESD on IPESD.RMMACO=IPESH.RPMACO 
 where IHTYPP=1 and  NANCA1 in(''''99610'''') and IHIDAT>='+@fecha+' 
 and IDNSVA<>0 and IDQTY <>0 and SUBSTRING(IDORDT,1,1) IN(''''F'''',''''R'''')
   order by IDINVN,IDLINE'
--print(@sqlQuery)
print('select *  from openquery(as400, ''' + @sqlQuery + ''')')
insert into #detalle_benavides  execute('select *  from openquery(as400, ''' + @sqlQuery + ''')')

insert into detacasaley

       select distinct
	   d.SUCURSAL,
	   d.SERIE,
	   d.IDCUNO,
	   d.NATREG,
	   d.IDINVN,
	   d.FACTURA,
	   d.IDLINE,
	   d.IDPRDC,
	   d.PCXPRC,
	   d.IDDESC,
	   d.IDQTY,
	   d.CF,
	   d.FARMACIA,
	   d.UNITARIO,
       d.PRECIO_CANTIDAD,
	   d.NETO_UNITARIO,
	   d.NETO_CANTIDAD,
	   d.IVA,
	   d.IEPS,
	   d.IEPS_MONEDA,
	   d.TOTAL_IEPS,
	   d.IVA_MONEDA,
	   d.TOTAL_FINAL,
	   d.FECHAPROG,
       d.NOPEDIDO--,d1.IDINVN
       from #detalle_benavides d
       left join  monkeyland.[dbo].[detacasaley] d1 on d.IDINVN = d1.IDINVN
       where d1.IDINVN is null    
       drop table #detalle_benavides   
       delete monkeyland..detacasaley where IDCUNO='99610' and convert(varchar,FECHAPROG,112)>=convert(varchar,getdate()-2,112)
END

GO

