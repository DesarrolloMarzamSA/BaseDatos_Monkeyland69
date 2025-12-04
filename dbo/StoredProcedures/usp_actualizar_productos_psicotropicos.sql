-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_actualizar_productos_psicotropicos]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	   
		CREATE TABLE #productosPsicotropicos(
			[PGPHPRDC] [char](35) NOT NULL,
			[PGPHNCAT] [char](3) NOT NULL,
			[PGPHISPC] [char](5) NOT NULL
		) ON [PRIMARY]

	insert into #productosPsicotropicos
	select  rtrim(ltrim(PGPHPRDC)),rtrim(ltrim(PGPHNCAT)),rtrim(ltrim(PGPHISPC))
    --from AS400.[S101FEBT].MA4620EF04.PHBPRG
    from AS400.[S78E2DC0].MA4620EF04.PHBPRG
	WHERE PGPHISPC<>''
	

	insert into productosPsicotropicos
	select rtrim(ltrim(p.PGPHPRDC)),rtrim(ltrim(p.PGPHNCAT)),rtrim(ltrim(p.PGPHISPC)),GETDATE()
	from #productosPsicotropicos p left join productosPsicotropicos p1	on p.PGPHPRDC=p1.PGPHPRDC
	where p1.PGPHPRDC is null	                           
	drop table #productosPsicotropicos
	--select * from  productosPsicotropicos order by PGPHNCAT	
	--drop table productosPsicotropicos		
END

GO

