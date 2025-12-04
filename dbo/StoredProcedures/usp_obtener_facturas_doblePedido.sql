-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_obtener_facturas_doblePedido]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	CREATE TABLE #HORNOS(
	[IHORNO] [numeric](12, 0) NOT NULL,
	[TOTAL] [int] NOT NULL
	) ON [PRIMARY]

	declare @query varchar(max),@fecha varchar(8)
	set @fecha= convert(varchar,getdate()-1,112)
	set @query='
	select IHORNO,COUNT(IHINVN) AS TOTAL	
	from MA4620EF04.SROISH
	WHERE IHTYPP=1 AND IHIDAT >='+@fecha+' and IHCUNO not in(''''J00100'''')
	GROUP BY IHORNO
	HAVING COUNT(IHINVN)>=2'
	--print('select * from openquery(AS400,'''+@query+''')')
	insert into #HORNOS execute ('select * from openquery(AS400,'''+@query+''')')
    select IHORNO from #HORNOS
	--SELECT h.IHCUNO as Cliente,s.NANSNA as NomCliente,h.IHORNO as OrdenPedido,h.IHINVN as Factura,h.IHIDAT as Fecha,r.RSROUT as ruta
	--FROM  AS400.[S101FEBT].MA4620EF04.SROISH h
	--INNER JOIN AS400.[S101FEBT].MA4620EF04.SRONAM s ON h.IHCUNO=s.NANUM	
	--INNER JOIN AS400.[S101FEBT].MA4620EF04.SRONAD s1 on s.NANUM=s1.ADNUM and s1.ADADNO=2
 --   INNER JOIN AS400.[S101FEBT].MA4620EF04.SRBRTS r on s1.ADDEST=r.RSDEST	
	--where h.IHORNO in(select IHORNO from #HORNOS)

	DROP TABLE  #HORNOS
END

GO

