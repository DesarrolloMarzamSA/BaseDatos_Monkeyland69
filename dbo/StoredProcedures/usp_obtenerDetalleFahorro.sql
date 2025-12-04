-- =============================================
-- Author:		Marco Andrade
-- Create date: 01-12-2017
-- Description:	obtiene detalle de Facturacion de Farmacias del ahorro
-- en base a la fecha indicada en la variable @fecha 
-- precio farmacia, unitario, neto, oferta, desc comercial, IVA, IEPS, EAN etc..
-- =============================================
CREATE PROCEDURE [dbo].[usp_obtenerDetalleFahorro]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	declare @fecha varchar(10)
	set @fecha=  convert(varchar(10),getdate()-1,112)
	
CREATE TABLE #detalle_fahorroFacturas(
	[SUCURSAL] [int] NOT NULL,
	[SERIE] [varchar](10) NULL,
	[IDCUNO] [varchar](12) NOT NULL,
	[NANCA1] [varchar](11) NOT NULL,
	[IDINVN] [numeric](12, 0) NOT NULL,
	[FACTURA] [varchar](24) NOT NULL,
	[IDLINE] [numeric](5, 0) NOT NULL,
	[IDPRDC] [char](35) NOT NULL,
	[PCXPRC] [numeric](13, 0) NULL,
	[IDDESC] [char](50) NOT NULL,
	[IDQTY] [numeric](15, 3) NOT NULL,
	[CF] [char](5) NOT NULL,
	[FARMACIA] [numeric](18, 4) NOT NULL,
	[UNITARIO] [numeric](18, 4) NOT NULL,
	[PUBLICO] [numeric](18, 4) NOT NULL,
	[PRECIO_CANTIDAD] [numeric](13, 2) NOT NULL,
	[NETO_UNITARIO] [numeric](13, 2) NOT NULL,
	[NETO_CANTIDAD] [numeric](13, 2) NOT NULL,
	[IVA] [numeric](4, 2) NULL,
	[IEPS] [numeric](13, 2) NOT NULL,
	[IEPS_MONEDA] [numeric](13, 2) NULL,
	[TOTAL_IEPS] [numeric](13, 2) NULL,
	[IVA_MONEDA] [numeric](13, 2) NULL,
	[TOTAL_FINAL] [numeric](13, 2) NULL,
	[DTDCPR] [numeric](13, 2) NOT NULL,
	[DESCOFERTA] [char](20) NULL,
	[DESCCOMERCIAL] [varchar](15) NULL,
	[DescComercialPesos] [char](20) NULL,
	[IDGDSQ] [numeric](15, 0) NOT NULL,
	[FECHAPROG] [datetime2](7) NOT NULL,
	[IHOREF] [varchar](35) NOT NULL,
	[NATREG] [char](16) NOT NULL,
	[HashCode] bigint null
) 
CREATE NONCLUSTERED INDEX ix_tempNCIndexBef ON #detalle_fahorroFacturas ([HashCode],[IDINVN]);


declare @sqlQuery varchar(max)
  set @sqlQuery= 'select CASE WHEN NOI.noz3lent=''''821'''' AND SUBSTRING(IDCUNO,1,1)=''''D'''' THEN CAST(''''04'''' AS INT) 
