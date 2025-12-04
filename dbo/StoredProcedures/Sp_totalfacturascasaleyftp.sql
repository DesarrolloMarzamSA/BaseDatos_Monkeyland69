CREATE procedure [dbo].[Sp_totalfacturascasaleyftp]-- '20170216'
			
 @fecha_ini varchar(10)
AS
BEGIN
       -- SET NOCOUNT ON added to prevent extra result sets from
       -- interfering with SELECT statements.
       SET NOCOUNT ON;
       declare @cadena_sql varchar(8000)
	   CREATE TABLE #tbl_tem_kike2(
       [SUCURSAL] [int] NOT NULL,
       [FACTURA] [int] NULL,
       [SERIE] [VARCHAR](11) NOT NULL ,
       [CLIENTE] [char](12) NOT NULL ,
       [RUTA] [varchar](24) NOT NULL,
       [FACTURADO] [nvarchar](40) NULL,
       [FARMACIA] [VARCHAR](95) NOT NULL ,
       [DOMICILIO] [VARCHAR](95) NULL,
       [COLONIA] [VARCHAR](50) NOT NULL,
       [NUMDIG] [VARCHAR](15) NOT NULL,
       [POBLACION] [VARCHAR](50) NOT NULL,
       [DIAPAGO] [INT] NOT NULL,
       [CVECREDITO] [NVARCHAR](4) NOT NULL,
       [PASSWORD] [VARCHAR](19) NOT NULL,
       [HORACAP] [DATETIME] NOT NULL,
       [IMPORTE] [int] NOT NULL,
       [DESCTOESP] [char](10) NULL,
       [DUENO] [VARCHAR](80) NOT NULL,
       [RUTAF] [VARCHAR](10) NULL,
       [FACTURADOF][VARCHAR](30)NULL,
       [ITINERAF] [VARCHAR](30) NULL,
       [FECHAFACTURA] [DATETIME] NULL,
       [TIPOORDER] [VARCHAR](10) NULL,
       [TIPOFACTURA] [VARCHAR] null, 
       [ORDERN] [VARCHAR](60) NULL,
       [FECHAALTA] [DATETIME] NULL,
       [SEGTO] [VARCHAR] (40) NULL,
       [CTEPADRE][VARCHAR](30) NULL,
       [TIMEESTAMP][DATETIME] NULL,
       [FOLIO_FISCAL][VARCHAR](50) NULL,
       [CONSECUTIVO] [VARCHAR] (60) NULL,
       [IBS_ORNO][NVARCHAR](50) NULL,
       [IHCUNO][NVARCHAR](40) NULL,
       [RFC][VARCHAR](80)NULL,
       [IHIAET][NVARCHAR](70)NULL,
       [IHIAIT][NVARCHAR](80)NULL,
       [FACTURAIBS][NVARCHAR](90)NULL
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
RIGHT(''''00000000'''' || TRIM(CAST(T1.IHINVN AS VARCHAR(25))), 8) FACTURA,
(SELECT TRIM(LEZ3ISKC)AS LEZ3ISKC  FROM MA4620EF04.Z3BCTLLE WHERE LEZ3LENT = NOI.noz3lent) SERIE,
CAST(trim(T1.IHCUNO) AS CHAR(10)) CLIENTE,
LEFT(TRIM(IFNULL(T4.OHDEST, '''' '''')) || ''''    '''', 4)        RUTA,
RIGHT(T4.OHSTAT || '''' '''', 1)                                   FACTURADO,
LEFT(T1.IHNSNA || ''''                    '''', 20)                FARMACIA,
LEFT(T5.ADADR2 || ''''                                   '''', 35) DOMICILIO,
CAST(LEFT(T5.ADADR3, 23) AS CHAR(23))                              COLONIA, 
LEFT(T4.OHSALE || ''''  '''', 2)                                   NUMDIG,
LEFT(T5.ADADR4 || ''''                                   '''', 15) POBLACION,
CAST(LEFT(T5.ADGANN || '''' '''', 1) AS CHAR(1))                   DIAPAGO,
CAST(LEFT(T4.OHTOPC || '''' '''', 1) AS CHAR(1))                   CVECREDITO,
CAST(LEFT(T4.OHHAND || ''''    '''', 4) AS CHAR(4))                PASSWORD,
TIMESTAMP(INSERT(INSERT(DIGITS(T4.OHODAT),5,0,''''-''''),8,0,''''-'''') || '''' '''' || INSERT(INSERT(DIGITS(T4.OHOTME), 3, 0, '''':''''), 6, 0, '''':'''') || ''''.000'''') HORACAP,
LEFT(CAST(T1.IHIAET AS CHAR(20)), 1)                               IMPORTE,
CAST(RIGHT(''''0000'''' || CAST(IFNULL(T6.DTDCPR, 0) * 100 AS INT), 4) AS CHAR(5)) DESCTOESP,
LEFT(T4.OHNAME || ''''                                   '''', 30) DUENO,
LEFT(T4.OHDEST || ''''   '''', 3) RUTAF,
RIGHT(T4.OHSTAT || '''' '''', 1) FACTURADOF,
LEFT(T4.OHDSNO || ''''   '''', 3) ITINERAF,
TIMESTAMP(INSERT(INSERT(DIGITS(T1.IHIDAT),5,0,''''-''''),8,0,''''-'''') || '''' 00:00:00.000'''') FECHAFACTURA,
CAST(LEFT(T4.OHORDT || '''' '''', 1) AS CHAR(1)) TIPOORDEN,
CAST(LEFT(T4.OHORDT || '''' '''', 1) AS CHAR(1))  TIPOFACTUR,
RIGHT(''''                '''' || CAST(TRIM(T4.OHSURF) AS VARCHAR(35)), 16) ORDEN,
TIMESTAMP(INSERT(INSERT(DIGITS(T4.OHDELT),5,0,''''-''''),8,0,''''-'''') || '''' 00:00:00.000'''') FECHAALTA,
SUBSTRING(T7.NOCGRP || ''''  '''', 1, 2) SEGTO,
trim(T2.NANCA1) CTEPADRE,
CURRENT_TIMESTAMP TIMESTAMP, 
RIGHT(''''00000000'''' || TRIM(CAST(T1.IHINVN AS VARCHAR(25))), 8) FOLIO_FISCAL,
cast(CASE PASO.FN_ISNUMERIC(T4.OHCORN) WHEN 0 THEN ''''0'''' ELSE T4.OHCORN END as bigint) CONSECUTIVO,
T1.IHORNO IBS_ORNO,
T1.IHCUNO,
t2.NATREG rfc,
t1.IHIAET,
t1.IHIAIT,
TRIM(T1.IHINVN) FACTURAIBS
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
--print('select * from openquery(AS400, ''' + @cadena_sql + ''')')
 insert into  #tbl_tem_kike2
  execute('select *  from openquery(AS400, ''' + @cadena_sql + ''')')
select count (FACTURA) AS totales from #tbl_tem_kike2 
--select * from #tbl_tem_kike2 
drop table  #tbl_tem_kike2
END

GO

