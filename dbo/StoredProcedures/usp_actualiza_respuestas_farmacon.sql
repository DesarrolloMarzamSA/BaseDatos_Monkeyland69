
CREATE PROCEDURE [dbo].[usp_actualiza_respuestas_farmacon]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements. select  CONVERT(varchar,getdate()-2,112)
	SET NOCOUNT ON;  
	  		
		CREATE TABLE #detalle_respuesta_farmacon(
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
	    CREATE CLUSTERED INDEX IX_tempDetalle ON #detalle_respuesta_farmacon ([SUCURSAL],[SERIE],[IDINVN])
	
		DECLARE @sqlQuery VARCHAR(2500)
		DECLARE @fecha VARCHAR(8)=  CONVERT(VARCHAR,GETDATE()-1,112)

		SET @sqlQuery= '
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
		 where IHTYPP=1 and  NANCA1 in(''''99599'''',''''99873'''',''''99965'''',''''99465'''') and IHIDAT>='+@fecha+'   order by IDINVN,IDLINE'
		--print(@sqlQuery)  print(len(@sqlQuery))
		--EXECUTE('select *  from openquery(as400, ''' + @sqlQuery + ''')')
		 	
		INSERT INTO #detalle_respuesta_farmacon  EXECUTE('select *  from openquery(as400, ''' + @sqlQuery + ''')')		
		INSERT INTO [monkeyland].[dbo].[detalle_respuesta_farmacon]
		SELECT DISTINCT r.[SUCURSAL],r.[SERIE],LTRIM(RTRIM(r.[IDCUNO])),r.[IDINVN],r.[IDLINE],LTRIM(RTRIM(r.[IDPRDC])),
			r.[PCXPRC],r.[IDDESC],r.[IDQTY],r.[FECHAPROG],r.[IHOREF],getdate()--,r1.IDINVN
		FROM #detalle_respuesta_farmacon r	
		LEFT JOIN [monkeyland].[dbo].[detalle_respuesta_farmacon] r1 ON r.IDINVN=r1.IDINVN
		WHERE r1.IDINVN is null
		DROP TABLE #detalle_respuesta_farmacon   
		
END

GO

