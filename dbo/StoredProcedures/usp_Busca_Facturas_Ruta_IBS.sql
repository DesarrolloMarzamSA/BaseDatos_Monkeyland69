
-- =============================================
-- Author:		ALBERTO MANZANO CABRERA
-- Create date: 19-04-16
-- Description:	BUSCA FACTURAS EN LA TABLA TBL_CambiaFolioAdenda
-- =============================================
CREATE PROCEDURE [dbo].[usp_Busca_Facturas_Ruta_IBS]
	-- Add the parameters for the stored procedure here
	@VAR_OPCION INT,
	@SQL_QUERY VARCHAR (MAX),
	@VAR_FECHA_ACTUAL VARCHAR(20),
	@VAR_FACTURA VARCHAR(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here	
	
	--Opcion = 0 Es para sacar las series que se van a recorrer y 1 es para sacar el nro de cliente por medio del nro de factura....

	IF (@VAR_OPCION = 0) -- SACA LA SERIE QUE SE VA A PROCESAR
	BEGIN
		IF OBJECT_ID('tempdb..#DetalleFacturas') IS NOT NULL 
		DROP TABLE #DetalleFacturas 

		SET @SQL_QUERY = 'SELECT * INTO #DetalleFacturas FROM OPENQUERY ' + '(as400, ' + '''select distinct CASE WHEN NOI.noz3lent= ' + '''''821''''' + ' AND SUBSTRING(IDCUNO,1,1)= ' + '''''D''''' + ' THEN CAST(' + '''''04''''' + ' AS INT) 
		WHEN NOI.noz3lent= ' + '''''807''''' + ' AND SUBSTRING(IDCUNO,1,1)=' + '''''X''''' + ' AND TRIM(SR.CMCSTS)= ' + '''''075''''' + '  THEN CAST(' + '''''24''''' + ' AS INT) 
		WHEN NOI.noz3lent= ' + '''''807''''' + ' AND SUBSTRING(IDCUNO,1,1)=' + '''''X''''' + ' THEN CAST(' + '''''23''''' + ' AS INT) 
		WHEN NOI.noz3lent= ' + '''''808''''' + ' AND SUBSTRING(IDCUNO,1,1)=' + '''''X''''' + ' THEN CAST(' + '''''24''''' + ' AS INT) 
		WHEN NOI.noz3lent= ' + '''''855''''' + ' THEN CAST(' + '''''09''''' + ' AS INT) 
		ELSE CAST(SUBSTRING(NOI.noz3lent,2,3)AS INT) 
		END SUCURSAL,
		(SELECT TRIM(LEZ3ISKC)AS LEZ3ISKC  FROM MA4620EF04.Z3BCTLLE WHERE LEZ3LENT = NOI.noz3lent) SERIE,
		TRIM(IDCUNO) AS IDCUNO,TRIM(NATREG) AS RFC,IDINVN,
		right(' + '''''000000000000''''' + '  || CAST(IDINVN AS varchar(12)), 8)as factura,
		TIMESTAMP(INSERT(INSERT(DIGITS(IHIDAT),5,0,' + '''''-''''' + ' ),8,0,' + '''''-''''' + ' ) || ' + ''''' 00:00:00.000''''' + ' ) FECHAFACTURA
		from  MA4620EF04.SRBISD  
		inner join MA4620EF04.SRBISH on IHINVN=IDINVN and IDCUNO=IHCUNO
		inner join MA4620EF04.SRBSOH on IDORNO= OHORNO AND OHCUNO=IHCUNO 
		inner join MA4620EF04.SRONAM ON IDCUNO=NANUM
		INNER JOIN MA4620EF04.Z3BNOI NOI ON IDCUNO=NOI.NONUM
		INNER JOIN MA4620EF04.SRBCMA SR ON IDCUNO=SR.CMCUNO 
		LEFT JOIN MA4620EF04.SROPCR ON IDPRDC=PCIPRC AND PCXRTY=' + '''''IA''''' + '  
		LEFT JOIN MA4620EF04.SRBVHC ON IDVAHC=HCVAHC 
		LEFT JOIN MA4620EF04.SROCTLFA T17 ON HCVATC=T17.CTVATC 
		left join MA4620EF04.SRBRPM as IPESH on IPESH.RPPRDC=IDPRDC 
		left join MA4620EF04.SRBCTLRM as IPESD on IPESD.RMMACO=IPESH.RPMACO 
		where IHTYPP=1 and  NANCA1 in(' + '''''99728''''' + ' ) and IHIDAT = ' + @VAR_FECHA_ACTUAL + '
		and IDNSVA<>0 and IDQTY <>0 and SUBSTRING(IDORDT,1,1) IN(' + '''''F''''' + ',' + '''''R''''' + ' )
		order by IDINVN'')
	 
		SELECT SERIE, RFC, FECHAFACTURA FROM #DetalleFacturas
		GROUP BY SERIE, RFC, FECHAFACTURA'

		EXEC (@SQL_QUERY)
	END

	IF (@VAR_OPCION = 1) -- BUSCAR UNA FACTURA EN UNA FECHA ESPECIFICA
	BEGIN
		SET @SQL_QUERY = 'SELECT * FROM OPENQUERY ' + '(as400, ' + '''select distinct CASE WHEN NOI.noz3lent= ' + '''''821''''' + ' AND SUBSTRING(IDCUNO,1,1)= ' + '''''D''''' + ' THEN CAST(' + '''''04''''' + ' AS INT) 
		WHEN NOI.noz3lent= ' + '''''807''''' + ' AND SUBSTRING(IDCUNO,1,1)=' + '''''X''''' + ' AND TRIM(SR.CMCSTS)= ' + '''''075''''' + '  THEN CAST(' + '''''24''''' + ' AS INT) 
		WHEN NOI.noz3lent= ' + '''''807''''' + ' AND SUBSTRING(IDCUNO,1,1)=' + '''''X''''' + ' THEN CAST(' + '''''23''''' + ' AS INT) 
		WHEN NOI.noz3lent= ' + '''''808''''' + ' AND SUBSTRING(IDCUNO,1,1)=' + '''''X''''' + ' THEN CAST(' + '''''24''''' + ' AS INT) 
		WHEN NOI.noz3lent= ' + '''''855''''' + ' THEN CAST(' + '''''09''''' + ' AS INT) 
		ELSE CAST(SUBSTRING(NOI.noz3lent,2,3)AS INT) 
		END SUCURSAL,
		(SELECT TRIM(LEZ3ISKC)AS LEZ3ISKC  FROM MA4620EF04.Z3BCTLLE WHERE LEZ3LENT = NOI.noz3lent) SERIE,
		TRIM(IDCUNO) AS IDCUNO,TRIM(NATREG) AS RFC,IDINVN,
		right(' + '''''000000000000''''' + '  || CAST(IDINVN AS varchar(12)), 8)as factura,
		TIMESTAMP(INSERT(INSERT(DIGITS(IHIDAT),5,0,' + '''''-''''' + ' ),8,0,' + '''''-''''' + ' ) || ' + ''''' 00:00:00.000''''' + ' ) FECHAFACTURA
		from  MA4620EF04.SRBISD  
		inner join MA4620EF04.SRBISH on IHINVN=IDINVN and IDCUNO=IHCUNO
		inner join MA4620EF04.SRBSOH on IDORNO= OHORNO AND OHCUNO=IHCUNO 
		inner join MA4620EF04.SRONAM ON IDCUNO=NANUM
		INNER JOIN MA4620EF04.Z3BNOI NOI ON IDCUNO=NOI.NONUM
		INNER JOIN MA4620EF04.SRBCMA SR ON IDCUNO=SR.CMCUNO 
		LEFT JOIN MA4620EF04.SROPCR ON IDPRDC=PCIPRC AND PCXRTY=' + '''''IA''''' + '  
		LEFT JOIN MA4620EF04.SRBVHC ON IDVAHC=HCVAHC 
		LEFT JOIN MA4620EF04.SROCTLFA T17 ON HCVATC=T17.CTVATC 
		left join MA4620EF04.SRBRPM as IPESH on IPESH.RPPRDC=IDPRDC 
		left join MA4620EF04.SRBCTLRM as IPESD on IPESD.RMMACO=IPESH.RPMACO 
		where IHTYPP=1 and  NANCA1 in(' + '''''99728''''' + ' ) and IHIDAT = ' + @VAR_FECHA_ACTUAL + ' AND right(' + '''''000000000000''''' + '  || CAST(IDINVN AS varchar(12)), 8) = ' + @VAR_FACTURA + '
		and IDNSVA<>0 and IDQTY <>0 and SUBSTRING(IDORDT,1,1) IN(' + '''''F''''' + ',' + '''''R''''' + ' )
		order by IDINVN'')'

		EXEC (@SQL_QUERY)		
	END

	IF (@VAR_OPCION = 2) -- REGRESA TODAS LAS FACTURAS DE UNA FECHA ESPECIFICA
	BEGIN
		SET @SQL_QUERY = 'SELECT * FROM OPENQUERY ' + '(as400, ' + '''select distinct CASE WHEN NOI.noz3lent= ' + '''''821''''' + ' AND SUBSTRING(IDCUNO,1,1)= ' + '''''D''''' + ' THEN CAST(' + '''''04''''' + ' AS INT) 
		WHEN NOI.noz3lent= ' + '''''807''''' + ' AND SUBSTRING(IDCUNO,1,1)=' + '''''X''''' + ' AND TRIM(SR.CMCSTS)= ' + '''''075''''' + '  THEN CAST(' + '''''24''''' + ' AS INT) 
		WHEN NOI.noz3lent= ' + '''''807''''' + ' AND SUBSTRING(IDCUNO,1,1)=' + '''''X''''' + ' THEN CAST(' + '''''23''''' + ' AS INT) 
		WHEN NOI.noz3lent= ' + '''''808''''' + ' AND SUBSTRING(IDCUNO,1,1)=' + '''''X''''' + ' THEN CAST(' + '''''24''''' + ' AS INT) 
		WHEN NOI.noz3lent= ' + '''''855''''' + ' THEN CAST(' + '''''09''''' + ' AS INT) 
		ELSE CAST(SUBSTRING(NOI.noz3lent,2,3)AS INT) 
		END SUCURSAL,
		(SELECT TRIM(LEZ3ISKC)AS LEZ3ISKC  FROM MA4620EF04.Z3BCTLLE WHERE LEZ3LENT = NOI.noz3lent) SERIE,
		TRIM(IDCUNO) AS IDCUNO,TRIM(NATREG) AS RFC,IDINVN,
		right(' + '''''000000000000''''' + '  || CAST(IDINVN AS varchar(12)), 8)as factura,
		TIMESTAMP(INSERT(INSERT(DIGITS(IHIDAT),5,0,' + '''''-''''' + ' ),8,0,' + '''''-''''' + ' ) || ' + ''''' 00:00:00.000''''' + ' ) FECHAFACTURA
		from  MA4620EF04.SRBISD  
		inner join MA4620EF04.SRBISH on IHINVN=IDINVN and IDCUNO=IHCUNO
		inner join MA4620EF04.SRBSOH on IDORNO= OHORNO AND OHCUNO=IHCUNO 
		inner join MA4620EF04.SRONAM ON IDCUNO=NANUM
		INNER JOIN MA4620EF04.Z3BNOI NOI ON IDCUNO=NOI.NONUM
		INNER JOIN MA4620EF04.SRBCMA SR ON IDCUNO=SR.CMCUNO 
		LEFT JOIN MA4620EF04.SROPCR ON IDPRDC=PCIPRC AND PCXRTY=' + '''''IA''''' + '  
		LEFT JOIN MA4620EF04.SRBVHC ON IDVAHC=HCVAHC 
		LEFT JOIN MA4620EF04.SROCTLFA T17 ON HCVATC=T17.CTVATC 
		left join MA4620EF04.SRBRPM as IPESH on IPESH.RPPRDC=IDPRDC 
		left join MA4620EF04.SRBCTLRM as IPESD on IPESD.RMMACO=IPESH.RPMACO 
		where IHTYPP=1 and  NANCA1 in(' + '''''99728''''' + ' ) and IHIDAT = ' + @VAR_FECHA_ACTUAL + '
		and IDNSVA<>0 and IDQTY <>0 and SUBSTRING(IDORDT,1,1) IN(' + '''''F''''' + ',' + '''''R''''' + ' )
		order by IDINVN'')'

		EXEC (@SQL_QUERY)		
	END
END

GO

