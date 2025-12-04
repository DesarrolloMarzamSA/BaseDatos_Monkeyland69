-- =============================================
-- Author:		mandrade
-- Create date: 10-09-2015
-- Description:	obtener lotes y fecha caducidad de productos facturacion
-- =============================================
CREATE PROCEDURE [dbo].[usp_obtener_facturacion_lote_caducidad]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @query varchar(max)
	declare @fecha varchar(10)
	set @fecha=(select convert(varchar,getdate()-1,112))
	--print @fecha
	CREATE TABLE #facturacion_lote_caducidad(
	[IDIDAT] [numeric](8, 0) NOT NULL,
	[IDINVN] [numeric](12, 0) NOT NULL,
	[FACTURA] [varchar](50) NOT NULL,
	[SERIE] [varchar](10) NULL,
	[IDCUNO] [varchar](50) NOT NULL,
	[IDLINE] [numeric](18, 0) NULL,
	[IDPRDC] [varchar](50) NOT NULL,
	[IDDESC] [varchar](450) NOT NULL,
	[IDPLNO] [numeric](12, 0) NOT NULL,
	[IDQTY] [numeric](15, 3) NOT NULL,
	[LTTRAQ] [numeric](15, 3) NULL,
	[LTBATC] [varchar](100) NULL,
	[LTUSBD] [numeric](8, 0) NULL,
	[NANCA1] [varchar](100) NOT NULL
	) ON [PRIMARY]

	set @query='
	SELECT DISTINCT 
          ISD.IDIDAT,
          ISD.IDINVN,
          RIGHT(''''00000000'''' || TRIM(CAST(ISD.IDINVN AS VARCHAR(25))), 8) AS FACTURA,
          (SELECT TRIM(LEZ3ISKC)AS LEZ3ISKC  FROM MA4620EF04.Z3BCTLLE WHERE LEZ3LENT = NOI.noz3lent) SERIE,
          TRIM(ISD.IDCUNO)as IDCUNO,
		  ISD.IDLINE ,
          TRIM(ISD.IDPRDC) as IDPRDC,
          TRIM(ISD.IDDESC) as IDDESC,
          ISD.IDPLNO ,
          ISD.IDQTY  ,
          LTR.LTTRAQ ,
          TRIM(IFNULL(LTR.LTBATC,''''        ''''))as LTBATC,
          IFNULL(LOT.LTUSBD,0)as LTUSBD ,
          TRIM(N.NANCA1) as NANCA1
	FROM		MARZAMDES.Z1BISD  AS ISD    -- Detalle de Venta
	INNER JOIN	MA4620EF04.SRBNAM N 
			ON ISD.IDCUNO=N.NANUM
	INNER JOIN	MA4620EF04.Z3BNOI NOI 
			ON ISD.IDCUNO=NOI.NONUM
	INNER JOIN	MA4620EF04.SRBCMA SR 
			ON ISD.IDCUNO=SR.CMCUNO 
	LEFT JOIN	MA4620EF04.WH1LTR AS LTR     -- Transacciones de Inventario
			ON LTR.LTPRDC = ISD.IDPRDC AND 
			  LTR.LTSROM = ISD.IDSROM AND 
			  LTR.LTDATE = ISD.IDIDAT AND 
			  LTR.LTORNO = ISD.IDORNO AND 
			  LTR.LTIECD = ''''SO'''' 
	LEFT JOIN MA4620EF04.SRBLOT AS LOT     -- Datos Generales de Lote
			ON LOT.LTBATC = LTR.LTBATC AND 
			  LOT.LTSROM = ISD.IDSROM AND 
			  LOT.LTPRDC = ISD.IDPRDC 
	WHERE     ISD.IDIDAT >= '+@fecha+'  and ISD.IDPCA6 IN (''''1'''',''''2'''',''''3'''') and N.NANCA1=''''99843'''''

	--print('select * from openquery(AS400,'''+@query+''')')

	insert into #facturacion_lote_caducidad execute('select * from openquery(AS400,'''+@query+''')')

	insert into facturacion_lote_caducidad
	select distinct f.IDIDAT,f.IDINVN,f.FACTURA,f.SERIE,f.IDCUNO,f.IDLINE,f.IDPRDC,f.IDDESC,f.IDPLNO,
	f.IDQTY,isnull(f.LTTRAQ,0),f.LTBATC,f.LTUSBD,f.NANCA1
	,getdate() from #facturacion_lote_caducidad f
	left join facturacion_lote_caducidad f1
	on f.IDINVN=f1.IDINVN and f.SERIE=f1.SERIE and f.IDCUNO=f1.IDCUNO and f.IDPRDC=f1.IDPRDC
	and f.LTBATC=f1.LTBATC and f.LTUSBD=f1.LTUSBD
	where f1.IDINVN is null

	drop table #facturacion_lote_caducidad

END

GO

