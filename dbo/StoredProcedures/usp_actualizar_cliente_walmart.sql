-- =============================================
-- Author:		mandrade
-- Create date: 24-08-2016
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[usp_actualizar_cliente_walmart]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

 CREATE TABLE #cat_tiendas_walmart(	
	[admxglnc] [varchar](50) NOT NULL,
	[nanum] [varchar](15) NOT NULL,
	[naname] [varchar](350) NOT NULL,
	[nanca1] [varchar](50) NOT NULL,
	)

	insert into #cat_tiendas_walmart
	select * from openquery(AS400,'
	SELECT trim(n.ADMXGLNC)as ADMXGLNC,trim(cl.NANUM)as NANUM,trim(cl.NANAME)as NANAME,trim(cl.NANCA1)AS NANCA1
	FROM MA4620EF04.SRBNAM cl inner join MARZAMPRD.MX3NAD n on cl.NANUM=n.ADNUM 
	WHERE cl.NANCA1 in(''99139'',''99004'') and n.ADADNO=2 
	order by trim(n.ADMXGLNC)')

	insert into [dbo].[cat_tiendas_walmart]
	select c1.* from #cat_tiendas_walmart c1
	left join [dbo].[cat_tiendas_walmart] c2 on
	c1.ADMXGLNC=c2.ADMXGLNC	and c1.NANUM=c2.NANUM
	where c2.NANUM is null

	drop table #cat_tiendas_walmart


END

GO

