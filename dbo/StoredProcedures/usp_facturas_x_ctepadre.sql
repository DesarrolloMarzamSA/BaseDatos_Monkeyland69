CREATE PROCEDURE [dbo].[usp_facturas_x_ctepadre] 
 @fecha_ini varchar(10)
AS
BEGIN
       -- SET NOCOUNT ON added to prevent extra result sets from
       -- interfering with SELECT statements.
       SET NOCOUNT ON;
       declare @cadena_sql varchar(8000)
	   CREATE TABLE #tbl_tem_kike(
       [SUCURSAL] varchar(10) NOT NULL,
   
       [SERIE] [VARCHAR](11) NOT NULL ,
 
       [FECHAFACTURA] [DATETIME] NULL,
    
       [RFC][VARCHAR](80)NULL,
  
) 





   select @cadena_sql = '
SELECT 
CASE WHEN NOI.noz3lent=''''821'''' AND SUBSTRING(T2.NANUM,1,1)=''''D'''' THEN CAST(''''04'''' AS INT) 
WHEN NOI.noz3lent=''''807'''' AND SUBSTRING(T2.NANUM,1,1)=''''X'''' AND TRIM(SR.CMCSTS)=''''075'''' THEN CAST(''''24'''' AS INT) 
WHEN NOI.noz3lent=''''807'''' AND SUBSTRING(T2.NANUM,1,1)=''''X'''' THEN CAST(''''23'''' AS INT) 
WHEN NOI.noz3lent=''''808'''' AND SUBSTRING(T2.NANUM,1,1)=''''X'''' THEN CAST(''''24'''' AS INT) 
WHEN NOI.noz3lent=''''855'''' THEN CAST(''''09'''' AS INT) 
ELSE CAST(SUBSTRING(NOI.noz3lent,2,3)AS INT) 
END SUCURSAL,

(SELECT TRIM(LEZ3ISKC)AS LEZ3ISKC  FROM MA4620EF04.Z3BCTLLE WHERE LEZ3LENT = NOI.noz3lent) SERIE,

TIMESTAMP(INSERT(INSERT(DIGITS(T1.IHIDAT),5,0,''''-''''),8,0,''''-'''') || '''' 00:00:00.000'''') FECHAFACTURA,
t2.NATREG rfc

FROM MA4620EF04.Z17ISH T1 
INNER JOIN MA4620EF04.SRBNAM T2 ON T1.IHCUNO = T2.NANUM 
INNER JOIN MA4620EF04.Z3BNOI NOI ON T2.NANUM=NOI.NONUM
INNER JOIN MA4620EF04.SRBCMA SR ON T2.NANUM=SR.CMCUNO 
INNER JOIN MA4620EF04.SR1SOH T4 ON T1.IHORNO = T4.OHORNO AND T1.IHCUNO = T4.OHCUNO
INNER JOIN MA4620EF04.SRBNAD T5 ON T1.IHIANO = T5.ADADNO AND T1.IHCUNO = T5.ADNUM
LEFT OUTER JOIN MA4620EF04.SRBGDT T6 ON T4.OHGDSQ = T6.DTGDSQ AND T6.DTSEQ = 1
INNER JOIN MA4620EF04.SRBNOI T7 ON T1.IHCUNO = T7.NONUM
WHERE T2.nanca1 in(''''99610 '''')  and '

SELECT @cadena_sql = @cadena_sql + 'T1.IHIDAT between ' + @fecha_ini + ' AND ' + @fecha_ini + '
and T1.IHTYPP = 1 AND 
T1.IHCUNO <> ''''Y99998'''' FOR FETCH ONLY WITH UR'

 insert into  #tbl_tem_kike
  execute('select *  from openquery(AS400, ''' + @cadena_sql + ''')')
  
  
CREATE TABLE #tbl_tem_kike2(
	[AWREF] [nvarchar](10) NOT NULL,
	[FKART] [nvarchar](4) NULL,
	[BUDAT] [datetime] NULL,
	[KUNAG] [nvarchar](10) NOT NULL,
	[BSTKD] [nvarchar](35) NULL,
	[FDTAG] [datetime] NULL,
	[VTWEG] [nvarchar](2) NULL,
	[RBUKRS] [nvarchar](4) NOT NULL,
	[REBZG] [nvarchar](10) NULL,
	[REBZJ] [nvarchar](4) NULL,
	[KUNRG] [nvarchar](10) NULL,
	[BLART] [nvarchar](2) NULL,
	[BELNR] [nvarchar](10) NOT NULL,
	[IND_SECTOR] [nvarchar](10) NULL,
	[XBLNR] [nvarchar](16) NULL,
	[NETWR] [decimal](13, 2) NULL,
	[MWSBK] [decimal](13, 2) NULL,
	[IMPORTE] [decimal](15, 2) NULL,
	[PARTNER] [nvarchar](10) NOT NULL,
	[BU_SORT1] [nvarchar](20) NULL,
	[IDNUMBER] [nvarchar](60) NULL,
	[TAXNUM] [nvarchar](20) NULL,
	[BUKRS] [nvarchar](4) NOT NULL,
	[VWERK] [nvarchar](4) NOT NULL,
	[ALTKN] [nvarchar](10) NULL,
	[KNRZE] [nvarchar](10) NULL
) ON [PRIMARY]
 insert into #tbl_tem_kike2
exec [192.168.90.209].[MiddleWare].[IEmbarque].[ExtraccionFacturacionEncabezado] '0011000004','',@fecha_ini


select 
  SERIE,
 count(SERIE) as numero_facturas,
 RFC,
 CAST([FECHAFACTURA] AS DATE) AS fecha
 from #tbl_tem_kike 
 group by SERIE,FECHAFACTURA,RFC
 union all 
 select SUBSTRING([XBLNR],1,4)AS SERIE,count(1)as numero_facturas,
 [TAXNUM]   as RFC,
  CAST(BUDAT AS DATE) AS fecha
  from #tbl_tem_kike2
  GROUP BY SUBSTRING([XBLNR],1,4),[TAXNUM],CAST(BUDAT AS DATE)
drop table  #tbl_tem_kike
drop table #tbl_tem_kike2
END

GO