WHEN NOI.noz3lent=''''807'''' AND SUBSTRING(IDCUNO,1,1)=''''X'''' AND TRIM(SR.CMCSTS)=''''075'''' THEN CAST(''''24'''' AS INT) 
WHEN NOI.noz3lent=''''807'''' AND SUBSTRING(IDCUNO,1,1)=''''X'''' THEN CAST(''''23'''' AS INT) 
WHEN NOI.noz3lent=''''808'''' AND SUBSTRING(IDCUNO,1,1)=''''X'''' THEN CAST(''''24'''' AS INT) 
WHEN NOI.noz3lent=''''855'''' THEN CAST(''''09'''' AS INT) 
ELSE CAST(SUBSTRING(NOI.noz3lent,2,3)AS INT) 
END SUCURSAL,
(SELECT TRIM(LEZ3ISKC)AS LEZ3ISKC  FROM MA4620EF04.Z3BCTLLE WHERE LEZ3LENT = NOI.noz3lent) SERIE,
TRIM(IDCUNO) AS IDCUNO,NANCA1,IDINVN,
right(''''000000000000'''' || CAST(IDINVN AS varchar(12)), 8)as factura,
idline,IDPRDC
,decimal(PCXPRC,13,0) as PCXPRC,IDDESC,IDQTY,IDPCA5 as cf 
 ,round(IDSALP,2) as farmacia,
round(idnprc,2) as unitario,
round(T2.PSSALP,2) as publico,
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
(SELECT TRIM(COALESCE(DTDCPR,0)) 
               FROM   MA4620EF04.SROGDT AS SROGDT 
               WHERE  SROGDT.DTGDSQ = IDGDSQ AND 
                      SROGDT.DTDITY = ''''H'''') as DESCCOMERCIAL,
SUBSTR(CHAR((SELECT COALESCE(SUM(DTHDCA),0) 
               FROM   MA4620EF04.SROGDT AS SROGDT 
               WHERE  SROGDT.DTGDSQ = IDGDSQ AND 
                      SROGDT.DTDITY = ''''H'''')),1,20) 
                          AS "DescComercialPesos", IDGDSQ,
TIMESTAMP(INSERT(INSERT(DIGITS(IHIDAT),5,0,''''-''''),8,0,''''-'''') || '''' 00:00:00.000'''') FECHAPROG,
TRIM(IFNULL(OHSURF,'''''''')) AS IHOREF,
NATREG 
from  MA4620EF04.SRBISD  
inner join MA4620EF04.SRBISH on IHINVN=IDINVN and IDCUNO=IHCUNO
inner join MA4620EF04.SRBSOH on IDORNO= OHORNO AND OHCUNO=IHCUNO 
inner join MA4620EF04.SRONAM ON IDCUNO=NANUM
INNER JOIN MA4620EF04.Z3BNOI NOI ON IDCUNO=NOI.NONUM
INNER JOIN MA4620EF04.SRBCMA SR ON IDCUNO=SR.CMCUNO 
INNER JOIN MA4620EF04.SRBPRS T2 ON IDPRDC = T2.PSPRDC AND T2.PSUNIT = ''''PZA'''' AND T2.PSPRIL = ''''03'''' 
LEFT JOIN MA4620EF04.SRBGDT AS SROGDT ON SROGDT.DTGDSQ = IDGDSQ AND SROGDT.DTDITY = ''''1'''' 
 LEFT JOIN MA4620EF04.SROPCR ON IDPRDC=PCIPRC AND PCXRTY=''''IA'''' 
 LEFT JOIN MA4620EF04.SRBVHC ON IDVAHC=HCVAHC 
 LEFT JOIN MA4620EF04.SROCTLFA T17 ON HCVATC=T17.CTVATC 
 left join MA4620EF04.SRBRPM as IPESH on IPESH.RPPRDC=IDPRDC 
 left join MA4620EF04.SRBCTLRM as IPESD on IPESD.RMMACO=IPESH.RPMACO 
 where IHTYPP=1 and  NANCA1=''''99007''''  AND IHIDAT >='+@fecha+'
 and IDNSVA<>0 and IDQTY <>0  order by IDINVN,IDLINE'
--IHIDAT between 20171201 and 20171231
-- AND IHINVN=33202352
-- >='+@fecha+'
print(@sqlQuery)
INSERT INTO #detalle_fahorroFacturas
           ([SUCURSAL]
           ,[SERIE]
           ,[IDCUNO]
           ,[NANCA1]
           ,[IDINVN]
           ,[FACTURA]
           ,[IDLINE]
           ,[IDPRDC]
           ,[PCXPRC]
           ,[IDDESC]
           ,[IDQTY]
           ,[CF]
           ,[FARMACIA]
           ,[UNITARIO]
           ,[PUBLICO]
           ,[PRECIO_CANTIDAD]
           ,[NETO_UNITARIO]
           ,[NETO_CANTIDAD]
           ,[IVA]
           ,[IEPS]
           ,[IEPS_MONEDA]
           ,[TOTAL_IEPS]
           ,[IVA_MONEDA]
           ,[TOTAL_FINAL]
           ,[DTDCPR]
           ,[DESCOFERTA]
           ,[DESCCOMERCIAL]
           ,[DescComercialPesos]
           ,[IDGDSQ]
           ,[FECHAPROG]
           ,[IHOREF]
           ,[NATREG])
execute('select *  from openquery(as400, ''' + @sqlQuery + ''')')
/*
            [IHINVN]=      --RemisionFactura
           ,[IDCUNO]       --id cliente
           ,[NANCA1]       --id cliente padre
           ,[IDINVN]       --factura completa en ibs         
           ,[IDPRDC]       --codigo producto marzam
           ,[PCXPRC]       --ean
           ,[IDDESC]       --descripcion del producto
           ,[IDQTY]        --cantidad pedida
           ,[CF]           --clasificacion fiscal del producto         
           ,[DTDCPR]                 --oferta en %
           ,[DESCOFERTA]             --oferta en $
           ,[DESCCOMERCIAL]          --desc comercial en %
           ,[DescComercialPesos]	 --desc comercial en $
           ,[IDGDSQ]                 --clave de oferta que se aplico a esta linea de producto
           ,[FECHAPROG]              --fecha de emision de la factura de ibs
           ,[IHOREF]                 --numero de pedido de cliente(Orden de compra)
           ,[NATREG]                 --rfc del cliente
*/

--select * from #detalle_fahorroFacturas where HashCode=1395522958
--select * from detalle_fahorroFacturas where HashCode=1395522958
--delete from detalle_fahorroFacturas where convert(varchar,fechaprog,112)>='20180103'
update #detalle_fahorroFacturas set HashCode=CHECKSUM([IDINVN],[IDCUNO],[IDLINE],rtrim([IDPRDC]),cast(ihoref as money))
  
     MERGE detalle_fahorroFacturas P2
	USING (SELECT * FROM #detalle_fahorroFacturas) P1
	ON (P1.[IDINVN] = P2.[IDINVN] and P1.[IDCUNO]=P2.[IDCUNO] and P1.[IDLINE]=P2.[IDLINE] and rtrim(P1.[IDPRDC])=rtrim(P2.[IDPRDC]) and cast(P1.ihoref as money)=cast(P2.ihoref as money))
	
	WHEN NOT MATCHED THEN
       INSERT ([SUCURSAL]
           ,[SERIE]
           ,[IDCUNO]
           ,[NANCA1]
           ,[IDINVN]
           ,[FACTURA]
           ,[IDLINE]
           ,[IDPRDC]
           ,[PCXPRC]
           ,[IDDESC]
           ,[IDQTY]
           ,[CF]
           ,[FARMACIA]
           ,[UNITARIO]
           ,[PUBLICO]
           ,[PRECIO_CANTIDAD]
           ,[NETO_UNITARIO]
           ,[NETO_CANTIDAD]
           ,[IVA]
           ,[IEPS]
           ,[IEPS_MONEDA]
           ,[TOTAL_IEPS]
           ,[IVA_MONEDA]
           ,[TOTAL_FINAL]
           ,[DTDCPR]
           ,[DESCOFERTA]
           ,[DESCCOMERCIAL]
           ,[DescComercialPesos]
           ,[IDGDSQ]
           ,[FECHAPROG]
           ,[IHOREF]
           ,[NATREG]
		   ,HashCode)
       VALUES (P1.[SUCURSAL]
           ,P1.[SERIE]
           ,P1.[IDCUNO]
           ,P1.[NANCA1]
           ,P1.[IDINVN]
           ,P1.[FACTURA]
           ,P1.[IDLINE]
           ,P1.[IDPRDC]
           ,P1.[PCXPRC]
           ,P1.[IDDESC]
           ,P1.[IDQTY]
           ,P1.[CF]
           ,P1.[FARMACIA]
           ,P1.[UNITARIO]
           ,P1.[PUBLICO]
           ,P1.[PRECIO_CANTIDAD]
           ,P1.[NETO_UNITARIO]
           ,P1.[NETO_CANTIDAD]
           ,P1.[IVA]
           ,P1.[IEPS]
           ,P1.[IEPS_MONEDA]
           ,P1.[TOTAL_IEPS]
           ,P1.[IVA_MONEDA]
           ,P1.[TOTAL_FINAL]
           ,P1.[DTDCPR]
           ,P1.[DESCOFERTA]
           ,P1.[DESCCOMERCIAL]
           ,P1.[DescComercialPesos]
           ,P1.[IDGDSQ]
           ,P1.[FECHAPROG]
           ,P1.[IHOREF]
           ,P1.[NATREG]
		   ,P1.HashCode);
	
  drop table #detalle_fahorroFacturas
  
  --select top 1000 * from detalle_fahorroFacturas order by fechaprog desc
 --truncate table detalle_fahorroFacturas
END

GO

