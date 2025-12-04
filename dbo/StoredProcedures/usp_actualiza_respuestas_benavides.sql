CREATE PROCEDURE [dbo].[usp_actualiza_respuestas_benavides]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements. select  CONVERT(varchar,getdate()-2,112)
	SET NOCOUNT ON;    
declare @sqlQuery varchar(max)
declare @fecha varchar(8)
set @fecha=  CONVERT(varchar,getdate()-1,112)
CREATE TABLE #detalle_respuesta_benavides(
	[SUCURSAL] [int] NOT NULL,
	[SERIE] [varchar](10) NOT NULL,
	[IDCUNO] [varchar](11) NOT NULL,
	[IDINVN] [numeric](12, 0) NOT NULL,
	[IDLINE] [numeric](5, 0) NOT NULL,
	[IDPRDC] [char](35) NOT NULL,
	[PCXPRC] [numeric](13, 0) NULL,
	[IDDESC] [char](50) NOT NULL,
	[IDQTY] [numeric](15, 3) NOT NULL,
	[FECHAPROG] [datetime2](7) NOT NULL,
	[IHOREF] [varchar](35) NOT NULL)
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
idline,IDPRDC
,decimal(PCXPRC,13,0) as PCXPRC,IDDESC,IDQTY, 
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
 where IHTYPP=1 and  NANCA1 in(''''99319'''',''''99199'''') and IHIDAT>='+@fecha+'   order by IDINVN,IDLINE'
 --print(@sqlQuery)
 --execute('select * into detalle_respuesta_benavides from openquery(as400, ''' + @sqlQuery + ''')')
 insert into #detalle_respuesta_benavides  execute('select *  from openquery(as400, ''' + @sqlQuery + ''')')
 insert into monkeyland.dbo.detalle_respuesta_benavides
	--select distinct [SUCURSAL],[SERIE],ltrim(rtrim([IDCUNO])),[IDINVN],[IDLINE],ltrim(rtrim([IDPRDC])),
	--[PCXPRC],[IDDESC],[IDQTY],[FECHAPROG],[IHOREF],getdate()
	--from #detalle_respuesta_benavides where IDINVN not in(select IDINVN from monkeyland.dbo.detalle_respuesta_benavides )
	select distinct r.[SUCURSAL],r.[SERIE],ltrim(rtrim(r.[IDCUNO])),r.[IDINVN],r.[IDLINE],ltrim(rtrim(r.[IDPRDC])),
		r.[PCXPRC],r.[IDDESC],r.[IDQTY],r.[FECHAPROG],r.[IHOREF],getdate()--,r1.IDINVN
	from #detalle_respuesta_benavides r	left join monkeyland.dbo.detalle_respuesta_benavides r1 on r.IDINVN=r1.IDINVN
	where r1.IDINVN is null
	drop table #detalle_respuesta_benavides   
	--delete from  monkeyland.dbo.detalle_respuesta_benavides
	--select * from  monkeyland.dbo.detalle_respuesta_benavides
END

GO

