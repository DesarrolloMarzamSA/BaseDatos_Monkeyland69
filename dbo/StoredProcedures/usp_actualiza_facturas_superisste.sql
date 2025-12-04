
CREATE PROCEDURE    [dbo].[usp_actualiza_facturas_superisste]
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
	[IDCUNO] [varchar](11) NOT NULL,
	[IDINVN] [numeric](12, 0) NOT NULL,
	[FACTURA] [varchar](24) NOT NULL,
	[IDLINE] [numeric](5, 0) NOT NULL,
	[IDPRDC] [char](35) NOT NULL,
	[PCXPRC] [numeric](13, 0) NULL,
	[IDDESC] [char](50) NOT NULL,
	[IDQTY] [numeric](15, 3) NOT NULL,
	[CF] [char](5) NOT NULL,
	[FARMACIA] [numeric](17, 4) NOT NULL,
	[UNITARIO] [numeric](17, 4) NOT NULL,
	[PRECIO_CANTIDAD] [numeric](17, 4) NOT NULL,
	[NETO_UNITARIO] [numeric](31, 15) NOT NULL,
	[NETO_CANTIDAD] [numeric](17, 4) NOT NULL,
	[IVA] [numeric](16, 3) NULL,
	[IEPS] [numeric](13, 3) NOT NULL,
	[IEPS_MONEDA] [numeric](31, 23) NULL,
	[TOTAL_IEPS] [numeric](31, 23) NULL,
	[IVA_MONEDA] [numeric](31, 26) NULL,
	[TOTAL_FINAL] [numeric](31, 27) NULL,
	[FECHAPROG] [datetime2](7) NOT NULL,
	[NOPEDIDO] [VARCHAR](300) NULL
) ON [PRIMARY]
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
 ,IDSALP as farmacia,
idnprc as unitario,
IDAMOU as precio_cantidad ,
IDNSVA/IDQTY as neto_unitario
,IDNSVA as neto_cantidad
,T17.CTVATP as iva
,COALESCE(RMPESI,0) as IEPS
,(IDITET*(COALESCE(RMPESI,0)/100)) as IEPS_MONEDA
,(IDITET+(IDITET*(COALESCE(RMPESI,0)/100))) as TOTAL_IEPS
,(IDNSVA+(IDNSVA*(COALESCE(RMPESI,0)/100)))*decimal((T17.CTVATP/100 ),5,3) as IVA_MONEDA
,((IDITET+(IDITET*(COALESCE(RMPESI,0)/100))))+((IDNSVA+(IDNSVA*(COALESCE(RMPESI,0)/100)))*decimal((T17.CTVATP/100 ),5,3)) as TOTAL_FINAL,
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
 where IHTYPP=1 and  NANCA1 in(''''99947'''') and IHIDAT>='+@fecha+' 
 and IDNSVA<>0 and IDQTY <>0 and SUBSTRING(IDORDT,1,1) IN(''''F'''',''''R'''')
   order by IDINVN,IDLINE'
--print(@sqlQuery)
--print('select *  from openquery(as400, ''' + @sqlQuery + ''')')
insert into #detalle_benavides
execute ('select *   from openquery(as400, ''' + @sqlQuery + ''')')
 --select * from #detalle_benavides
 --drop table #detalle_benavides
insert into monkeyland.[dbo].[detalle_superisste]
       --select distinct SUCURSAL,SERIE,IDCUNO,IDINVN,FACTURA,IDLINE,IDPRDC,PCXPRC,IDDESC,IDQTY,CF,FARMACIA,UNITARIO,
       --PRECIO_CANTIDAD,NETO_UNITARIO,NETO_CANTIDAD,IVA,IEPS,IEPS_MONEDA,TOTAL_IEPS,IVA_MONEDA,TOTAL_FINAL,FECHAPROG,cast((PRECIO_CANTIDAD-NETO_CANTIDAD)as numeric(13,2)),GETDATE(),NOPEDIDO
       --from #detalle_benavides where IDINVN not in(select IDINVN from monkeyland.[dbo].[detalle_benavides] )--where convert(varchar,FECHAPROG,112)>=@fecha)
       select distinct d.SUCURSAL,d.SERIE,d.IDCUNO,d.IDINVN,d.FACTURA,d.IDLINE,d.IDPRDC,d.PCXPRC,d.IDDESC,d.IDQTY,d.CF,d.FARMACIA,d.UNITARIO,
       d.PRECIO_CANTIDAD,d.NETO_UNITARIO,d.NETO_CANTIDAD,d.IVA,d.IEPS,d.IEPS_MONEDA,d.TOTAL_IEPS,d.IVA_MONEDA,d.TOTAL_FINAL,d.FECHAPROG,
       cast((d.PRECIO_CANTIDAD-d.NETO_CANTIDAD)as numeric(17,4)),GETDATE(),d.NOPEDIDO,1 AS ESTATUS,1 as ESTATUSD,GETDATE()--,d1.IDINVN
       from #detalle_benavides d
       left join  monkeyland.[dbo].[detalle_superisste] d1 on d.IDINVN=d1.IDINVN
       where d1.IDINVN is null    
       drop table #detalle_benavides   
       delete monkeyland..detalle_superisste where IDCUNO='G05961' and convert(varchar,FECHAPROG,112)>=convert(varchar,getdate()-2,112)
END

GO

